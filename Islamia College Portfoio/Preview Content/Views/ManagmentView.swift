//
//  ManagementView.swift
//  Islamia College Portfolio
//
//  Created by Development on 30/06/2025.
//

import SwiftUI

// MARK: - Data Models
struct ManagementPerson {
    let id = UUID()
    let name: String
    let position: String
    let department: String
    let email: String
    let phone: String
    let experience: String
    let qualification: String
    let imageName: String
    let description: String
}

struct ManagementView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var searchText = ""
    @State private var selectedDepartment = "All"
    
    let departments = ["All", "Administration", "Academic", "Finance", "Student Affairs", "IT"]
    
    let managementTeam: [ManagementPerson] = [
        ManagementPerson(
            name: "Dr. Muhammad Ahmad",
            position: "Principal",
            department: "Administration",
            email: "principal@islamiacollege.edu",
            phone: "+92-300-1234567",
            experience: "15 years",
            qualification: "Ph.D. in Education",
            imageName: "Usman",
            description: "Leading the college with vision and dedication to academic excellence."
        ),
        ManagementPerson(
            name: "Prof. Sarah Khan",
            position: "Vice Principal",
            department: "Academic",
            email: "vp.academic@islamiacollege.edu",
            phone: "+92-300-2345678",
            experience: "12 years",
            qualification: "M.Phil. Computer Science",
            imageName: "vice_principal_image",
            description: "Overseeing academic programs and curriculum development."
        ),
        ManagementPerson(
            name: "Mr. Ali Hassan",
            position: "Finance Director",
            department: "Finance",
            email: "finance@islamiacollege.edu",
            phone: "+92-300-3456789",
            experience: "10 years",
            qualification: "MBA Finance",
            imageName: "finance_director_image",
            description: "Managing financial operations and budget planning."
        ),
        ManagementPerson(
            name: "Ms. Fatima Malik",
            position: "Student Affairs Officer",
            department: "Student Affairs",
            email: "studentaffairs@islamiacollege.edu",
            phone: "+92-300-4567890",
            experience: "8 years",
            qualification: "M.A. Psychology",
            imageName: "student_affairs_image",
            description: "Supporting student welfare and extracurricular activities."
        ),
        ManagementPerson(
            name: "Mr. Usman Sheikh",
            position: "IT Manager",
            department: "IT",
            email: "it@islamiacollege.edu",
            phone: "+92-300-5678901",
            experience: "6 years",
            qualification: "MS Computer Science",
            imageName: "it_manager_image",
            description: "Managing IT infrastructure and digital systems."
        )
    ]
    
    var filteredManagement: [ManagementPerson] {
        let departmentFiltered = selectedDepartment == "All" ?
            managementTeam :
            managementTeam.filter { $0.department == selectedDepartment }
        
        if searchText.isEmpty {
            return departmentFiltered
        } else {
            return departmentFiltered.filter { person in
                person.name.localizedCaseInsensitiveContains(searchText) ||
                person.position.localizedCaseInsensitiveContains(searchText) ||
                person.department.localizedCaseInsensitiveContains(searchText)
            }
        }
    }
    
    var body: some View {
        VStack(spacing: 0) {
            customHeader
            VStack(spacing: 20) {
                searchBar
                departmentFilter
                managementList
            }
            .padding(.horizontal, 16)
            .padding(.top, 20)
        }
        .background(
            LinearGradient(
                gradient: Gradient(colors: [Color.accentColor.opacity(0.1), Color.accentColor.opacity(0.1)]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        .navigationBarHidden(true)
    }
    
    private var customHeader: some View {
        VStack(spacing: 0) {
            HStack {
                Button(action: {
                    dismiss()
                }) {
                    Image(systemName: "chevron.left")
                        .font(.title2)
                        .fontWeight(.medium)
                        .foregroundColor(.primary)
                }
                
                Spacer()
            }
            .padding(.horizontal, 16)
            .padding(.top, 8)
        }
        .background(Color(.systemBackground))
    }
    
    private var searchBar: some View {
        HStack(spacing: 12) {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.gray)
                .font(.system(size: 16))
            
            TextField("Search management...", text: $searchText)
                .font(.system(size: 16))
            
            if !searchText.isEmpty {
                Button(action: {
                    searchText = ""
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.gray)
                        .font(.system(size: 16))
                }
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
    
    private var departmentFilter: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                ForEach(departments, id: \.self) { department in
                    Button(action: {
                        withAnimation(.easeInOut(duration: 0.2)) {
                            selectedDepartment = department
                        }
                    }) {
                        Text(department)
                            .font(.system(size: 14, weight: .medium))
                            .padding(.horizontal, 16)
                            .padding(.vertical, 8)
                            .background(
                                selectedDepartment == department ?
                                Color.accentColor : Color(.systemGray6)
                            )
                            .foregroundColor(
                                selectedDepartment == department ?
                                .white : .primary
                            )
                            .cornerRadius(20)
                    }
                }
            }
            .padding(.horizontal, 16)
        }
    }
    
    private var managementList: some View {
        ScrollView(showsIndicators: false) {
            LazyVStack(spacing: 12) {
                ForEach(filteredManagement, id: \.id) { person in
                    NavigationLink(destination: ManagementDetailView(person: person)) {
                        ManagementCard(person: person)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
        }
    }
}

struct ManagementCard: View {
    let person: ManagementPerson
    
    var body: some View {
        HStack(spacing: 16) {
            AsyncImage(url: nil) { _ in
                Image(person.imageName)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 56, height: 56)
                    .clipShape(Circle())
                    .overlay(
                        Circle()
                            .stroke(Color.accentColor.opacity(0.3), lineWidth: 2)
                    )
            } placeholder: {
                ZStack {
                    Circle()
                        .fill(
                            LinearGradient(
                                gradient: Gradient(colors: [Color.accentColor.opacity(0.8), Color.accentColor]),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 56, height: 56)
                    
                    Text(String(person.name.prefix(1)))
                        .font(.system(size: 24, weight: .semibold))
                        .foregroundColor(.white)
                }
            }
            
            VStack(alignment: .leading, spacing: 6) {
                Text(person.name)
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(.primary)
                    .lineLimit(1)
                
                Text(person.position)
                    .font(.system(size: 15, weight: .medium))
                    .foregroundColor(.accentColor)
                    .lineLimit(1)
                
                HStack(spacing: 8) {
                    HStack(spacing: 4) {
                        Image(systemName: "building.2")
                            .font(.system(size: 12))
                            .foregroundColor(.secondary)
                        
                        Text(person.department)
                            .font(.system(size: 13))
                            .foregroundColor(.secondary)
                    }
                    
                    Text("•")
                        .font(.system(size: 13))
                        .foregroundColor(.secondary)
                    
                    HStack(spacing: 4) {
                        Image(systemName: "clock")
                            .font(.system(size: 12))
                            .foregroundColor(.secondary)
                        
                        Text(person.experience)
                            .font(.system(size: 13))
                            .foregroundColor(.secondary)
                    }
                }
            }
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(.gray)
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(.systemBackground))
                .shadow(
                    color: Color.black.opacity(0.04),
                    radius: 8,
                    x: 0,
                    y: 2
                )
        )
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color(.systemGray5), lineWidth: 0.5)
        )
    }
}

struct ManagementDetailView: View {
    @Environment(\.dismiss) private var dismiss
    let person: ManagementPerson
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 24) {
                VStack(spacing: 20) {
                    AsyncImage(url: nil) { _ in
                        Image(person.imageName)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 100, height: 100)
                            .clipShape(Circle())
                            .overlay(
                                Circle()
                                    .stroke(Color.accentColor.opacity(0.3), lineWidth: 3)
                            )
                    } placeholder: {
                        ZStack {
                            Circle()
                                .fill(
                                    LinearGradient(
                                        gradient: Gradient(colors: [Color.accentColor.opacity(0.8), Color.accentColor]),
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                                .frame(width: 100, height: 100)
                            
                            Text(String(person.name.prefix(1)))
                                .font(.system(size: 40, weight: .semibold))
                                .foregroundColor(.white)
                        }
                    }
                    
                    VStack(spacing: 8) {
                        Text(person.name)
                            .font(.title2)
                            .fontWeight(.bold)
                            .multilineTextAlignment(.center)
                        
                        Text(person.position)
                            .font(.title3)
                            .fontWeight(.medium)
                            .foregroundColor(.accentColor)
                        
                        Text(person.department)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                }
                .padding(.top, 20)
                
                VStack(alignment: .leading, spacing: 16) {
                    Text("About")
                        .font(.headline)
                        .fontWeight(.semibold)
                    
                    Text(person.description)
                        .font(.body)
                        .foregroundColor(.secondary)
                        .lineSpacing(4)
                }
                .padding(20)
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(Color(.systemGray6))
                )
                
                VStack(alignment: .leading, spacing: 20) {
                    Text("Contact Information")
                        .font(.headline)
                        .fontWeight(.semibold)
                    
                    VStack(spacing: 16) {
                        ContactRow(icon: "envelope.fill", title: "Email", value: person.email, color: .orange)
                        ContactRow(icon: "phone.fill", title: "Phone", value: person.phone, color: .green)
                        ContactRow(icon: "graduationcap.fill", title: "Qualification", value: person.qualification, color: .purple)
                        ContactRow(icon: "clock.fill", title: "Experience", value: person.experience, color: .accentColor)
                    }
                }
                .padding(20)
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(Color(.systemGray6))
                )
                
                Spacer(minLength: 40)
            }
            .padding(.horizontal, 16)
        }
        .background(
            LinearGradient(
                gradient: Gradient(colors: [Color.accentColor.opacity(0.1), Color.accentColor.opacity(0.1)]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    dismiss()
                }) {
                    Image(systemName: "chevron.left")
                        .font(.title2)
                        .fontWeight(.medium)
                        .foregroundColor(.primary)
                }
            }
        }
    }
}

struct ContactRow: View {
    let icon: String
    let title: String
    let value: String
    let color: Color
    
    var body: some View {
        HStack(spacing: 16) {
            ZStack {
                Circle()
                    .fill(color.opacity(0.1))
                    .frame(width: 40, height: 40)
                
                Image(systemName: icon)
                    .foregroundColor(color)
                    .font(.system(size: 16))
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .fontWeight(.medium)
                
                Text(value)
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundColor(.primary)
            }
            
            Spacer()
        }
    }
}

#Preview {
    NavigationView {
        ManagementView()
    }
}
