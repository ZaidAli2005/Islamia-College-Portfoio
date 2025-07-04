import SwiftUI
import PhotosUI
import AVKit
import UniformTypeIdentifiers
import Firebase
import FirebaseFirestore
import FirebaseStorage
import FirebaseAuth

struct ActivityPost: Identifiable, Codable {
    var id = UUID().uuidString
    let userId: String
    let userName: String
    let userImage: String
    let date: Date
    let caption: String
    let mediaItems: [MediaItem]
    var likes: Int = 0
    let tags: [String]
    
    enum CodingKeys: String, CodingKey {
        case id, userId, userName, userImage, date, caption, mediaItems, likes, tags
    }
    
    func toDictionary() -> [String: Any] {
        return [
            "id": id,
            "userId": userId,
            "userName": userName,
            "userImage": userImage,
            "date": Timestamp(date: date),
            "caption": caption,
            "mediaItems": mediaItems.map { $0.toDictionary() },
            "likes": likes,
            "tags": tags
        ]
    }
    
    static func fromDictionary(_ data: [String: Any]) -> ActivityPost? {
        guard let id = data["id"] as? String,
              let userId = data["userId"] as? String,
              let userName = data["userName"] as? String,
              let userImage = data["userImage"] as? String,
              let timestamp = data["date"] as? Timestamp,
              let caption = data["caption"] as? String,
              let mediaItemsData = data["mediaItems"] as? [[String: Any]],
              let likes = data["likes"] as? Int,
              let tags = data["tags"] as? [String] else {
            return nil
        }
        
        let mediaItems = mediaItemsData.compactMap { MediaItem.fromDictionary($0) }
        
        var post = ActivityPost(
            userId: userId,
            userName: userName,
            userImage: userImage,
            date: timestamp.dateValue(),
            caption: caption,
            mediaItems: mediaItems,
            likes: likes,
            tags: tags
        )
        post.id = id
        return post
    }
    
    init(userId: String, userName: String, userImage: String, date: Date, caption: String, mediaItems: [MediaItem], likes: Int = 0, tags: [String]) {
        self.userId = userId
        self.userName = userName
        self.userImage = userImage
        self.date = date
        self.caption = caption
        self.mediaItems = mediaItems
        self.likes = likes
        self.tags = tags
    }
}

struct MediaItem: Identifiable, Codable {
    var id = UUID().uuidString
    let type: MediaType
    let fileName: String
    let firebaseURL: String
    
    enum MediaType: String, Codable, CaseIterable {
        case image = "image"
        case video = "video"
    }
    
    enum CodingKeys: String, CodingKey {
        case id, type, fileName, firebaseURL
    }
    
    func toDictionary() -> [String: Any] {
        return [
            "id": id,
            "type": type.rawValue,
            "fileName": fileName,
            "firebaseURL": firebaseURL
        ]
    }
    
    static func fromDictionary(_ data: [String: Any]) -> MediaItem? {
        print("Parsing MediaItem from dictionary: \(data)")
        
        guard let id = data["id"] as? String,
              let typeString = data["type"] as? String,
              let type = MediaType(rawValue: typeString),
              let fileName = data["fileName"] as? String,
              let firebaseURL = data["firebaseURL"] as? String else {
            print("Failed to parse MediaItem - missing required fields")
            print("id: \(data["id"] as? String ?? "nil")")
            print("type: \(data["type"] as? String ?? "nil")")
            print("fileName: \(data["fileName"] as? String ?? "nil")")
            print("firebaseURL: \(data["firebaseURL"] as? String ?? "nil")")
            return nil
        }
        
        guard URL(string: firebaseURL) != nil else {
            print("Invalid Firebase URL: \(firebaseURL)")
            return nil
        }
        
        var item = MediaItem(type: type, fileName: fileName, firebaseURL: firebaseURL)
        item.id = id
        
        print("Successfully parsed MediaItem: \(item)")
        return item
    }
    
    init(type: MediaType, fileName: String, firebaseURL: String) {
        self.type = type
        self.fileName = fileName
        self.firebaseURL = firebaseURL
    }
}

class FirebaseManager: ObservableObject {
    @Published var posts: [ActivityPost] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var uploadProgress: Double = 0
    
