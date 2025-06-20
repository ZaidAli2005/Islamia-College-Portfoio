import SwiftUI
import Firebase
import FirebaseAuth
import FirebaseFirestore
import UserNotifications

@main
struct Islamia_College_PortfoioApp: App {
    @StateObject private var session = SessionManager()
    @StateObject private var notificationManager = NotificationManager()

    init() {
        FirebaseApp.configure()
        
        // Configure Firestore settings immediately after Firebase configuration
        let db = Firestore.firestore()
        let settings = FirestoreSettings()
        settings.isPersistenceEnabled = true
        settings.cacheSizeBytes = FirestoreCacheSizeUnlimited
        db.settings = settings
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
                notificationManager.requestPermission()
            }
            .onChange(of: session.isLoggedIn) { _, isLoggedIn in
                if session.shouldSendLoginNotification && isLoggedIn {
                    notificationManager.sendLoginNotification()
                    session.resetLoginFlag()
                } else if session.shouldSendLogoutNotification && !isLoggedIn {
                    notificationManager.sendLogoutNotification()
                    session.resetLogoutFlag()
                }
            }
        }
    }
}

// Rest of your SessionManager and NotificationManager code remains the same...
class SessionManager: ObservableObject {
    @Published var isLoggedIn = false
    private var isFirstAuthStateChange = true
    private var shouldSendLoginNotificationFlag = false
    private var shouldSendLogoutNotificationFlag = false
    
    var shouldSendLoginNotification: Bool {
        return shouldSendLoginNotificationFlag
    }
    
    var shouldSendLogoutNotification: Bool {
        return shouldSendLogoutNotificationFlag
    }
    
    func listen() {
        Auth.auth().addStateDidChangeListener { _, user in
            DispatchQueue.main.async {
                let wasLoggedIn = self.isLoggedIn
                let isNowLoggedIn = (user != nil)
                
                if !self.isFirstAuthStateChange {
                    if !wasLoggedIn && isNowLoggedIn {
                        self.shouldSendLoginNotificationFlag = true
                    }
                    else if wasLoggedIn && !isNowLoggedIn {
                        self.shouldSendLogoutNotificationFlag = true
                    }
                }
                
                self.isLoggedIn = isNowLoggedIn
                if self.isFirstAuthStateChange {
                    self.isFirstAuthStateChange = false
                }
            }
        }
    }
    
    func resetLoginFlag() {
        shouldSendLoginNotificationFlag = false
    }
    
    func resetLogoutFlag() {
        shouldSendLogoutNotificationFlag = false
    }
}

// MARK: - Notification Manager
class NotificationManager: NSObject, ObservableObject {
    
    override init() {
        super.init()
        UNUserNotificationCenter.current().delegate = self
    }
    
    func requestPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
            if granted {
                print("Notification permission granted")
            } else if let error = error {
                print("Notification permission error: \(error.localizedDescription)")
            }
        }
    }
    
    func sendLoginNotification() {
        let content = UNMutableNotificationContent()
        content.title = "Welcome Back!"
        content.body = "Successfully logged in"
        content.sound = UNNotificationSound.default
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 0.5, repeats: false)
        let request = UNNotificationRequest(identifier: "login_success", content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Login notification error: \(error.localizedDescription)")
            }
        }
    }
    
    func sendLogoutNotification() {
        let content = UNMutableNotificationContent()
        content.title = "See You Soon!"
        content.body = "Successfully logged out"
        content.sound = UNNotificationSound.default
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 0.5, repeats: false)
        let request = UNNotificationRequest(identifier: "logout_success", content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Logout notification error: \(error.localizedDescription)")
            }
        }
    }
}

// MARK: - UNUserNotificationCenterDelegate
extension NotificationManager: UNUserNotificationCenterDelegate {
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.banner, .sound])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        completionHandler()
    }
}
