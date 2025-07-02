import SwiftUI
import PhotosUI
import AVKit

struct ActivityPost: Identifiable, Codable {
    let id = UUID()
    let userName: String
    let userImage: String
    let date: Date
    let caption: String
    let mediaItems: [MediaItem]
    var likes: Int = 0
    let tags: [String]
    
    enum CodingKeys: String, CodingKey {
        case id, userName, userImage, date, caption, mediaItems, likes, tags
    }
}

struct MediaItem: Identifiable, Codable {
    var id = UUID()
    let type: MediaType
    let fileName: String
    
    enum MediaType: String, Codable, CaseIterable {
        case image = "image"
        case video = "video"
    }
    
    enum CodingKeys: String, CodingKey {
        case id, type, fileName
    }
}

struct Movie: Transferable {
    let url: URL
    
    static var transferRepresentation: some TransferRepresentation {
        FileRepresentation(contentType: .movie) { movie in
            SentTransferredFile(movie.url)
        } importing: { received in
            let copy = URL.documentsDirectory.appending(path: "movie-\(UUID().uuidString).mov")
            try FileManager.default.copyItem(at: received.file, to: copy)
            return Self.init(url: copy)
        }
    }
}

class ActivityDataManager: ObservableObject {
    @Published var posts: [ActivityPost] = []
    
    private let documentsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    private let postsFileName = "activity_posts.json"
    private let userDefaultsKey = "ActivityPosts"
    
    init() {
        loadPosts()
    }
    
    func addPost(_ post: ActivityPost) {
        posts.insert(post, at: 0)
        savePosts()
    }
    
    func toggleLike(for postId: UUID) {
        if let index = posts.firstIndex(where: { $0.id == postId }) {
            posts[index].likes += posts[index].likes > 0 ? -1 : 1
            savePosts()
        }
    }
    
    private func savePosts() {
        saveToUserDefaults()
        saveToFile()
    }
    
    private func saveToUserDefaults() {
        do {
            let data = try JSONEncoder().encode(posts)
            UserDefaults.standard.set(data, forKey: userDefaultsKey)
            UserDefaults.standard.synchronize()
        } catch {
            print("Error saving posts to UserDefaults: \(error)")
        }
    }
    
    private func saveToFile() {
        let url = documentsPath.appendingPathComponent(postsFileName)
        do {
            let data = try JSONEncoder().encode(posts)
            try data.write(to: url)
        } catch {
            print("Error saving posts to file: \(error)")
        }
    }
    
    private func loadPosts() {
        if loadFromUserDefaults() {
            return
        } else if loadFromFile() {
            return
        } else {
            loadSampleData()
        }
    }
    
    private func loadFromUserDefaults() -> Bool {
        guard let data = UserDefaults.standard.data(forKey: userDefaultsKey) else {
            return false
        }
        
        do {
            posts = try JSONDecoder().decode([ActivityPost].self, from: data)
            return true
        } catch {
            print("Error loading posts from UserDefaults: \(error)")
            return false
        }
    }
    
    private func loadFromFile() -> Bool {
        let url = documentsPath.appendingPathComponent(postsFileName)
        do {
            let data = try Data(contentsOf: url)
            posts = try JSONDecoder().decode([ActivityPost].self, from: data)
            saveToUserDefaults()
            return true
        } catch {
            print("Error loading posts from file: \(error)")
            return false
        }
    }
    
    private func loadSampleData() {
        let samplePost = ActivityPost(
            userName: "Ethan",
            userImage: "person.circle.fill",
            date: Date(),
            caption: "Integrated approach to learning with modern educational techniques and methodologies for better understanding.",
            mediaItems: [],
            likes: 0,
            tags: ["learning", "education"]
        )
        posts = [samplePost]
        savePosts()
    }
    
    func saveImageToDocuments(_ image: UIImage) -> String? {
        let fileName = "\(UUID().uuidString).jpg"
        let url = documentsPath.appendingPathComponent(fileName)
        
        if let data = image.jpegData(compressionQuality: 0.8) {
            do {
                try data.write(to: url)
                return fileName
            } catch {
                print("Error saving image: \(error)")
            }
        }
        return nil
    }
    
