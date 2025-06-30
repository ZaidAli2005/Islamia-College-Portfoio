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
                .frame(height: 200)
                .clipped()
                .cornerRadius(20)
                .padding(.horizontal, 20)
                .padding(.top, 10)
                
                VStack(alignment: .leading, spacing: 24) {
                    Text(department.name)
                        .font(.system(size: 32, weight: .bold))
                        .foregroundColor(.primary)
                        .padding(.horizontal, 20)
                        .padding(.top, 30)
                        .frame(maxWidth: .infinity, alignment: .center)
                    if let headOfDepartment = department.headOfDepartment {
                        VStack(alignment: .leading, spacing: 16) {
                            Text("Head of Department")
                                .font(.system(size: 16, weight: .medium))
                                .foregroundColor(.secondary)
                                .padding(.horizontal, 20)
                            
                            HStack(spacing: 16) {
                                Circle()
                                    .fill(Color.green)
                                    .frame(width: 40, height: 40)
                                    .overlay(
                                        Image(systemName: "person.fill")
                                            .foregroundColor(.white)
                                            .font(.system(size: 18, weight: .medium))
                                    )
                                
                                VStack(alignment: .leading, spacing: 2) {
                                    Text("Hod of \(department.name.replacingOccurrences(of: "BS ", with: "")) is")
                                        .font(.system(size: 16, weight: .medium))
                                        .foregroundColor(.primary)
                                    
                                    Text(headOfDepartment)
                                        .font(.system(size: 16, weight: .semibold))
                                        .foregroundColor(.primary)
                                }
                                
                                Spacer()
                            }
                            .padding(.horizontal, 20)
                            .padding(.vertical, 20)
                            .background(
                                RoundedRectangle(cornerRadius: 16)
                                    .fill(Color(.white))
                            )
                            .padding(.horizontal, 20)
                        }
                    }
                    if let description = department.description {
                        Text(description)
                            .font(.system(size: 16, weight: .regular))
                            .foregroundColor(.secondary)
                            .lineSpacing(6)
                            .padding(.horizontal, 20)
                    }
                    if let studentCount = department.teacherCount {
                        VStack(spacing: 16) {
                            HStack(spacing: 20) {
                                if let teacherCount = department.teacherCount {
                                    VStack(alignment: .leading, spacing: 8) {
                                        HStack(spacing: 8) {
                                            Image(systemName: "person.fill")
                                                .foregroundColor(.green)
                                                .font(.system(size: 20))
                                            Text("Teachers")
                                                .font(.system(size: 14, weight: .medium))
                                                .foregroundColor(.secondary)
                                        }
                                        Text("\(teacherCount)")
                                            .font(.system(size: 24, weight: .bold))
                                            .foregroundColor(.green)
                                    }
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                }
                            }
                            if let establishedYear = department.establishedYear {
                                HStack(spacing: 8) {
                                    Image(systemName: "calendar")
                                        .foregroundColor(.orange)
                                        .font(.system(size: 20))
                                    Text("Established in \(establishedYear)")
                                        .font(.system(size: 16, weight: .medium))
                                        .foregroundColor(.primary)
                                    Spacer()
                                }
                            }
                        }
                        .padding(20)
                        .background(
                            RoundedRectangle(cornerRadius: 16)
                                .fill(Color(.systemBackground))
                        )
                        .padding(.horizontal, 20)
                    }
                    if let facilities = department.facilities, !facilities.isEmpty {
                        VStack(alignment: .leading, spacing: 16) {
                            Text("Facilities")
                                .font(.system(size: 20, weight: .bold))
                                .foregroundColor(.primary)
                                .padding(.horizontal, 20)
                            
                            VStack(spacing: 12) {
                                ForEach(facilities, id: \.self) { facility in
                                    HStack(spacing: 12) {
                                        Image(systemName: "checkmark.circle.fill")
                                            .foregroundColor(.green)
                                            .font(.system(size: 18))
                                        
                                        Text(facility)
                                            .font(.system(size: 16, weight: .medium))
                                            .foregroundColor(.primary)
                                        
                                        Spacer()
                                    }
                                    .padding(.horizontal, 16)
                                    .padding(.vertical, 12)
                                    .background(
                                        RoundedRectangle(cornerRadius: 12)
                                    )
                                }
                            }
                            .padding(.horizontal, 20)
                        }
                    }
                    if department.contactEmail != nil || department.contactPhone != nil {
                        VStack(alignment: .leading, spacing: 16) {
                            Text("Contact Information")
                                .font(.system(size: 20, weight: .bold))
                                .foregroundColor(.primary)
                                .padding(.horizontal, 20)
                            
                            VStack(spacing: 12) {
                                if let email = department.contactEmail {
                                    HStack(spacing: 16) {
                                        Circle()
                                            .frame(width: 40, height: 40)
                                            .overlay(
                                                Image(systemName: "envelope.fill")
                                                    .foregroundColor(.blue)
                                                    .font(.system(size: 16))
                                            )
                                        
                                        Text(email)
                                            .font(.system(size: 16, weight: .medium))
                                            .foregroundColor(.primary)
                                        
                                        Spacer()
                                    }
                                }
                                
                                if let phone = department.contactPhone {
                                    HStack(spacing: 16) {
                                        Circle()
                                            .fill(Color.green.opacity(0.2))
                                            .frame(width: 40, height: 40)
                                            .overlay(
                                                Image(systemName: "phone.fill")
                                                    .foregroundColor(.green)
                                                    .font(.system(size: 16))
                                            )
                                        
                                        Text(phone)
                                            .font(.system(size: 16, weight: .medium))
                                            .foregroundColor(.primary)
                                        
                                        Spacer()
                                    }
                                }
                            }
                            .padding(20)
                            .background(
                                RoundedRectangle(cornerRadius: 16)
                                    .fill(Color(.systemGray6))
                            )
                            .padding(.horizontal, 20)
                        }
                    }
                    Spacer(minLength: 100)
                }
            }
        }
        .background(Color(.systemGroupedBackground))
        .navigationBarBackButtonHidden(true)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button(action: {
                    dismiss()
                }) {
                    HStack(spacing: 6) {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 16, weight: .medium))
                        Text("Back")
                            .font(.system(size: 17, weight: .regular))
                    }
                    .foregroundColor(.green)
                }
            }
        }
    }
}

// MARK: - Preview
#Preview {
    NavigationView {
        ClasssesDetailView(department: Department.sampleDepartments[0])
    }
}
