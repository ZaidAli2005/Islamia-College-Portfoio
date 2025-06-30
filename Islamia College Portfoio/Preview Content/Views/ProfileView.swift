import SwiftUI
import Firebase
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage
import PhotosUI
import Network

struct UserProfile {
    let id: String
    let fullName: String
    let email: String
    let studentID: String
    let profileImageURL: String?
    let createdAt: Date
    
    init(id: String, data: [String: Any]) {
        self.id = id
        self.fullName = data["fullName"] as? String ?? ""
        self.email = data["email"] as? String ?? ""
        self.studentID = data["studentID"] as? String ?? ""
        self.profileImageURL = data["profileImageURL"] as? String
        
        if let timestamp = data["createdAt"] as? Timestamp {
            self.createdAt = timestamp.dateValue()
        } else {
            self.createdAt = Date()
        }
    }
}

class ProfileViewModel: ObservableObject {
    @Published var userProfile: UserProfile?
    @Published var isLoading = true
    @Published var errorMessage = ""
    @Published var showingEditProfile = false
    @Published var isUploadingImage = false
    @Published var selectedImage: UIImage?
    @Published var showingImagePicker = false
    @Published var isOffline = false
    
    private let db = Firestore.firestore()
    private let storage = Storage.storage()
    private let networkMonitor = NWPathMonitor()
    private let networkQueue = DispatchQueue(label: "NetworkMonitor")
    
    init() {
        setupFirestore()
        setupNetworkMonitoring()
        fetchUserProfile()
    }
    
    deinit {
        networkMonitor.cancel()
    }
    
    private func setupFirestore() {
        let settings = FirestoreSettings()
        settings.isPersistenceEnabled = true
        settings.cacheSizeBytes = FirestoreCacheSizeUnlimited
        db.settings = settings
        
        db.enableNetwork { [weak self] error in
            if let error = error {
                print("Failed to enable Firestore network: \(error.localizedDescription)")
            } else {
                print("Firestore network enabled successfully")
                DispatchQueue.main.async {
                    self?.fetchUserProfile()
                }
            }
        }
    }
    
    private func setupNetworkMonitoring() {
        networkMonitor.pathUpdateHandler = { [weak self] path in
            DispatchQueue.main.async {
                self?.isOffline = path.status != .satisfied
                if path.status == .satisfied && self?.userProfile == nil {
                    self?.fetchUserProfile()
                }
            }
        }
        networkMonitor.start(queue: networkQueue)
    }
    
    func fetchUserProfile() {
        guard let userId = Auth.auth().currentUser?.uid else {
            errorMessage = "No user logged in"
            isLoading = false
            return
        }
        
        isLoading = true
        errorMessage = ""
        
        let docRef = db.collection("users").document(userId)
        
        docRef.getDocument(source: .cache) { [weak self] document, error in
            if let document = document, document.exists, let data = document.data() {
                DispatchQueue.main.async {
                    self?.userProfile = UserProfile(id: userId, data: data)
                    self?.isLoading = false
                }
                self?.fetchFromServer(docRef: docRef, userId: userId)
            } else {
                self?.fetchFromServer(docRef: docRef, userId: userId)
            }
        }
    }
    
    private func fetchFromServer(docRef: DocumentReference, userId: String) {
        docRef.getDocument(source: .server) { [weak self] document, error in
            DispatchQueue.main.async {
                self?.isLoading = false
                
                if let error = error {
                    let nsError = error as NSError
                    if nsError.code == 14 {
                        self?.errorMessage = "Unable to connect to server. Please check your internet connection."
                    } else {
                        self?.errorMessage = error.localizedDescription
                    }
                } else if let document = document, document.exists, let data = document.data() {
                    self?.userProfile = UserProfile(id: userId, data: data)
                    self?.errorMessage = ""
                } else {
                    self?.errorMessage = "User profile not found"
                }
            }
        }
    }
    