    private let db = Firestore.firestore()
    private let storage = Storage.storage()
    private var listener: ListenerRegistration?
    
    init() {
        setupFirebaseListener()
    }
    
    deinit {
        listener?.remove()
    }
    
    private func setupFirebaseListener() {
        guard Auth.auth().currentUser?.uid != nil else {
            print("No authenticated user")
            return
        }
        
        listener = db.collection("posts")
            .order(by: "date", descending: true)
            .addSnapshotListener { [weak self] snapshot, error in
                DispatchQueue.main.async {
                    if let error = error {
                        print("Error fetching posts: \(error)")
                        self?.errorMessage = error.localizedDescription
                        return
                    }
                    
                    guard let documents = snapshot?.documents else {
                        print("No documents found")
                        return
                    }
                    
                    self?.posts = documents.compactMap { document in
                        let data = document.data()
                        print("Document data: \(data)")
                        return ActivityPost.fromDictionary(data)
                    }
                    
                    print("Loaded \(self?.posts.count ?? 0) posts")
                }
            }
    }
    
    func uploadMediaItems(images: [UIImage], videos: [URL]) async -> [MediaItem] {
        var mediaItems: [MediaItem] = []
        let totalItems = images.count + videos.count
        var completedItems = 0
        
        await withTaskGroup(of: MediaItem?.self) { group in
            for (index, image) in images.enumerated() {
                group.addTask {
                    if let firebaseURL = await self.uploadImage(image) {
                        return MediaItem(
                            type: .image,
                            fileName: "image_\(index)_\(UUID().uuidString).jpg",
                            firebaseURL: firebaseURL
                        )
                    }
                    return nil
                }
            }
            
            for (index, videoURL) in videos.enumerated() {
                group.addTask {
                    if let firebaseURL = await self.uploadVideo(videoURL) {
                        return MediaItem(
                            type: .video,
                            fileName: "video_\(index)_\(UUID().uuidString).mov",
                            firebaseURL: firebaseURL
                        )
                    }
                    return nil
                }
            }
            
            for await result in group {
                if let mediaItem = result {
                    mediaItems.append(mediaItem)
                }
                completedItems += 1
                
                DispatchQueue.main.async {
                    self.uploadProgress = Double(completedItems) / Double(totalItems)
                }
            }
        }
        
        return mediaItems
    }
    
    func uploadImage(_ image: UIImage) async -> String? {
        guard let imageData = image.jpegData(compressionQuality: 0.8) else {
            print("Failed to convert image to data")
            return nil
        }
        
        let fileName = "\(UUID().uuidString).jpg"
        let storageRef = storage.reference().child("images/\(fileName)")
        
        do {
            print("Starting image upload for: \(fileName)")
            let metadata = StorageMetadata()
            metadata.contentType = "image/jpeg"
            
            let _ = try await storageRef.putData(imageData, metadata: metadata)
            let downloadURL = try await storageRef.downloadURL()
            
            print("Image uploaded successfully: \(downloadURL.absoluteString)")
            return downloadURL.absoluteString
        } catch {
            print("Error uploading image: \(error)")
            DispatchQueue.main.async {
                self.errorMessage = "Failed to upload image: \(error.localizedDescription)"
            }
            return nil
        }
    }

    func uploadVideo(_ videoURL: URL) async -> String? {
        let fileName = "\(UUID().uuidString).mov"
        let storageRef = storage.reference().child("videos/\(fileName)")
        
        do {
            print("Starting video upload for: \(fileName)")
            let metadata = StorageMetadata()
            metadata.contentType = "video/quicktime"
            
            let _ = try await storageRef.putFile(from: videoURL, metadata: metadata)
            let downloadURL = try await storageRef.downloadURL()
            
            print("Video uploaded successfully: \(downloadURL.absoluteString)")
            return downloadURL.absoluteString
        } catch {
            print("Error uploading video: \(error)")
            DispatchQueue.main.async {
                self.errorMessage = "Failed to upload video: \(error.localizedDescription)"
            }
            return nil
        }
    }
    
