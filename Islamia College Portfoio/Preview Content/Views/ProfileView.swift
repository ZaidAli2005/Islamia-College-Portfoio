import SwiftUI
import Firebase
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage
import PhotosUI

class ProfileViewModel: ObservableObject {
    @Published var userProfile: UserProfile?
    @Published var isLoading = false
    @Published var errorMessage = ""
    @Published var isEditing = false
    @Published var showingImagePicker = false
    @Published var selectedImage: UIImage?
    @Published var profileImageURL: String?
    @Published var isUploadingImage = false
    @Published var showingProfileSetup = false
    
    private let db = Firestore.firestore()
    private let storage = Storage.storage()
    
    init() {
        fetchUserProfile()
    }
    
    func fetchUserProfile() {
        guard let currentUser = Auth.auth().currentUser else { return }
        
        isLoading = true
        errorMessage = ""
        
        db.collection("users").document(currentUser.uid).getDocument { [weak self] document, error in
            DispatchQueue.main.async {
                self?.isLoading = false
                if let error = error {
                    self?.errorMessage = error.localizedDescription
                } else if let document = document, document.exists {
                    let data = document.data() ?? [:]
                    self?.userProfile = UserProfile(
                        id: currentUser.uid,
                        fullName: data["fullName"] as? String ?? "",
                        email: data["email"] as? String ?? "",
                        studentID: data["studentID"] as? String ?? "",
                        profileImageURL: data["profileImageURL"] as? String,
                        phoneNumber: data["phoneNumber"] as? String,
                        department: data["department"] as? String,
                        semester: data["semester"] as? String,
                        createdAt: data["createdAt"] as? Timestamp ?? Timestamp()
                    )
                    self?.profileImageURL = data["profileImageURL"] as? String
                } else {
                    self?.createBasicProfile(for: currentUser)
                }
            }
        }
    }
    
    private func createBasicProfile(for user: User) {
        let basicProfile = UserProfile(
            id: user.uid,
            fullName: user.displayName ?? "",
            email: user.email ?? "",
            studentID: "",
            profileImageURL: user.photoURL?.absoluteString,
            phoneNumber: nil,
            department: nil,
            semester: nil,
            createdAt: Timestamp()
        )
        
        let userData: [String: Any] = [
            "fullName": basicProfile.fullName,
            "email": basicProfile.email,
            "studentID": basicProfile.studentID,
            "profileImageURL": basicProfile.profileImageURL ?? "",
            "phoneNumber": basicProfile.phoneNumber ?? "",
            "department": basicProfile.department ?? "",
            "semester": basicProfile.semester ?? "",
            "createdAt": basicProfile.createdAt
        ]
        
        db.collection("users").document(user.uid).setData(userData) { [weak self] error in
            DispatchQueue.main.async {
                if let error = error {
                    self?.errorMessage = error.localizedDescription
                } else {
                    self?.userProfile = basicProfile
                    self?.profileImageURL = basicProfile.profileImageURL
                    self?.showingProfileSetup = true
                    self?.isEditing = true
                }
            }
        }
    }
    
    func updateProfile() {
        guard let userId = Auth.auth().currentUser?.uid,
              let profile = userProfile else { return }
        
        isLoading = true
        errorMessage = ""
        
        let userData: [String: Any] = [
            "fullName": profile.fullName,
            "email": profile.email,
            "studentID": profile.studentID,
            "phoneNumber": profile.phoneNumber ?? "",
            "department": profile.department ?? "",
            "semester": profile.semester ?? "",
            "profileImageURL": profileImageURL ?? ""
        ]
        
        db.collection("users").document(userId).updateData(userData) { [weak self] error in
            DispatchQueue.main.async {
                self?.isLoading = false
                if let error = error {
                    self?.errorMessage = error.localizedDescription
                } else {
                    self?.isEditing = false
                    self?.showingProfileSetup = false
                }
            }
        }
    }
    
