//
//  ClassessView.swift
//  Islamia College Portfolio
//
//  Created by Development on 17/06/2025.
//

import SwiftUI

struct ClassessView: View {
    @State private var departments = Department.sampleDepartments
    @State private var animateStats = false
    @State private var animateDepartments = false
    @State private var selectedDepartment: Department?
    
    private let stats = DepartmentStats.collegeStats
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    statsHeaderView
                        .scaleEffect(animateStats ? 1.0 : 0.8)
                        .opacity(animateStats ? 1.0 : 0.0)
                        .animation(.spring(response: 0.8, dampingFraction: 0.8), value: animateStats)
                    
                    departmentsListView
                        .offset(y: animateDepartments ? 0 : 50)
                        .opacity(animateDepartments ? 1.0 : 0.0)
                        .animation(.spring(response: 1.0, dampingFraction: 0.7).delay(0.3), value: animateDepartments)
                    
                    Spacer(minLength: 100)
                }
                .padding(.horizontal, 20)
                .padding(.top, 20)
            }
            .background(
                LinearGradient(
                    gradient: Gradient(colors: [
                        Color(.systemGroupedBackground),
                        Color(.systemBackground).opacity(0.8)
                    ]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        // Handle back action with haptic feedback
                        let impactFeedback = UIImpactFeedbackGenerator(style: .light)
                        impactFeedback.impactOccurred()
                    }) {
                        HStack(spacing: 6) {
                            Image(systemName: "chevron.left")
                                .font(.system(size: 16, weight: .semibold))
                            Text("Back")
                                .font(.system(size: 17, weight: .medium))
                        }
                        .foregroundStyle(
                            LinearGradient(
                                colors: [.blue, .cyan],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                    }
                    .buttonStyle(ScaleButtonStyle())
                }
                
                ToolbarItem(placement: .principal) {
                    HStack(spacing: 8) {
                        Image(systemName: "graduationcap.fill")
                            .foregroundStyle(
                                LinearGradient(
                                    colors: [.blue, .purple],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .font(.title2)
                            .symbolEffect(.bounce, value: animateStats)
                        
                        Text("Departments")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundStyle(
                                LinearGradient(
                                    colors: [.primary, .secondary],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                    }
                }
            }
        }
        .onAppear {
            withAnimation {
                animateStats = true
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                withAnimation {
                    animateDepartments = true
                }
            }
        }
    }
    
    // MARK: - Stats Header View
    private var statsHeaderView: some View {
        HStack(spacing: 0) {
            statCard(
                icon: "building.2",
                value: "\(stats.totalDepartments)",
                label: "Total Depts",
                color: .blue,
                delay: 0.1
            )
            
            Divider()
                .frame(height: 60)
                .background(
                    LinearGradient(
                        colors: [.clear, .gray.opacity(0.3), .clear],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
            
            statCard(
                icon: "person.3.fill",
                value: stats.totalStudents,
                label: "Students",
                color: .green,
                delay: 0.2
            )
            
            Divider()
                .frame(height: 60)
                .background(
                    LinearGradient(
                        colors: [.clear, .gray.opacity(0.3), .clear],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
            
            statCard(
                icon: "person.fill",
                value: stats.totalTeachers,
                label: "Teachers",
                color: .orange,
                delay: 0.3
            )
        }
        .padding(.vertical, 24)
        .padding(.horizontal, 20)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(
                    LinearGradient(
                        gradient: Gradient(stops: [
                            .init(color: Color(.systemBackground), location: 0.0),
                            .init(color: Color(.systemBackground).opacity(0.95), location: 1.0)
                        ]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(
                            LinearGradient(
                                colors: [.blue.opacity(0.2), .purple.opacity(0.1)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: 1
                        )
                )
                .shadow(color: .black.opacity(0.08), radius: 12, x: 0, y: 4)
                .shadow(color: .blue.opacity(0.1), radius: 20, x: 0, y: 8)
        )
    }
    
    private func statCard(icon: String, value: String, label: String, color: Color, delay: Double) -> some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.title)
                .foregroundStyle(
                    LinearGradient(
                        colors: [color, color.opacity(0.7)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .frame(height: 32)
                .symbolEffect(.pulse, options: .repeat(.continuous).speed(0.5))
            
            Text(value)
                .font(.title.bold())
                .foregroundColor(.primary)
                .contentTransition(.numericText())
            
            Text(label)
                .font(.caption.weight(.medium))
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity)
        .scaleEffect(animateStats ? 1.0 : 0.5)
        .opacity(animateStats ? 1.0 : 0.0)
        .animation(.spring(response: 0.6, dampingFraction: 0.8).delay(delay), value: animateStats)
    }
    
    private var departmentsListView: some View {
        LazyVStack(spacing: 16) {
            ForEach(Array(departments.enumerated()), id: \.element.id) { index, department in
                departmentRowView(department: department, index: index)
                    .onTapGesture {
                        selectedDepartment = department
                        let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
                        impactFeedback.impactOccurred()
                    }
            }
        }
    }
    
    private func departmentRowView(department: Department, index: Int) -> some View {
        NavigationLink(destination: ClasssesDetailView(department: department)) {
            HStack(spacing: 16) {
                // Department Image with enhanced styling
                Image(department.imageName)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 70, height: 70)
                    .clipShape(Circle())
                    .overlay(
                        Circle()
                            .stroke(
                                LinearGradient(
                                    colors: [.blue.opacity(0.3), .purple.opacity(0.2)],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ),
                                lineWidth: 2
                            )
                    )
                    .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)
                    .scaleEffect(selectedDepartment?.id == department.id ? 1.1 : 1.0)
                    .animation(.spring(response: 0.3, dampingFraction: 0.7), value: selectedDepartment?.id)
                
                VStack(alignment: .leading, spacing: 6) {
                    Text(department.name)
                        .font(.system(size: 18, weight: .bold))
                        .foregroundStyle(
                            LinearGradient(
                                colors: [.primary, .primary.opacity(0.8)],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .multilineTextAlignment(.leading)
                    
                    if let studentCount = department.studentCount {
                        HStack(spacing: 4) {
                            Image(systemName: "person.2.fill")
                                .font(.caption)
                                .foregroundColor(.blue)
                            
                            Text("\(studentCount) students")
                                .font(.caption.weight(.medium))
                                .foregroundColor(.secondary)
                        }
                    }
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundStyle(
                        LinearGradient(
                            colors: [.blue, .cyan],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .rotationEffect(.degrees(selectedDepartment?.id == department.id ? 90 : 0))
                    .animation(.spring(response: 0.3), value: selectedDepartment?.id)
            }
            .padding(.vertical, 20)
            .padding(.horizontal, 24)
            .background(
                RoundedRectangle(cornerRadius: 18)
                    .fill(
                        LinearGradient(
                            gradient: Gradient(stops: [
                                .init(color: Color(.systemBackground), location: 0.0),
                                .init(color: Color(.systemBackground).opacity(0.98), location: 1.0)
                            ]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 18)
                            .stroke(
                                LinearGradient(
                                    colors: selectedDepartment?.id == department.id ?
                                        [.blue.opacity(0.4), .purple.opacity(0.3)] :
                                        [.gray.opacity(0.1), .clear],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ),
                                lineWidth: selectedDepartment?.id == department.id ? 1.5 : 0.5
                            )
                    )
                    .shadow(
                        color: selectedDepartment?.id == department.id ?
                            .blue.opacity(0.2) : .black.opacity(0.06),
                        radius: selectedDepartment?.id == department.id ? 16 : 8,
                        x: 0,
                        y: selectedDepartment?.id == department.id ? 6 : 3
                    )
                    .scaleEffect(selectedDepartment?.id == department.id ? 1.02 : 1.0)
                    .animation(.spring(response: 0.4, dampingFraction: 0.8), value: selectedDepartment?.id)
            )
        }
        .buttonStyle(PlainButtonStyle())
        .offset(x: animateDepartments ? 0 : 100)
        .opacity(animateDepartments ? 1.0 : 0.0)
        .animation(
            .spring(response: 0.8, dampingFraction: 0.8)
                .delay(0.5 + Double(index) * 0.1),
            value: animateDepartments
        )
        .onTapGesture {
            withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                selectedDepartment = selectedDepartment?.id == department.id ? nil : department
            }
            
            // Reset selection after a delay
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                    selectedDepartment = nil
                }
            }
        }
    }
}

// MARK: - Custom Button Style
struct ScaleButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
            .opacity(configuration.isPressed ? 0.8 : 1.0)
            .animation(.easeInOut(duration: 0.1), value: configuration.isPressed)
    }
}

#Preview {
    ClassessView()
}