    func addPost(_ post: ActivityPost) async {
        isLoading = true
        errorMessage = nil
        
        do {
            let postData = post.toDictionary()
            print("Adding post to Firestore: \(postData)")
            
            try await db.collection("posts").document(post.id).setData(postData)
            print("Post added successfully with ID: \(post.id)")
            
            let document = try await db.collection("posts").document(post.id).getDocument()
            if document.exists {
                print("Post verification successful")
            } else {
                print("Post verification failed - document doesn't exist")
            }
            
        } catch {
            print("Error adding post: \(error)")
            errorMessage = error.localizedDescription
        }
        
        isLoading = false
    }
    
    func toggleLike(for postId: String) async {
        guard let index = posts.firstIndex(where: { $0.id == postId }) else { return }
        
        let newLikeCount = posts[index].likes == 0 ? 1 : 0
        
        do {
            try await db.collection("posts").document(postId).updateData([
                "likes": newLikeCount
            ])
            print("Like toggled successfully")
        } catch {
            print("Error toggling like: \(error)")
            errorMessage = error.localizedDescription
        }
    }
    
    func deletePost(_ postId: String) async {
        do {
            try await db.collection("posts").document(postId).delete()
            print("Post deleted successfully")
        } catch {
            print("Error deleting post: \(error)")
            errorMessage = error.localizedDescription
        }
    }
}

struct ActivityView: View {
    @StateObject private var firebaseManager = FirebaseManager()
    @StateObject private var profileViewModel = ProfileViewModel()
    @State private var showingNewPost = false
    @State private var showingSettings = false
    @State private var showingAuth = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                if firebaseManager.isLoading {
                    ProgressView("Loading posts...")
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .padding()
                } else if firebaseManager.posts.isEmpty {
                    VStack(spacing: 20) {
                        Spacer()
                        
                        Image(systemName: "doc.text")
                            .font(.system(size: 60))
                            .foregroundColor(.gray.opacity(0.5))
                        
                        VStack(spacing: 8) {
                            Text("No Posts Yet")
                                .font(.title2)
                                .fontWeight(.semibold)
                                .foregroundColor(.primary)
                            
                            Text("Create your first post to get started")
                                .font(.body)
                                .foregroundColor(.secondary)
                                .multilineTextAlignment(.center)
                        }
                        
                        Button(action: { showingNewPost = true }) {
                            HStack {
                                Image(systemName: "plus.circle.fill")
                                    .font(.title3)
                                Text("Create Post")
                                    .fontWeight(.medium)
                            }
                            .foregroundColor(.white)
                            .padding(.horizontal, 24)
                            .padding(.vertical, 12)
                            .background(Color.accentColor)
                            .cornerRadius(25)
                        }
                        
                        Spacer()
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .padding(.horizontal, 32)
                } else {
                    LazyVStack(spacing: 20) {
                        ForEach(firebaseManager.posts) { post in
                            ActivityPostCard(
                                post: post,
                                firebaseManager: firebaseManager,
                                profileViewModel: profileViewModel
                            )
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.top, 8)
                }
            }
            .background(
                LinearGradient(
                    gradient: Gradient(colors: [Color.accentColor.opacity(0.1), Color.accentColor.opacity(0.1)]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            .navigationTitle("Activity")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) { }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { showingNewPost = true }) {
                        Image(systemName: "plus.circle.fill")
                            .font(.title2)
                            .foregroundColor(.accentColor)
                    }
                }
            }
            .sheet(isPresented: $showingNewPost) {
                NewPostView(firebaseManager: firebaseManager, profileViewModel: profileViewModel)
            }
            .alert("Error", isPresented: .constant(firebaseManager.errorMessage != nil)) {
                Button("OK") {
                    firebaseManager.errorMessage = nil
                }
            } message: {
                Text(firebaseManager.errorMessage ?? "")
            }
        }
        .onAppear {
            checkAuthStatus()
        }
    }
    
    private func checkAuthStatus() {
        if Auth.auth().currentUser == nil {
            showingAuth = true
        }
    }
}

struct ActivityPostCard: View {
    let post: ActivityPost
    let firebaseManager: FirebaseManager
    let profileViewModel: ProfileViewModel
    @State private var isExpanded = false
    
