import SwiftUI

struct FeeView: View {
    @State private var selectedSession = ""
    @State private var selectedDegree = "BS"
    @State private var selectedSemester = 1
    @State private var animateCards = false
    @State private var showDegreeSelection = false
    @State private var showDetails = false
    
    let sessions = ["Morning", "Evening"]
    let semesters = Array(1...8)
    
    var body: some View {
        NavigationView {
            ZStack {
                LinearGradient(
                    gradient: Gradient(colors: [
                        Color.accentColor.opacity(0.1),
                        Color.accentColor.opacity(0.1),
                        Color.accentColor.opacity(0.05)
                    ]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 25) {
                        headerSection
                        
                        if !showDegreeSelection {
                            sessionSelectionSection
                        } else {
                            selectionSection
                            if showDetails {
                                feeDetailsSection
                            }
                        }
                        
                        Spacer(minLength: 100)
                    }
                    .padding(.horizontal, 20)
                }
            }
            .onAppear {
                withAnimation(.spring(response: 0.8, dampingFraction: 0.8)) {
                    animateCards = true
                }
            }
        }
    }
    
    private var headerSection: some View {
        VStack(spacing: 15) {
            HStack {
                Image(systemName: "graduationcap.fill")
                    .font(.system(size: 30))
                    .foregroundColor(.accentColor)
                    .scaleEffect(animateCards ? 1.0 : 0.5)
                    .animation(.spring(response: 0.6, dampingFraction: 0.7).delay(0.1), value: animateCards)
                
                VStack(alignment: .leading, spacing: 5) {
                    Text("Islamia College")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.primary)
                    
                    Text("Fee Structure")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    
                    if !selectedSession.isEmpty {
                        Text("\(selectedSession) Session")
                            .font(.caption)
                            .foregroundColor(.accentColor)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 2)
                            .background(Color.secondary.opacity(0.1))
                            .cornerRadius(4)
                    }
                }
                
                Spacer()
                
                if showDegreeSelection {
                    Button(action: {
                        withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                            showDegreeSelection = false
                            showDetails = false
                            selectedSession = ""
                        }
                    }) {
                        Image(systemName: "arrow.left.circle.fill")
                            .font(.system(size: 24))
                            .foregroundColor(.secondary)
                    }
                }
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color(UIColor.systemBackground))
                    .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: 5)
            )
            .scaleEffect(animateCards ? 1.0 : 0.8)
            .opacity(animateCards ? 1.0 : 0.0)
            .animation(.spring(response: 0.8, dampingFraction: 0.8).delay(0.2), value: animateCards)
        }
    }
    
    private var sessionSelectionSection: some View {
        VStack(spacing: 20) {
            VStack(alignment: .leading, spacing: 15) {
                Text("Select Session")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.primary)
                
                Text("Choose your preferred session timing")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            
            VStack(spacing: 16) {
                ForEach(sessions, id: \.self) { session in
                    SessionCard(
                        session: session,
                        isSelected: selectedSession == session,
                        onTap: {
                            withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                                selectedSession = session
                                showDegreeSelection = true
                            }
                        }
                    )
                }
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(UIColor.systemBackground))
                .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: 5)
        )
        .scaleEffect(animateCards ? 1.0 : 0.8)
        .opacity(animateCards ? 1.0 : 0.0)
        .animation(.spring(response: 0.8, dampingFraction: 0.8).delay(0.4), value: animateCards)
    }
    
    private var selectionSection: some View {
        VStack(spacing: 20) {
            VStack(alignment: .leading, spacing: 15) {
                Text("Select Semester")
                    .font(.headline)
                    .foregroundColor(.primary)
                
                Text("Choose your current semester")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            
            VStack(spacing: 12) {
                ForEach(semesters, id: \.self) { semester in
                    SemesterListCard(
                        semester: semester,
                        isSelected: selectedSemester == semester,
                        onTap: {
                            withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                                selectedSemester = semester
                                showDetails = true
                            }
                        }
                    )
                }
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(UIColor.systemBackground))
                .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: 5)
        )
        .opacity(showDegreeSelection ? 1.0 : 0.0)
        .scaleEffect(showDegreeSelection ? 1.0 : 0.8)
        .animation(.spring(response: 0.8, dampingFraction: 0.8).delay(0.3), value: showDegreeSelection)
    }
    
    private var feeDetailsSection: some View {
        VStack(spacing: 15) {
            HStack {
                Text("Fee Details - \(selectedDegree) Semester \(selectedSemester)")
                    .font(.headline)
                    .foregroundColor(.primary)
                Spacer()
            }
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 1), spacing: 12) {
                FeeCard(
                    title: "Semester Fee",
                    amount: getFeeAmount(for: "semester"),
                    icon: "creditcard.fill",
                    color: .accentColor,
                    delay: 0.1
                )
                
                FeeCard(
                    title: "Exams Fee",
                    amount: getFeeAmount(for: "mid exam"),
                    icon: "creditcard.fill",
                    color: .accentColor,
                    delay: 0.2
                )
                
                TotalFeeCard(
                    totalAmount: getTotalFee(),
                    delay: 0.5
                )
            }
        }
        .opacity(showDetails ? 1.0 : 0.0)
        .scaleEffect(showDetails ? 1.0 : 0.8)
        .animation(.spring(response: 0.8, dampingFraction: 0.8).delay(0.2), value: showDetails)
    }
    
    private func getFeeAmount(for type: String) -> Int {
        let baseFees: [String: Int] = [
            "semester": 17000,
            "mid exam": 8500,
        ]
        
        let degreeMultiplier = selectedDegree == "BS" ? 1.0 : selectedDegree == "MS" ? 1.5 : 2.0
        let sessionMultiplier = selectedSession == "Evening" ? 1.2 : 1.0
        
        return Int(Double(baseFees[type] ?? 0) * degreeMultiplier * sessionMultiplier)
    }
    
    private func getTotalFee() -> Int {
        return getFeeAmount(for: "semester") + getFeeAmount(for: "mid exam")
    }
}

