import SwiftUI
import AVKit

struct SportsView: View {
    @State private var selectedTab = 0
    @State private var currentImageIndex = 0
    @State private var showImageViewer = false
    @State private var selectedImage = ""
    @State private var animateCards = false
    
    let sportsImages = [
        "Splash Img", "Splash Img", "Splash Img", "Splash Img",
        "Splash Img", "Splash Img", "Splash Img", "Splash Img"
    ]
    
    let sportsVideos = [
        SportVideo(title: "Football Championship", thumbnail: "football_thumb", videoURL: "football_video"),
        SportVideo(title: "Basketball Finals", thumbnail: "basketball_thumb", videoURL: "basketball_video"),
        SportVideo(title: "Cricket Match", thumbnail: "cricket_thumb", videoURL: "cricket_video"),
        SportVideo(title: "Track & Field", thumbnail: "track_thumb", videoURL: "track_video")
    ]
    
    let activities = [
        Activity(title: "Football", icon: "⚽️", color: .green),
        Activity(title: "Basketball", icon: "🏀", color: .orange),
        Activity(title: "Cricket", icon: "🏏", color: .blue),
        Activity(title: "Tennis", icon: "🎾", color: .yellow),
        Activity(title: "Swimming", icon: "🏊‍♂️", color: .cyan),
        Activity(title: "Athletics", icon: "🏃‍♂️", color: .red)
    ]
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    headerSection
                    tabSelector
                    if selectedTab == 0 {
                        activitiesSection
                    } else if selectedTab == 1 {
                        imageGallerySection
                    } else {
                        videoGallerySection
                    }
                }
                .padding(.horizontal)
            }
            .background(
                LinearGradient(
                    colors: [Color(.systemBackground), Color(.systemGray6)],
                    startPoint: .top,
                    endPoint: .bottom
                )
            )
            .onAppear {
                withAnimation(.easeInOut(duration: 0.8).delay(0.2)) {
                    animateCards = true
                }
                startImageSlideshow()
            }
        }
        .sheet(isPresented: $showImageViewer) {
            ImageViewer(imageName: selectedImage, isPresented: $showImageViewer)
        }
    }
    
    private var headerSection: some View {
        VStack(spacing: 16) {
            ZStack {
                RoundedRectangle(cornerRadius: 20)
                    .fill(
                        LinearGradient(
                            colors: [.blue.opacity(0.3), .purple.opacity(0.3)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(height: 200)
                
                AsyncImage(url: Bundle.main.url(forResource: sportsImages[currentImageIndex], withExtension: "jpg")) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                } placeholder: {
                    RoundedRectangle(cornerRadius: 20)
                        .fill(Color.gray.opacity(0.3))
                        .overlay(
                            Image(systemName: "photo")
                                .font(.system(size: 40))
                                .foregroundColor(.gray)
                        )
                }
                .frame(height: 200)
                .clipped()
                
                RoundedRectangle(cornerRadius: 20)
                    .fill(
                        LinearGradient(
                            colors: [.clear, .black.opacity(0.4)],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                
                VStack {
                    Spacer()
                    HStack {
                        VStack(alignment: .leading) {
                            Text("Sports & Activities")
                                .font(.title2)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                            Text("Stay Active, Stay Healthy")
                                .font(.subheadline)
                                .foregroundColor(.white.opacity(0.8))
                        }
                        Spacer()
                    }
                    .padding()
                }
            }
            .scaleEffect(animateCards ? 1 : 0.8)
            .opacity(animateCards ? 1 : 0)
            .animation(.easeOut(duration: 0.6), value: animateCards)
        }
    }
    
    private var tabSelector: some View {
        HStack(spacing: 0) {
            ForEach(0..<3) { index in
                Button(action: {
                    withAnimation(.easeInOut(duration: 0.3)) {
                        selectedTab = index
                    }
                }) {
                    VStack(spacing: 8) {
                        Image(systemName: tabIcon(for: index))
                            .font(.system(size: 20, weight: .medium))
                        Text(tabTitle(for: index))
                            .font(.caption)
                            .fontWeight(.medium)
                    }
                    .foregroundColor(selectedTab == index ? .white : .primary)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 12)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(selectedTab == index ? Color.blue : Color.clear)
                            .animation(.easeInOut(duration: 0.3), value: selectedTab)
                    )
                }
            }
        }
        .padding(4)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(.systemGray5))
        )
        .scaleEffect(animateCards ? 1 : 0.8)
        .opacity(animateCards ? 1 : 0)
        .animation(.easeOut(duration: 0.6).delay(0.2), value: animateCards)
    }
    
    private var activitiesSection: some View {
        LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 16), count: 2), spacing: 16) {
            ForEach(Array(activities.enumerated()), id: \.offset) { index, activity in
                ActivityCard(activity: activity)
                    .scaleEffect(animateCards ? 1 : 0.5)
                    .opacity(animateCards ? 1 : 0)
                    .animation(.easeOut(duration: 0.6).delay(Double(index) * 0.1 + 0.4), value: animateCards)
            }
        }
    }
    
    private var imageGallerySection: some View {
        LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 12), count: 2), spacing: 12) {
            ForEach(Array(sportsImages.enumerated()), id: \.offset) { index, imageName in
                ImageCard(imageName: imageName) {
                    selectedImage = imageName
                    showImageViewer = true
                }
                .scaleEffect(animateCards ? 1 : 0.5)
                .opacity(animateCards ? 1 : 0)
                .animation(.easeOut(duration: 0.6).delay(Double(index) * 0.1 + 0.4), value: animateCards)
            }
        }
    }
    
    private var videoGallerySection: some View {
        LazyVStack(spacing: 16) {
            ForEach(Array(sportsVideos.enumerated()), id: \.offset) { index, video in
                VideoCard(video: video)
                    .scaleEffect(animateCards ? 1 : 0.5)
                    .opacity(animateCards ? 1 : 0)
                    .animation(.easeOut(duration: 0.6).delay(Double(index) * 0.1 + 0.4), value: animateCards)
            }
        }
    }
    
    private func tabIcon(for index: Int) -> String {
        switch index {
        case 0: return "figure.run"
        case 1: return "photo.on.rectangle"
        case 2: return "play.rectangle"
        default: return "questionmark"
        }
    }
    
    private func tabTitle(for index: Int) -> String {
        switch index {
        case 0: return "Activities"
        case 1: return "Gallery"
        case 2: return "Videos"
        default: return ""
        }
    }
    
    private func startImageSlideshow() {
        Timer.scheduledTimer(withTimeInterval: 3.0, repeats: true) { _ in
            withAnimation(.easeInOut(duration: 0.5)) {
                currentImageIndex = (currentImageIndex + 1) % sportsImages.count
            }
        }
    }
}