    func uploadProfileImage() {
        guard let userId = Auth.auth().currentUser?.uid,
              let image = selectedImage,
              let imageData = image.jpegData(compressionQuality: 0.7) else { return }
        
        isUploadingImage = true
        let storageRef = storage.reference().child("profile_images/\(userId).jpg")
        
        storageRef.putData(imageData, metadata: nil) { [weak self] _, error in
            if let error = error {
                DispatchQueue.main.async {
                    self?.isUploadingImage = false
                    self?.errorMessage = error.localizedDescription
                }
                return
            }
            
            storageRef.downloadURL { url, error in
                DispatchQueue.main.async {
                    self?.isUploadingImage = false
                    if let error = error {
                        self?.errorMessage = error.localizedDescription
                    } else if let url = url {
                        self?.profileImageURL = url.absoluteString
                        self?.updateProfileImageURL(url: url.absoluteString)
                    }
                }
            }
        }
    }
    
    private func updateProfileImageURL(url: String) {
        guard let userId = Auth.auth().currentUser?.uid else { return }
        
        db.collection("users").document(userId).updateData(["profileImageURL": url]) { error in
            if let error = error {
                print("Error updating profile image URL: \(error.localizedDescription)")
            }
        }
    }
}

struct UserProfile {
    let id: String
    var fullName: String
    var email: String
    let studentID: String
    var profileImageURL: String?
    var phoneNumber: String?
    var department: String?
    var semester: String?
    let createdAt: Timestamp
}

struct ProfileView: View {
    @StateObject private var viewModel = ProfileViewModel()
    @StateObject private var authViewModel = AuthViewModel()
    @State private var selectedPhoto: PhotosPickerItem?
    @State private var showSettingsSheet = false
    
    var body: some View {
        NavigationView {
            ZStack {
                Color(.systemGroupedBackground)
                    .ignoresSafeArea()
                
                if viewModel.isLoading {
                    loadingView()
                } else if let profile = viewModel.userProfile {
                    ScrollView(showsIndicators: false) {
                        LazyVStack(spacing: 20) {
                            topNavigationBar()
                            profileHeaderCard(profile: profile)
                            personalInfoCard(profile: profile)
                            academicInfoCard(profile: profile)
                        }
                        .padding(.horizontal, 16)
                        .padding(.bottom, 30)
                    }
                } else {
                    errorStateView()
                }
            }
            .navigationBarHidden(true)
        }
        .photosPicker(
            isPresented: $viewModel.showingImagePicker,
            selection: $selectedPhoto,
            matching: .images,
            photoLibrary: .shared()
        )
        .onChange(of: selectedPhoto) { newPhoto in
            Task {
                if let data = try? await newPhoto?.loadTransferable(type: Data.self),
                   let image = UIImage(data: data) {
                    viewModel.selectedImage = image
                    viewModel.uploadProfileImage()
                }
            }
        }
    }
    
    @ViewBuilder
    private func topNavigationBar() -> some View {
        HStack {
            Text("Profile")
                .font(.largeTitle)
                .fontWeight(.heavy)
                .foregroundColor(.primary)
            
            Spacer()
            
            Button(action: {
                authViewModel.signOut()
            }) {
                HStack(spacing: 6) {
                    Image(systemName: "rectangle.portrait.and.arrow.right")
                        .font(.system(size: 22, weight: .medium))
                }
                .foregroundColor(.accentColor)
                .padding(.horizontal, 8)
                .padding(.vertical, 8)
                .clipShape(Capsule())
            }
        }
        .padding(.horizontal, 20)
        .padding(.top, 10)
    }
    
