import SwiftUI

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
    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                VStack(spacing: 20) {
                    HStack {
                        Circle()
                            .fill(Color.white.opacity(0.2))
                            .frame(width: 45, height: 45)
                            .overlay(
                                Image(systemName: "graduationcap.fill")
                                    .foregroundColor(.white)
                                    .font(.system(size: 20))
                            )
                        
                        Spacer()
                        
                        Circle()
                            .fill(Color.white.opacity(0.2))
                            .frame(width: 45, height: 45)
                            .overlay(
                                Image(systemName: "bell.fill")
                                    .foregroundColor(.white)
                                    .font(.system(size: 20))
                            )
                    }
                    .padding(.horizontal, 25)
                    .padding(.top, 80)
                    
                    HStack(spacing: 15) {
                        Circle()
                            .fill(Color.white)
                            .frame(width: 55, height: 55)
                            .overlay(
                                Circle()
                                    .fill(Color.green.opacity(0.8))
                                    .overlay(
                                        Image(systemName: "building.2.fill")
                                            .foregroundColor(.white)
                                            .font(.system(size: 18))
                                    )
                            )
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Welcome To!")
                                .font(.system(size: 28, weight: .bold))
                                .foregroundColor(.white)
                            
                            Text("Islamia College Gujranwala")
                                .font(.system(size: 16))
                                .foregroundColor(.white.opacity(0.9))
                        }
                        
                        Spacer()
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 60)
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
                VStack(spacing: 30) {
                    VStack(alignment: .leading, spacing: 30) {
                        Text("Dashboard")
                            .font(.system(size: 26, weight: .bold))
                            .foregroundColor(.black)
                            .padding(.horizontal, 20)
                            .padding(.top, 30)
                        
                        LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 15), count: 4), spacing: 25) {
                            NavigationLink(destination: ClassessView()) {
                                DashboardItem(icon: "grid.circle.fill", title: "Classes", iconColor: Color(red: 0.2, green: 0.4, blue: 0.8))
                            }
                            .buttonStyle(PlainButtonStyle())
                            
                            NavigationLink(destination: CanteenView()) {
                                DashboardItem(icon: "building.2.fill", title: "Canteen", iconColor: Color.orange)
                            }
                            .buttonStyle(PlainButtonStyle())
                            
                            NavigationLink(destination: PrincipalView()) {
                                DashboardItem(icon: "person.fill", title: "Principle", iconColor: Color(red: 0.3, green: 0.6, blue: 0.9))
                            }
                            .buttonStyle(PlainButtonStyle())
                            
                            NavigationLink(destination: TeachersView()) {
                                DashboardItem(icon: "person.2.fill", title: "Teachers", iconColor: Color.purple)
                            }
                            .buttonStyle(PlainButtonStyle())
                            
                            NavigationLink(destination: EventsView()) {
                                DashboardItem(icon: "trophy.fill", title: "Events", iconColor: Color.orange)
                            }
                            .buttonStyle(PlainButtonStyle())
                            
                            NavigationLink(destination: TimeTableView()) {
                                DashboardItem(icon: "clock.fill", title: "Time Table", iconColor: Color.purple)
                            }
                            .buttonStyle(PlainButtonStyle())
                            
                            NavigationLink(destination: LabsView()) {
                                DashboardItem(icon: "flask.fill", title: "Labs", iconColor: Color.teal)
                            }
                            .buttonStyle(PlainButtonStyle())
                            
                            NavigationLink(destination: AboutsView()) {
                                DashboardItem(icon: "info.circle.fill", title: "About", iconColor: Color(red: 0.4, green: 0.6, blue: 0.9))
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                        .padding(.horizontal, 20)
                    }
                    
                    VStack(alignment: .leading, spacing: 20) {
                        Text("More")
                            .font(.system(size: 24, weight: .bold))
                            .foregroundColor(.black)
                            .padding(.horizontal, 20)
                        
                        HStack(spacing: 12) {
                            NavigationLink(destination: LibraryView()) {
                                MoreItem(
                                    title: "Library",
                                    subtitle: "Study Resources",
                                    imageName: "library_image"
                                )
                            }
                            .buttonStyle(PlainButtonStyle())
                            
                            NavigationLink(destination: SportsView()) {
                                MoreItem(
                                    title: "Sports & Funs",
                                    subtitle: "All Sports",
                                    imageName: "sports_image"
                                )
                            }
                            .buttonStyle(PlainButtonStyle())
                            
                            NavigationLink(destination: ContactUsView()) {
                                MoreItem(
                                    title: "Parking",
                                    subtitle: "Parking Resources",
                                    imageName: "parking_image"
                                )
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                        .padding(.horizontal, 20)
                    }
                    
                    VStack(alignment: .leading, spacing: 20) {
                        Text("Recommended")
                            .font(.system(size: 24, weight: .bold))
                            .foregroundColor(.black)
                            .padding(.horizontal, 20)
                        
                        NavigationLink(destination: AdmissionsView()) {
                            HStack(spacing: 15) {
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(Color.gray.opacity(0.3))
                                    .frame(width: 60, height: 60)
                                    .overlay(
                                        Image(systemName: "doc.text.fill")
                                            .foregroundColor(.white)
                                            .font(.system(size: 20))
                                    )
                                
                                Text("Admissions")
                                    .font(.system(size: 18, weight: .semibold))
                                    .foregroundColor(.black)
                                
                                Spacer()
                            }
                            .padding(.horizontal, 20)
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                    
                    Spacer(minLength: 100)
                }
                .background(Color.white)
                .cornerRadius(25, corners: [.topLeft, .topRight])
                .offset(y: -25)
            }
        }
        .ignoresSafeArea(.all, edges: .top)
    }
}

