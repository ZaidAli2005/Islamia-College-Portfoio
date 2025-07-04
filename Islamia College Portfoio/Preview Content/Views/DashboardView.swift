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
                        CalendarView()
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
                                .fill(.white.opacity(0.2))
                                .frame(width: 48, height: 48)
                                .overlay(
                                    Image(systemName: "graduationcap.fill")
                                        .foregroundColor(.white)
                                        .font(.system(size: 20, weight: .semibold))
                                )
                                .shadow(color: .black.opacity(0.1), radius: 8, x: 0, y: 4)
                                .scaleEffect(showGreeting ? 1.0 : 0.8)
                                .animation(.spring(response: 0.6, dampingFraction: 0.8).delay(0.1), value: showGreeting)
                        }
                        
                        Spacer()
                        
                        Button(action: {
                            handleLogout()
                        }) {
                            Circle()
                                .frame(width: 48, height: 48)
                                .overlay(
                                    Image(systemName: "rectangle.portrait.and.arrow.right")
                                        .foregroundColor(.white)
                                        .font(.system(size: 18, weight: .semibold))
                                )
                        }
                    }
                    .padding(.horizontal, 24)
                    .padding(.top, 60)
                    
                    HStack(spacing: 20) {
                        ZStack {
                            Circle()
                                .fill(
                                    LinearGradient(
                                        colors: [.white.opacity(0.3), .white.opacity(0.1)],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                                .frame(width: 64, height: 64)
                                .shadow(color: .black.opacity(0.1), radius: 12, x: 0, y: 6)
                            
                            Image("Splash Img")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 40, height: 40)
                                .foregroundColor(.white)
                        }
                        .scaleEffect(showGreeting ? 1.0 : 0.5)
                        .animation(.spring(response: 0.8, dampingFraction: 0.6).delay(0.3), value: showGreeting)
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Welcome Back!")
                                .font(.system(size: 34, weight: .bold, design: .rounded))
                                .foregroundColor(.white)
                                .opacity(showGreeting ? 1.0 : 0)
                                .offset(x: showGreeting ? 0 : -30)
                                .animation(.easeOut(duration: 0.6).delay(0.4), value: showGreeting)
                            
                            Text("Islamia College Gujranwala")
                                .font(.system(size: 16, weight: .medium))
                                .foregroundColor(.white.opacity(0.9))
                                .opacity(showGreeting ? 1.0 : 0)
                                .offset(x: showGreeting ? 0 : -30)
                                .animation(.easeOut(duration: 0.6).delay(0.5), value: showGreeting)
                        }
                        
                        Spacer()
                    }
                    .padding(.horizontal, 24)
                    .padding(.top, 40)
                    .padding(.bottom, 50)
                }
                .background(
                    LinearGradient(
                        gradient: Gradient(colors: [
                            Color(red: 0.2, green: 0.4, blue: 0.5),
                            Color(red: 0.2, green: 0.4, blue: 0.5)
                        ]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .clipped()
                
                VStack(spacing: 40) {
                    VStack(alignment: .leading, spacing: 28) {
                        HStack {
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Dashboard")
                                    .font(.system(size: 32, weight: .bold, design: .rounded))
                                    .foregroundColor(.primary)
                            }
                            
                            Spacer()
                        }
                        .padding(.horizontal, 24)
                        .padding(.top, 36)
                        .opacity(showDashboardItems ? 1.0 : 0)
                        .offset(y: showDashboardItems ? 0 : 20)
                        .animation(.easeOut(duration: 0.6).delay(0.6), value: showDashboardItems)
                        
                        LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 20), count: 4), spacing: 24) {
                            let items = [
                                ("grid.circle.fill", "Classes", Color.teal),
                                ("building.2.fill", "Canteen", Color.teal),
                                ("person.fill", "Principal", Color.teal),
                                ("person.2.fill", "Teachers", Color.teal),
                                ("trophy.fill", "Events", Color.teal),
                                ("clock.fill", "Timetable", Color.teal),
                                ("flask.fill", "Labs", Color.teal),
                                ("info.circle.fill", "About", Color.teal)
                            ]
                            
                            ForEach(Array(items.enumerated()), id: \.offset) { index, item in
                                NavigationLink(destination: destinationView(for: item.1)) {
                                    EnhancedDashboardItem(
                                        icon: item.0,
                                        title: item.1,
                                        iconColor: item.2
                                    )
                                }
                                .buttonStyle(EnhancedDashboardItemButtonStyle())
                                .opacity(showDashboardItems ? 1.0 : 0)
                                .offset(y: showDashboardItems ? 0 : 40)
                                .animation(.spring(response: 0.7, dampingFraction: 0.8).delay(0.7 + Double(index) * 0.08), value: showDashboardItems)
                            }
                        }
                        .padding(.horizontal, 24)
                    }
                    
                    VStack(alignment: .leading, spacing: 24) {
                        HStack {
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Quick Access")
                                    .font(.system(size: 26, weight: .bold, design: .rounded))
                                    .foregroundColor(.primary)
                            }
                            Spacer()
                        }
                        .padding(.horizontal, 24)
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 20) {
                                NavigationLink(destination: LibraryView()) {
                                    EnhancedMoreItem(
                                        title: "Library",
                                        subtitle: "Study Resources",
                                        icon: "book.fill",
                                        gradient: [Color.green.opacity(0.8), Color.green]
                                    )
                                }
                                .buttonStyle(PlainButtonStyle())
                                
                                NavigationLink(destination: SportsView()) {
                                    EnhancedMoreItem(
                                        title: "Sports & Fun",
                                        subtitle: "All Sports",
                                        icon: "sportscourt.fill",
                                        gradient: [Color.red.opacity(0.8), Color.red]
                                    )
                                }
                                .buttonStyle(PlainButtonStyle())
                                
                                NavigationLink(destination: ContactUsView()) {
                                    EnhancedMoreItem(
                                        title: "Contact",
                                        subtitle: "Contact Us",
                                        icon: "person.crop.circle.fill.badge.checkmark",
                                        gradient: [Color.blue.opacity(0.8), Color.blue]
                                    )
                                }
                                .buttonStyle(PlainButtonStyle())
                            }
                            .padding(.horizontal, 24)
                        }
                    }
                    
                    VStack(alignment: .leading, spacing: 20) {
                        HStack {
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Recommended")
                                    .font(.system(size: 26, weight: .bold, design: .rounded))
                                    .foregroundColor(.primary)
                            }
                            Spacer()
                        }
                        .padding(.horizontal, 24)
                        
                        VStack(spacing: 16) {
                            NavigationLink(destination: AdmissionsView()) {
                                EnhancedRecommendedItem(
                                    icon: "doc.text.fill",
                                    title: "Admissions",
                                    subtitle: "Apply Online",
                                    iconColor: .accentColor
                                )
                            }
                            
                            NavigationLink(destination: FeeView()) {
                                EnhancedRecommendedItem(
                                    icon: "creditcard.fill",
                                    title: "Fee",
                                    subtitle: "About Fee",
                                    iconColor: .accentColor
                                )
                            }
                            
                            NavigationLink(destination: ManagementView()) {
                                EnhancedRecommendedItem(
                                    icon: "person.crop.circle.fill",
                                    title: "Managment",
                                    subtitle: "About Managment People",
                                    iconColor: .accentColor
                                )
                            }
                            
                            NavigationLink(destination: ExamsView()) {
                                EnhancedRecommendedItem(
                                    icon: "creditcard.fill",
                                    title: "Exams",
                                    subtitle: "About Mid Exams",
                                    iconColor: .accentColor
                                )
                            }
                        }
                        .padding(.horizontal, 24)
                    }
                    
                    AutoPlayVideoView(videoURL: "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4")
                        .padding(.top, 20)
                    
                    Spacer(minLength: 140)
                }
                .background(Color(.systemBackground))
                .clipShape(
                    RoundedRectangle(cornerRadius: 36)
                )
                .offset(y: -36)
                .shadow(color: .black.opacity(0.1), radius: 20, x: 0, y: -10)
            }
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