    func saveVideoToDocuments(_ videoURL: URL) -> String? {
        let fileName = "\(UUID().uuidString).\(videoURL.pathExtension.isEmpty ? "mov" : videoURL.pathExtension)"
        let destinationURL = documentsPath.appendingPathComponent(fileName)
        
        do {
            if FileManager.default.fileExists(atPath: destinationURL.path) {
                try FileManager.default.removeItem(at: destinationURL)
            }
            
            try FileManager.default.copyItem(at: videoURL, to: destinationURL)
            return fileName
        } catch {
            print("Error saving video: \(error)")
            return nil
        }
    }
    
    func loadImageFromDocuments(_ fileName: String) -> UIImage? {
        let url = documentsPath.appendingPathComponent(fileName)
        return UIImage(contentsOfFile: url.path)
    }
    
    func getVideoURL(_ fileName: String) -> URL {
        return documentsPath.appendingPathComponent(fileName)
    }
    
    func exportPosts() -> Data? {
        do {
            return try JSONEncoder().encode(posts)
        } catch {
            print("Error exporting posts: \(error)")
            return nil
        }
    }
    
    func importPosts(from data: Data) {
        do {
            let importedPosts = try JSONDecoder().decode([ActivityPost].self, from: data)
            
            var mergedPosts = posts
            for importedPost in importedPosts {
                if !mergedPosts.contains(where: { $0.id == importedPost.id }) {
                    mergedPosts.append(importedPost)
                }
            }
            
            mergedPosts.sort { $0.date > $1.date }
            
            posts = mergedPosts
            savePosts()
        } catch {
            print("Error importing posts: \(error)")
        }
    }
    
    func clearAllData() {
        posts = []
        UserDefaults.standard.removeObject(forKey: userDefaultsKey)
        
        let url = documentsPath.appendingPathComponent(postsFileName)
        try? FileManager.default.removeItem(at: url)
        
        loadSampleData()
    }
}

struct ActivityView: View {
    @StateObject private var dataManager = ActivityDataManager()
    @State private var showingNewPost = false
    @State private var showingSettings = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                LazyVStack(spacing: 20) {
                    ForEach(dataManager.posts) { post in
                        ActivityPostCard(post: post, dataManager: dataManager)
                    }
                }
                .padding(.horizontal, 16)
                .padding(.top, 8)
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
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: { showingSettings = true }) {
                        Image(systemName: "gear")
                            .font(.title2)
                            .foregroundColor(.accentColor)
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { showingNewPost = true }) {
                        Image(systemName: "plus.circle.fill")
                            .font(.title2)
                            .foregroundColor(.accentColor)
                    }
                }
            }
            .sheet(isPresented: $showingNewPost) {
                NewPostView(dataManager: dataManager)
            }
            .sheet(isPresented: $showingSettings) {
                SettingsView(dataManager: dataManager)
            }
        }
    }
}