    @ViewBuilder
    private func profileHeaderCard(profile: UserProfile) -> some View {
        VStack(spacing: 24) {
            HStack {
                Spacer()
                ZStack {
                    Group {
                        if let profileImageURL = viewModel.profileImageURL,
                           !profileImageURL.isEmpty,
                           let url = URL(string: profileImageURL) {
                            AsyncImage(url: url) { phase in
                                switch phase {
                                case .success(let image):
                                    image
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                case .failure(_):
                                    defaultAvatar()
                                case .empty:
                                    ZStack {
                                        defaultAvatar()
                                        ProgressView()
                                            .tint(.primary)
                                    }
                                @unknown default:
                                    defaultAvatar()
                                }
                            }
                        } else {
                            defaultAvatar()
                        }
                    }
                    .frame(width: 120, height: 120)
                    .clipShape(Circle())
                    .overlay(
                        Circle()
                            .stroke(Color(.systemBackground), lineWidth: 4)
                    )
                    .shadow(color: .black.opacity(0.15), radius: 10, x: 0, y: 5)
                    
                    Button(action: {
                        viewModel.showingImagePicker = true
                    }) {
                        ZStack {
                            Circle()
                                .fill(Color.accentColor)
                                .frame(width: 36, height: 36)
                            
                            Image(systemName: "camera.fill")
                                .font(.system(size: 16, weight: .medium))
                                .foregroundColor(.white)
                        }
                        .shadow(color: .blue.opacity(0.4), radius: 6, x: 0, y: 3)
                    }
                    .offset(x: 40, y: 40)
                    
                    if viewModel.isUploadingImage {
                        Circle()
                            .fill(Color.black.opacity(0.6))
                            .frame(width: 120, height: 120)
                            .overlay(
                                ProgressView()
                                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                    .scaleEffect(1.2)
                            )
                    }
                }
                Spacer()
            }
            
            VStack(spacing: 8) {
                Text(profile.fullName)
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.primary)
                
                HStack(spacing: 6) {
                    Image(systemName: "studentdesk")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    Text(profile.studentID)
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .foregroundColor(.secondary)
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(Color(.secondarySystemGroupedBackground))
                .clipShape(Capsule())
            }
        }
        .padding(.vertical, 30)
        .frame(maxWidth: .infinity)
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .shadow(color: .black.opacity(0.08), radius: 8, x: 0, y: 4)
    }
    
