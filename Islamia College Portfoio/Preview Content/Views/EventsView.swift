//
//  EventsView.swift
//  Islamia College Portfolio
//
//  Created by Development on 17/06/2025.
//

import SwiftUI

// MARK: - Event Model
struct Event: Identifiable, Codable {
    var id = UUID()
    let title: String
    let description: String
    let date: Date
    let location: String
    let imageNames: [String]
    let category: EventCategory
    let isUpcoming: Bool
    let attendeesCount: Int
    let organizer: String
    
    var primaryImage: String {
        return imageNames.first ?? "placeholder"
    }
    
    var hasMultipleImages: Bool {
        return imageNames.count > 1
    }
    
    var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
    
    var daysSinceOrUntil: Int {
        Calendar.current.dateComponents([.day], from: Date(), to: date).day ?? 0
    }
}

enum EventCategory: String, CaseIterable, Codable {
    case academic = "Academic"
    case sports = "Sports"
    case cultural = "Cultural"
    case workshop = "Workshop"
    case seminar = "Seminar"
    case competition = "Competition"
    
    var color: Color {
        switch self {
        case .academic: return .accentColor
        case .sports: return .accentColor
        case .cultural: return .accentColor
        case .workshop: return .accentColor
        case .seminar: return .accentColor
        case .competition: return .accentColor
        }
    }
    
    var icon: String {
        switch self {
        case .academic: return "book.fill"
        case .sports: return "sportscourt.fill"
        case .cultural: return "theatermasks.fill"
        case .workshop: return "hammer.fill"
        case .seminar: return "person.3.fill"
        case .competition: return "trophy.fill"
        }
    }
}

class EventsViewModel: ObservableObject {
    @Published var events: [Event] = []
    @Published var selectedCategory: EventCategory? = nil
    @Published var searchText = ""
    @Published var showingUpcomingOnly = false
    
    init() {
        loadSampleEvents()
    }
    
    var filteredEvents: [Event] {
        var filtered = events
        
        if let category = selectedCategory {
            filtered = filtered.filter { $0.category == category }
        }
        
        if showingUpcomingOnly {
            filtered = filtered.filter { $0.isUpcoming }
        }
        
        if !searchText.isEmpty {
            filtered = filtered.filter {
                $0.title.localizedCaseInsensitiveContains(searchText) ||
                $0.description.localizedCaseInsensitiveContains(searchText) ||
                $0.location.localizedCaseInsensitiveContains(searchText)
            }
        }
        
        return filtered.sorted { $0.date < $1.date }
    }
    
    private func loadSampleEvents() {
        let calendar = Calendar.current
        let today = Date()
        
        events = [
            Event(
                title: "Annual Science Fair",
                description: "Showcase of innovative projects by students from various departments. Join us for an exciting display of creativity and scientific innovation.",
                date: calendar.date(byAdding: .day, value: 15, to: today) ?? today,
                location: "Main Auditorium",
                imageNames: ["science_fair_1", "science_fair_2", "science_fair_3", "science_fair_4"],
                category: .academic,
                isUpcoming: true,
                attendeesCount: 450,
                organizer: "Science Department"
            ),
            Event(
                title: "Inter-College Football Championship",
                description: "Annual football tournament featuring teams from multiple colleges. Come support our team as they compete for the championship title.",
                date: calendar.date(byAdding: .day, value: 8, to: today) ?? today,
                location: "Sports Complex",
                imageNames: ["football_1", "football_2", "sports_complex"],
                category: .sports,
                isUpcoming: true,
                attendeesCount: 1200,
                organizer: "Sports Committee"
            ),
            Event(
                title: "Cultural Night 2025",
                description: "An evening celebrating diverse cultures with traditional performances, music, and food from around the world.",
                date: calendar.date(byAdding: .day, value: 22, to: today) ?? today,
                location: "College Grounds",
                imageNames: ["cultural_night_1", "cultural_night_2", "cultural_night_3", "cultural_performances", "cultural_food"],
                category: .cultural,
                isUpcoming: true,
                attendeesCount: 800,
                organizer: "Cultural Society"
            ),
            Event(
                title: "iOS Development Workshop",
                description: "Learn the fundamentals of iOS app development with Swift and SwiftUI. Perfect for beginners and intermediate developers.",
                date: calendar.date(byAdding: .day, value: 5, to: today) ?? today,
                location: "Computer Lab A",
                imageNames: ["ios_workshop_1", "ios_workshop_2", "computer_lab"],
                category: .workshop,
                isUpcoming: true,
                attendeesCount: 60,
                organizer: "IT Department"
            ),
            Event(
                title: "Career Guidance Seminar",
                description: "Professional guidance session with industry experts sharing insights about career opportunities and job market trends.",
                date: calendar.date(byAdding: .day, value: -10, to: today) ?? today,
                location: "Conference Hall",
                imageNames: ["career_seminar_1", "career_seminar_2", "conference_hall"],
                category: .seminar,
                isUpcoming: false,
                attendeesCount: 320,
                organizer: "Career Services"
            ),
            Event(
                title: "Coding Competition 2025",
                description: "Test your programming skills in this exciting coding challenge with attractive prizes for winners.",
                date: calendar.date(byAdding: .day, value: 12, to: today) ?? today,
                location: "IT Block",
                imageNames: ["coding_competition_1", "coding_competition_2", "it_block", "programming_setup"],
                category: .competition,
                isUpcoming: true,
                attendeesCount: 150,
                organizer: "Programming Club"
            )
        ]
    }
}