struct ActivityCard: View {
    let activity: Activity
    @State private var isPressed = false
    
    var body: some View {
        VStack(spacing: 12) {
            Text(activity.icon)
                .font(.system(size: 40))
                .scaleEffect(isPressed ? 1.2 : 1.0)
                .animation(.easeInOut(duration: 0.2), value: isPressed)
            
            Text(activity.title)
                .font(.headline)
                .fontWeight(.semibold)
                .multilineTextAlignment(.center)
        }
        .frame(height: 120)
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(
                    LinearGradient(
                        colors: [activity.color.opacity(0.2), activity.color.opacity(0.1)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
        )
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(activity.color.opacity(0.3), lineWidth: 1)
        )
        .scaleEffect(isPressed ? 0.95 : 1.0)
        .onTapGesture {
            withAnimation(.easeInOut(duration: 0.1)) {
                isPressed = true
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                withAnimation(.easeInOut(duration: 0.1)) {
                    isPressed = false
                }
            }
        }
    }
}

struct ImageCard: View {
    let imageName: String
    let onTap: () -> Void
    @State private var isPressed = false
    
    var body: some View {
        Button(action: onTap) {
            AsyncImage(url: Bundle.main.url(forResource: imageName, withExtension: "jpg")) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            } placeholder: {
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.gray.opacity(0.3))
                    .overlay(
                        Image(systemName: "photo")
                            .font(.system(size: 30))
                            .foregroundColor(.gray)
                    )
            }
            .frame(height: 120)
            .clipped()
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color.white.opacity(0.2), lineWidth: 1)
            )
            .scaleEffect(isPressed ? 0.95 : 1.0)
            .animation(.easeInOut(duration: 0.1), value: isPressed)
        }
        .pressEvents(
            onPress: { isPressed = true },
            onRelease: { isPressed = false }
        )
    }
}

struct VideoCard: View {
    let video: SportVideo
    @State private var isPressed = false
    
    var body: some View {
        HStack(spacing: 16) {
            AsyncImage(url: Bundle.main.url(forResource: video.thumbnail, withExtension: "jpg")) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            } placeholder: {
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.gray.opacity(0.3))
                    .overlay(
                        Image(systemName: "video")
                            .font(.system(size: 25))
                            .foregroundColor(.gray)
                    )
            }
            .frame(width: 80, height: 60)
            .clipped()
            .cornerRadius(12)
            .overlay(
                Image(systemName: "play.fill")
                    .font(.system(size: 16))
                    .foregroundColor(.white)
                    .background(
                        Circle()
                            .fill(Color.black.opacity(0.6))
                            .frame(width: 30, height: 30)
                    )
            )
            VStack(alignment: .leading, spacing: 4) {
                Text(video.title)
                    .font(.headline)
                    .fontWeight(.semibold)
                
                Text("Tap to watch")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(.secondary)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(.systemBackground))
                .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 2)
        )
        .scaleEffect(isPressed ? 0.98 : 1.0)
        .animation(.easeInOut(duration: 0.1), value: isPressed)
        .onTapGesture {
            withAnimation(.easeInOut(duration: 0.1)) {
                isPressed = true
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                withAnimation(.easeInOut(duration: 0.1)) {
                    isPressed = false
                }
            }
        }
    }
}

struct ImageViewer: View {
    let imageName: String
    @Binding var isPresented: Bool
    @State private var scale: CGFloat = 1.0
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.black.ignoresSafeArea()
                
                AsyncImage(url: Bundle.main.url(forResource: imageName, withExtension: "jpg")) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .scaleEffect(scale)
                        .gesture(
                            MagnificationGesture()
                                .onChanged { value in
                                    scale = value
                                }
                                .onEnded { _ in
                                    withAnimation(.easeInOut) {
                                        scale = max(1.0, min(scale, 3.0))
                                    }
                                }
                        )
                } placeholder: {
                    ProgressView()
                        .tint(.white)
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        isPresented = false
                    }
                    .foregroundColor(.white)
                }
            }
        }
    }
}


struct Activity {
    let title: String
    let icon: String
    let color: Color
}

struct SportVideo {
    let title: String
    let thumbnail: String
    let videoURL: String
}

extension View {
    func pressEvents(onPress: @escaping () -> Void, onRelease: @escaping () -> Void) -> some View {
        self
            .onLongPressGesture(minimumDuration: 0, maximumDistance: .infinity, pressing: { pressing in
                if pressing {
                    onPress()
                } else {
                    onRelease()
                }
            }, perform: {})
    }
}

#Preview {
    SportsView()
}
