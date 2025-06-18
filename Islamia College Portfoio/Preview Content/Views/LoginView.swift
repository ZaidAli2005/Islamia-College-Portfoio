import SwiftUI
import Firebase
import FirebaseAuth
import FirebaseFirestore

class AuthViewModel: ObservableObject {
    @Published var isAuthenticated = false
    @Published var isLoading = false
    @Published var errorMessage = ""
    
    private let db = Firestore.firestore()
    
    func signIn(email: String, password: String) {
        isLoading = true
        errorMessage = ""
        
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] result, error in
            DispatchQueue.main.async {
                self?.isLoading = false
                if let error = error {
                    self?.errorMessage = error.localizedDescription
                } else {
                    self?.isAuthenticated = true
                }
            }
        }
    }
    
    func signUp(fullName: String, email: String, password: String) {
        isLoading = true
        errorMessage = ""
        
        Auth.auth().createUser(withEmail: email, password: password) { [weak self] result, error in
            DispatchQueue.main.async {
                self?.isLoading = false
                if let error = error {
                    self?.errorMessage = error.localizedDescription
                } else if let user = result?.user {
                    self?.saveUserData(uid: user.uid, fullName: fullName, email: email)
                    self?.isAuthenticated = true
                }
            }
        }
    }
    
    private func saveUserData(uid: String, fullName: String, email: String) {
        let userData: [String: Any] = [
            "fullName": fullName,
            "email": email,
            "studentID": generateStudentID(),
            "createdAt": Timestamp()
        ]
        
        db.collection("users").document(uid).setData(userData) { error in
            if let error = error {
                print("Error saving user data: \(error.localizedDescription)")
            }
        }
    }
    
    private func generateStudentID() -> String {
        let currentYear = Calendar.current.component(.year, from: Date())
        let randomNumber = Int.random(in: 1000...9999)
        return "IC\(currentYear)\(randomNumber)"
    }
    
    func signOut() {
        do {
            try Auth.auth().signOut()
            isAuthenticated = false
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}

struct LoginView: View {
    @StateObject private var authViewModel = AuthViewModel()
    @State private var isLoginMode = true
    @State private var fullName = ""
    @State private var email = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    @State private var showPassword = false
    @State private var showConfirmPassword = false
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                LinearGradient(
                    colors: [
                        Color(red: 0.2, green: 0.4, blue: 0.5),
                        Color(red: 0.2, green: 0.4, blue: 0.5)
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                
                Circle()
                    .fill(Color.white.opacity(0.1))
                    .frame(width: 200, height: 200)
                    .position(x: geometry.size.width * 0.8, y: geometry.size.height * 0.2)
                
                Circle()
                    .fill(Color.white.opacity(0.05))
                    .frame(width: 150, height: 150)
                    .position(x: geometry.size.width * 0.2, y: geometry.size.height * 0.8)
                
                VStack(spacing: 40) {
                    VStack(spacing: 16) {
                        ZStack {
                            Circle()
                                .fill(Color.white.opacity(0.2))
                                .frame(width: 100, height: 100)
                            
                            Image(systemName: "graduationcap.fill")
                                .font(.system(size: 40))
                                .foregroundColor(.white)
                        }
                        
                        VStack(spacing: 8) {
                            Text("Student Portal")
                                .font(.largeTitle)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                            
                            Text("Islamia College Gujranwala")
                                .font(.subheadline)
                                .foregroundColor(.white.opacity(0.8))
                        }
                    }
                    
                    VStack(spacing: 0) {
                        HStack(spacing: 0) {
                            Button(action: {
                                withAnimation(.easeInOut(duration: 0.3)) {
                                    isLoginMode = true
                                }
                            }) {
                                Text("Login")
                                    .font(.headline)
                                    .fontWeight(.semibold)
                                    .foregroundColor(isLoginMode ? .white : .white.opacity(0.6))
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 16)
                                    .background(
                                        RoundedRectangle(cornerRadius: 25)
                                            .fill(isLoginMode ? Color.white.opacity(0.3) : Color.clear)
                                    )
                            }
                            
                            Button(action: {
                                withAnimation(.easeInOut(duration: 0.3)) {
                                    isLoginMode = false
                                }
                            }) {
                                Text("Register")
                                    .font(.headline)
                                    .fontWeight(.semibold)
                                    .foregroundColor(!isLoginMode ? .white : .white.opacity(0.6))
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 16)
                                    .background(
                                        RoundedRectangle(cornerRadius: 25)
                                            .fill(!isLoginMode ? Color.white.opacity(0.3) : Color.clear)
                                    )
                            }
                        }
                        .padding(4)
                        .background(
                            RoundedRectangle(cornerRadius: 25)
                                .fill(Color.white.opacity(0.1))
                        )
                        .padding(.bottom, 30)
                        VStack(spacing: 16) {
                            if !isLoginMode {
                                CustomTextField(
                                    text: $fullName,
                                    placeholder: "Full Name",
                                    icon: "person.fill"
                                )
                                .transition(.asymmetric(
                                    insertion: .move(edge: .top).combined(with: .opacity),
                                    removal: .move(edge: .top).combined(with: .opacity)
                                ))
                            }
                            CustomTextField(
                                text: $email,
                                placeholder: "Email Address",
                                icon: "envelope.fill"
                            )
                            .keyboardType(.emailAddress)
                            .autocapitalization(.none)
                            CustomSecureField(
                                text: $password,
                                placeholder: "Password",
                                showPassword: $showPassword
                            )
                            if !isLoginMode {
                                CustomSecureField(
                                    text: $confirmPassword,
                                    placeholder: "Confirm Password",
                                    showPassword: $showConfirmPassword
                                )
                                .transition(.asymmetric(
                                    insertion: .move(edge: .top).combined(with: .opacity),
                                    removal: .move(edge: .top).combined(with: .opacity)
                                ))
                            }
                        }
                        if !authViewModel.errorMessage.isEmpty {
                            Text(authViewModel.errorMessage)
                                .foregroundColor(.red)
                                .font(.caption)
                                .padding(.top, 8)
                        }
                        Button(action: handleAction) {
                            HStack {
                                if authViewModel.isLoading {
                                    ProgressView()
                                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                        .scaleEffect(0.8)
                                }
                                
                                Text(isLoginMode ? "Sign In" : "Create Student Account")
                                    .font(.headline)
                                    .fontWeight(.bold)
                            }
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(
                                LinearGradient(
                                    colors: [Color.teal, Color.teal],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .cornerRadius(25)
                        }
                        .disabled(authViewModel.isLoading || !isFormValid)
                        .opacity(isFormValid ? 1.0 : 0.6)
                        .padding(.top, 24)
                        
                        if isLoginMode {
                            Button("Forgot Password?") {
                                // Handle forgot password
                            }
                            .foregroundColor(.white.opacity(0.8))
                            .font(.subheadline)
                            .padding(.top, 16)
                        }
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
                .padding(.top, 60)
            }
        }
        .fullScreenCover(isPresented: $authViewModel.isAuthenticated) {
            Text("Welcome to Student Portal!")
                .font(.title)
                .foregroundColor(.blue)
        }
    }
    
    private var isFormValid: Bool {
        if isLoginMode {
            return !email.isEmpty && !password.isEmpty
        } else {
            return !fullName.isEmpty &&
                   !email.isEmpty &&
                   !password.isEmpty &&
                   !confirmPassword.isEmpty &&
                   password == confirmPassword &&
                   password.count >= 6
        }
    }
    
    private func handleAction() {
        if isLoginMode {
            authViewModel.signIn(email: email, password: password)
        } else {
            authViewModel.signUp(fullName: fullName, email: email, password: password)
        }
    }
}
struct CustomTextField: View {
    @Binding var text: String
    let placeholder: String
    let icon: String
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .foregroundColor(.white.opacity(0.7))
                .font(.system(size: 16))
                .frame(width: 20)
            
            TextField(placeholder, text: $text)
                .foregroundColor(.white)
                .font(.system(size: 16))
        }
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
}

struct CustomSecureField: View {
    @Binding var text: String
    let placeholder: String
    @Binding var showPassword: Bool
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: "lock.fill")
                .foregroundColor(.white.opacity(0.7))
                .font(.system(size: 16))
                .frame(width: 20)
            
            if showPassword {
                TextField(placeholder, text: $text)
                    .foregroundColor(.white)
                    .font(.system(size: 16))
            } else {
                SecureField(placeholder, text: $text)
                    .foregroundColor(.white)
                    .font(.system(size: 16))
            }
            
            Button(action: { showPassword.toggle() }) {
                Image(systemName: showPassword ? "eye.slash.fill" : "eye.fill")
                    .foregroundColor(.white.opacity(0.7))
                    .font(.system(size: 16))
            }
        }
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
}

#Preview {
    LoginView()
}