// MARK: - Main Events View
struct EventsView: View {
    @StateObject private var viewModel = EventsViewModel()
    @State private var selectedEvent: Event?
    @State private var showingFilters = false
    @State private var animateCards = false
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                searchAndFilterSection
                eventsListView
            }
            .background(
                LinearGradient(
                    gradient: Gradient(colors: [Color.blue.opacity(0.1), Color.purple.opacity(0.1)]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            .navigationBarHidden(true)
        }
        .sheet(item: $selectedEvent) { event in
            EventDetailView(event: event)
        }
        .onAppear {
            withAnimation(.easeInOut(duration: 0.8)) {
                animateCards = true
            }
        }
    }
    
    private var searchAndFilterSection: some View {
        VStack(spacing: 12) {
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.gray)
                
                TextField("Search events...", text: $viewModel.searchText)
                    .textFieldStyle(PlainTextFieldStyle())
                
                if !viewModel.searchText.isEmpty {
                    Button(action: { viewModel.searchText = "" }) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.gray)
                    }
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(Color.white)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .shadow(color: .black.opacity(0.1), radius: 2, x: 0, y: 1)
            if showingFilters {
                categoryFiltersView
                    .transition(.move(edge: .top).combined(with: .opacity))
            }
            HStack {
                Toggle("Show upcoming only", isOn: $viewModel.showingUpcomingOnly)
                    .font(.subheadline)
                
                Spacer()
                
                Text("\(viewModel.filteredEvents.count) events")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
        .padding(.horizontal, 20)
        .padding(.top, 30)
        .animation(.easeInOut(duration: 0.3), value: showingFilters)
    }
    
    private var categoryFiltersView: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                // All categories button
                Button(action: {
                    withAnimation(.spring()) {
                        viewModel.selectedCategory = nil
                    }
                }) {
                    HStack(spacing: 6) {
                        Image(systemName: "list.bullet")
                        Text("All")
                    }
                    .font(.subheadline)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
                    .background(viewModel.selectedCategory == nil ? Color.accentColor : Color.gray.opacity(0.2))
                    .foregroundColor(viewModel.selectedCategory == nil ? .white : .primary)
                    .clipShape(Capsule())
                }
                
                ForEach(EventCategory.allCases, id: \.self) { category in
                    Button(action: {
                        withAnimation(.spring()) {
                            viewModel.selectedCategory = viewModel.selectedCategory == category ? nil : category
                        }
                    }) {
                        HStack(spacing: 6) {
                            Image(systemName: category.icon)
                            Text(category.rawValue)
                        }
                        .font(.subheadline)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                        .background(viewModel.selectedCategory == category ? category.color : Color.gray.opacity(0.2))
                        .foregroundColor(viewModel.selectedCategory == category ? .white : .primary)
                        .clipShape(Capsule())
                    }
                }
            }
            .padding(.horizontal, 20)
        }
    }
    
    // MARK: - Events List
    private var eventsListView: some View {
        ScrollView {
            LazyVStack(spacing: 16) {
                ForEach(Array(viewModel.filteredEvents.enumerated()), id: \.element.id) { index, event in
                    EventCardView(event: event)
                        .onTapGesture {
                            selectedEvent = event
                        }
                        .scaleEffect(animateCards ? 1.0 : 0.8)
                        .opacity(animateCards ? 1.0 : 0)
                        .animation(
                            .spring(response: 0.6, dampingFraction: 0.8)
                            .delay(Double(index) * 0.1),
                            value: animateCards
                        )
                }
            }
            .padding(.horizontal, 20)
            .padding(.top, 20)
            .padding(.bottom, 100)
        }
    }
}

