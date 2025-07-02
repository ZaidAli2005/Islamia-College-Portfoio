import SwiftUI
import AVKit
import Photos

struct SportsView: View {
    @State private var selectedTab = 0
    @State private var currentImageIndex = 0
    @State private var showImageViewer = false
    @State private var selectedImage = ""
    @State private var animateCards = false
    @State private var showVideoPlayer = false
    @State private var selectedVideoURL = ""
    
    let sportsImages = [
        "50", "51", "52", "53","54", "55", "56", "57","58","59","60","61","62","63","64","65","66","67","68","69","70","71","86","87","88","89","90","91","92","93","94","95","72","73","74","75","76","77","78","79","80","81","82","83","84","85"
    ]
    
    let sportsVideos = [
        SportVideo(title: "Football Championship", thumbnail: "50", videoURL: "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4"),
        SportVideo(title: "Basketball Finals", thumbnail: "64", videoURL: "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ElephantsDream.mp4"),
        SportVideo(title: "Cricket Match", thumbnail: "53", videoURL: "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerBlazes.mp4"),
        SportVideo(title: "Track & Field", thumbnail: "56", videoURL: "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ElephantsDream.mp4")
    ]
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    headerSection
                    tabSelector
                    if selectedTab == 0 {
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
        .fullScreenCover(isPresented: $showVideoPlayer) {
            VideoPlayerView(videoURL: selectedVideoURL, isPresented: $showVideoPlayer)
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
                
                Image(sportsImages[currentImageIndex])
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(height: 200)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                    .clipped()
                    .onTapGesture {
                        print("Image tapped: \(sportsImages[currentImageIndex])")
                    }
                
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
            ForEach(0..<2) { index in 
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
                            .fill(selectedTab == index ? Color.accentColor : Color.clear)
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
                VideoCard(video: video) {
                    selectedVideoURL = video.videoURL
                    showVideoPlayer = true
                }
                .scaleEffect(animateCards ? 1 : 0.5)
                .opacity(animateCards ? 1 : 0)
                .animation(.easeOut(duration: 0.6).delay(Double(index) * 0.1 + 0.4), value: animateCards)
            }
        }
    }
    
    private func tabIcon(for index: Int) -> String {
        switch index {
        case 0: return "photo.on.rectangle"
        case 1: return "play.rectangle"
        default: return "questionmark"
        }
    }
    
