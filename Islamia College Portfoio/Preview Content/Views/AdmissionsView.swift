import SwiftUI

struct AdmissionsView: View {
    @State private var showIntermediateDetails = false
    @State private var showGraduationDetails = false
    @State private var showDocuments = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                LazyVStack(spacing: 24) {
                    headerView
                    
                    VStack(spacing: 16) {
                        AdmissionCard(
                            title: "Intermediate (11th & 12th)",
                            duration: "2 Years Program",
                            icon: "graduationcap.fill",
                            isExpanded: $showIntermediateDetails,
                            gradientColors: [Color.accentColor, Color.accentColor.opacity(0.7)]
                        ) {
                            intermediateDetailsView
                        }
                        
                        AdmissionCard(
                            title: "Graduation Admission",
                            duration: "Bachelor's Degree • 4 Years",
                            icon: "star.fill",
                            isExpanded: $showGraduationDetails,
                            gradientColors: [Color.accentColor, Color.accentColor.opacity(0.7)]
                        ) {
                            graduationDetailsView
                        }
                        
                        DocumentsCard(showDocuments: $showDocuments)
                    }
                    .padding(.horizontal, 20)
                    
                    submitButton
                        .padding(.horizontal, 20)
                        .padding(.top, 8)
                }
                .padding(.vertical, 20)
            }
            .background(
                LinearGradient(
                    gradient: Gradient(colors: [
                        Color(.systemBackground),
                        Color(.systemGray6).opacity(0.3)
                    ]),
                    startPoint: .top,
                    endPoint: .bottom
                )
            )
        }
    }
    
    private var headerView: some View {
        VStack(spacing: 12) {
            HStack {
                Image(systemName: "building.columns.fill")
                    .font(.title2)
                    .foregroundColor(.white)
                
                Text("Admissions Criteria")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
            }
            
            Text("Choose your academic path")
                .font(.subheadline)
                .foregroundColor(.white.opacity(0.85))
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 24)
        .padding(.horizontal, 20)
        .background(
            ZStack {
                LinearGradient(
                    gradient: Gradient(colors: [
                        Color.accentColor.opacity(0.9),
                        Color.accentColor.opacity(0.8)
                    ]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                
                Circle()
                    .fill(Color.white.opacity(0.1))
                    .frame(width: 100, height: 100)
                    .offset(x: 80, y: -30)
                
                Circle()
                    .fill(Color.white.opacity(0.05))
                    .frame(width: 60, height: 60)
                    .offset(x: -70, y: 20)
            }
        )
        .cornerRadius(20)
        .shadow(color: Color.green.opacity(0.3), radius: 15, x: 0, y: 8)
        .padding(.horizontal, 20)
    }
    
    private var submitButton: some View {
        NavigationLink(destination: AdmissionPortalForm()) {
            HStack(spacing: 12) {
                Image(systemName: "paperplane.fill")
                    .font(.title3)
                    .foregroundColor(.white)
                
                VStack(alignment: .leading, spacing: 2) {
                    Text("Submit Application")
                        .font(.headline)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                    
                    Text("Start your journey today")
                        .font(.caption)
                        .foregroundColor(.white.opacity(0.85))
                }
                
                Spacer()
                
                Image(systemName: "arrow.right.circle.fill")
                    .font(.title2)
                    .foregroundColor(.white)
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 16)
            .background(
                LinearGradient(
                    gradient: Gradient(colors: [
                        Color.accentColor,
                        Color.accentColor.opacity(0.8)
                    ]),
                    startPoint: .leading,
                    endPoint: .trailing
                )
            )
            .cornerRadius(16)
            .shadow(color: Color.accentColor.opacity(0.4), radius: 12, x: 0, y: 6)
        }
        .buttonStyle(ScaleButtonStyle())
    }
    
    private var intermediateDetailsView: some View {
        VStack(alignment: .leading, spacing: 16) {
            RequirementsSection(
                title: "Admission Requirements",
                requirements: intermediateRequirements,
                color: .accentColor
            )
            
            Divider()
                .padding(.vertical, 8)
            
            VStack(alignment: .leading, spacing: 12) {
                Text("Available Programs")
                    .font(.headline)
                    .fontWeight(.semibold)
                    .foregroundColor(.accentColor)
                
                VStack(spacing: 10) {
                    ProgramRow(title: "Pre-Engineering", subjects: "Physics, Chemistry, Mathematics", icon: "gear.circle.fill")
                    ProgramRow(title: "Pre-Medical", subjects: "Physics, Chemistry, Biology", icon: "cross.circle.fill")
                    ProgramRow(title: "ICS", subjects: "Physics, Statistics", icon: "desktopcomputer.circle.fill")
                }
            }
        }
    }
    
    private var graduationDetailsView: some View {
        VStack(alignment: .leading, spacing: 16) {
            RequirementsSection(
                title: "Admission Requirements",
                requirements: graduationRequirements,
                color: .accentColor
            )
            
            Divider()
                .padding(.vertical, 8)
            
            VStack(alignment: .leading, spacing: 16) {
                Text("Bachelor's Programs")
                    .font(.headline)
                    .fontWeight(.semibold)
                    .foregroundColor(.accentColor)
                
                LazyVGrid(columns: [
                    GridItem(.flexible(), spacing: 8),
                    GridItem(.flexible(), spacing: 8)
                ], spacing: 12) {
                    ForEach(graduationPrograms, id: \.self) { program in
                        ProgramCardView(name: program, gradientColors: [Color.accentColor.opacity(0.8), Color.accentColor.opacity(0.6)])
                    }
                }
            }
        }
    }
    
    // Data arrays
    private let intermediateRequirements = [
        "Matric/O-Level Certificate",
        "Minimum 60% marks in Matric",
        "Merit-based admission",
        "No Entry Test Required"
    ]
    
    private let graduationRequirements = [
        "Intermediate/A-Level Certificate",
        "Minimum 60% marks in Inter",
        "Merit-based admission",
        "130 Credit Hours Program",
        "Regular classes attendance"
    ]
    
    private let graduationPrograms = [
        "BS Islamic Studies", "BS Mathematics", "BS Chemistry",
        "BS Economics", "BS Zoology", "BS Physics",
        "BS English", "BS Urdu", "BS Information Technology"
    ]
}

// MARK: - Custom Views

struct AdmissionCard<Content: View>: View {
    let title: String
    let duration: String
    let icon: String
    @Binding var isExpanded: Bool
    let gradientColors: [Color]
    let content: () -> Content
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack(spacing: 16) {
                Image(systemName: icon)
                    .font(.title2)
                    .foregroundColor(.white)
                    .frame(width: 40, height: 40)
                    .background(
                        LinearGradient(
                            gradient: Gradient(colors: gradientColors),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .cornerRadius(10)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(.title3)
                        .fontWeight(.bold)
                        .foregroundColor(.primary)
                    
                    Text(duration)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                Image(systemName: isExpanded ? "chevron.up.circle.fill" : "chevron.down.circle")
                    .font(.title2)
                    .foregroundColor(gradientColors.first ?? .accentColor)
                    .rotationEffect(.degrees(isExpanded ? 180 : 0))
            }
            .padding(20)
            .contentShape(Rectangle())
            .onTapGesture {
                withAnimation(.spring(response: 0.5, dampingFraction: 0.8)) {
                    isExpanded.toggle()
                }
            }
            
            if isExpanded {
                content()
                    .padding(.horizontal, 20)
                    .padding(.bottom, 20)
                    .transition(.asymmetric(
                        insertion: .opacity.combined(with: .move(edge: .top)),
                        removal: .opacity.combined(with: .move(edge: .top))
                    ))
            }
        }
        .background(Color(.systemBackground))
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.08), radius: 12, x: 0, y: 6)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(
                    LinearGradient(
                        gradient: Gradient(colors: gradientColors.map { $0.opacity(0.3) }),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ),
                    lineWidth: 1
                )
        )
    }
}