    private var shouldShowReadMore: Bool {
        let lines = post.caption.components(separatedBy: .newlines)
        return lines.count > 2 || post.caption.count > 100
    }
    
    private var displayCaption: String {
        if !isExpanded && shouldShowReadMore {
            let words = post.caption.components(separatedBy: .whitespaces)
            if words.count > 20 {
                return words.prefix(20).joined(separator: " ") + "..."
            }
        }
        return post.caption
    }
    
    private var displayUserName: String {
        if let userProfile = profileViewModel.userProfile, !userProfile.fullName.isEmpty {
            return userProfile.fullName
        }
        return post.userName.isEmpty ? "Current User" : post.userName
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            // Header
            HStack(spacing: 12) {
                Circle()
                    .fill(Color.accentColor)
                    .frame(width: 44, height: 44)
                    .overlay(
                        Image(systemName: "person.fill")
                            .font(.title2)
                            .foregroundColor(.white)
                    )
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(displayUserName)
                        .font(.headline)
                        .fontWeight(.semibold)
                    
                    Text(DateFormatter.activityDate.string(from: post.date))
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                Button(action: {}) {
                    Image(systemName: "ellipsis")
                        .font(.title3)
                        .foregroundColor(.secondary)
                }
            }
            
            // Caption
            if !post.caption.isEmpty {
                VStack(alignment: .leading, spacing: 8) {
                    Text(displayCaption)
                        .font(.body)
                        .multilineTextAlignment(.leading)
                        .lineLimit(isExpanded ? nil : 3)
                    
                    if shouldShowReadMore {
                        Button(action: {
                            withAnimation(.easeInOut(duration: 0.3)) {
                                isExpanded.toggle()
                            }
                        }) {
                            Text(isExpanded ? "Show less" : "Show more")
                                .font(.caption)
                                .fontWeight(.medium)
                                .foregroundColor(.blue)
                        }
                    }
                }
            }
            
            // Media - Remove debug overlay, just show the media
            if !post.mediaItems.isEmpty {
                FirebaseMediaGridView(mediaItems: post.mediaItems)
                    .frame(maxWidth: .infinity)
            }
            
            // Tags
            if !post.tags.isEmpty {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
                        ForEach(post.tags, id: \.self) { tag in
                            Text("#\(tag)")
                                .font(.caption)
                                .fontWeight(.medium)
                                .padding(.horizontal, 12)
                                .padding(.vertical, 6)
                                .background(Color.orange.opacity(0.15))
                                .foregroundColor(.orange)
                                .cornerRadius(16)
                        }
                    }
                    .padding(.horizontal, 1)
                }
            }
            
            // Like button
            HStack(spacing: 20) {
                Button(action: {
                    Task {
                        await firebaseManager.toggleLike(for: post.id)
                    }
                }) {
                    HStack(spacing: 6) {
                        Image(systemName: post.likes > 0 ? "heart.fill" : "heart")
                            .foregroundColor(post.likes > 0 ? .red : .primary)
                            .scaleEffect(post.likes > 0 ? 1.1 : 1.0)
                        Text("\(post.likes)")
                            .font(.caption)
                            .fontWeight(.medium)
                            .foregroundColor(.primary)
                    }
                }
                .buttonStyle(PlainButtonStyle())
                
                Spacer()
            }
        }
        .padding(20)
        .background(Color(.systemGray6))
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 2)
        .onAppear {
            print("=== Post Debug Info ===")
            print("Post ID: \(post.id)")
            print("Caption: \(post.caption)")
            print("Media items count: \(post.mediaItems.count)")
            for (index, item) in post.mediaItems.enumerated() {
                print("[\(index)] \(item.type.rawValue): \(item.firebaseURL)")
            }
            print("======================")
        }
    }
}

struct FirebaseMediaGridView: View {
    let mediaItems: [MediaItem]
    @State private var selectedVideoURL: URL?
    @State private var showingVideoPlayer = false
    
    private let maxDisplayItems = 4
    
