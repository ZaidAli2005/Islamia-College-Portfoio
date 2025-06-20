import SwiftUI
import FirebaseAuth
import Firebase
import AVKit
import AVFoundation

struct DashboardView: View {
    @State private var selectedTab = 0
    
    var body: some View {
        NavigationView {
            ZStack {
                Group {
                    switch selectedTab {
                    case 0:
                        DashboardContentView()
                    case 1:
                        AIChatBotView()
                    case 2:
                        ActivityView()
                    case 3:
                        ProfileView()
                    default:
                        DashboardContentView()
                    }
                }
                VStack {
                    Spacer()
                    CustomTabBar(selectedTab: $selectedTab)
                }
            }
        }
        .navigationBarHidden(true)
    }
}

struct DashboardContentView: View {
    @State private var showGreeting = false
    @State private var showDashboardItems = false
    @State private var showLogoutAlert = false
    
    private func handleLogout() {
        showLogoutAlert = true
    }
    
    private func performLogout() {
        do {
            try Auth.auth().signOut()
        } catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
        }
    }
    
    @ViewBuilder
    private func destinationView(for title: String) -> some View {
        switch title {
        case "Classes": ClassessView()
        case "Canteen": CanteenView()
        case "Principal": PrincipalView()
        case "Teachers": TeachersView()
        case "Events": EventsView()
        case "Timetable": TimeTableView()
        case "Labs": LabsView()
        case "About": AboutsView()
        default: Text("Coming Soon")
        }
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                VStack(spacing: 0) {
                    HStack {
                        Button(action: {}) {
                            Circle()
                                .fill(.white.opacity(0.15))
                                .frame(width: 44, height: 44)
                                .overlay(
                                    Image(systemName: "graduationcap.fill")
                                        .foregroundColor(.white)
                                        .font(.system(size: 18, weight: .medium))
                                )
                                .scaleEffect(showGreeting ? 1.0 : 0.8)
                                .animation(.spring(response: 0.6, dampingFraction: 0.8).delay(0.1), value: showGreeting)
                        }
                        
                        Spacer()
                        
                        Button(action: {
                            handleLogout()
                        }) {
                            Circle()
                                .fill(.white.opacity(0.15))
                                .frame(width: 44, height: 44)
                                .overlay(
                                    Image(systemName: "rectangle.portrait.and.arrow.right")
                                        .foregroundColor(.white)
                                        .font(.system(size: 18, weight: .medium))
                                )
                                .scaleEffect(showGreeting ? 1.0 : 0.8)
                                .animation(.spring(response: 0.6, dampingFraction: 0.8).delay(0.2), value: showGreeting)
                        }
                    }
                }
                .padding(.horizontal, 24)
                .padding(.top, 60)
                
                HStack(spacing: 16) {
                    ZStack {
                        Circle()
                            .fill(
                                LinearGradient(
                                    colors: [Color.green.opacity(0.8), Color.green],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .frame(width: 56, height: 56)
                            .overlay(
                                Image("Splash Img")
                                    .resizable()
                                    .foregroundColor(.white)
                                    .font(.system(size: 20, weight: .semibold))
                            )
                    }
                    .scaleEffect(showGreeting ? 1.0 : 0.5)
                    .animation(.spring(response: 0.8, dampingFraction: 0.6).delay(0.3), value: showGreeting)
                    
                    VStack(alignment: .leading, spacing: 6) {
                        Text("Welcome Back!")
                            .font(.system(size: 32, weight: .bold, design: .rounded))
                            .foregroundColor(.white)
                            .opacity(showGreeting ? 1.0 : 0)
                            .offset(x: showGreeting ? 0 : -20)
                            .animation(.easeOut(duration: 0.6).delay(0.4), value: showGreeting)
                        
                        Text("Islamia College Gujranwala")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(.white.opacity(0.9))
                            .opacity(showGreeting ? 1.0 : 0)
                            .offset(x: showGreeting ? 0 : -20)
                            .animation(.easeOut(duration: 0.6).delay(0.5), value: showGreeting)
                    }
                    
                    Spacer()
                }
                .padding(.horizontal, 24)
                .padding(.top, 32)
                .padding(.bottom, 40)
            }
            .background(
                LinearGradient(
                    gradient: Gradient(stops: [
                        .init(color: Color(red: 0.15, green: 0.35, blue: 0.55), location: 0.0),
                        .init(color: Color(red: 0.25, green: 0.45, blue: 0.65), location: 0.5),
                        .init(color: Color(red: 0.2, green: 0.4, blue: 0.6), location: 1.0)
                    ]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            .overlay(
                HStack {
                    Spacer()
                    VStack {
                        Circle()
                            .fill(.white.opacity(0.1))
                            .frame(width: 120, height: 120)
                            .offset(x: 40, y: -20)
                        Spacer()
                    }
                }
            )
            .clipped()
            
            VStack(spacing: 32) {
                VStack(alignment: .leading, spacing: 24) {
                    HStack {
                        Text("Dashboard")
                            .font(.system(size: 28, weight: .bold, design: .rounded))
                            .foregroundColor(.primary)
                        
                        Spacer()
                    }
                    .padding(.horizontal, 24)
                    .padding(.top, 32)
                    .opacity(showDashboardItems ? 1.0 : 0)
                    .offset(y: showDashboardItems ? 0 : 20)
                    .animation(.easeOut(duration: 0.6).delay(0.6), value: showDashboardItems)
                    
                    LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 16), count: 4), spacing: 20) {
                        let items = [
                            ("grid.circle.fill", "Classes", Color.blue),
                            ("building.2.fill", "Canteen", Color.orange),
                            ("person.fill", "Principal", Color.indigo),
                            ("person.2.fill", "Teachers", Color.purple),
                            ("trophy.fill", "Events", Color.pink),
                            ("clock.fill", "Timetable", Color.teal),
                            ("flask.fill", "Labs", Color.cyan),
                            ("info.circle.fill", "About", Color.mint)
                        ]
                        
                        ForEach(Array(items.enumerated()), id: \.offset) { index, item in
                            NavigationLink(destination: destinationView(for: item.1)) {
                                DashboardItem(
                                    icon: item.0,
                                    title: item.1,
                                    iconColor: item.2
                                )
                            }
                            .buttonStyle(DashboardItemButtonStyle())
                            .opacity(showDashboardItems ? 1.0 : 0)
                            .offset(y: showDashboardItems ? 0 : 30)
                            .animation(.spring(response: 0.6, dampingFraction: 0.8).delay(0.7 + Double(index) * 0.1), value: showDashboardItems)
                        }
                    }
                    .padding(.horizontal, 24)
                }
                VStack(alignment: .leading, spacing: 20) {
                    Text("Quick Access")
                        .font(.system(size: 24, weight: .bold, design: .rounded))
                        .foregroundColor(.primary)
                        .padding(.horizontal, 24)
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 16) {
                            NavigationLink(destination: LibraryView()) {
                                MoreItem(
                                    title: "Library",
                                    subtitle: "Study Resources",
                                    imageName: "Splash Img",
                                    gradient: [Color.white.opacity(0.8), Color.white.opacity(0.8)]
                                )
                            }
                            .buttonStyle(PlainButtonStyle())
                            
                            NavigationLink(destination: SportsView()) {
                                MoreItem(
                                    title: "Sports & Fun",
                                    subtitle: "All Sports",
                                    imageName: "Splash Img",
                                    gradient: [Color.white.opacity(0.8), Color.white.opacity(0.8)]
                                )
                            }
                            .buttonStyle(PlainButtonStyle())
                            
                            NavigationLink(destination: ContactUsView()) {
                                MoreItem(
                                    title: "Parking",
                                    subtitle: "Parking Areas",
                                    imageName: "Splash Img",
                                    gradient: [Color.white.opacity(0.8), Color.white.opacity(0.8)]
                                )
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                        .padding(.horizontal, 24)
                    }
                }
                
                VStack(alignment: .leading, spacing: 16) {
                    Text("Recommended")
                        .font(.system(size: 24, weight: .bold, design: .rounded))
                        .foregroundColor(.primary)
                        .padding(.horizontal, 24)
                    
                    NavigationLink(destination: AdmissionsView()) {
                        HStack(spacing: 16) {
                            ZStack {
                                RoundedRectangle(cornerRadius: 16)
                                    .fill(
                                        LinearGradient(
                                            colors: [Color.accentColor, Color.accentColor],
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing
                                        )
                                    )
                                    .frame(width: 64, height: 64)
                                
                                Image(systemName: "doc.text.fill")
                                    .foregroundColor(.white)
                                    .font(.system(size: 24, weight: .semibold))
                            }
                            
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Admissions")
                                    .font(.system(size: 18, weight: .semibold))
                                    .foregroundColor(.primary)
                                
                                Text("Apply Online")
                                    .font(.system(size: 14))
                                    .foregroundColor(.secondary)
                            }
                            
                            Spacer()
                            
                            Image(systemName: "chevron.right")
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundColor(.secondary)
                        }
                        .padding(20)
                        .background(
                            RoundedRectangle(cornerRadius: 20)
                                .fill(Color(.systemGray6))
                        )
                        .padding(.horizontal, 24)
                    }
                    
                    NavigationLink(destination: DemoVideos()) {
                        HStack(spacing: 16) {
                            ZStack {
                                RoundedRectangle(cornerRadius: 16)
                                    .fill(
                                        LinearGradient(
                                            colors: [Color.accentColor, Color.accentColor],
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing
                                        )
                                    )
                                    .frame(width: 64, height: 64)
                                
                                Image(systemName: "play.rectangle.fill")
                                    .foregroundColor(.white)
                                    .font(.system(size: 24, weight: .semibold))
                            }
                            
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Watch Demo")
                                    .font(.system(size: 18, weight: .semibold))
                                    .foregroundColor(.primary)
                                
                                Text("Demos")
                                    .font(.system(size: 14))
                                    .foregroundColor(.secondary)
                            }
                            
                            Spacer()
                            
                            Image(systemName: "chevron.right")
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundColor(.secondary)
                        }
                        .padding(20)
                        .background(
                            RoundedRectangle(cornerRadius: 20)
                                .fill(Color(.systemGray6))
                        )
                        .padding(.horizontal, 24)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
                
                AutoPlayVideoView(videoURL: "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4")
                    .padding(.top, 16)
                
                Spacer(minLength: 120)
            }
            .background(Color(.systemBackground))
            .clipShape(
                RoundedRectangle(cornerRadius: 32)
            )
            .offset(y: -32)
        }
        .ignoresSafeArea(.all, edges: .top)
        .alert("Logout", isPresented: $showLogoutAlert) {
            Button("Cancel", role: .cancel) {
            }
            
            Button("Logout", role: .destructive) {
                performLogout()
            }
        } message: {
            Text("Are you sure you want to logout?")
        }
        .onAppear {
            withAnimation {
                showGreeting = true
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                withAnimation {
                    showDashboardItems = true
                }
            }
        }
    }
}