    private func tabTitle(for index: Int) -> String {
        switch index {
        case 0: return "Gallery"
        case 1: return "Videos"
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

struct ImageCard: View {
    let imageName: String
    let onTap: () -> Void
    @State private var isPressed = false
    
    var body: some View {
        Button(action: onTap) {
            ZStack {
                Image(imageName)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(height: 120)
                    .clipped()
                    .cornerRadius(12)
                    .onAppear {
                        if UIImage(named: imageName) == nil {
                            print("Warning: Image '\(imageName)' not found in bundle")
                        }
                    }
            }
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
    let onTap: () -> Void
    @State private var isPressed = false
    
    var body: some View {
        HStack(spacing: 16) {
            ZStack {
                Image(video.thumbnail)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 80, height: 60)
                    .clipped()
                    .cornerRadius(12)
                    .onAppear {
                        if UIImage(named: video.thumbnail) == nil {
                            print("Warning: Thumbnail '\(video.thumbnail)' not found in bundle")
                        }
                    }
                
                Image(systemName: "play.fill")
                    .font(.system(size: 16))
                    .foregroundColor(.white)
                    .background(
                        Circle()
                            .fill(Color.black.opacity(0.6))
                            .frame(width: 30, height: 30)
                    )
            }
            
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
                onTap()
            }
        }
    }
}

struct VideoPlayerView: View {
    let videoURL: String
    @Binding var isPresented: Bool
    @State private var showToast = false
    @State private var toastMessage = ""
    @State private var isDownloading = false
    @State private var downloadProgress: Float = 0.0
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.black.ignoresSafeArea()
                
                if let url = URL(string: videoURL) {
                    VideoPlayer(player: AVPlayer(url: url))
                        .onAppear {
                            AVPlayer(url: url).play()
                        }
                } else {
                    VStack {
                        Image(systemName: "exclamationmark.triangle")
                            .font(.system(size: 50))
                            .foregroundColor(.white)
                        Text("Unable to load video")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding(.top)
                    }
                }
                
                if showToast {
                    VStack {
                        Spacer()
                        HStack(spacing: 12) {
                            if isDownloading {
                                ZStack {
                                    Circle()
                                        .stroke(Color.white.opacity(0.3), lineWidth: 3)
                                        .frame(width: 24, height: 24)
                                    
                                    Circle()
                                        .trim(from: 0, to: CGFloat(downloadProgress))
                                        .stroke(Color.blue, style: StrokeStyle(lineWidth: 3, lineCap: .round))
                                        .frame(width: 24, height: 24)
                                        .rotationEffect(.degrees(-90))
                                        .animation(.easeInOut(duration: 0.2), value: downloadProgress)
                                }
                            } else {
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundColor(.green)
                                    .font(.system(size: 20))
                            }
                            
                            VStack(alignment: .leading, spacing: 2) {
                                Text(toastMessage)
                                    .foregroundColor(.white)
                                    .font(.system(size: 16, weight: .medium))
                                
                                if isDownloading {
                                    Text("\(Int(downloadProgress * 100))%")
                                        .foregroundColor(.white.opacity(0.8))
                                        .font(.system(size: 14, weight: .regular))
                                }
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.vertical, 16)
                        .background(
                            RoundedRectangle(cornerRadius: 25)
                                .fill(Color.black.opacity(0.85))
                        )
                        .padding(.bottom, 100)
                    }
                    .transition(.move(edge: .bottom).combined(with: .opacity))
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: downloadVideo) {
                        if isDownloading {
                            ZStack {
                                Circle()
                                    .stroke(Color.white.opacity(0.3), lineWidth: 2)
                                    .frame(width: 20, height: 20)
                                
                                Circle()
                                    .trim(from: 0, to: CGFloat(downloadProgress))
                                    .stroke(Color.white, style: StrokeStyle(lineWidth: 2, lineCap: .round))
                                    .frame(width: 20, height: 20)
                                    .rotationEffect(.degrees(-90))
                                    .animation(.easeInOut(duration: 0.2), value: downloadProgress)
                            }
                        } else {
                            Image(systemName: "arrow.down.circle")
                                .font(.system(size: 20))
                                .foregroundColor(.white)
                        }
                    }
                    .disabled(isDownloading)
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        isPresented = false
                    }
                    .foregroundColor(.white)
                }
            }
        }
    }
    
    private func downloadVideo() {
        guard let url = URL(string: videoURL) else {
            showToastMessage("Invalid video URL", isDownloading: false)
            return
        }
        
        PHPhotoLibrary.requestAuthorization { status in
            DispatchQueue.main.async {
                switch status {
                case .authorized, .limited:
                    self.performDownload(url: url)
                case .denied, .restricted:
                    self.showToastMessage("Photo library access denied", isDownloading: false)
                case .notDetermined:
                    self.showToastMessage("Photo library permission required", isDownloading: false)
                @unknown default:
                    self.showToastMessage("Unknown permission status", isDownloading: false)
                }
            }
        }
    }
    
    private func performDownload(url: URL) {
        isDownloading = true
        downloadProgress = 0.0
        showToastMessage("Downloading video...", isDownloading: true)
        
        let session = URLSession(configuration: .default, delegate: DownloadDelegate { progress in
            DispatchQueue.main.async {
                self.downloadProgress = progress
                self.showToastMessage("Downloading video...", isDownloading: true)
            }
        } completion: { localURL, error in
            DispatchQueue.main.async {
                self.isDownloading = false
                
                if let error = error {
                    self.showToastMessage("Download failed: \(error.localizedDescription)", isDownloading: false)
                    return
                }
                
                guard let localURL = localURL else {
                    self.showToastMessage("Download failed", isDownloading: false)
                    return
                }
                
                self.saveVideoToPhotos(videoURL: localURL)
            }
        }, delegateQueue: nil)
        
        let downloadTask = session.downloadTask(with: url)
        downloadTask.resume()
    }
    
    private func saveVideoToPhotos(videoURL: URL) {
        PHPhotoLibrary.shared().performChanges({
            PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: videoURL)
        }) { success, error in
            DispatchQueue.main.async {
                if success {
                    self.showToastMessage("Video saved to Photos", isDownloading: false)
                } else {
                    let errorMessage = error?.localizedDescription ?? "Unknown error"
                    self.showToastMessage("Failed to save: \(errorMessage)", isDownloading: false)
                }
            }
        }
    }
    
    private func showToastMessage(_ message: String, isDownloading: Bool) {
        toastMessage = message
        self.isDownloading = isDownloading
        
        withAnimation(.easeInOut(duration: 0.3)) {
            showToast = true
        }
        
        if !isDownloading {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                withAnimation(.easeInOut(duration: 0.3)) {
                    showToast = false
                }
            }
        }
    }
}

