import SwiftUI

struct ClasssesDetailView: View {
    let department: Department
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                AsyncImage(url: URL(string: department.imageName)) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                } placeholder: {
                    Image(department.imageName)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                }
                .frame(height: 220)
                .clipped()
                .cornerRadius(16)
                .padding(.horizontal, 16)
                .padding(.top, 8)
                VStack(alignment: .leading, spacing: 28) {
                    Text(department.name)
                        .font(.system(size: 28, weight: .bold, design: .rounded))
                        .foregroundColor(.primary)
                        .padding(.horizontal, 20)
                        .padding(.top, 24)
                        .frame(maxWidth: .infinity, alignment: .center)
                    
                    if let headOfDepartment = department.headOfDepartment {
                        VStack(alignment: .leading, spacing: 16) {
                            Text("Head of Department")
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundColor(.secondary)
                                .textCase(.uppercase)
                                .tracking(0.5)
                                .padding(.horizontal, 20)
                            
                            HStack(spacing: 16) {
                                ZStack {
                                    Circle()
                                        .fill(
                                            LinearGradient(
                                                colors: [.accentColor.opacity(0.8), .accentColor],
                                                startPoint: .topLeading,
                                                endPoint: .bottomTrailing
                                            )
                                        )
                                        .frame(width: 50, height: 50)
                                    
                                    Image(systemName: "person.fill")
                                        .foregroundColor(.white)
                                        .font(.system(size: 20, weight: .medium))
                                }
                                
                                VStack(alignment: .leading, spacing: 4) {
                                    Text("Head of \(department.name.replacingOccurrences(of: "BS ", with: ""))")
                                        .font(.system(size: 14, weight: .medium))
                                        .foregroundColor(.secondary)
                                    
                                    Text(headOfDepartment)
                                        .font(.system(size: 17, weight: .semibold))
                                        .foregroundColor(.primary)
                                }
                                
                                Spacer()
                            }
                            .padding(.horizontal, 20)
                            .padding(.vertical, 20)
                            .background(
                                RoundedRectangle(cornerRadius: 16)
                                    .fill(.ultraThinMaterial)
                                    .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 2)
                            )
                            .padding(.horizontal, 20)
                        }
                    }
                    
                    if let description = department.description {
                        VStack(alignment: .leading, spacing: 12) {
                            Text("About Department")
                                .font(.system(size: 20, weight: .bold))
                                .foregroundColor(.primary)
                                .padding(.horizontal, 20)
                            
                            Text(description)
                                .font(.system(size: 16, weight: .regular))
                                .foregroundColor(.secondary)
                                .lineSpacing(8)
                                .padding(.horizontal, 20)
                        }
                    }
                    
                    if let teacherCount = department.teacherCount {
                        VStack(spacing: 16) {
                            HStack(spacing: 24) {
                                VStack(alignment: .leading, spacing: 8) {
                                    HStack(spacing: 8) {
                                        Image(systemName: "person.2.fill")
                                            .foregroundColor(.accentColor)
                                            .font(.system(size: 18))
                                        Text("Teachers")
                                            .font(.system(size: 14, weight: .medium))
                                            .foregroundColor(.secondary)
                                    }
                                    Text("\(teacherCount)")
                                        .font(.system(size: 32, weight: .bold, design: .rounded))
                                        .foregroundColor(.accentColor)
                                }
                                .frame(maxWidth: .infinity, alignment: .leading)
                                
                                Spacer()
                            }
                            
                            if let establishedYear = department.establishedYear {
                                HStack(spacing: 12) {
                                    ZStack {
                                        Circle()
                                            .fill(Color.orange.opacity(0.15))
                                            .frame(width: 36, height: 36)
                                        
                                        Image(systemName: "calendar")
                                            .foregroundColor(.orange)
                                            .font(.system(size: 16, weight: .medium))
                                    }
                                    
                                    Text("Established in \(establishedYear)")
                                        .font(.system(size: 16, weight: .medium))
                                        .foregroundColor(.primary)
                                    
                                    Spacer()
                                }
                            }
                        }
                        .padding(24)
                        .background(
                            RoundedRectangle(cornerRadius: 20)
                                .fill(.ultraThinMaterial)
                                .shadow(color: .black.opacity(0.05), radius: 10, x: 0, y: 4)
                        )
                        .padding(.horizontal, 20)
                    }
                    
                    if let facilities = department.facilities, !facilities.isEmpty {
                        VStack(alignment: .leading, spacing: 20) {
                            Text("Facilities")
                                .font(.system(size: 22, weight: .bold))
                                .foregroundColor(.primary)
                                .padding(.horizontal, 20)
                            
                            LazyVGrid(columns: [
                                GridItem(.flexible()),
                                GridItem(.flexible())
                            ], spacing: 12) {
                                ForEach(facilities, id: \.self) { facility in
                                    HStack(spacing: 12) {
                                        ZStack {
                                            Circle()
                                                .fill(Color.accentColor.opacity(0.15))
                                                .frame(width: 28, height: 28)
                                            
                                            Image(systemName: "checkmark")
                                                .foregroundColor(.accentColor)
                                                .font(.system(size: 12, weight: .bold))
                                        }
                                        
                                        Text(facility)
                                            .font(.system(size: 14, weight: .medium))
                                            .foregroundColor(.primary)
                                            .multilineTextAlignment(.leading)
                                        
                                        Spacer(minLength: 0)
                                    }
                                    .padding(.horizontal, 16)
                                    .padding(.vertical, 16)
                                    .background(
                                        RoundedRectangle(cornerRadius: 12)
                                            .fill(Color(.systemBackground))
                                            .shadow(color: .black.opacity(0.03), radius: 4, x: 0, y: 2)
                                    )
                                }
                            }
                            .padding(.horizontal, 20)
                        }
                    }
                    
                    if department.contactEmail != nil || department.contactPhone != nil {
                        VStack(alignment: .leading, spacing: 20) {
                            Text("Contact Information")
                                .font(.system(size: 22, weight: .bold))
                                .foregroundColor(.primary)
                                .padding(.horizontal, 20)
                            
                            VStack(spacing: 16) {
                                if let email = department.contactEmail {
                                    HStack(spacing: 16) {
                                        ZStack {
                                            Circle()
                                                .fill(Color.blue.opacity(0.15))
                                                .frame(width: 48, height: 48)
                                            
                                            Image(systemName: "envelope.fill")
                                                .foregroundColor(.blue)
                                                .font(.system(size: 18))
                                        }
                                        
                                        VStack(alignment: .leading, spacing: 2) {
                                            Text("Email Address")
                                                .font(.system(size: 12, weight: .medium))
                                                .foregroundColor(.secondary)
                                            
                                            Text(email)
                                                .font(.system(size: 16, weight: .medium))
                                                .foregroundColor(.primary)
                                        }
                                        
                                        Spacer()
                                    }
                                }
                                
                                if let phone = department.contactPhone {
                                    HStack(spacing: 16) {
                                        ZStack {
                                            Circle()
                                                .fill(Color.accentColor.opacity(0.15))
                                                .frame(width: 48, height: 48)
                                            
                                            Image(systemName: "phone.fill")
                                                .foregroundColor(.accentColor)
                                                .font(.system(size: 18))
                                        }
                                        
                                        VStack(alignment: .leading, spacing: 2) {
                                            Text("Phone Number")
                                                .font(.system(size: 12, weight: .medium))
                                                .foregroundColor(.secondary)
                                            
                                            Text(phone)
                                                .font(.system(size: 16, weight: .medium))
                                                .foregroundColor(.primary)
                                        }
                                        
                                        Spacer()
                                    }
                                }
                            }
                            .padding(24)
                            .background(
                                RoundedRectangle(cornerRadius: 20)
                                    .fill(.ultraThinMaterial)
                                    .shadow(color: .black.opacity(0.05), radius: 10, x: 0, y: 4)
                            )
                            .padding(.horizontal, 20)
                        }
                    }
                    
                    Spacer(minLength: 40)
                }
            }
        }
        .background(
            LinearGradient(
                colors: [
                    Color(.systemGroupedBackground),
                    Color(.systemGroupedBackground).opacity(0.8)
                ],
                startPoint: .top,
                endPoint: .bottom
            )
        )
        .navigationBarBackButtonHidden(true)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button(action: {
                    dismiss()
                }) {
                    HStack(spacing: 8) {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 22, weight: .semibold))
                    }
                    .foregroundColor(.accentColor)
                }
            }
        }
    }
}

#Preview {
    NavigationView {
        ClasssesDetailView(department: Department.sampleDepartments[0])
    }
}
