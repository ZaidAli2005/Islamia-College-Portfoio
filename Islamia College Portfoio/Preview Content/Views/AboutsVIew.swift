//
//  AboutsView.swift
//  Islamia College Portfolio
//
//  Created by Development on 17/06/2025.
//

import SwiftUI

struct AboutsView: View {
    @State private var animateContent = false
    @State private var selectedTab = 0
    @State private var showStats = false
    @State private var currentImageIndex = 0
    
    let campusImages = ["50", "51", "52", "53"]
    let tabs = ["Overview", "History", "Academics", "Campus Life"]
    
    let collegeStats = [
        ("Founded", "1947"),
        ("Students", "25,000+"),
        ("Faculty", "500+"),
        ("Programs", "100+")
    ]
    
    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                GeometryReader { geometry in
                    ZStack {
                        LinearGradient(
                            colors: [
                                Color(red: 0.4, green: 0.6, blue: 0.8),
                                Color(red: 0.3, green: 0.5, blue: 0.7)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                        
                        ForEach(0..<6, id: \.self) { index in
                            Circle()
                                .fill(Color.white.opacity(0.1))
                                .frame(width: CGFloat.random(in: 50...150))
                                .position(
                                    x: CGFloat.random(in: 0...geometry.size.width),
                                    y: CGFloat.random(in: 0...geometry.size.height)
                                )
                                .scaleEffect(animateContent ? 1.2 : 0.8)
                                .animation(
                                    Animation.easeInOut(duration: 2.0 + Double(index) * 0.5)
                                        .repeatForever(autoreverses: true)
                                        .delay(Double(index) * 0.2),
                                    value: animateContent
                                )
                        }
                        
                        VStack(spacing: 20) {
                            ZStack {
                                Circle()
                                    .fill(Color.white.opacity(0.2))
                                    .frame(width: 120, height: 120)
                                
                                Image(systemName: "building.columns.fill")
                                    .font(.system(size: 50))
                                    .foregroundColor(.white)
                            }
                            .scaleEffect(animateContent ? 1.0 : 0.5)
                            .opacity(animateContent ? 1.0 : 0.0)
                            .animation(.spring(response: 0.8, dampingFraction: 0.6), value: animateContent)
                            
                            VStack(spacing: 8) {
                                Text("ISLAMIA COLLEGE")
                                    .font(.system(size: 32, weight: .bold, design: .serif))
                                    .foregroundColor(.white)
                                    .multilineTextAlignment(.center)
                                    .opacity(animateContent ? 1.0 : 0.0)
                                    .offset(y: animateContent ? 0 : 50)
                                    .animation(.easeOut(duration: 0.8).delay(0.3), value: animateContent)
                                
                                Text("Excellence in Education Since 1947")
                                    .font(.system(size: 16, weight: .medium))
                                    .foregroundColor(.white.opacity(0.9))
                                    .opacity(animateContent ? 1.0 : 0.0)
                                    .offset(y: animateContent ? 0 : 30)
                                    .animation(.easeOut(duration: 0.8).delay(0.5), value: animateContent)
                            }
                        }
                    }
                }
                .frame(height: 350)
                .clipped()
                LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 16) {
                    ForEach(Array(collegeStats.enumerated()), id: \.offset) { index, stat in
                        StatsCard(title: stat.0, value: stat.1, index: index, showStats: showStats)
                    }
                }
                .padding(.horizontal)
                .padding(.top, -50)
                .zIndex(1)
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 20) {
                        ForEach(Array(tabs.enumerated()), id: \.offset) { index, tab in
                            TabButton(
                                title: tab,
                                isSelected: selectedTab == index,
                                action: {
                                    withAnimation(.easeInOut(duration: 0.3)) {
                                        selectedTab = index
                                    }
                                }
                            )
                        }
                    }
                    .padding(.horizontal)
                }
                .padding(.top, 30)
                VStack(spacing: 30) {
                    Group {
                        switch selectedTab {
                        case 0:
                            OverviewContent()
                        case 1:
                            HistoryContent()
                        case 2:
                            AcademicsContent()
                        case 3:
                            CampusLifeContent()
                        default:
                            OverviewContent()
                        }
                    }
                    .transition(.asymmetric(
                        insertion: .move(edge: .trailing).combined(with: .opacity),
                        removal: .move(edge: .leading).combined(with: .opacity)
                    ))
                }
                .padding(.horizontal)
                .padding(.top, 20)
                ContactSection()
                    .padding(.top, 40)
            }
        }
        .ignoresSafeArea(edges: .top)
        .onAppear {
            withAnimation {
                animateContent = true
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                withAnimation(.easeOut(duration: 1.0)) {
                    showStats = true
                }
            }
        }
    }
}