// MARK: - Event Card View
struct EventCardView: View {
    let event: Event
    @State private var isPressed = false
    @State private var currentImageIndex = 0
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Image section with carousel
            ZStack(alignment: .topTrailing) {
                // Image carousel
                TabView(selection: $currentImageIndex) {
                    ForEach(Array(event.imageNames.enumerated()), id: \.offset) { index, imageName in
                        Image(imageName)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(height: 180)
                            .clipped()
                            .overlay(
                                // Fallback gradient overlay if image doesn't exist
                                LinearGradient(
                                    gradient: Gradient(colors: [Color.clear, event.category.color.opacity(0.3)]),
                                    startPoint: .top,
                                    endPoint: .bottom
                                )
                            )
                            .tag(index)
                    }
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                .frame(height: 180)
                .onAppear {
                    // Auto-scroll through images if multiple exist
                    if event.hasMultipleImages {
                        startImageTimer()
                    }
                }
                
                VStack(alignment: .trailing, spacing: 8) {
                    // Status badge
                    statusBadge
                    
                    // Image counter (if multiple images)
                    if event.hasMultipleImages {
                        imageCounter
                    }
                }
                .padding(.top, 12)
                .padding(.trailing, 12)
            }
            
            // Content section
            VStack(alignment: .leading, spacing: 12) {
                // Title and date
                VStack(alignment: .leading, spacing: 6) {
                    Text(event.title)
                        .font(.headline)
                        .fontWeight(.semibold)
                        .lineLimit(2)
                    
                    HStack {
                        Image(systemName: "calendar")
                            .foregroundColor(.secondary)
                        Text(event.formattedDate)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                }
                
                // Description
                Text(event.description)
                    .font(.body)
                    .foregroundColor(.secondary)
                    .lineLimit(3)
                    .multilineTextAlignment(.leading)
                
                // Location and attendees
                HStack {
                    HStack(spacing: 4) {
                        Image(systemName: "location")
                            .foregroundColor(.blue)
                        Text(event.location)
                            .font(.caption)
                            .foregroundColor(.primary)
                    }
                    
                    Spacer()
                    
                    HStack(spacing: 4) {
                        Image(systemName: "person.2")
                            .foregroundColor(.green)
                        Text("\(event.attendeesCount)")
                            .font(.caption)
                            .foregroundColor(.primary)
                    }
                }
                
                // Organizer
                HStack {
                    Text("Organized by")
                        .font(.caption2)
                        .foregroundColor(.secondary)
                    Text(event.organizer)
                        .font(.caption)
                        .fontWeight(.medium)
                        .foregroundColor(.blue)
                }
            }
            .padding(16)
        }
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
        .shadow(color: .black.opacity(0.1), radius: 8, x: 0, y: 4)
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
    
    private var statusBadge: some View {
        HStack(spacing: 4) {
            Circle()
                .fill(event.isUpcoming ? Color.green : Color.gray)
                .frame(width: 6, height: 6)
            
            Text(event.isUpcoming ? "Upcoming" : "Past")
                .font(.caption2)
                .fontWeight(.medium)
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 4)
        .background(Color.white.opacity(0.9))
        .clipShape(Capsule())
    }
    
    private var imageCounter: some View {
        HStack(spacing: 4) {
            Text("\(currentImageIndex + 1)/\(event.imageNames.count)")
                .font(.caption2)
                .fontWeight(.medium)
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 4)
        .background(Color.black.opacity(0.7))
        .foregroundColor(.white)
        .clipShape(Capsule())
    }
    
    private func startImageTimer() {
        Timer.scheduledTimer(withTimeInterval: 3.0, repeats: true) { _ in
            withAnimation(.easeInOut(duration: 0.5)) {
                currentImageIndex = (currentImageIndex + 1) % event.imageNames.count
            }
        }
    }
}

// MARK: - Event Detail View
struct EventDetailView: View {
    let event: Event
    @Environment(\.dismiss) private var dismiss
    @State private var currentImageIndex = 0
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    // Hero image carousel
                    ZStack(alignment: .bottomLeading) {
                        TabView(selection: $currentImageIndex) {
                            ForEach(Array(event.imageNames.enumerated()), id: \.offset) { index, imageName in
                                Image(imageName)
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(height: 250)
                                    .clipped()
                                    .overlay(
                                        // Dark gradient overlay for text readability
                                        LinearGradient(
                                            gradient: Gradient(colors: [Color.clear, Color.black.opacity(0.6)]),
                                            startPoint: .top,
                                            endPoint: .bottom
                                        )
                                    )
                                    .tag(index)
                            }
                        }
                        .tabViewStyle(PageTabViewStyle())
                        .frame(height: 250)
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text(event.category.rawValue)
                                .font(.subheadline)
                                .fontWeight(.medium)
                                .padding(.horizontal, 12)
                                .padding(.vertical, 6)
                                .background(Color.white.opacity(0.2))
                                .clipShape(Capsule())
                                .foregroundColor(.white)
                            
                            Text(event.title)
                                .font(.largeTitle)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                        }
                        .padding(20)
                    }
                    .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
                    