struct DashboardItem: View {
    let icon: String
    let title: String
    let iconColor: Color
    
    var body: some View {
        VStack(spacing: 12) {
            ZStack {
                Circle()
                    .fill(iconColor.opacity(0.15))
                    .frame(width: 56, height: 56)
                
                Image(systemName: icon)
                    .foregroundColor(iconColor)
                    .font(.system(size: 22, weight: .semibold))
            }
            
            Text(title)
                .font(.system(size: 12, weight: .medium))
                .foregroundColor(.primary)
                .multilineTextAlignment(.center)
                .lineLimit(2)
        }
        .frame(maxWidth: .infinity)
    }
}

struct DashboardItemButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
            .opacity(configuration.isPressed ? 0.8 : 1.0)
            .animation(.easeInOut(duration: 0.1), value: configuration.isPressed)
    }
}

struct MoreItem: View {
    let title: String
    let subtitle: String
    let imageName: String
    let gradient: [Color]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            RoundedRectangle(cornerRadius: 16)
                .fill(
                    LinearGradient(
                        colors: gradient,
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .frame(width: 140, height: 100)
                .overlay(
                    getImageContent()
                )
                .shadow(color: .black.opacity(0.1), radius: 8, x: 0, y: 4)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundColor(.primary)
                
                Text(subtitle)
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(.secondary)
            }
        }
    }
    
    @ViewBuilder
    private func getImageContent() -> some View {
        switch imageName {
        case "library_image":
            HStack(spacing: 2) {
                ForEach(0..<4) { index in
                    RoundedRectangle(cornerRadius: 2)
                        .fill(.white.opacity(0.8))
                        .frame(width: 6, height: CGFloat.random(in: 25...35))
                }
            }
            .padding(.leading, 20)
            
        case "sports_image":
            HStack(spacing: 8) {
                Circle()
                    .fill(.white)
                    .frame(width: 16, height: 16)
                Circle()
                    .fill(.black)
                    .frame(width: 12, height: 12)
                RoundedRectangle(cornerRadius: 2)
                    .fill(.brown)
                    .frame(width: 3, height: 20)
            }
            .padding(.leading, 20)
            .padding(.top, 20)
            
        case "parking_image":
            RoundedRectangle(cornerRadius: 8)
                .fill(.white)
                .frame(width: 32, height: 24)
                .overlay(
                    Text("P")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(.blue)
                )
        default:
            EmptyView()
        }
    }
}