struct StatsCard: View {
    let title: String
    let value: String
    let index: Int
    let showStats: Bool
    
    var body: some View {
        VStack(spacing: 8) {
            Text(value)
                .font(.system(size: 24, weight: .bold))
                .foregroundColor(.primary)
                .opacity(showStats ? 1.0 : 0.0)
                .scaleEffect(showStats ? 1.0 : 0.5)
                .animation(.spring(response: 0.6, dampingFraction: 0.8).delay(Double(index) * 0.1), value: showStats)
            
            Text(title)
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(.secondary)
                .opacity(showStats ? 1.0 : 0.0)
                .animation(.easeOut(duration: 0.5).delay(Double(index) * 0.1 + 0.2), value: showStats)
        }
        .frame(maxWidth: .infinity)
        .frame(height: 100)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(.systemBackground))
                .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: 5)
        )
        .offset(y: showStats ? 0 : 100)
        .animation(.spring(response: 0.8, dampingFraction: 0.7).delay(Double(index) * 0.1), value: showStats)
    }
}

struct TabButton: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 4) {
                Text(title)
                    .font(.system(size: 16, weight: isSelected ? .semibold : .medium))
                    .foregroundColor(isSelected ? .blue : .secondary)
                
                Rectangle()
                    .fill(Color.blue)
                    .frame(height: 2)
                    .opacity(isSelected ? 1.0 : 0.0)
                    .animation(.easeInOut(duration: 0.2), value: isSelected)
            }
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct OverviewContent: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            InfoCard(
                icon: "star.fill",
                title: "Our Mission",
                content: "To provide quality education that combines traditional Islamic values with modern academic excellence, preparing students for leadership roles in society."
            )
            
            InfoCard(
                icon: "eye.fill",
                title: "Our Vision",
                content: "To be a premier educational institution that bridges the gap between Islamic scholarship and contemporary knowledge, fostering intellectual growth and moral development."
            )
            
            InfoCard(
                icon: "heart.fill",
                title: "Our Values",
                content: "Excellence, Integrity, Innovation, Inclusivity, and Islamic principles guide everything we do in our pursuit of educational excellence."
            )
        }
    }
}

struct HistoryContent: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            InfoCard(
                icon: "calendar",
                title: "Foundation (1947)",
                content: "Islamia College was established in 1947 with the vision of providing quality education rooted in Islamic values while embracing modern academic standards."
            )
            
            InfoCard(
                icon: "building.2.fill",
                title: "Growth & Development",
                content: "Over the decades, the college has expanded from a small institution to a comprehensive educational complex with multiple faculties and thousands of students."
            )
            
            InfoCard(
                icon: "trophy.fill",
                title: "Achievements",
                content: "Recognized as one of the leading educational institutions in the region, with numerous awards for academic excellence and community service."
            )
        }
    }
}

struct AcademicsContent: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            InfoCard(
                icon: "graduationcap.fill",
                title: "Undergraduate Programs",
                content: "Bachelor's degrees in Arts, Science, Commerce, Islamic Studies, and various professional programs designed to meet modern career demands."
            )
            
            InfoCard(
                icon: "book.fill",
                title: "Graduate Programs",
                content: "Master's and doctoral programs in specialized fields, combining traditional scholarship with contemporary research methodologies."
            )
            
            InfoCard(
                icon: "person.3.fill",
                title: "Faculty Excellence",
                content: "Our distinguished faculty comprises renowned scholars and experts who bring both academic rigor and practical experience to the classroom."
            )
        }
    }
}