    func retryFetchProfile() {
        errorMessage = ""
        db.enableNetwork { [weak self] error in
            if let error = error {
                print("Network enable error: \(error.localizedDescription)")
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                self?.fetchUserProfile()
            }
        }
    }
    
    func uploadProfileImage(_ image: UIImage) {
        guard let userId = Auth.auth().currentUser?.uid else { return }
        guard let imageData = image.jpegData(compressionQuality: 0.8) else { return }
        
        isUploadingImage = true
        
        let imageRef = storage.reference().child("profile_images/\(userId).jpg")
        
        imageRef.putData(imageData, metadata: nil) { [weak self] metadata, error in
            if let error = error {
                DispatchQueue.main.async {
                    self?.isUploadingImage = false
                    self?.errorMessage = "Failed to upload image: \(error.localizedDescription)"
                }
                return
            }
            
            imageRef.downloadURL { [weak self] url, error in
                DispatchQueue.main.async {
                    self?.isUploadingImage = false
                    
                    if let error = error {
                        self?.errorMessage = "Failed to get download URL: \(error.localizedDescription)"
                    } else if let url = url {
                        self?.updateProfileImageURL(url.absoluteString)
                    }
                }
            }
        }
    }
    
    private func updateProfileImageURL(_ imageURL: String) {
        guard let userId = Auth.auth().currentUser?.uid else { return }
        
        db.collection("users").document(userId).updateData([
            "profileImageURL": imageURL
        ]) { [weak self] error in
            DispatchQueue.main.async {
                if let error = error {
                    self?.errorMessage = error.localizedDescription
                } else {
                    self?.fetchUserProfile()
                }
            }
        }
    }
    
    func signOut() {
        do {
            try Auth.auth().signOut()
        } catch {
            errorMessage = error.localizedDescription
        }
    }
    
    func updateProfile(fullName: String) {
        guard let userId = Auth.auth().currentUser?.uid else { return }
        
        db.collection("users").document(userId).updateData([
            "fullName": fullName
        ]) { [weak self] error in
            DispatchQueue.main.async {
                if let error = error {
                    self?.errorMessage = error.localizedDescription
                } else {
                    self?.fetchUserProfile()
                    self?.showingEditProfile = false
                }
            }
        }
    }
}

struct ProfileView: View {
    @StateObject private var viewModel = ProfileViewModel()
    @State private var showingSignOutAlert = false
    
