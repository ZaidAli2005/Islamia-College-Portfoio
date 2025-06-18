import SwiftUI
import Firebase

@main
struct Islamia_College_PortfoioApp: App {
    @StateObject private var session = SessionManager()

    init() {
        FirebaseApp.configure()
    }

    var body: some Scene {
        WindowGroup {
            Group {
                if session.isLoggedIn {
                    SplashView()
                } else {
                    LoginView()
                }
            }
            .onAppear {
                session.listen()
            }
        }
    }
}