struct ActivityPostCard: View {
    let post: ActivityPost
    let dataManager: ActivityDataManager
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
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack(spacing: 12) {
                Image(systemName: post.userImage)
                    .font(.title2)
                    .foregroundColor(.white)
                    .frame(width: 44, height: 44)
                    .background(
                        LinearGradient(
                            colors: [.accentColor, .accentColor],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .clipShape(Circle())
                
                VStack(alignment: .leading, spacing: 4) {
                    HStack {
                        Text(post.userName)
                            .font(.headline)
                            .fontWeight(.semibold)
                        
                        Image(systemName: "checkmark.seal.fill")
                            .font(.caption)
                            .foregroundColor(.blue)
                    }
                    
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
            
            if !post.caption.isEmpty {
                VStack(alignment: .leading, spacing: 8) {
                    Text(displayCaption)
                        .font(.body)
                        .multilineTextAlignment(.leading)
                        .lineLimit(isExpanded ? nil : 2)
                    
                    if shouldShowReadMore {
                        Button(action: {
                            withAnimation(.easeInOut(duration: 0.3)) {
                                isExpanded.toggle()
                            }
                        }) {
                            Text(isExpanded ? "Read less" : "Read more")
                                .font(.caption)
                                .fontWeight(.medium)
                                .foregroundColor(.blue)
                        }
                    }
                }
            }
            
            if !post.mediaItems.isEmpty {
                MediaGridView(mediaItems: post.mediaItems, dataManager: dataManager)
            }
            
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
            
            HStack(spacing: 20) {
                Button(action: {
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                        dataManager.toggleLike(for: post.id)
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
                Spacer()
            }
        }
        .padding(20)
        .background(Color(.systemGray6))
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 2)
    }
}

struct FullScreenImageGallery: View {
    let mediaItems: [MediaItem]
    let dataManager: ActivityDataManager
    let initialIndex: Int
    @Binding var isPresented: Bool
    
    @State private var currentIndex: Int
    @State private var dragOffset: CGSize = .zero
    @State private var scale: CGFloat = 1.0
    @State private var lastScale: CGFloat = 1.0
    @GestureState private var magnifyBy = 1.0
    
    init(mediaItems: [MediaItem], dataManager: ActivityDataManager, initialIndex: Int, isPresented: Binding<Bool>) {
        self.mediaItems = mediaItems.filter { $0.type == .image }
        self.dataManager = dataManager
        self.initialIndex = initialIndex
        self._isPresented = isPresented
        self._currentIndex = State(initialValue: initialIndex)
    }
    
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            
            if !mediaItems.isEmpty && currentIndex < mediaItems.count {
                TabView(selection: $currentIndex) {
                    ForEach(Array(mediaItems.enumerated()), id: \.element.id) { index, item in
                        if let image = dataManager.loadImageFromDocuments(item.fileName) {
                            GeometryReader { geometry in
                                Image(uiImage: image)
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: geometry.size.width, height: geometry.size.height)
                                    .scaleEffect(scale * magnifyBy)
                                    .offset(dragOffset)
                                    .gesture(
                                        SimultaneousGesture(
                                            MagnificationGesture()
                                                .updating($magnifyBy) { currentState, gestureState, transaction in
                                                    gestureState = currentState
                                                }
                                                .onEnded { value in
                                                    scale = max(1.0, min(scale * value, 5.0))
                                                },
                                            
                                            DragGesture()
                                                .onChanged { value in
                                                    if scale > 1.0 {
                                                        dragOffset = value.translation
                                                    }
                                                }
                                                .onEnded { value in
                                                    if scale > 1.0 {
                                                        withAnimation(.spring()) {
                                                            dragOffset = .zero
                                                        }
                                                    }
                                                }
                                        )
                                    )
                                    .onTapGesture(count: 2) {
                                        withAnimation(.spring()) {
                                            if scale > 1.0 {
                                                scale = 1.0
                                                dragOffset = .zero
                                            } else {
                                                scale = 3.0
                                            }
                                        }
                                    }
                            }
                            .tag(index)
                        }
                    }
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                .onChange(of: currentIndex) { _, _ in
                    withAnimation(.easeInOut(duration: 0.2)) {
                        scale = 1.0
                        dragOffset = .zero
                    }
                }
            }
            
            VStack {
                HStack {
                    Button(action: {
                        isPresented = false
                    }) {
                        Image(systemName: "xmark")
                            .font(.title2)
                            .foregroundColor(.white)
                            .padding(12)
                            .background(Color.black.opacity(0.6))
                            .clipShape(Circle())
                    }
                    
                    Spacer()
                    
                    Text("\(currentIndex + 1) of \(mediaItems.count)")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                        .background(Color.black.opacity(0.6))
                        .cornerRadius(20)
                }
                .padding()
                
                Spacer()
            }
            
            if mediaItems.count > 1 {
                VStack {
                    Spacer()
                    
                    HStack(spacing: 8) {
                        ForEach(0..<mediaItems.count, id: \.self) { index in
                            Circle()
                                .fill(index == currentIndex ? Color.white : Color.white.opacity(0.4))
                                .frame(width: 8, height: 8)
                                .animation(.easeInOut(duration: 0.2), value: currentIndex)
                        }
                    }
                    .padding(.bottom, 50)
                }
            }
        }
        .statusBarHidden()
        .onAppear {
            currentIndex = initialIndex
        }
    }
}

struct MediaGridView: View {
    let mediaItems: [MediaItem]
    let dataManager: ActivityDataManager
    @State private var selectedVideoURL: URL?
    @State private var showingVideoPlayer = false
    @State private var showingAllMedia = false
    @State private var showingImageGallery = false
    @State private var selectedImageIndex = 0
    