struct SemesterListCard: View {
    let semester: Int
    let isSelected: Bool
    let onTap: () -> Void
    
    @State private var animateCard = false
    
    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 20) {
                ZStack {
                    Circle()
                        .fill(isSelected ? Color.accentColor : Color.accentColor.opacity(0.1))
                        .frame(width: 50, height: 50)
                    
                    Text("\(semester)")
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(isSelected ? .white : .accentColor)
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    Text("Semester \(semester)")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(.primary)
                    
                    Text(getSemesterYear(semester: semester))
                        .font(.system(size: 14))
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                if isSelected {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.system(size: 20))
                        .foregroundColor(.accentColor)
                } else {
                    Image(systemName: "chevron.right")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(.secondary)
                }
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 16)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color(UIColor.systemBackground))
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(isSelected ? Color.accentColor : Color.clear, lineWidth: 2)
                    )
                    .shadow(color: .black.opacity(0.1), radius: 6, x: 0, y: 3)
            )
            .scaleEffect(isSelected ? 1.02 : 1.0)
        }
        .buttonStyle(PlainButtonStyle())
        .scaleEffect(animateCard ? 1.0 : 0.8)
        .opacity(animateCard ? 1.0 : 0.0)
        .onAppear {
            withAnimation(.spring(response: 0.6, dampingFraction: 0.8).delay(Double(semester) * 0.1)) {
                animateCard = true
            }
        }
    }
    
    private func getSemesterYear(semester: Int) -> String {
        switch semester {
        case 1, 2:
            return "1st Year"
        case 3, 4:
            return "2nd Year"
        case 5, 6:
            return "3rd Year"
        case 7, 8:
            return "4th Year"
        default:
            return "Year \((semester + 1) / 2)"
        }
    }
}

