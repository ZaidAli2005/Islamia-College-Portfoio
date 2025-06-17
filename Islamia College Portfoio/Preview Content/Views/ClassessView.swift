//
//  ClassessView.swift
//  Islamia College Portfolio
//
//  Created by Development on 17/06/2025.
//

import SwiftUI

struct ClassessView: View {
    @State private var departments = Department.sampleDepartments
    private let stats = DepartmentStats.collegeStats
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    statsHeaderView
                    departmentsListView
                    
                    Spacer(minLength: 100)
                }
                .padding(.horizontal, 16)
                .padding(.top, 20)
            }
            .background(Color(.systemGroupedBackground))
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        // Handle back action
                    }) {
                        HStack(spacing: 5) {
                            Image(systemName: "chevron.left")
                                .font(.system(size: 16, weight: .medium))
                            Text("Back")
                                .font(.system(size: 17))
                        }
                        .foregroundColor(.blue)
                    }
                }
                
                ToolbarItem(placement: .principal) {
                    HStack {
                        Image(systemName: "graduationcap.fill")
                            .foregroundColor(.blue)
                            .font(.title2)
                        Text("Departments")
                            .font(.title2)
                            .fontWeight(.semibold)
                            .foregroundColor(.primary)
                    }
                }
            }
        }
    }
    
    // MARK: - Stats Header View
    private var statsHeaderView: some View {
        HStack {
            VStack {
                Image(systemName: "building.2")
                    .font(.title)
                    .foregroundColor(.blue)
                    .frame(height: 30)
                
                Text("\(stats.totalDepartments)")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.primary)
                
                Text("Total Depts")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            .frame(maxWidth: .infinity)
            
            Rectangle()
                .fill(Color.gray.opacity(0.3))
                .frame(width: 1, height: 60)
            VStack {
                Image(systemName: "person.3.fill")
                    .font(.title)
                    .foregroundColor(.blue)
                    .frame(height: 30)
                
                Text(stats.totalStudents)
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.primary)
                
                Text("Students")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            .frame(maxWidth: .infinity)
            Rectangle()
                .fill(Color.gray.opacity(0.3))
                .frame(width: 1, height: 60)
            VStack {
                Image(systemName: "person.fill")
                    .font(.title)
                    .foregroundColor(.blue)
                    .frame(height: 30)
                
                Text(stats.totalTeachers)
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.primary)
                
                Text("Teachers")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            .frame(maxWidth: .infinity)
        }
        .padding(.vertical, 20)
        .padding(.horizontal, 16)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(.systemBackground))
                .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 2)
        )
    }
    private var departmentsListView: some View {
        VStack(spacing: 12) {
            ForEach(departments) { department in
                departmentRowView(department: department)
            }
        }
    }
    
    private func departmentRowView(department: Department) -> some View {
        NavigationLink(destination: ClasssesDetailView(department: department)) {
            HStack(spacing: 16) {
                Image(department.imageName)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 60, height: 60)
                    .clipShape(Circle())
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(department.name)
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(.primary)
                        .multilineTextAlignment(.leading)
                    
                    if let studentCount = department.studentCount {
                        Text("\(studentCount) students")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.blue)
            }
            .padding(.vertical, 16)
            .padding(.horizontal, 20)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color(.systemBackground))
                    .shadow(color: .black.opacity(0.05), radius: 6, x: 0, y: 2)
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    ClassessView()
}