    var body: some View {
        NavigationView {
            GeometryReader { geometry in
                ZStack {
                    LinearGradient(
                        colors: [
                            Color(red: 0.4, green: 0.6, blue: 0.8),
                            Color(red: 0.3, green: 0.5, blue: 0.7)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                    .ignoresSafeArea()
                    
                    Circle()
                        .fill(Color.white.opacity(0.1))
                        .frame(width: 150, height: 150)
                        .position(x: geometry.size.width * 0.9, y: geometry.size.height * 0.1)
                    
                    Circle()
                        .fill(Color.white.opacity(0.05))
                        .frame(width: 100, height: 100)
                        .position(x: geometry.size.width * 0.1, y: geometry.size.height * 0.8)
                    
                    if viewModel.isOffline {
                        VStack {
                            HStack {
                                Image(systemName: "wifi.slash")
                                    .font(.system(size: 12))
                                Text("No Internet Connection")
                                    .font(.caption)
                            }
                            .foregroundColor(.white)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(
                                Capsule()
                                    .fill(Color.red.opacity(0.8))
                            )
                            Spacer()
                        }
                        .padding(.top, 10)
                    }
                    
                    if viewModel.isLoading {
                        VStack {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                .scaleEffect(1.5)
                            
                            Text("Loading Profile...")
                                .foregroundColor(.white)
                                .font(.headline)
                                .padding(.top, 16)
                        }
                    } else if let userProfile = viewModel.userProfile {
                        ScrollView {
                            VStack(spacing: 30) {
                                VStack(spacing: 20) {
                                    ZStack {
                                        ProfileImageView(
                                            imageURL: userProfile.profileImageURL,
                                            fallbackText: userProfile.fullName.prefix(2).uppercased(),
                                            isUploading: viewModel.isUploadingImage
                                        )
                                        .onTapGesture {
                                            viewModel.showingImagePicker = true
                                        }
                                        VStack {
                                            Spacer()
                                            HStack {
                                                Spacer()
                                                ZStack {
                                                    Circle()
                                                        .fill(Color.blue)
                                                        .frame(width: 32, height: 32)
                                                    
                                                    Image(systemName: "camera.fill")
                                                        .foregroundColor(.white)
                                                        .font(.system(size: 14))
                                                }
                                                .offset(x: -8, y: -8)
                                            }
                                        }
                                        .frame(width: 120, height: 120)
                                    }
                                    
                                    VStack(spacing: 8) {
                                        Text(userProfile.fullName)
                                            .font(.title2)
                                            .fontWeight(.bold)
                                            .foregroundColor(.white)
                                        
                                        Text("Student ID: \(userProfile.studentID)")
                                            .font(.subheadline)
                                            .foregroundColor(.white.opacity(0.8))
                                            .padding(.horizontal, 16)
                                            .padding(.vertical, 6)
                                            .background(
                                                Capsule()
                                                    .fill(Color.white.opacity(0.2))
                                            )
                                    }
                                }
                                .padding(.top, 20)
                                
                                VStack(spacing: 16) {
                                    ProfileInfoCard(
                                        icon: "envelope.fill",
                                        title: "Email Address",
                                        value: userProfile.email,
                                        iconColor: .blue
                                    )
                                    
                                    ProfileInfoCard(
                                        icon: "calendar.circle.fill",
                                        title: "Member Since",
                                        value: formatDate(userProfile.createdAt),
                                        iconColor: .blue
                                    )
                                    
                                    ProfileInfoCard(
                                        icon: "graduationcap.fill",
                                        title: "Institution",
                                        value: "Islamia College Gujranwala",
                                        iconColor: .blue
                                    )
                                    
                                    ProfileInfoCard(
                                        icon: "person.badge.shield.checkmark.fill",
                                        title: "Account Status",
                                        value: "Active Student",
                                        iconColor: .blue
                                    )
                                }
                                VStack(spacing: 12) {
                                    Button(action: {
                                        viewModel.showingEditProfile = true
                                    }) {
                                        HStack {
                                            Image(systemName: "pencil.circle.fill")
                                                .font(.system(size: 20))
                                            Text("Edit Profile")
                                                .font(.headline)
                                                .fontWeight(.semibold)
                                        }
                                        .foregroundColor(.white)
                                        .frame(maxWidth: .infinity)
                                        .padding(.vertical, 16)
                                        .background(
                                            LinearGradient(
                                                colors: [Color.accentColor, Color.accentColor],
                                                startPoint: .leading,
                                                endPoint: .trailing
                                            )
                                        )
                                        .cornerRadius(25)
                                    }
                                    Button(action: {
                                        showingSignOutAlert = true
                                    }) {
                                        HStack {
                                            Image(systemName: "arrow.right.square.fill")
                                                .font(.system(size: 20))
                                            Text("Sign Out")
                                                .font(.headline)
                                                .fontWeight(.semibold)
                                        }
                                        .foregroundColor(.white)
                                        .frame(maxWidth: .infinity)
                                        .padding(.vertical, 16)
                                        .background(
                                            LinearGradient(
                                                colors: [Color.red.opacity(0.8), Color.pink.opacity(0.8)],
                                                startPoint: .leading,
                                                endPoint: .trailing
                                            )
                                        )
                                        .cornerRadius(25)
                                    }
                                }
                                .padding(.top, 20)
                                
                                Spacer(minLength: 50)
                            }
                            .padding(.horizontal, 20)
                        }
                    } else {
                        VStack(spacing: 20) {
                            Image(systemName: viewModel.isOffline ? "wifi.slash" : "exclamationmark.triangle.fill")
                                .font(.system(size: 60))
                                .foregroundColor(.white.opacity(0.8))
                            
                            Text(viewModel.isOffline ? "No Internet Connection" : "Unable to Load Profile")
                                .font(.title2)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                            
                            Text(viewModel.isOffline ? "Please check your internet connection and try again." : viewModel.errorMessage)
                                .font(.body)
                                .foregroundColor(.white.opacity(0.8))
                                .multilineTextAlignment(.center)
                                .padding(.horizontal, 40)
                            
                            Button("Retry") {
                                viewModel.retryFetchProfile()
                            }
                            .foregroundColor(.white)
                            .font(.headline)
                            .padding(.horizontal, 30)
                            .padding(.vertical, 12)
                            .background(
                                Capsule()
                                    .fill(Color.white.opacity(0.3))
                            )
                        }
                    }
                }
            }
            .navigationTitle("Profile")
            .navigationBarTitleDisplayMode(.inline)
            .toolbarBackground(.clear, for: .navigationBar)
            .toolbarColorScheme(.dark, for: .navigationBar)
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .alert("Sign Out", isPresented: $showingSignOutAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Sign Out", role: .destructive) {
                viewModel.signOut()
            }
        } message: {
            Text("Are you sure you want to sign out?")
        }
        .sheet(isPresented: $viewModel.showingEditProfile) {
            if let userProfile = viewModel.userProfile {
                EditProfileView(
                    currentName: userProfile.fullName,
                    onSave: viewModel.updateProfile
                )
            }
        }
        .sheet(isPresented: $viewModel.showingImagePicker) {
            ImagePicker(selectedImage: $viewModel.selectedImage)
        }
        .onChange(of: viewModel.selectedImage) { newImage in
            if let image = newImage {
                viewModel.uploadProfileImage(image)
            }
        }
        .onAppear {
            if viewModel.userProfile == nil && !viewModel.isLoading {
                viewModel.retryFetchProfile()
            }
        }
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }
}

struct ProfileImageView: View {
    let imageURL: String?
    let fallbackText: String
    let isUploading: Bool
    
    var body: some View {
        ZStack {
            if let imageURL = imageURL, !imageURL.isEmpty {
                AsyncImage(url: URL(string: imageURL)) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 120, height: 120)
                        .clipShape(Circle())
                        .overlay(
                            Circle()
                                .stroke(Color.white.opacity(0.3), lineWidth: 3)
                        )
                } placeholder: {
                    Circle()
                        .fill(
                            LinearGradient(
                                colors: [Color.cyan.opacity(0.8), Color.blue.opacity(0.8)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 120, height: 120)
                        .overlay(
                            Circle()
                                .stroke(Color.white.opacity(0.3), lineWidth: 3)
                        )
                        .overlay(
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle(tint: .white))
                        )
                }
            } else {
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [Color.cyan.opacity(0.8), Color.blue.opacity(0.8)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 120, height: 120)
                    .overlay(
                        Circle()
                            .stroke(Color.white.opacity(0.3), lineWidth: 3)
                    )
                    .overlay(
                        Text(fallbackText)
                            .font(.system(size: 36, weight: .bold))
                            .foregroundColor(.white)
                    )
            }
            
            if isUploading {
                Circle()
                    .fill(Color.black.opacity(0.5))
                    .frame(width: 120, height: 120)
                    .overlay(
                        VStack {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle(tint: .white))
                            Text("Uploading...")
                                .font(.caption)
                                .foregroundColor(.white)
                                .padding(.top, 4)
                        }
                    )
            }
        }
    }
}