struct CustomTabBar: View {
    @Binding var selectedTab: Int
    
    var body: some View {
        HStack(spacing: 0) {
            TabBarItems(
                icon: "house.fill",
                title: "Home",
                isSelected: selectedTab == 0
            ) {
                selectedTab = 0
            }
            
            TabBarItems(
                icon: "message.fill",
                title: "Chat",
                isSelected: selectedTab == 1
            ) {
                selectedTab = 1
            }
            
            TabBarItems(
                icon: "chart.bar.fill",
                title: "Activity",
                isSelected: selectedTab == 2
            ) {
                selectedTab = 2
            }
            
            TabBarItems(
                icon: "person.fill",
                title: "Profile",
                isSelected: selectedTab == 3
            ) {
                selectedTab = 3
            }
        }
        .padding(.horizontal, 24)
        .padding(.vertical, 16)
        .background(
            RoundedRectangle(cornerRadius: 24)
                .fill(.regularMaterial)
                .shadow(color: .black.opacity(0.1), radius: 20, x: 0, y: 10)
        )
        .padding(.horizontal, 2)
        .padding(.bottom, 0)
    }
}

struct TabBarItems: View {
    let icon: String
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 4) {
                ZStack {
                    if isSelected {
                        Circle()
                            .fill(.blue.opacity(0.2))
                            .frame(width: 32, height: 32)
                    }
                    
                    Image(systemName: icon)
                        .font(.system(size: 18, weight: .medium))
                        .foregroundColor(isSelected ? .accentColor : .secondary)
                }
                
                Text(title)
                    .font(.system(size: 10, weight: .medium))
                    .foregroundColor(isSelected ? .accentColor : .secondary)
            }
            .frame(maxWidth: .infinity)
        }
        .scaleEffect(isSelected ? 1.1 : 1.0)
        .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isSelected)
    }
}