    var body: some View {
        let displayItems = Array(mediaItems.prefix(maxDisplayItems))
        let remainingCount = max(0, mediaItems.count - maxDisplayItems)
        
        VStack(alignment: .leading, spacing: 8) {
            if !displayItems.isEmpty {
                LazyVGrid(columns: gridColumns(for: displayItems.count), spacing: 8) {
                    ForEach(Array(displayItems.enumerated()), id: \.element.id) { index, item in
                        ZStack {
                            if item.type == .image {
                                AsyncImageView(url: item.firebaseURL, height: imageHeight(for: displayItems.count))
                            } else if item.type == .video {
                                VideoThumbnailView(
                                    url: item.firebaseURL,
                                    height: imageHeight(for: displayItems.count)
                                ) {
                                    selectedVideoURL = URL(string: item.firebaseURL)
                                    showingVideoPlayer = true
                                }
                            }
                            
                            // Show remaining count overlay on last item
                            if index == displayItems.count - 1 && remainingCount > 0 {
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(Color.black.opacity(0.6))
                                    .frame(height: imageHeight(for: displayItems.count))
                                    .overlay(
                                        VStack(spacing: 4) {
                                            Text("+\(remainingCount)")
                                                .font(.title2)
                                                .fontWeight(.bold)
                                                .foregroundColor(.white)
                                            Text("more")
                                                .font(.caption)
                                                .foregroundColor(.white)
                                        }
                                    )
                                    .onTapGesture {
                                        print("Show all media tapped")
                                    }
                            }
                        }
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
        .fullScreenCover(isPresented: $showingVideoPlayer) {
            if let videoURL = selectedVideoURL {
                FirebaseVideoPlayerView(videoURL: videoURL, isPresented: $showingVideoPlayer)
            }
        }
    }
    
    private func gridColumns(for itemCount: Int) -> [GridItem] {
        switch itemCount {
        case 1:
            return [GridItem(.flexible())]
        case 2:
            return Array(repeating: GridItem(.flexible(), spacing: 8), count: 2)
        case 3, 4:
            return Array(repeating: GridItem(.flexible(), spacing: 8), count: 2)
        default:
            return Array(repeating: GridItem(.flexible(), spacing: 8), count: 2)
        }
    }
    
    private func imageHeight(for itemCount: Int) -> CGFloat {
        switch itemCount {
        case 1:
            return 250
        case 2:
            return 180
        case 3, 4:
            return 150
        default:
            return 150
        }
    }
}

struct AsyncImageView: View {
    let url: String
    let height: CGFloat
    @State private var loadingState: ImageLoadingState = .loading
    
    enum ImageLoadingState {
        case loading
        case loaded(UIImage)
        case failed(String)
    }
    
    var body: some View {
        Group {
            switch loadingState {
            case .loading:
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.gray.opacity(0.2))
                    .frame(height: height)
                    .overlay(
                        VStack(spacing: 8) {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle(tint: .accentColor))
                                .scaleEffect(0.8)
                            Text("Loading image...")
                                .font(.caption2)
                                .foregroundColor(.secondary)
                        }
                    )
                
            case .loaded(let image):
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(height: height)
                    .frame(maxWidth: .infinity)
                    .clipped()
                    .cornerRadius(12)
                    .transition(.opacity.combined(with: .scale(scale: 0.95)))
                
            case .failed(let error):
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.red.opacity(0.1))
                    .frame(height: height)
                    .overlay(
                        VStack(spacing: 6) {
                            Image(systemName: "photo")
                                .foregroundColor(.red)
                                .font(.title3)
                            Text("Failed to load")
                                .font(.caption)
                                .foregroundColor(.red)
                                .fontWeight(.medium)
                            Text(error)
                                .font(.caption2)
                                .foregroundColor(.secondary)
                                .multilineTextAlignment(.center)
                                .lineLimit(2)
                        }
                        .padding(12)
                    )
            }
        }
        .onAppear {
            loadImage()
        }
        .onChange(of: url) { _ in
            loadImage()
        }
    }
    
    private func loadImage() {
        guard !url.isEmpty else {
            loadingState = .failed("Empty URL")
            return
        }
        
        guard let imageURL = URL(string: url) else {
            loadingState = .failed("Invalid URL")
            return
        }
        
        print("🖼️ Loading image from: \(url)")
        
        // Reset state
        loadingState = .loading
        
        // Create URLRequest with proper configuration
        var request = URLRequest(url: imageURL)
        request.timeoutInterval = 30.0
        request.cachePolicy = .returnCacheDataElseLoad
        
        // Add headers for Firebase Storage
        request.setValue("image/*", forHTTPHeaderField: "Accept")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                if let error = error {
                    print("❌ Image loading error: \(error.localizedDescription)")
                    loadingState = .failed(error.localizedDescription)
                    return
                }
                
                guard let httpResponse = response as? HTTPURLResponse else {
                    print("❌ Invalid response type")
                    loadingState = .failed("Invalid response")
                    return
                }
                
                print("📡 Response status: \(httpResponse.statusCode)")
                
                guard 200...299 ~= httpResponse.statusCode else {
                    print("❌ HTTP error: \(httpResponse.statusCode)")
                    loadingState = .failed("HTTP \(httpResponse.statusCode)")
                    return
                }
                
                guard let data = data, !data.isEmpty else {
                    print("❌ Empty or nil data")
                    loadingState = .failed("No data received")
                    return
                }
                
                print("📦 Received \(data.count) bytes")
                
                guard let image = UIImage(data: data) else {
                    print("❌ Failed to create image from data")
                    loadingState = .failed("Invalid image data")
                    return
                }
                
                print("✅ Image loaded successfully - Size: \(image.size)")
                withAnimation(.easeInOut(duration: 0.3)) {
                    loadingState = .loaded(image)
                }
            }
        }.resume()
    }
}