struct ImagePicker: UIViewControllerRepresentable {
    @Binding var selectedImage: UIImage?
    @Environment(\.dismiss) private var dismiss
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        picker.sourceType = .photoLibrary
        picker.allowsEditing = true
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        let parent: ImagePicker
        
        init(_ parent: ImagePicker) {
            self.parent = parent
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let editedImage = info[.editedImage] as? UIImage {
                parent.selectedImage = editedImage
            } else if let originalImage = info[.originalImage] as? UIImage {
                parent.selectedImage = originalImage
            }
            parent.dismiss()
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            parent.dismiss()
        }
    }
}

struct ProfileInfoCard: View {
    let icon: String
    let title: String
    let value: String
    let iconColor: Color
    
    var body: some View {
        HStack(spacing: 16) {
            ZStack {
                Circle()
                    .fill(iconColor.opacity(0.2))
                    .frame(width: 50, height: 50)
                
                Image(systemName: icon)
                    .font(.system(size: 22))
                    .foregroundColor(iconColor)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.caption)
                    .foregroundColor(.white.opacity(0.9))
                    .textCase(.uppercase)
                    .tracking(0.5)
                
                Text(value)
                    .font(.body)
                    .fontWeight(.medium)
                    .foregroundColor(.white)
            }
            
            Spacer()
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(.ultraThinMaterial)
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(Color.white.opacity(0.2), lineWidth: 1)
                )
        )
    }
}