    private let maxDisplayItems = 4
    
    var body: some View {
        let displayItems = Array(mediaItems.prefix(maxDisplayItems))
        let remainingCount = max(0, mediaItems.count - maxDisplayItems)
        
        LazyVGrid(columns: gridColumns(for: displayItems.count), spacing: 8) {
            ForEach(Array(displayItems.enumerated()), id: \.element.id) { index, item in
                ZStack {
                    if item.type == .image {
                        if let image = dataManager.loadImageFromDocuments(item.fileName) {
                            Image(uiImage: image)
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(height: imageHeight(for: displayItems.count))
                                .clipped()
                                .cornerRadius(12)
                                .onTapGesture {
                                    if let originalIndex = mediaItems.firstIndex(where: { $0.id == item.id }) {
                                        selectedImageIndex = getImageIndex(for: originalIndex)
                                        showingImageGallery = true
                                    }
                                }
                        }
                    } else if item.type == .video {
                        Button(action: {
                            selectedVideoURL = dataManager.getVideoURL(item.fileName)
                            showingVideoPlayer = true
                        }) {
                            ZStack {
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(
                                        LinearGradient(
                                            colors: [.black.opacity(0.3), .black.opacity(0.7)],
                                            startPoint: .top,
                                            endPoint: .bottom
                                        )
                                    )
                                    .frame(height: imageHeight(for: displayItems.count))
                                
                                VStack(spacing: 8) {
                                    Image(systemName: "play.circle.fill")
                                        .font(.system(size: 40))
                                        .foregroundColor(.white)
                                }
                            }
                        }
                    }
                    
                    if index == displayItems.count - 1 && remainingCount > 0 {
                        Button(action: {
                            showingAllMedia = true
                        }) {
                            ZStack {
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(Color.black.opacity(0.6))
                                    .frame(height: imageHeight(for: displayItems.count))
                                
                                VStack(spacing: 4) {
                                    Text("+\(remainingCount) more")
                                        .font(.title)
                                        .fontWeight(.semibold)
                                        .foregroundColor(.white)
                                }
                            }
                        }
                    }
                }
            }
        }
        .fullScreenCover(isPresented: $showingVideoPlayer) {
            if let videoURL = selectedVideoURL {
                VideosPlayerView(videoURL: videoURL, isPresented: $showingVideoPlayer)
            }
        }
        .sheet(isPresented: $showingAllMedia) {
            AllMediaView(mediaItems: mediaItems, dataManager: dataManager)
        }
        .fullScreenCover(isPresented: $showingImageGallery) {
            FullScreenImageGallery(
                mediaItems: mediaItems,
                dataManager: dataManager,
                initialIndex: selectedImageIndex,
                isPresented: $showingImageGallery
            )
        }
    }
    
    private func getImageIndex(for originalIndex: Int) -> Int {
        let imagesBeforeIndex = mediaItems.prefix(originalIndex).filter { $0.type == .image }.count
        return imagesBeforeIndex
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
            return 140
        case 2:
            return 140
        case 3, 4:
            return 140
        default:
            return 140
        }
    }
}

struct AllMediaView: View {
    let mediaItems: [MediaItem]
    let dataManager: ActivityDataManager
    @Environment(\.dismiss) private var dismiss
    @State private var selectedVideoURL: URL?
    @State private var showingVideoPlayer = false
    @State private var showingImageGallery = false
    @State private var selectedImageIndex = 0
    