struct RequirementsSection: View {
    let title: String
    let requirements: [String]
    let color: Color
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(.headline)
                .fontWeight(.semibold)
                .foregroundColor(color)
            
            VStack(spacing: 8) {
                ForEach(requirements, id: \.self) { requirement in
                    RequirementItem(text: requirement, color: color)
                }
            }
        }
    }
}

struct RequirementItem: View {
    let text: String
    let color: Color
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: "checkmark.circle.fill")
                .foregroundColor(color)
                .font(.system(size: 18))
            
            Text(text)
                .font(.subheadline)
                .foregroundColor(.primary)
            
            Spacer()
        }
        .padding(.vertical, 4)
    }
}

struct ProgramRow: View {
    let title: String
    let subjects: String
    let icon: String
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.title3)
                .foregroundColor(.accentColor)
                .frame(width: 24)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(.primary)
                
                Text(subjects)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 10)
        .background(Color.accentColor.opacity(0.05))
        .cornerRadius(10)
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color.accentColor.opacity(0.2), lineWidth: 1)
        )
    }
}

struct ProgramCardView: View {
    let name: String
    let gradientColors: [Color]
    
    var body: some View {
        VStack(spacing: 6) {
            let components = name.components(separatedBy: " ")
            let firstWord = components.first ?? ""
            let remainingWords = components.dropFirst().joined(separator: " ")
            
            Text(firstWord)
                .font(.system(size: 16, weight: .bold))
                .foregroundColor(.white)
            
            if !remainingWords.isEmpty {
                Text(remainingWords)
                    .font(.system(size: 13, weight: .medium))
                    .foregroundColor(.white.opacity(0.9))
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
            }
        }
        .frame(maxWidth: .infinity, minHeight: 80)
        .padding(.horizontal, 8)
        .padding(.vertical, 12)
        .background(
            LinearGradient(
                gradient: Gradient(colors: gradientColors),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        .cornerRadius(12)
        .shadow(color: gradientColors.first?.opacity(0.3) ?? Color.clear, radius: 8, x: 0, y: 4)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.white.opacity(0.2), lineWidth: 1)
        )
    }
}