struct SessionCard: View {
    let session: String
    let isSelected: Bool
    let onTap: () -> Void
    
    @State private var animateCard = false
    
    var sessionIcon: String {
        session == "Morning" ? "sun.max.fill" : "moon.stars.fill"
    }
    
    var sessionTime: String {
        session == "Morning" ? "8:00 AM - 2:00 PM" : "2:30 PM - 8:30 PM"
    }
    
    var sessionColor: Color {
        session == "Morning" ? .accentColor : .accentColor
    }
    
    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 20) {
                VStack {
                    Image(systemName: sessionIcon)
                        .font(.system(size: 32))
                        .foregroundColor(sessionColor)
                        .frame(width: 60, height: 60)
                        .background(
                            Circle()
                                .fill(sessionColor.opacity(0.1))
                        )
                }
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("\(session) Session")
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(.primary)
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(sessionColor)
            }
            .padding(20)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color(UIColor.systemBackground))
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(sessionColor, lineWidth: isSelected ? 2 : 0)
                    )
                    .shadow(color: sessionColor.opacity(0.2), radius: 8, x: 0, y: 4)
            )
            .scaleEffect(isSelected ? 1.02 : 1.0)
        }
        .buttonStyle(PlainButtonStyle())
        .scaleEffect(animateCard ? 1.0 : 0.8)
        .opacity(animateCard ? 1.0 : 0.0)
        .onAppear {
            withAnimation(.spring(response: 0.6, dampingFraction: 0.8).delay(Double.random(in: 0.1...0.3))) {
                animateCard = true
            }
        }
    }
}

struct FeeCard: View {
    let title: String
    let amount: Int
    let icon: String
    let color: Color
    let delay: Double
    
    @State private var animateCard = false
    
    var body: some View {
        HStack(spacing: 15) {
            Image(systemName: icon)
                .font(.system(size: 24))
                .foregroundColor(color)
                .frame(width: 50, height: 50)
                .background(
                    Circle()
                        .fill(color.opacity(0.1))
                )
            
            VStack(alignment: .leading, spacing: 5) {
                Text(title)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.primary)
                
                Text("PKR \(amount.formatted())")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(color)
            }
            
            Spacer()
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(UIColor.systemBackground))
                .shadow(color: color.opacity(0.2), radius: 8, x: 0, y: 4)
        )
        .scaleEffect(animateCard ? 1.0 : 0.8)
        .opacity(animateCard ? 1.0 : 0.0)
        .onAppear {
            withAnimation(.spring(response: 0.6, dampingFraction: 0.8).delay(delay)) {
                animateCard = true
            }
        }
    }
}

struct TotalFeeCard: View {
    let totalAmount: Int
    let delay: Double
    
    @State private var animateCard = false
    
    var body: some View {
        HStack(spacing: 15) {
            Image(systemName: "creditcard.fill")
                .font(.system(size: 28))
                .foregroundColor(.white)
                .frame(width: 60, height: 60)
                .background(
                    Circle()
                        .fill(LinearGradient(colors: [.accentColor, .accentColor], startPoint: .topLeading, endPoint: .bottomTrailing))
                )
            
            VStack(alignment: .leading, spacing: 5) {
                Text("Total Fee Amount")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(.white)
                
                Text("PKR \(totalAmount.formatted())")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(.white)
            }
            
            Spacer()
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(LinearGradient(colors: [.accentColor, .accentColor], startPoint: .topLeading, endPoint: .bottomTrailing))
                .shadow(color: .accentColor.opacity(0.4), radius: 15, x: 0, y: 8)
        )
        .scaleEffect(animateCard ? 1.0 : 0.8)
        .opacity(animateCard ? 1.0 : 0.0)
        .onAppear {
            withAnimation(.spring(response: 0.6, dampingFraction: 0.8).delay(delay)) {
                animateCard = true
            }
        }
    }
}

#Preview {
    FeeView()
}