    var body: some View {
        NavigationView {
            ScrollView {
                LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 8), count: 2), spacing: 8) {
                    ForEach(Array(mediaItems.enumerated()), id: \.element.id) { index, item in
                        if item.type == .image {
                            if let image = dataManager.loadImageFromDocuments(item.fileName) {
                                Image(uiImage: image)
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(height: 160)
                                    .clipped()
                                    .cornerRadius(12)
                                    .onTapGesture {
                                        selectedImageIndex = getImageIndex(for: index)
                                        showingImageGallery = true
                                    }
                            }
                        } else if item.type == .video {
                            Button(action: {
                                selectedVideoURL = dataManager.getVideoURL(item.fileName)
                                showingVideoPlayer = true
                            }) {
                                ZStack {
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(
                                            LinearGradient(
                                                colors: [.black.opacity(0.3), .black.opacity(0.7)],
                                                startPoint: .top,
                                                endPoint: .bottom
                                            )
                                        )
                                        .frame(height: 160)
                                    
                                    VStack(spacing: 8) {
                                        Image(systemName: "play.circle.fill")
                                            .font(.system(size: 40))
                                            .foregroundColor(.white)
                                    }
                                }
                            }
                        }
                    }
                }
                .padding(.horizontal, 16)
                .padding(.top, 8)
            }
            .navigationTitle("All Media (\(mediaItems.count))")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
            .fullScreenCover(isPresented: $showingVideoPlayer) {
                if let videoURL = selectedVideoURL {
                    VideosPlayerView(videoURL: videoURL, isPresented: $showingVideoPlayer)
                }
            }
            .fullScreenCover(isPresented: $showingImageGallery) {
                FullScreenImageGallery(
                    mediaItems: mediaItems,
                    dataManager: dataManager,
                    initialIndex: selectedImageIndex,
                    isPresented: $showingImageGallery
                )
            }
        }
    }
    
    private func getImageIndex(for originalIndex: Int) -> Int {
        let imagesBeforeIndex = mediaItems.prefix(originalIndex).filter { $0.type == .image }.count
        return imagesBeforeIndex
    }
}

struct VideosPlayerView: View {
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
            setupPlayer()
        }
        .onDisappear {
            cleanupPlayer()
        }
    }
    
    private func setupPlayer() {
        guard FileManager.default.fileExists(atPath: videoURL.path) else {
            print("Video file does not exist at: \(videoURL.path)")
            return
        }
        
        player = AVPlayer(url: videoURL)
        
        NotificationCenter.default.addObserver(
            forName: .AVPlayerItemDidPlayToEndTime,
            object: player?.currentItem,
            queue: .main
        ) { _ in
            player?.seek(to: .zero)
        }
    }
    
    private func cleanupPlayer() {
        player?.pause()
        player = nil
        NotificationCenter.default.removeObserver(self)
    }
}

struct SettingsView: View {
    @ObservedObject var dataManager: ActivityDataManager
    @Environment(\.dismiss) private var dismiss
    @State private var showingClearAlert = false
    @State private var showingExportShare = false
    @State private var exportData: Data?
    
    var body: some View {
        NavigationView {
            Form {
                Section("Data Management") {
                    Button(action: exportPosts) {
                        Label("Export Posts", systemImage: "square.and.arrow.up")
                    }
                    
                    Button(action: { showingClearAlert = true }) {
                        Label("Clear All Data", systemImage: "trash")
                            .foregroundColor(.red)
                    }
                }
                
                Section("Info") {
                    HStack {
                        Text("Total Posts")
                        Spacer()
                        Text("\(dataManager.posts.count)")
                            .foregroundColor(.secondary)
                    }
                    
                    HStack {
                        Text("Storage")
                        Spacer()
                        Text("Local Device")
                            .foregroundColor(.secondary)
                    }
                }
            }
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
            .alert("Clear All Data", isPresented: $showingClearAlert) {
                Button("Cancel", role: .cancel) { }
                Button("Clear", role: .destructive) {
                    dataManager.clearAllData()
                }
            } message: {
                Text("This will permanently delete all your posts and images. This action cannot be undone.")
            }
            .sheet(isPresented: $showingExportShare) {
                if let data = exportData {
                    ActivityViewController(activityItems: [data])
                }
            }
        }
    }
    
    private func exportPosts() {
        if let data = dataManager.exportPosts() {
            exportData = data
            showingExportShare = true
        }
    }
}

struct ActivityViewController: UIViewControllerRepresentable {
    let activityItems: [Any]
    
    func makeUIViewController(context: Context) -> UIActivityViewController {
        return UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
    }
    
    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
}

struct NewPostView: View {
    @ObservedObject var dataManager: ActivityDataManager
    @Environment(\.dismiss) private var dismiss
    
    @State private var userName = "Current User"
    @State private var caption = ""
    @State private var tags = ""
    @State private var selectedImages: [UIImage] = []
    @State private var selectedVideoURLs: [URL] = []
    @State private var isProcessingMedia = false
    @State private var photoPickerItems: [PhotosPickerItem] = []
    
