import SwiftUI

struct AdmissionsView: View {
    @State private var showIntermediateDetails = false
    @State private var showGraduationDetails = false
    
    let programColors: [Color] = [
        .accentColor.opacity(0.1), .accentColor.opacity(0.1), .accentColor.opacity(0.1), .accentColor.opacity(0.1), .accentColor.opacity(0.1),
        .accentColor.opacity(0.1), .accentColor.opacity(0.1), .accentColor.opacity(0.1), .accentColor.opacity(0.1)
    ]
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    headerView
                    AdmissionCard(
                        title: "Intermediate (11th & 12th)",
                        duration: "2 Years",
                        isExpanded: $showIntermediateDetails,
                        color: .accentColor
                    ) {
                        intermediateDetailsView
                    }
                    .padding(.horizontal)
                    AdmissionCard(
                        title: "Graduation Admission",
                        duration: "Bachelor's Degree Programs • 4 Years",
                        isExpanded: $showGraduationDetails,
                        color: .accentColor
                    ) {
                        graduationDetailsView
                    }
                    .padding(.horizontal)
                    DocumentsSection()
                        .padding(.horizontal)
                    NavigationLink(destination: AdmissionPortalForm()) {
                        HStack {
                            Image(systemName: "paperplane.fill")
                                .font(.title3)
                            Text("Submit Online Application")
                                .font(.headline)
                                .fontWeight(.semibold)
                        }
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(
                            LinearGradient(
                                gradient: Gradient(colors: [Color.accentColor, Color.accentColor.opacity(0.8)]),
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .cornerRadius(12)
                        .shadow(color: Color.accentColor.opacity(0.4), radius: 8, x: 0, y: 4)
                    }
                    .padding(.horizontal)
                    .padding(.top, 10)
                }
                .padding(.vertical)
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {}) {
                        HStack {
                            Text("")
                        }
                    }
                }
                ToolbarItem(placement: .principal) {
                    Text("Admission Portal")
                        .font(.headline)
                        .bold()
                }
            }
        }
    }
    
    private var headerView: some View {
        VStack {
            Text("Admissions Criteria")
                .font(.title)
                .bold()
                .foregroundColor(.white)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(LinearGradient(gradient: Gradient(colors: [Color.accentColor, Color.accentColor.opacity(0.8)]),
                                   startPoint: .top,
                                   endPoint: .bottom))
        .cornerRadius(12)
        .shadow(color: Color.accentColor.opacity(0.4), radius: 8, x: 0, y: 4)
        .padding(.horizontal)
    }
    
    private var intermediateDetailsView: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Requirements:")
                .font(.headline)
                .foregroundColor(.accentColor)
            
            ForEach(intermediateRequirements, id: \.self) { req in
                RequirementItem(text: req)
            }
            
            Divider()
                .padding(.vertical, 8)
            
            VStack(alignment: .leading, spacing: 12) {
                ProgramItem(title: "Pre-Engineering", subjects: "Physics, Chemistry, Mathematics")
                ProgramItem(title: "Pre-Medical", subjects: "Physics, Chemistry, Biology")
                ProgramItem(title: "ICS", subjects: "Physics, Stats")
            }
        }
    }
    
    private var graduationDetailsView: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Requirements:")
                .font(.headline)
                .foregroundColor(.accentColor)
            
            ForEach(graduationRequirements, id: \.self) { req in
                RequirementItem(text: req)
            }
            
            Divider()
                .padding(.vertical, 8)
            
            VStack(alignment: .leading, spacing: 12) {
                Text("Available Programs:")
                    .font(.headline)
                    .foregroundColor(.accentColor)
                
                LazyVGrid(columns: [GridItem(.adaptive(minimum: 160), spacing: 12), GridItem(.adaptive(minimum: 160))], spacing: 12) {
                    ForEach(Array(zip(graduationPrograms.indices, graduationPrograms)), id: \.0) { index, program in
                        ProgramCardView(name: program, color: .accentColor)
                    }
                }
            }
        }
    }
    
    private let intermediateRequirements = [
        "Matric/O-Level Certificate",
        "Minimum 60% marks in Matric",
        "Merit-based admission",
        "No Entry Test"
    ]
    
    private let graduationRequirements = [
        "Intermediate/A-Level Certificate",
        "Minimum 60% marks in Inter",
        "On Merit Base",
        "130 (Credit Hours)",
        "Join Classes"
    ]
    
    private let graduationPrograms = [
        "BS Islamic Studies",
        "BS Mathematics",
        "BS Chemistry",
        "BS Economics",
        "BS Zoology",
        "BS Physics",
        "BS English",
        "BS Urdu",
        "BS IT"
    ]
}


struct ProgramCardView: View {
    let name: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 4) {
            Text(name.components(separatedBy: " ").first ?? "")
                .font(.system(size: 16, weight: .bold))
                .foregroundColor(.white)
            
            Text(name.components(separatedBy: " ").dropFirst().joined(separator: " "))
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(.white.opacity(0.9))
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity, minHeight: 70)
        .padding(8)
        .background(
            LinearGradient(
                gradient: Gradient(colors: [color, color.opacity(0.7)]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        .cornerRadius(10)
        .shadow(color: color.opacity(0.3), radius: 4, x: 0, y: 2)
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color.white.opacity(0.2), lineWidth: 1)
        )
    }
}

