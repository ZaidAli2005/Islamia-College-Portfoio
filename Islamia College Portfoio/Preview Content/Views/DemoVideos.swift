//
//  DemoVideos.swift
//  Islamia College Portfolio
//
//  Created by Development on 19/06/2025.
//

import SwiftUI
import AVKit

struct VideoItem: Identifiable {
    let id = UUID()
    let title: String
    let description: String
    let videoURL: URL
    let thumbnailName: String
    let duration: String
    let category: String
}

struct DemoVideos: View {
    @State private var selectedVideo: VideoItem? = nil
    @State private var showingVideoPlayer = false
    @State private var searchText = ""
    @State private var selectedCategory = "All"
    
    private let demoVideos: [VideoItem] = [
        VideoItem(
            title: "Campus Tour 2024",
            description: "Take a virtual tour of our beautiful campus facilities, including libraries, labs, and recreational areas.",
            videoURL: URL(string: "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4")!,
            thumbnailName: "campus_thumb",
            duration: "5:30",
            category: "Campus"
        ),
        VideoItem(
            title: "Academic Excellence",
            description: "Discover our academic programs and the achievements of our students and faculty members.",
            videoURL: URL(string: "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4")!,
            thumbnailName: "academic_thumb",
            duration: "3:45",
            category: "Academics"
        ),
        VideoItem(
            title: "Student Life Highlights",
            description: "Experience the vibrant student life with clubs, societies, and extracurricular activities.",
            videoURL: URL(string: "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4")!,
            thumbnailName: "student_life_thumb",
            duration: "4:20",
            category: "Student Life"
        ),
        VideoItem(
            title: "Research & Innovation",
            description: "Explore cutting-edge research projects and innovative solutions developed by our community.",
            videoURL: URL(string: "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4")!,
            thumbnailName: "research_thumb",
            duration: "6:15",
            category: "Research"
        ),
        VideoItem(
            title: "Alumni Success Stories",
            description: "Meet our successful alumni and learn about their inspiring career journeys.",
            videoURL: URL(string: "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4")!,
            thumbnailName: "alumni_thumb",
            duration: "7:30",
            category: "Alumni"
        ),
        VideoItem(
            title: "Sports & Recreation",
            description: "Witness our athletic achievements and recreational facilities that promote healthy living.",
            videoURL: URL(string: "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4")!,
            thumbnailName: "sports_thumb",
            duration: "4:50",
            category: "Sports"
        )
    ]
    
    private let categories = ["All", "Campus", "Academics", "Student Life", "Research", "Alumni", "Sports"]
    
    private var filteredVideos: [VideoItem] {
        let categoryFiltered = selectedCategory == "All" ? demoVideos : demoVideos.filter { $0.category == selectedCategory }
        
        if searchText.isEmpty {
            return categoryFiltered
        } else {
            return categoryFiltered.filter {
                $0.title.localizedCaseInsensitiveContains(searchText) ||
                $0.description.localizedCaseInsensitiveContains(searchText)
            }
        }
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Header Section
                headerSection
                
                // Search and Filter Section
                searchAndFilterSection
                
                // Videos Grid
                videosGridSection
            }
            .navigationBarHidden(true)
            .background(
                LinearGradient(
                    colors: [Color(.systemBackground), Color(.systemGray6)],
                    startPoint: .top,
                    endPoint: .bottom
                )
            )
        }
        .sheet(isPresented: $showingVideoPlayer) {
            if let video = selectedVideo {
                VideoPlayerView(video: video, isPresented: $showingVideoPlayer)
            }
        }
    }
    
    // MARK: - Header Section
    private var headerSection: some View {
        VStack(spacing: 16) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Demo Videos")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.primary)
                    
                    Text("Explore our college highlights")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                Button(action: {}) {
                    Image(systemName: "square.grid.2x2")
                        .font(.title2)
                        .foregroundColor(.primary)
                }
            }
            .padding(.horizontal, 20)
            .padding(.top, 20)
        }
    }
    
    // MARK: - Search and Filter Section
    private var searchAndFilterSection: some View {
        VStack(spacing: 16) {
            // Search Bar
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.secondary)
                
                TextField("Search videos...", text: $searchText)
                    .textFieldStyle(PlainTextFieldStyle())
                
                if !searchText.isEmpty {
                    Button(action: { searchText = "" }) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.secondary)
                    }
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(Color(.systemGray5))
            .cornerRadius(12)
            .padding(.horizontal, 20)
            
            // Category Filter
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(categories, id: \.self) { category in
                        CategoryButton(
                            title: category,
                            isSelected: selectedCategory == category,
                            action: { selectedCategory = category }
                        )
                    }
                }
                .padding(.horizontal, 20)
            }
        }
        .padding(.vertical, 16)
    }
    
    // MARK: - Videos Grid Section
    private var videosGridSection: some View {
        ScrollView {
            LazyVGrid(columns: [
                GridItem(.flexible(), spacing: 16),
                GridItem(.flexible(), spacing: 16)
            ], spacing: 20) {
                ForEach(filteredVideos) { video in
                    VideosCard(video: video) {
                        selectedVideo = video
                        showingVideoPlayer = true
                    }
                }
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 30)
        }
    }
}