    @ViewBuilder
    private func personalInfoCard(profile: UserProfile) -> some View {
        VStack(alignment: .leading, spacing: 20) {
            HStack {
                Text("Personal Information")
                    .font(.headline)
                    .fontWeight(.semibold)
                Spacer()
                Button(action: {
                    withAnimation(.spring()) {
                        viewModel.isEditing.toggle()
                    }
                }) {
                    Text(viewModel.isEditing ? "Done" : "Edit")
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .foregroundColor(.accentColor)
                }
            }
            
            VStack(spacing: 16) {
                ModernInfoRow(
                    icon: "person.circle.fill",
                    title: "Full Name",
                    value: Binding(
                        get: { viewModel.userProfile?.fullName ?? "" },
                        set: { viewModel.userProfile?.fullName = $0 }
                    ),
                    isEditing: viewModel.isEditing,
                    iconColor: .accentColor
                )
                
                ModernInfoRow(
                    icon: "envelope.circle.fill",
                    title: "Email",
                    value: .constant(profile.email),
                    isEditing: false,
                    iconColor: .accentColor
                )
                
                ModernInfoRow(
                    icon: "phone.circle.fill",
                    title: "Phone",
                    value: Binding(
                        get: { viewModel.userProfile?.phoneNumber ?? "" },
                        set: { viewModel.userProfile?.phoneNumber = $0 }
                    ),
                    isEditing: viewModel.isEditing,
                    placeholder: "Your phone number",
                    iconColor: .accentColor
                )
            }
            
            if viewModel.isEditing {
                Button(action: {
                    viewModel.updateProfile()
                }) {
                    HStack {
                        if viewModel.isLoading {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                .scaleEffect(0.8)
                        }
                        
                        Text("Save Changes")
                            .fontWeight(.semibold)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 12)
                    .background(Color.accentColor)
                    .foregroundColor(.white)
                    .clipShape(Capsule())
                }
                .disabled(viewModel.isLoading)
                .transition(.scale.combined(with: .opacity))
            }
        }
        .padding(20)
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 5))
        .shadow(color: .black.opacity(0.06), radius: 6, x: 0, y: 3)
    }
    
    @ViewBuilder
    private func academicInfoCard(profile: UserProfile) -> some View {
        VStack(alignment: .leading, spacing: 20) {
            HStack {
                Text("Academic Details")
                    .font(.headline)
                    .fontWeight(.semibold)
            }
            
            VStack(spacing: 16) {
                ModernInfoRow(
                    icon: "book.circle.fill",
                    title: "Department",
                    value: Binding(
                        get: { viewModel.userProfile?.department ?? "" },
                        set: { viewModel.userProfile?.department = $0 }
                    ),
                    isEditing: viewModel.isEditing,
                    placeholder: "e.g., Computer Science",
                    iconColor: .accentColor
                )
                
                ModernInfoRow(
                    icon: "book.circle.fill",
                    title: "Semester",
                    value: Binding(
                        get: { viewModel.userProfile?.semester ?? "" },
                        set: { viewModel.userProfile?.semester = $0 }
                    ),
                    isEditing: viewModel.isEditing,
                    placeholder: "e.g., 8th Semester",
                    iconColor: .accentColor
                )
                
                ModernInfoRow(
                    icon: "calendar.circle.fill",
                    title: "Member Since",
                    value: .constant(formatDate(profile.createdAt.dateValue())),
                    isEditing: false,
                    iconColor: .accentColor
                )
            }
        }
        .padding(20)
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .shadow(color: .black.opacity(0.06), radius: 6, x: 0, y: 3)
    }
    
    @ViewBuilder
    private func defaultAvatar() -> some View {
        Circle()
            .fill(
                LinearGradient(
                    colors: [.accentColor.opacity(0.6), .accentColor.opacity(0.6)],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            .overlay(
                Image(systemName: "person.fill")
                    .font(.system(size: 40, weight: .medium))
                    .foregroundColor(.white)
            )
    }
    
    @ViewBuilder
    private func loadingView() -> some View {
        VStack(spacing: 20) {
            ProgressView()
                .scaleEffect(1.5)
            
            Text("Loading Profile...")
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
    }
    
    @ViewBuilder
    private func errorStateView() -> some View {
        VStack(spacing: 24) {
            Image(systemName: "person.crop.circle.badge.exclamationmark")
                .font(.system(size: 60))
                .foregroundColor(.secondary)
            
            VStack(spacing: 12) {
                Text("Unable to Load Profile")
                    .font(.title2)
                    .fontWeight(.semibold)
                
                if !viewModel.errorMessage.isEmpty {
                    Text(viewModel.errorMessage)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 40)
                }
            }
            
            Button("Try Again") {
                viewModel.fetchUserProfile()
            }
            .font(.headline)
            .foregroundColor(.white)
            .padding(.horizontal, 32)
            .padding(.vertical, 12)
            .background(Color.accentColor)
            .clipShape(Capsule())
        }
        .padding(40)
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM dd, yyyy"
        return formatter.string(from: date)
    }
}

struct ModernInfoRow: View {
    let icon: String
    let title: String
    @Binding var value: String
    let isEditing: Bool
    let placeholder: String
    let iconColor: Color
    
    init(icon: String, title: String, value: Binding<String>, isEditing: Bool, placeholder: String = "", iconColor: Color = .accentColor) {
        self.icon = icon
        self.title = title
        self._value = value
        self.isEditing = isEditing
        self.placeholder = placeholder.isEmpty ? "Enter \(title.lowercased())" : placeholder
        self.iconColor = iconColor
    }
    
    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(iconColor)
                .frame(width: 32)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.caption)
                    .fontWeight(.medium)
                    .foregroundColor(.secondary)
                    .textCase(.uppercase)
                
                if isEditing {
                    TextField(placeholder, text: $value)
                        .font(.subheadline)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                } else {
                    Text(value.isEmpty ? "Not specified" : value)
                        .font(.subheadline)
                        .foregroundColor(value.isEmpty ? .secondary : .primary)
                }
            }
            Spacer()
        }
    }
}

struct ActionButton: View {
    let icon: String
    let title: String
    let color: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 8) {
                Image(systemName: icon)
                    .font(.title2)
                    .foregroundColor(color)
                
                Text(title)
                    .font(.caption)
                    .fontWeight(.medium)
                    .foregroundColor(.primary)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .background(color.opacity(0.1))
            .clipShape(RoundedRectangle(cornerRadius: 12))
        }
    }
}

#Preview {
    ProfileView()
}