class DownloadDelegate: NSObject, URLSessionDownloadDelegate {
    private let progressHandler: (Float) -> Void
    private let completionHandler: (URL?, Error?) -> Void
    
    init(progressHandler: @escaping (Float) -> Void, completion: @escaping (URL?, Error?) -> Void) {
        self.progressHandler = progressHandler
        self.completionHandler = completion
        super.init()
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        
        let progress = Float(totalBytesWritten) / Float(totalBytesExpectedToWrite)
        progressHandler(progress)
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        completionHandler(location, nil)
    }
    
    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        if let error = error {
            completionHandler(nil, error)
        }
    }
}

struct LinearProgressView: View {
    let progress: Float
    
    var body: some View {
        VStack(spacing: 8) {
            HStack {
                Text("Downloading...")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.white)
                Spacer()
                Text("\(Int(progress * 100))%")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.white)
            }
            
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 2)
                        .fill(Color.white.opacity(0.3))
                        .frame(height: 4)
                    
                    RoundedRectangle(cornerRadius: 2)
                        .fill(Color.blue)
                        .frame(width: geometry.size.width * CGFloat(progress), height: 4)
                        .animation(.easeInOut(duration: 0.2), value: progress)
                }
            }
            .frame(height: 4)
        }
    }
}

struct ImageViewer: View {
    let imageName: String
    @Binding var isPresented: Bool
    @State private var scale: CGFloat = 1.0
    @State private var showToast = false
    @State private var toastMessage = ""
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.black.ignoresSafeArea()
                
                Image(imageName)
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
                
                if showToast {
                    VStack {
                        Spacer()
                        HStack {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundColor(.green)
                            Text(toastMessage)
                                .foregroundColor(.white)
                                .font(.system(size: 16, weight: .medium))
                        }
                        .padding(.horizontal, 20)
                        .padding(.vertical, 12)
                        .background(
                            RoundedRectangle(cornerRadius: 25)
                                .fill(Color.black.opacity(0.8))
                        )
                        .padding(.bottom, 100)
                    }
                    .transition(.move(edge: .bottom).combined(with: .opacity))
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: downloadImage) {
                        Image(systemName: "arrow.down.circle")
                            .font(.system(size: 20))
                            .foregroundColor(.white)
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        isPresented = false
                    }
                    .foregroundColor(.white)
                }
            }
        }
    }
    
    private func downloadImage() {
        guard let image = UIImage(named: imageName) else {
            showToastMessage("Failed to download image")
            return
        }
        
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
        showToastMessage("Image downloaded successfully")
    }
    
    private func showToastMessage(_ message: String) {
        toastMessage = message
        withAnimation(.easeInOut(duration: 0.3)) {
            showToast = true
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            withAnimation(.easeInOut(duration: 0.3)) {
                showToast = false
            }
        }
    }
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