struct AdmissionCard<Content: View>: View {
    let title: String
    let duration: String
    @Binding var isExpanded: Bool
    let color: Color
    let content: () -> Content
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(.title3)
                        .bold()
                        .foregroundColor(color)
                    
                    Text(duration)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                    .foregroundColor(color)
            }
            .padding()
            .contentShape(Rectangle())
            .onTapGesture {
                withAnimation(.spring(response: 0.4, dampingFraction: 0.7)) {
                    isExpanded.toggle()
                }
            }
            
            if isExpanded {
                content()
                    .padding()
                    .transition(.opacity.combined(with: .move(edge: .top)))
            }
        }
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: color.opacity(0.2), radius: 8, x: 0, y: 4)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(color.opacity(0.3), lineWidth: 1)
        )
    }
}

struct RequirementItem: View {
    let text: String
    
    var body: some View {
        HStack(alignment: .top) {
            Image(systemName: "checkmark.circle.fill")
                .foregroundColor(.accentColor)
                .frame(width: 20, height: 20)
                .padding(.top, 2)
            
            Text(text)
                .font(.subheadline)
            
            Spacer()
        }
        .padding(.vertical, 4)
    }
}

struct ProgramItem: View {
    let title: String
    let subjects: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .bold()
                .foregroundColor(.accentColor)
            
            Text(subjects)
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
        .padding(.vertical, 6)
        .padding(.horizontal, 10)
        .background(Color.accentColor.opacity(0.1))
        .cornerRadius(8)
    }
}

struct DocumentsSection: View {
    @State private var showDocuments = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack {
                Text("Required Documents")
                    .font(.title3)
                    .bold()
                    .foregroundColor(.accentColor)
                
                Spacer()
                
                Image(systemName: showDocuments ? "chevron.up" : "chevron.down")
                    .foregroundColor(.accentColor)
            }
            .padding()
            .contentShape(Rectangle())
            .onTapGesture {
                withAnimation {
                    showDocuments.toggle()
                }
            }
            
            if showDocuments {
                VStack(alignment: .leading, spacing: 12) {
                    DocumentCategory(title: "For Intermediate Admission", items: intermediateDocuments)
                    DocumentCategory(title: "For Graduation Admission", items: graduationDocuments)
                    
                    VStack(alignment: .leading, spacing: 12) {
                        HStack(alignment: .top, spacing: 8) {
                            Image(systemName: "exclamationmark.triangle.fill")
                                .foregroundColor(.yellow)
                                .font(.title3)
                            
                            Text("Important Notes")
                                .font(.headline)
                                .foregroundColor(.orange)
                        }
                        
                        VStack(alignment: .leading, spacing: 8) {
                            ForEach(importantNotes, id: \.self) { note in
                                HStack(alignment: .top, spacing: 8) {
                                    Image(systemName: "exclamationmark.circle.fill")
                                        .foregroundColor(.orange)
                                        .font(.subheadline)
                                    
                                    Text(note)
                                        .font(.subheadline)
                                        .fixedSize(horizontal: false, vertical: true)
                                }
                            }
                        }
                        .padding(12)
                        .background(Color.orange.opacity(0.1))
                        .cornerRadius(8)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.orange.opacity(0.3), lineWidth: 1)
                        )
                    }
                    .padding(.top, 8)
                }
                .padding([.horizontal, .bottom])
                .transition(.opacity.combined(with: .move(edge: .top)))
            }
        }
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: Color.accentColor.opacity(0.2), radius: 8, x: 0, y: 4)
    }
    
    private let intermediateDocuments = [
        "1. Original Matric/O-Level Certificate",
        "2. Matric/O-Level Detailed Marks Sheet",
        "3. Character Certificate from previous school",
        "4. Birth Certificate or B-Form",
        "5. 4 Passport size photographs",
        "6. Transfer Certificate (if applicable)",
        "7. Medical Certificate (Optional)"
    ]
    
    private let graduationDocuments = [
        "1. Original Intermediate/A-Level Certificate",
        "2. Intermediate/A-Level Detailed Marks Sheet",
        "3. Matric/O-Level Certificate & Marks Sheet",
        "4. Character Certificate",
        "5. Domicile Certificate (Optional)",
        "6. CNIC/B-Form Copy",
        "7. 6 Passport size photographs",
        "8. Medical Fitness Certificate (Optional)"
    ]
    
    private let importantNotes = [
        "All documents must be attested by a Gazetted Officer.",
        "Original documents required for verification.",
        "Photocopies should be clear and readable.",
        "Submit documents within deadline.",
        "Late submissions may result in penalty."
    ]
}

struct DocumentCategory: View {
    let title: String
    let items: [String]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.headline)
                .foregroundColor(.teal)
            
            ForEach(items, id: \.self) { item in
                HStack(alignment: .top) {
                    Image(systemName: "doc.text.fill")
                        .foregroundColor(.accentColor)
                        .frame(width: 20, height: 20)
                    Text(item)
                        .font(.subheadline)
                }
            }
        }
        .padding(.bottom)
    }
}

#Preview {
    AdmissionsView()
        .preferredColorScheme(.light)
}

#Preview {
    AdmissionsView()
        .preferredColorScheme(.dark)
}