struct VideoThumbnailView: View {
    let url: String
    let height: CGFloat
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .fill(
                        LinearGradient(
                            colors: [Color.blue.opacity(0.6), Color.blue.opacity(0.8)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(height: height)
                
                VStack(spacing: 8) {
                    Image(systemName: "play.circle.fill")
                        .font(.system(size: min(height * 0.25, 40)))
                        .foregroundColor(.white)
                    
                    Text("Video")
                        .font(.caption)
                        .fontWeight(.medium)
                        .foregroundColor(.white)
                }
                
                // Add subtle border
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color.white.opacity(0.3), lineWidth: 1)
                    .frame(height: height)
            }
        }
        .buttonStyle(PlainButtonStyle())
        .onAppear {
            print("🎥 Video thumbnail for: \(url)")
        }
    }
}

struct FirebaseVideoPlayerView: View {
    let videoURL: URL
    @Binding var isPresented: Bool
    @State private var player: AVPlayer?
    
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            
            if let player = player {
                VideoPlayer(player: player)
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                            player.play()
                        }
                    }
                    .onDisappear {
                        player.pause()
                    }
            } else {
                ProgressView("Loading video...")
                    .foregroundColor(.white)
            }
            
            VStack {
                HStack {
                    Spacer()
                    Button(action: {
                        player?.pause()
                        isPresented = false
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .font(.title2)
                            .foregroundColor(.white)
                            .background(Color.black.opacity(0.6))
                            .clipShape(Circle())
                    }
                    .padding()
                }
                Spacer()
            }
        }
        .onAppear {
            player = AVPlayer(url: videoURL)
        }
        .onDisappear {
            player?.pause()
            player = nil
        }
    }
}

struct NewPostView: View {
    let firebaseManager: FirebaseManager
    let profileViewModel: ProfileViewModel
    @Environment(\.dismiss) private var dismiss
    
    @State private var caption = ""
    @State private var selectedImages: [UIImage] = []
    @State private var selectedVideos: [URL] = []
    @State private var tags = ""
    @State private var showingImagePicker = false
    @State private var showingVideoPicker = false
    @State private var showingActionSheet = false
    @State private var isUploading = false
    @State private var uploadError: String?
    @State private var showingUploadError = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Caption")
                            .font(.headline)
                        