struct EditProfileView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var fullName: String
    let onSave: (String) -> Void
    
    init(currentName: String, onSave: @escaping (String) -> Void) {
        _fullName = State(initialValue: currentName)
        self.onSave = onSave
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                LinearGradient(
                    colors: [
                        Color(red: 0.4, green: 0.6, blue: 0.8),
                        Color(red: 0.3, green: 0.5, blue: 0.7)
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                
                VStack(spacing: 30) {
                    VStack(spacing: 16) {
                        Image(systemName: "person.crop.circle.badge.plus")
                            .font(.system(size: 60))
                            .foregroundColor(.white.opacity(0.8))
                        
                        Text("Edit Profile")
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                    }
                    .padding(.top, 40)
                    
                    VStack(spacing: 20) {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Full Name")
                                .font(.headline)
                                .foregroundColor(.white)
                            
                            TextField("Enter your full name", text: $fullName)
                                .foregroundColor(.white)
                                .font(.system(size: 16))
                                .padding(.horizontal, 16)
                                .padding(.vertical, 16)
                                .background(
                                    RoundedRectangle(cornerRadius: 20)
                                        .fill(Color.white.opacity(0.2))
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 20)
                                                .stroke(Color.white.opacity(0.3), lineWidth: 1)
                                        )
                                )
                        }
                        
                        Button(action: {
                            onSave(fullName)
                            dismiss()
                        }) {
                            Text("Save Changes")
                                .font(.headline)
                                .fontWeight(.semibold)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 16)
                                .background(
                                    LinearGradient(
                                        colors: [Color.accentColor, Color.accentColor],
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                )
                                .cornerRadius(25)
                        }
                        .disabled(fullName.isEmpty)
                        .opacity(fullName.isEmpty ? 0.6 : 1.0)
                    }
                    .padding(30)
                    .background(
                        RoundedRectangle(cornerRadius: 30)
                            .fill(.ultraThinMaterial)
                            .overlay(
                                RoundedRectangle(cornerRadius: 30)
                                    .stroke(Color.white.opacity(0.2), lineWidth: 1)
                            )
                    )
                    .padding(.horizontal, 20)
                    
                    Spacer()
                }
            }
            .navigationTitle("Edit Profile")
            .navigationBarTitleDisplayMode(.inline)
            .toolbarBackground(.clear, for: .navigationBar)
            .toolbarColorScheme(.dark, for: .navigationBar)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .foregroundColor(.white)
                }
            }
        }
    }
}

#Preview {
    ProfileView()
}