struct EnhancedDashboardItem: View {
    let icon: String
    let title: String
    let iconColor: Color
    
    var body: some View {
        VStack(spacing: 14) {
            ZStack {
                Circle()
                    .fill(iconColor.opacity(0.12))
                    .frame(width: 64, height: 64)
                    .shadow(color: iconColor.opacity(0.3), radius: 8, x: 0, y: 4)
                
                Image(systemName: icon)
                    .foregroundColor(iconColor)
                    .font(.system(size: 24, weight: .semibold))
                    .opacity(1)
            }
            
            Text(title)
                .font(.system(size: 13, weight: .semibold))
                .foregroundColor(.primary)
                .multilineTextAlignment(.center)
                .lineLimit(2)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 8)
    }
}

struct EnhancedDashboardItemButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.92 : 1.0)
            .opacity(configuration.isPressed ? 0.8 : 1.0)
            .animation(.easeInOut(duration: 0.15), value: configuration.isPressed)
    }
}

struct EnhancedMoreItem: View {
    let title: String
    let subtitle: String
    let icon: String
    let gradient: [Color]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            RoundedRectangle(cornerRadius: 20)
                .fill(
                    LinearGradient(
                        colors: gradient,
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .frame(width: 160, height: 120)
                .overlay(
                    VStack {
                        HStack {
                            Spacer()
                            Image(systemName: icon)
                                .font(.system(size: 28, weight: .semibold))
                                .foregroundColor(.white)
                                .padding(.top, 20)
                                .padding(.trailing, 20)
                        }
                        Spacer()
                    }
                )
            
            VStack(alignment: .leading, spacing: 6) {
                Text(title)
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(.primary)
                
                Text(subtitle)
                    .font(.system(size: 13, weight: .medium))
                    .foregroundColor(.secondary)
            }
        }
    }
}