                        TextEditor(text: $caption)
                            .frame(minHeight: 100)
                            .padding(12)
                            .background(Color(.systemGray6))
                            .cornerRadius(12)
                    }
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Tags (separate with commas)")
                            .font(.headline)
                        
                        TextField("fitness, workout, healthy etc.", text: $tags)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                    }
                    
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Media")
                            .font(.headline)
                        
                        Button(action: {
                            showingActionSheet = true
                        }) {
                            HStack {
                                Image(systemName: "plus.circle.fill")
                                Text("Add Photos/Videos")
                            }
                            .foregroundColor(.accentColor)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.accentColor.opacity(0.1))
                            .cornerRadius(12)
                        }
                        .disabled(isUploading)
                        
                        if !selectedImages.isEmpty || !selectedVideos.isEmpty {
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Selected Media (\(selectedImages.count + selectedVideos.count) items)")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                                
                                ScrollView(.horizontal, showsIndicators: false) {
                                    HStack(spacing: 12) {
                                        ForEach(Array(selectedImages.enumerated()), id: \.offset) { index, image in
                                            ZStack(alignment: .topTrailing) {
                                                Image(uiImage: image)
                                                    .resizable()
                                                    .aspectRatio(contentMode: .fill)
                                                    .frame(width: 80, height: 80)
                                                    .clipped()
                                                    .cornerRadius(8)
                                                
                                                Button(action: {
                                                    selectedImages.remove(at: index)
                                                }) {
                                                    Image(systemName: "xmark.circle.fill")
                                                        .foregroundColor(.red)
                                                        .background(Color.white)
                                                        .clipShape(Circle())
                                                }
                                                .offset(x: 8, y: -8)
                                            }
                                        }
                                        
                                        ForEach(Array(selectedVideos.enumerated()), id: \.offset) { index, url in
                                            ZStack(alignment: .topTrailing) {
                                                ZStack {
                                                    RoundedRectangle(cornerRadius: 8)
                                                        .fill(Color.blue.opacity(0.3))
                                                        .frame(width: 80, height: 80)
                                                    
                                                    VStack(spacing: 4) {
                                                        Image(systemName: "play.circle.fill")
                                                            .font(.title2)
                                                            .foregroundColor(.white)
                                                        Text("Video")
                                                            .font(.caption2)
                                                            .foregroundColor(.white)
                                                    }
                                                }
                                                
                                                Button(action: {
                                                    selectedVideos.remove(at: index)
                                                }) {
                                                    Image(systemName: "xmark.circle.fill")
                                                        .foregroundColor(.red)
                                                        .background(Color.white)
                                                        .clipShape(Circle())
                                                }
                                                .offset(x: 8, y: -8)
                                            }
                                        }
                                    }
                                    .padding(.horizontal, 1)
                                }
                            }
                        }
                    }
                    
                    if isUploading {
                        VStack(spacing: 12) {
                            ProgressView(value: firebaseManager.uploadProgress)
                                .progressViewStyle(LinearProgressViewStyle())
                            
                            VStack(spacing: 4) {
                                Text("Uploading post...")
                                    .font(.headline)
                                Text("Please wait while we upload your media")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                                Text("\(Int(firebaseManager.uploadProgress * 100))% complete")
                                    .font(.caption)
                                    .foregroundColor(.accentColor)
                            }
                        }
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(12)
                    }
                    
                    Spacer()
                }
                .padding()
            }
            .navigationTitle("New Post")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .disabled(isUploading)
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Post") {
                        Task {
                            await createPost()
                        }
                    }
                    .disabled(isPostButtonDisabled)
                }
            }
            .sheet(isPresented: $showingImagePicker) {
                ImagePicker(selectedImages: $selectedImages)
            }
            .sheet(isPresented: $showingVideoPicker) {
                VideoPicker(selectedVideos: $selectedVideos)
            }
            .actionSheet(isPresented: $showingActionSheet) {
                ActionSheet(
                    title: Text("Add Media"),
                    buttons: [
                        .default(Text("Photos")) {
                            showingImagePicker = true
                        },
                        .default(Text("Videos")) {
                            showingVideoPicker = true
                        },
                        .cancel()
                    ]
                )
            }
            .alert("Upload Error", isPresented: $showingUploadError) {
                Button("OK") {
                    uploadError = nil
                }
            } message: {
                Text(uploadError ?? "Unknown error occurred")
            }
        }
    }
    
    private var isPostButtonDisabled: Bool {
        let hasContent = !caption.isEmpty || !selectedImages.isEmpty || !selectedVideos.isEmpty
        return !hasContent || isUploading
    }
    
    private func createPost() async {
        isUploading = true
        uploadError = nil
        
        do {
            print("Starting post creation...")
            print("Images: \(selectedImages.count), Videos: \(selectedVideos.count)")
            
            let mediaItems = await firebaseManager.uploadMediaItems(
                images: selectedImages,
                videos: selectedVideos
            )
            
            print("Media upload completed. Items: \(mediaItems.count)")
            
            for item in mediaItems {
                print("MediaItem: \(item.type.rawValue) - \(item.firebaseURL)")
                if item.firebaseURL.isEmpty {
                    throw NSError(domain: "MediaUpload", code: 1, userInfo: [NSLocalizedDescriptionKey: "Failed to upload media item"])
                }
            }
            
            let tagArray = tags.split(separator: ",")
                .map { $0.trimmingCharacters(in: .whitespaces) }
                .filter { !$0.isEmpty }
            
            let post = ActivityPost(
                userId: Auth.auth().currentUser?.uid ?? "anonymous",
                userName: profileViewModel.userProfile?.fullName ?? "Current User",
                userImage: "person.fill",
                date: Date(),
                caption: caption,
                mediaItems: mediaItems,
                likes: 0,
                tags: tagArray
            )
            
            print("Creating post with \(mediaItems.count) media items")
            
            await firebaseManager.addPost(post)
            
            print("Post created successfully")
            
            caption = ""
            selectedImages = []
            selectedVideos = []
            tags = ""
            
            isUploading = false
            dismiss()
            
        } catch {
            print("Error creating post: \(error)")
            uploadError = error.localizedDescription
            showingUploadError = true
            isUploading = false
        }
    }
}

