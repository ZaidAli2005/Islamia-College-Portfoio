//
//  TeachersView.swift
//  Islamia College Portfolio
//
//  Created by Development on 17/06/2025.
//

import SwiftUI

struct TeachersView: View {
    @State private var searchText = ""
    @State private var selectedDepartment: Departments = .all
    @State private var teachers = Teacher.mockData
    
    var filteredTeachers: [Teacher] {
        var filtered = teachers
        
        if selectedDepartment != .all {
            filtered = filtered.filter { teacher in
                teacher.department.lowercased().contains(selectedDepartment.rawValue.lowercased())
            }
        }
        
        if !searchText.isEmpty {
            filtered = filtered.filter { teacher in
                teacher.name.lowercased().contains(searchText.lowercased()) ||
                teacher.department.lowercased().contains(searchText.lowercased())
            }
        }
        
        return filtered
    }
    
    @ViewBuilder
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Header
                HStack {
                    Spacer()
                    
                    Text("Faculty Directory")
                        .font(.system(size: 22, weight: .bold))
                        .foregroundColor(.primary)
                    
                    Spacer()
                }
                .padding(.horizontal, 16)
                .padding(.top, 10)
                .padding(.bottom, 20)
                
                // Search Bar
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.accentColor)
                        .font(.system(size: 16, weight: .medium))
                    
                    TextField("Search professors, departments...", text: $searchText)
                        .font(.system(size: 16))
                        .textFieldStyle(PlainTextFieldStyle())
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 14)
                .background(Color.white)
                .cornerRadius(25)
                .shadow(color: .black.opacity(0.08), radius: 4, x: 0, y: 2)
                .padding(.horizontal, 16)
                .padding(.bottom, 20)
                
                // Department Filter
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 12) {
                        ForEach(Departments.allCases, id: \.self) { department in
                            Button(action: {
                                withAnimation(.easeInOut(duration: 0.2)) {
                                    selectedDepartment = department
                                }
                            }) {
                                Text(department.rawValue)
                                    .font(.system(size: 15, weight: .medium))
                                    .padding(.horizontal, 18)
                                    .padding(.vertical, 10)
                                    .background(
                                        selectedDepartment == department
                                        ? .accentColor
                                        : Color(.systemGray5)
                                    )
                                    .foregroundColor(
                                        selectedDepartment == department
                                            ? .white
                                            : .primary
                                    )
                                    .cornerRadius(20)
                                    .scaleEffect(selectedDepartment == department ? 1.05 : 1.0)
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                    }
                    .padding(.horizontal, 16)
                }
                .padding(.bottom, 20)
                
                // Teachers List
                ScrollView {
                    LazyVStack(spacing: 12) {
                        ForEach(filteredTeachers) { teacher in
                            NavigationLink(destination: TeachersDetailView(teacher: teacher)) {
                                TeacherRowView(teacher: teacher)
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.bottom, 100)
                }
                
                Spacer()
            }
            .background(Color(.systemGroupedBackground))
            .navigationBarHidden(true)
        }
    }
}

struct TeacherRowView: View {
    let teacher: Teacher
    
    var body: some View {
        HStack(spacing: 16) {
            // Profile Image with fallback
            Group {
                if !teacher.imageName.isEmpty {
                    Image(teacher.imageName)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 60, height: 60)
                        .clipShape(Circle())
                } else {
                    Circle()
                        .fill(
                            LinearGradient(
                                colors: [.accentColor.opacity(0.8), .accentColor],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 60, height: 60)
                        .overlay(
                            Text(String(teacher.name.prefix(1)))
                                .font(.system(size: 24, weight: .semibold))
                                .foregroundColor(.white)
                        )
                }
            }
            .shadow(color: .black.opacity(0.1), radius: 2, x: 0, y: 1)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(teacher.name)
                    .font(.system(size: 17, weight: .semibold))
                    .foregroundColor(.primary)
                    .lineLimit(1)
                
                Text(teacher.department)
                    .font(.system(size: 15, weight: .medium))
                    .foregroundColor(.secondary)
                    .lineLimit(1)
                
                Text(teacher.designation)
                    .font(.system(size: 13, weight: .regular))
                    .foregroundColor(.secondary)
                    .lineLimit(1)
            }
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(.accentColor)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 16)
        .background(Color.white)
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.06), radius: 4, x: 0, y: 2)
    }
}

#Preview() {
    TeachersView()
}