struct EnhancedRecommendedItem: View {
    let icon: String
    let title: String
    let subtitle: String
    let iconColor: Color
    
    var body: some View {
        HStack(spacing: 20) {
            ZStack {
                RoundedRectangle(cornerRadius: 18)
                    .fill(
                        LinearGradient(
                            colors: [iconColor, iconColor],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 72, height: 72)
                
                Image(systemName: icon)
                    .foregroundColor(.white)
                    .font(.system(size: 16, weight: .semibold))
            }
            
            VStack(alignment: .leading, spacing: 6) {
                Text(title)
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(.primary)
                
                Text(subtitle)
                    .font(.system(size: 15, weight: .medium))
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(.secondary)
        }
        .padding(14)
        .background(
            RoundedRectangle(cornerRadius: 24)
                .fill(Color(.systemGray6))
                .shadow(color: .black.opacity(0.05), radius: 10, x: 0, y: 4)
        )
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
                icon: "calendar",
                title: "Calendar",
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
        .padding(.horizontal, 10)
        .padding(.vertical, 10)
        .background(
            RoundedRectangle(cornerRadius: 28)
                .fill(.ultraThinMaterial)
                .shadow(color: .black.opacity(0.15), radius: 25, x: 0, y: 12)
        )
        .padding(.horizontal, 10)
        .padding(.bottom, 8)
    }
}

struct TabBarItems: View {
    let icon: String
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 6) {
                ZStack {
                    if isSelected {
                        Circle()
                            .fill(.blue.opacity(0))
                            .frame(width: 36, height: 36)
                    }
                    
                    Image(systemName: icon)
                        .font(.system(size: 20, weight: .medium))
                        .foregroundColor(isSelected ? .accentColor : .secondary)
                }
                
                Text(title)
                    .font(.system(size: 11, weight: .semibold))
                    .foregroundColor(isSelected ? .accentColor : .secondary)
            }
            .frame(maxWidth: .infinity)
        }
        .scaleEffect(isSelected ? 1.05 : 1.0)
        .animation(.spring(response: 0.4, dampingFraction: 0.7), value: isSelected)
    }
}

struct AutoPlayVideoView: View {
    @State private var player: AVPlayer?
    @State private var isPlaying = false
    @State private var showControls = false
    @State private var playerObserver: NSKeyValueObservation?
    
    let videoURL: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Featured Video")
                        .font(.system(size: 26, weight: .bold, design: .rounded))
                        .foregroundColor(.primary)
                    
                    Text("Educational content")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.secondary)
                }
                Spacer()
            }
            .padding(.horizontal, 24)
            
            ZStack {
                if let player = player {
                    VideoPlayer(player: player)
                        .frame(height: 220)
                        .cornerRadius(20)
                        .shadow(color: .black.opacity(0.2), radius: 15, x: 0, y: 8)
                        .onTapGesture {
                            togglePlayback()
                        }
                        .overlay(
                            RoundedRectangle(cornerRadius: 20)
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
                                        ZStack {
                                            Circle()
                                                .fill(Color.black.opacity(0.4))
                                                .frame(width: 50, height: 50)
                                                .blur(radius: 1)
                                            
                                            Image(systemName: isPlaying ? "pause.circle.fill" : "play.circle.fill")
                                                .font(.system(size: 32, weight: .semibold))
                                                .foregroundColor(.white)
                                        }
                                        .opacity(showControls ? 1.0 : 0.0)
                                        Spacer()
                                    }
                                    .padding(.top, 20)
                                    .padding(.trailing, 20)
                                }
                                Spacer()
                            }
                        )
                } else {
                    RoundedRectangle(cornerRadius: 20)
                        .fill(Color.gray.opacity(0.2))
                        .frame(height: 220)
                        .overlay(
                            VStack(spacing: 12) {
                                Image(systemName: "video.slash")
                                    .font(.system(size: 36))
                                    .foregroundColor(.gray)
                                Text("Video not available")
                                    .font(.system(size: 16, weight: .medium))
                                    .foregroundColor(.gray)
                            }
                        )
                        .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: 4)
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