struct CampusLifeContent: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            InfoCard(
                icon: "house.fill",
                title: "Campus Facilities",
                content: "Modern libraries, laboratories, sports facilities, hostels, and recreational areas provide a comprehensive environment for student growth."
            )
            
            InfoCard(
                icon: "person.2.fill",
                title: "Student Activities",
                content: "Active student societies, cultural events, sports competitions, and community service programs enrich the college experience."
            )
            
            InfoCard(
                icon: "wifi",
                title: "Modern Amenities",
                content: "State-of-the-art technology infrastructure, digital learning resources, and modern facilities support contemporary educational needs."
            )
        }
    }
}

struct InfoCard: View {
    let icon: String
    let title: String
    let content: String
    @State private var isVisible = false
    
    var body: some View {
        HStack(alignment: .top, spacing: 16) {
            ZStack {
                Circle()
                    .fill(LinearGradient(
                        gradient: Gradient(colors: [Color.accentColor, Color.accentColor]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ))
                    .frame(width: 50, height: 50)
                
                Image(systemName: icon)
                    .font(.system(size: 20, weight: .medium))
                    .foregroundColor(.white)
            }
            .scaleEffect(isVisible ? 1.0 : 0.5)
            .animation(.spring(response: 0.6, dampingFraction: 0.7), value: isVisible)
            
            VStack(alignment: .leading, spacing: 8) {
                Text(title)
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(.primary)
                
                Text(content)
                    .font(.system(size: 15))
                    .foregroundColor(.secondary)
                    .lineLimit(nil)
                    .fixedSize(horizontal: false, vertical: true)
            }
            .opacity(isVisible ? 1.0 : 0.0)
            .offset(x: isVisible ? 0 : 30)
            .animation(.easeOut(duration: 0.6).delay(0.2), value: isVisible)
            
            Spacer()
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(.systemBackground))
                .shadow(color: .black.opacity(0.08), radius: 8, x: 0, y: 4)
        )
        .onAppear {
            withAnimation {
                isVisible = true
            }
        }
    }
}

struct ContactSection: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 24) {
            HStack(spacing: 12) {
                ZStack {
                    Circle()
                        .fill(Color.green)
                        .frame(width: 36, height: 36)
                    
                    Image(systemName: "phone.fill")
                        .font(.system(size: 18))
                        .foregroundColor(.white)
                }
                
                Text("Contact Us")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(.primary)
                
                Spacer()
            }
            
            VStack(spacing: 20) {
                ContactItem(
                    icon: "phone.fill",
                    iconColor: .blue,
                    title: "Phone",
                    value: "+92 55 4223484"
                )
                ContactItem(
                    icon: "envelope.fill",
                    iconColor: .cyan,
                    title: "Email",
                    value: "info@gicg.edu.pk"
                )
                ContactItem(
                    icon: "globe",
                    iconColor: .blue,
                    title: "Website",
                    value: "gicg.edu.pk"
                )
                ContactItem(
                    icon: "location.fill",
                    iconColor: .cyan,
                    title: "Address",
                    value: "557C+FVF, Islamia College Rd,\nGujranwala, Punjab"
                )
                ContactItem(
                    icon: "clock.fill",
                    iconColor: .cyan,
                    title: "Office Hours",
                    value: "Mon-Fri: 8:00 AM - 4:00 PM"
                )
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 30)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color(.systemBackground))
                .shadow(color: .black.opacity(0.05), radius: 10, x: 0, y: 5)
        )
        .padding(.horizontal)
    }
}

struct ContactItem: View {
    let icon: String
    let iconColor: Color
    let title: String
    let value: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(spacing: 12) {
                Image(systemName: icon)
                    .font(.system(size: 18))
                    .foregroundColor(iconColor)
                    .frame(width: 24, height: 24)
                
                Text(title)
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.secondary)
                
                Spacer()
            }
            
            Text(value)
                .font(.system(size: 18, weight: .medium))
                .foregroundColor(.primary)
                .lineLimit(nil)
                .multilineTextAlignment(.leading)
                .padding(.leading, 36)
        }
    }
}

#Preview {
    AboutsView()
}