    var body: some View {
        NavigationView {
            Form {
                Section("User Info") {
                    TextField("Your Name", text: $userName)
                }
                
                Section("Media") {
                    PhotosPicker(
                        selection: $photoPickerItems,
                        maxSelectionCount: 20,
                        matching: .any(of: [.images, .videos])
                    ) {
                        Label("Select Photos & Videos", systemImage: "photo.on.rectangle.angled")
                    }
                    
                    if !selectedImages.isEmpty || !selectedVideoURLs.isEmpty {
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack {
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
                                                .foregroundColor(.white)
                                                .background(Color.black.opacity(0.6))
                                                .clipShape(Circle())
                                        }
                                        .padding(4)
                                    }
                                }
                                
                                ForEach(Array(selectedVideoURLs.enumerated()), id: \.offset) { index, videoURL in
                                    ZStack(alignment: .topTrailing) {
                                        RoundedRectangle(cornerRadius: 8)
                                            .fill(Color.gray.opacity(0.3))
                                            .frame(width: 80, height: 80)
                                            .overlay(
                                                VStack {
                                                    Image(systemName: "play.circle.fill")
                                                        .font(.title2)
                                                        .foregroundColor(.white)
                                                }
                                            )
                                        
                                        Button(action: {
                                            selectedVideoURLs.remove(at: index)
                                        }) {
                                            Image(systemName: "xmark.circle.fill")
                                                .foregroundColor(.white)
                                                .background(Color.black.opacity(0.6))
                                                .clipShape(Circle())
                                        }
                                        .padding(4)
                                    }
                                }
                            }
                            .padding(.horizontal)
                        }
                    }
                }
                
                Section("Content") {
                    TextField("What's happening?", text: $caption, axis: .vertical)
                        .lineLimit(3...6)
                    
                    TextField("Tags (comma separated)", text: $tags)
                }
            }
            .navigationTitle("New Post")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Post") {
                        createPost()
                    }
                    .disabled(caption.isEmpty && selectedImages.isEmpty && selectedVideoURLs.isEmpty)
                }
            }
            .onChange(of: photoPickerItems) { _, newItems in
                processSelectedMedia(newItems)
            }
        }
    }
    
    private func processSelectedMedia(_ items: [PhotosPickerItem]) {
        guard !items.isEmpty else { return }
        
        isProcessingMedia = true
        selectedImages.removeAll()
        selectedVideoURLs.removeAll()
        
        Task {
            await withTaskGroup(of: Void.self) { group in
                for item in items {
                    group.addTask {
                        await processMediaItem(item)
                    }
                }
            }
            
            await MainActor.run {
                isProcessingMedia = false
            }
        }
    }
    
    private func processMediaItem(_ item: PhotosPickerItem) async {
        do {
            if let imageData = try? await item.loadTransferable(type: Data.self),
               let image = UIImage(data: imageData) {
                await MainActor.run {
                    selectedImages.append(image)
                }
                return
            }
            
            if let movie = try? await item.loadTransferable(type: Movie.self) {
                await MainActor.run {
                    selectedVideoURLs.append(movie.url)
                }
            }
        } catch {
            print("Error processing media item: \(error)")
        }
    }
    
    private func createPost() {
        var mediaItems: [MediaItem] = []
        
        for image in selectedImages {
            if let fileName = dataManager.saveImageToDocuments(image) {
                let mediaItem = MediaItem(type: .image, fileName: fileName)
                mediaItems.append(mediaItem)
            }
        }
        
        for videoURL in selectedVideoURLs {
            if let fileName = dataManager.saveVideoToDocuments(videoURL) {
                let mediaItem = MediaItem(type: .video, fileName: fileName)
                mediaItems.append(mediaItem)
            }
        }
        
        let tagArray = tags.split(separator: ",").map { $0.trimmingCharacters(in: .whitespaces) }
        
        let newPost = ActivityPost(
            userName: userName,
            userImage: "person.circle.fill",
            date: Date(),
            caption: caption,
            mediaItems: mediaItems,
            likes: 0,
            tags: tagArray
        )
        
        dataManager.addPost(newPost)
        dismiss()
    }
}

extension DateFormatter {
    static let activityDate: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM dd, yyyy"
        return formatter
    }()
}

#Preview {
    ActivityView()
}