struct AutoPlayVideoView: View {
    @State private var player: AVPlayer?
    @State private var isPlaying = false
    @State private var showControls = false
    @State private var playerObserver: NSKeyValueObservation?
    
    let videoURL: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Featured Video")
                .font(.system(size: 24, weight: .bold, design: .rounded))
                .foregroundColor(.primary)
                .padding(.horizontal, 24)
            
            ZStack {
                if let player = player {
                    VideoPlayer(player: player)
                        .frame(height: 200)
                        .cornerRadius(16)
                        .onTapGesture {
                            togglePlayback()
                        }
                        .overlay(
                            RoundedRectangle(cornerRadius: 16)
                                .fill(Color.clear)
                                .contentShape(Rectangle())
                                .onTapGesture {
                                    togglePlayback()
                                }
                        )
                        .overlay(
                            VStack {
                                HStack {
                                    Spacer()
                                    VStack {
                                        Image(systemName: isPlaying ? "pause.circle.fill" : "play.circle.fill")
                                            .font(.system(size: 30))
                                            .foregroundColor(.white)
                                            .background(
                                                Circle()
                                                    .fill(Color.black.opacity(0.3))
                                                    .frame(width: 40, height: 40)
                                            )
                                            .opacity(showControls ? 1.0 : 0.0)
                                        Spacer()
                                    }
                                    .padding(.top, 16)
                                    .padding(.trailing, 16)
                                }
                                Spacer()
                            }
                        )
                } else {
                    RoundedRectangle(cornerRadius: 16)
                        .fill(Color.gray.opacity(0.3))
                        .frame(height: 200)
                        .overlay(
                            VStack {
                                Image(systemName: "video.slash")
                                    .font(.system(size: 30))
                                    .foregroundColor(.gray)
                                Text("Video not available")
                                    .font(.caption)
                                    .foregroundColor(.gray)
                            }
                        )
                }
            }
            .padding(.horizontal, 24)
            .onAppear {
                setupPlayer()
            }
            .onDisappear {
                cleanupPlayer()
            }
        }
    }
    
    private func setupPlayer() {
        guard let url = URL(string: videoURL) else { return }
        
        player = AVPlayer(url: url)
        NotificationCenter.default.addObserver(
            forName: .AVPlayerItemDidPlayToEndTime,
            object: player?.currentItem,
            queue: .main
        ) { _ in
            player?.seek(to: .zero)
            if isPlaying {
                player?.play()
            }
        }
        
        playerObserver = player?.observe(\.status, options: [.new]) { [self] observedPlayer, _ in
            DispatchQueue.main.async {
                if observedPlayer.status == .readyToPlay {
                    observedPlayer.play()
                    self.isPlaying = true
                }
            }
        }
    }
    
    private func togglePlayback() {
        guard let player = player else { return }
        
        if isPlaying {
            player.pause()
            isPlaying = false
        } else {
            player.play()
            isPlaying = true
        }
        
        showControls = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            withAnimation(.easeOut(duration: 0.5)) {
                showControls = false
            }
        }
    }
    
    private func cleanupPlayer() {
        player?.pause()
        player = nil
        playerObserver?.invalidate()
        playerObserver = nil
        
        NotificationCenter.default.removeObserver(self)
    }
}

#Preview {
    DashboardView()
}