struct DocumentsCard: View {
    @Binding var showDocuments: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack(spacing: 16) {
                Image(systemName: "doc.text.fill")
                    .font(.title2)
                    .foregroundColor(.white)
                    .frame(width: 40, height: 40)
                    .background(
                        LinearGradient(
                            gradient: Gradient(colors: [Color.accentColor, Color.accentColor.opacity(0.7)]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .cornerRadius(10)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text("Required Documents")
                        .font(.title3)
                        .fontWeight(.bold)
                        .foregroundColor(.accentColor)
                    
                    Text("Complete documentation checklist")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                Image(systemName: showDocuments ? "chevron.up.circle.fill" : "chevron.down.circle")
                    .font(.title2)
                    .foregroundColor(.accentColor)
                    .rotationEffect(.degrees(showDocuments ? 180 : 0))
            }
            .padding(20)
            .contentShape(Rectangle())
            .onTapGesture {
                withAnimation(.spring(response: 0.5, dampingFraction: 0.8)) {
                    showDocuments.toggle()
                }
            }
            
            if showDocuments {
                DocumentsContent()
                    .padding(.horizontal, 20)
                    .padding(.bottom, 20)
                    .transition(.asymmetric(
                        insertion: .opacity.combined(with: .move(edge: .top)),
                        removal: .opacity.combined(with: .move(edge: .top))
                    ))
            }
        }
        .background(Color(.systemBackground))
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.08), radius: 12, x: 0, y: 6)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.teal.opacity(0.3), lineWidth: 1)
        )
    }
}

struct DocumentsContent: View {
    private let intermediateDocuments = [
        "Original Matric/O-Level Certificate",
        "Detailed Marks Sheet",
        "Character Certificate",
        "Birth Certificate or B-Form",
        "4 Passport size photographs",
        "Transfer Certificate (if applicable)"
    ]
    
    private let graduationDocuments = [
        "Original Intermediate/A-Level Certificate",
        "Detailed Marks Sheet",
        "Previous certificates & marks sheets",
        "Character Certificate",
        "CNIC/B-Form Copy",
        "6 Passport size photographs"
    ]
    
    private let importantNotes = [
        "All documents must be attested by a Gazetted Officer",
        "Original documents required for verification",
        "Submit documents within deadline",
        "Late submissions may incur penalty"
    ]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            DocumentCategory(
                title: "For Intermediate Admission",
                items: intermediateDocuments,
                color: .accentColor
            )
            
            DocumentCategory(
                title: "For Graduation Admission",
                items: graduationDocuments,
                color: .accentColor
            )
            
            ImportantNotesSection(notes: importantNotes)
        }
    }
}

struct DocumentCategory: View {
    let title: String
    let items: [String]
    let color: Color
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(.headline)
                .fontWeight(.semibold)
                .foregroundColor(color)
            
            VStack(spacing: 8) {
                ForEach(Array(items.enumerated()), id: \.offset) { index, item in
                    HStack(spacing: 12) {
                        Text("\(index + 1)")
                            .font(.caption)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .frame(width: 20, height: 20)
                            .background(color)
                            .cornerRadius(10)
                        
                        Text(item)
                            .font(.subheadline)
                            .foregroundColor(.primary)
                        
                        Spacer()
                    }
                }
            }
        }
    }
}

struct ImportantNotesSection: View {
    let notes: [String]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 8) {
                Image(systemName: "exclamationmark.triangle.fill")
                    .foregroundColor(.orange)
                    .font(.title3)
                
                Text("Important Notes")
                    .font(.headline)
                    .fontWeight(.semibold)
                    .foregroundColor(.orange)
            }
            
            VStack(spacing: 8) {
                ForEach(notes, id: \.self) { note in
                    HStack(alignment: .top, spacing: 8) {
                        Image(systemName: "info.circle.fill")
                            .foregroundColor(.orange)
                            .font(.subheadline)
                        
                        Text(note)
                            .font(.subheadline)
                            .foregroundColor(.primary)
                            .fixedSize(horizontal: false, vertical: true)
                        
                        Spacer()
                    }
                }
            }
            .padding(16)
            .background(Color.orange.opacity(0.1))
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color.orange.opacity(0.3), lineWidth: 1)
            )
        }
    }
}

// MARK: - Button Styles

struct ScalesButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
            .animation(.easeInOut(duration: 0.1), value: configuration.isPressed)
    }
}

#Preview {
    AdmissionsView()
}
