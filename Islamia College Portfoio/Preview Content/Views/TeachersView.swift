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
                HStack {
                    Spacer()
                    
                    Text("Faculty Directory")
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundColor(.black)
                    
                    Spacer()
                }
                .padding(.horizontal, 16)
                .padding(.top, 10)
                .padding(.bottom, 20)
                
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(Color.blue)
                        .font(.system(size: 16))
                    
                    TextField("Search professors, departments...", text: $searchText)
                        .font(.system(size: 16))
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 14)
                .background(Color.white)
                .cornerRadius(25)
                .shadow(color: .black.opacity(0.1), radius: 2, x: 0, y: 1)
                .padding(.horizontal, 16)
                .padding(.bottom, 20)
                
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 12) {
                        ForEach(Departments.allCases, id: \.self) { department in
                            Button(action: {
                                selectedDepartment = department
                            }) {
                                Text(department.rawValue)
                                    .font(.system(size: 16, weight: .medium))
                                    .padding(.horizontal, 20)
                                    .padding(.vertical, 10)
                                    .background(
                                        selectedDepartment == department
                                        ? .accentColor
                                            : Color(UIColor.systemGray5)
                                    )
                                    .foregroundColor(
                                        selectedDepartment == department
                                            ? .white
                                            : .primary
                                    )
                                    .cornerRadius(20)
                            }
                        }
                    }
                    .padding(.horizontal, 16)
                }
                .padding(.bottom, 20)
                
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
                }
                
                Spacer()
            }
            .background(Color(UIColor.systemGray6))
            .navigationBarHidden(true)
        }
    }
}

struct TeacherRowView: View {
    let teacher: Teacher
    
    var body: some View {
        HStack(spacing: 16) {
            Image(teacher.imageName)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 60, height: 60)
                .clipShape(Circle())
                .overlay(
                    Circle()
                        .fill(Color.blue.opacity(0.3))
                        .overlay(
                            Text(String(teacher.name.prefix(1)))
                                .font(.system(size: 20, weight: .medium))
                                .foregroundColor(.white)
                        )
                        .opacity(0)
                )
            
            VStack(alignment: .leading, spacing: 2) {
                Text(teacher.name)
                    .font(.system(size: 17, weight: .semibold))
                    .foregroundColor(.black)
                    .lineLimit(1)
                
                Text(teacher.department)
                    .font(.system(size: 15, weight: .regular))
                    .foregroundColor(.gray)
                    .lineLimit(1)
            }
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(.gray)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 16)
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.05), radius: 2, x: 0, y: 1)
    }
}

#Preview() {
    TeachersView()
}