struct ImagePicker: UIViewControllerRepresentable {
    @Binding var selectedImages: [UIImage]
    @Environment(\.dismiss) private var dismiss
    
    func makeUIViewController(context: Context) -> PHPickerViewController {
        var configuration = PHPickerConfiguration()
        configuration.filter = .images
        configuration.selectionLimit = 10
        
        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = context.coordinator
        return picker
    }
    
    func updateUIViewController(_ uiViewController: PHPickerViewController, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, PHPickerViewControllerDelegate {
        let parent: ImagePicker
        
        init(_ parent: ImagePicker) {
            self.parent = parent
        }
        
        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            parent.dismiss()
            
            for result in results {
                if result.itemProvider.canLoadObject(ofClass: UIImage.self) {
                    result.itemProvider.loadObject(ofClass: UIImage.self) { image, error in
                        if let image = image as? UIImage {
                            DispatchQueue.main.async {
                                self.parent.selectedImages.append(image)
                            }
                        }
                    }
                }
            }
        }
    }
}

struct VideoPicker: UIViewControllerRepresentable {
    @Binding var selectedVideos: [URL]
    @Environment(\.dismiss) private var dismiss
    
    func makeUIViewController(context: Context) -> PHPickerViewController {
        var configuration = PHPickerConfiguration()
        configuration.filter = .videos
        configuration.selectionLimit = 5
        
        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = context.coordinator
        return picker
    }
    
    func updateUIViewController(_ uiViewController: PHPickerViewController, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, PHPickerViewControllerDelegate {
        let parent: VideoPicker
        
        init(_ parent: VideoPicker) {
            self.parent = parent
        }
        
        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            parent.dismiss()
            
            for result in results {
                if result.itemProvider.hasItemConformingToTypeIdentifier(UTType.movie.identifier) {
                    result.itemProvider.loadFileRepresentation(forTypeIdentifier: UTType.movie.identifier) { url, error in
                        if let url = url {
                            let tempURL = FileManager.default.temporaryDirectory.appendingPathComponent(UUID().uuidString).appendingPathExtension("mov")
                            do {
                                try FileManager.default.copyItem(at: url, to: tempURL)
                                DispatchQueue.main.async {
                                    self.parent.selectedVideos.append(tempURL)
                                }
                            } catch {
                                print("Error copying video: \(error)")
                            }
                        }
                    }
                }
            }
        }
    }
}

extension DateFormatter {
    static let activityDate: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter
    }()
}