// MARK: - Category Button
struct CategoryButton: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.subheadline)
                .fontWeight(.medium)
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(
                    Capsule()
                        .fill(isSelected ? Color.blue : Color(.systemGray5))
                )
                .foregroundColor(isSelected ? .white : .primary)
                .scaleEffect(isSelected ? 1.05 : 1.0)
                .animation(.easeInOut(duration: 0.2), value: isSelected)
        }
    }
}

// MARK: - Video Card
struct VideosCard: View {
    let video: VideoItem
    let onTap: () -> Void
    @State private var isPressed = false
    
    var body: some View {
        Button(action: onTap) {
            VStack(alignment: .leading, spacing: 0) {
                // Thumbnail Section
                ZStack {
                    // Placeholder thumbnail
                    RoundedRectangle(cornerRadius: 16)
                        .fill(
                            LinearGradient(
                                colors: [.blue.opacity(0.3), .purple.opacity(0.3)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .aspectRatio(16/9, contentMode: .fit)
                    
                    // Play button overlay
                    VStack {
                        Spacer()
                        HStack {
                            Spacer()
                            
                            ZStack {
                                Circle()
                                    .fill(.ultraThinMaterial)
                                    .frame(width: 60, height: 60)
                                
                                Image(systemName: "play.fill")
                                    .font(.title2)
                                    .foregroundColor(.white)
                            }
                            .scaleEffect(isPressed ? 0.9 : 1.0)
                            .animation(.easeInOut(duration: 0.1), value: isPressed)
                            
                            Spacer()
                        }
                        Spacer()
                    }
                    
                    // Duration badge
                    VStack {
                        HStack {
                            Spacer()
                            
                            Text(video.duration)
                                .font(.caption)
                                .fontWeight(.semibold)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 4)
                                .background(.ultraThinMaterial)
                                .foregroundColor(.white)
                                .clipShape(Capsule())
                                .padding(.trailing, 12)
                                .padding(.top, 12)
                        }
                        Spacer()
                    }
                }
                
                // Content Section
                VStack(alignment: .leading, spacing: 8) {
                    Text(video.title)
                        .font(.headline)
                        .fontWeight(.semibold)
                        .lineLimit(2)
                        .multilineTextAlignment(.leading)
                    
                    Text(video.description)
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .lineLimit(3)
                        .multilineTextAlignment(.leading)
                    
                    HStack {
                        Text(video.category)
                            .font(.caption2)
                            .fontWeight(.medium)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(Color.blue.opacity(0.1))
                            .foregroundColor(.blue)
                            .clipShape(Capsule())
                        
                        Spacer()
                    }
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 12)
            }
        }
        .buttonStyle(PlainButtonStyle())
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .shadow(color: .black.opacity(0.1), radius: 8, x: 0, y: 4)
        .scaleEffect(isPressed ? 0.95 : 1.0)
        .animation(.easeInOut(duration: 0.2), value: isPressed)
        .onLongPressGesture(minimumDuration: 0, maximumDistance: .infinity, pressing: { pressing in
            isPressed = pressing
        }, perform: {})
    }
}

// MARK: - Video Player View
struct VideoPlayerView: View {
    let video: VideoItem
    @Binding var isPresented: Bool
    @State private var player: AVPlayer?
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Video Player
                if let player = player {
                    VideoPlayer(player: player)
                        .aspectRatio(16/9, contentMode: .fit)
                        .background(Color.black)
                } else {
                    RoundedRectangle(cornerRadius: 16)
                        .fill(Color(.systemGray5))
                        .aspectRatio(16/9, contentMode: .fit)
                        .overlay(
                            ProgressView()
                                .scaleEffect(1.5)
                        )
                        .padding()
                }
                
                // Video Info
                ScrollView {
                    VStack(alignment: .leading, spacing: 16) {
                        VStack(alignment: .leading, spacing: 8) {
                            Text(video.title)
                                .font(.title2)
                                .fontWeight(.bold)
                            
                            HStack {
                                Text(video.category)
                                    .font(.subheadline)
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 6)
                                    .background(Color.blue.opacity(0.1))
                                    .foregroundColor(.blue)
                                    .clipShape(Capsule())
                                
                                Text(video.duration)
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                                
                                Spacer()
                            }
                        }
                        
                        Text(video.description)
                            .font(.body)
                            .foregroundColor(.secondary)
                            .lineSpacing(2)
                    }
                    .padding()
                }
                .background(Color(.systemBackground))
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarTitle("", displayMode: .inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        player?.pause()
                        isPresented = false
                    }
                }
            }
        }
        .onAppear {
            player = AVPlayer(url: video.videoURL)
        }
        .onDisappear {
            player?.pause()
            player = nil
        }
    }
}

#Preview {
    DemoVideos()
}
