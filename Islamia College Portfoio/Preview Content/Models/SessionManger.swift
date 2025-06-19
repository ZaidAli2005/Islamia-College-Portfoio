import SwiftUI
import Firebase

class SessionManager: ObservableObject {
    @Published var isLoggedIn = false
    private var handle: AuthStateDidChangeListenerHandle?
    
    func listen() {
        handle = Auth.auth().addStateDidChangeListener { [weak self] (auth, user) in
            DispatchQueue.main.async {
                self?.isLoggedIn = user != nil
            }
        }
    }
    
    deinit {
        if let handle = handle {
            Auth.auth().removeStateDidChangeListener(handle)
        }
    }
}