struct CustomTabBar: View {
    @Binding var selectedTab: Int
    
    var body: some View {
        HStack {
            TabBarItem(
                icon: "house.fill",
                title: "Home",
                isSelected: selectedTab == 0
            ) {
                selectedTab = 0
            }
            
            TabBarItem(
                icon: "message.fill",
                title: "Chat",
                isSelected: selectedTab == 1
            ) {
                selectedTab = 1
            }
            
            TabBarItem(
                icon: "chart.bar.fill",
                title: "Activity",
                isSelected: selectedTab == 2
            ) {
                selectedTab = 2
            }
            
            TabBarItem(
                icon: "person.fill",
                title: "Profile",
                isSelected: selectedTab == 3
            ) {
                selectedTab = 3
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 15)
        .background(Color.white)
        .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: -5)
    }
}

struct DashboardItem: View {
    let icon: String
    let title: String
    let iconColor: Color
    
    var body: some View {
        VStack(spacing: 10) {
            Circle()
                .fill(Color.gray.opacity(0.1))
                .frame(width: 60, height: 60)
                .overlay(
                    Image(systemName: icon)
                        .foregroundColor(iconColor)
                        .font(.system(size: 24, weight: .medium))
                )
            
            Text(title)
                .font(.system(size: 13, weight: .medium))
                .foregroundColor(.black)
                .multilineTextAlignment(.center)
        }
    }
}

struct MoreItem: View {
    let title: String
    let subtitle: String
    let imageName: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            RoundedRectangle(cornerRadius: 12)
                .fill(getImageBackground())
                .frame(height: 100)
                .overlay(
                    getImageContent()
                )
            
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundColor(.black)
                
                Text(subtitle)
                    .font(.system(size: 12))
                    .foregroundColor(.gray)
            }
        }
        .frame(maxWidth: .infinity)
    }
    
    @ViewBuilder
    private func getImageContent() -> some View {
        switch imageName {
        case "library_image":
            VStack {
                HStack {
                    Rectangle()
                        .fill(Color.brown.opacity(0.6))
                        .frame(width: 8, height: 40)
                    Rectangle()
                        .fill(Color.red.opacity(0.6))
                        .frame(width: 8, height: 35)
                    Rectangle()
                        .fill(Color.blue.opacity(0.6))
                        .frame(width: 8, height: 38)
                    Rectangle()
                        .fill(Color.green.opacity(0.6))
                        .frame(width: 8, height: 42)
                    Spacer()
                }
                .padding(.leading, 20)
                Spacer()
            }
        case "sports_image":
            HStack {
                Circle()
                    .fill(Color.orange)
                    .frame(width: 20, height: 20)
                Circle()
                    .fill(Color.black)
                    .frame(width: 15, height: 15)
                Rectangle()
                    .fill(Color.brown)
                    .frame(width: 3, height: 25)
                Spacer()
            }
            .padding(.leading, 20)
            .padding(.top, 20)
        case "parking_image":
            RoundedRectangle(cornerRadius: 6)
                .fill(Color.blue)
                .frame(width: 40, height: 30)
                .overlay(
                    Text("P")
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(.white)
                )
        default:
            EmptyView()
        }
    }
    
    private func getImageBackground() -> Color {
        switch imageName {
        case "library_image":
            return Color(red: 0.9, green: 0.9, blue: 0.85)
        case "sports_image":
            return Color(red: 0.7, green: 0.7, blue: 0.7)
        case "parking_image":
            return Color(red: 0.85, green: 0.9, blue: 0.95)
        default:
            return Color.gray.opacity(0.3)
        }
    }
}

struct TabBarItem: View {
    let icon: String
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 6) {
                Image(systemName: icon)
                    .font(.system(size: 22))
                    .foregroundColor(isSelected ? .accentColor : .gray)
                
                Text(title)
                    .font(.system(size: 11))
                    .foregroundColor(isSelected ? .accentColor : .gray)
            }
            .frame(maxWidth: .infinity)
        }
    }
}

extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners))
    }
}

struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        )
        return Path(path.cgPath)
    }
}

#Preview {
    DashboardView()
}