                    // Image thumbnails (if multiple images)
                    if event.hasMultipleImages {
                        imageGalleryThumbnails
                    }
                    
                    VStack(alignment: .leading, spacing: 16) {
                        // Event details
                        detailRow(icon: "calendar", title: "Date & Time", value: event.formattedDate)
                        detailRow(icon: "location", title: "Location", value: event.location)
                        detailRow(icon: "person.2", title: "Expected Attendees", value: "\(event.attendeesCount) people")
                        detailRow(icon: "person.crop.circle", title: "Organizer", value: event.organizer)
                        
                        Divider()
                        
                        // Description
                        VStack(alignment: .leading, spacing: 8) {
                            Text("About This Event")
                                .font(.headline)
                                .fontWeight(.semibold)
                            
                            Text(event.description)
                                .font(.body)
                                .foregroundColor(.secondary)
                                .lineSpacing(4)
                        }
                        
                        Spacer(minLength: 20)
                        
                        // Action buttons
                        VStack(spacing: 12) {
                            Button(action: {}) {
                                HStack {
                                    Image(systemName: event.isUpcoming ? "calendar.badge.plus" : "checkmark.circle")
                                    Text(event.isUpcoming ? "Add to Calendar" : "Event Completed")
                                }
                                .font(.headline)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(event.isUpcoming ? Color.blue : Color.gray)
                                .clipShape(RoundedRectangle(cornerRadius: 12))
                            }
                            .disabled(!event.isUpcoming)
                            
                            if event.isUpcoming {
                                Button(action: {}) {
                                    HStack {
                                        Image(systemName: "bell")
                                        Text("Set Reminder")
                                    }
                                    .font(.subheadline)
                                    .foregroundColor(.blue)
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(Color.blue.opacity(0.1))
                                    .clipShape(RoundedRectangle(cornerRadius: 12))
                                }
                            }
                        }
                    }
                    .padding(.horizontal, 20)
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Close") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {}) {
                        Image(systemName: "square.and.arrow.up")
                    }
                }
            }
        }
    }
    
    private var imageGalleryThumbnails: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                ForEach(Array(event.imageNames.enumerated()), id: \.offset) { index, imageName in
                    Button(action: {
                        withAnimation(.easeInOut(duration: 0.3)) {
                            currentImageIndex = index
                        }
                    }) {
                        Image(imageName)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 60, height: 60)
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(currentImageIndex == index ? Color.blue : Color.clear, lineWidth: 2)
                            )
                            .scaleEffect(currentImageIndex == index ? 1.1 : 1.0)
                            .animation(.easeInOut(duration: 0.2), value: currentImageIndex)
                    }
                }
            }
            .padding(.horizontal, 20)
        }
    }
    
    private func detailRow(icon: String, title: String, value: String) -> some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.title3)
                .foregroundColor(.blue)
                .frame(width: 24)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.caption)
                    .foregroundColor(.secondary)
                Text(value)
                    .font(.subheadline)
                    .fontWeight(.medium)
            }
            
            Spacer()
        }
        .padding(.vertical, 4)
    }
}

// MARK: - Preview
#Preview {
    EventsView()
}
