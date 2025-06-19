//
//  AdmissionPortalForm.swift
//  Islamia College Portfolio
//
//  Created by Development on 19/06/2025.
//

import SwiftUI
import PhotosUI
import UniformTypeIdentifiers
import MessageUI
import PDFKit

struct PersonalInfo: Codable {
    var firstName: String = ""
    var lastName: String = ""
    var email: String = ""
    var phoneNumber: String = ""
    var dateOfBirth: Date = Date()
    var temporaryAddress: String = ""
    var city: String = ""
    var zipCode: String = ""
    var gender: Gender = .male
}

struct AcademicInfo: Codable {
    var previousSchoolName: String = ""
    var previousCollegeName: String = ""
    var matricRollNo: String = ""
    var interRollNo: String = ""
    var matricMarks: String = ""
    var interMarks: String = ""
    var gpa: String = ""
    var graduationYear: String = ""
    var intendedMajor: String = ""
}

struct GuardianInfo: Codable {
    var guardianName: String = ""
    var guardianCNIC: String = ""
    var guardianPhoneNumber: String = ""
    var guardianOccupation: String = ""
    var relationship: GuardianRelationship = .father
}

enum Gender: String, CaseIterable, Codable {
    case male = "Male"
    case female = "Female"
    
    var displayName: String { rawValue }
}

enum GuardianRelationship: String, CaseIterable, Codable {
    case father = "Father"
    case mother = "Mother"
    case guardian = "Guardian"
    case other = "Other"
    
    var displayName: String { rawValue }
}

class ApplicationData: ObservableObject {
    @Published var personalInfo = PersonalInfo()
    @Published var academicInfo = AcademicInfo()
    @Published var guardianInfo = GuardianInfo()
    @Published var personalStatement: String = ""
    @Published var agreedToTerms: Bool = false
    @Published var studentPhoto: UIImage?
    @Published var documents: [DocumentItem] = []
    @Published var isSubmitting: Bool = false
    @Published var submissionStatus: SubmissionStatus = .none
    @Published var referenceID: String = ""
    
    enum SubmissionStatus {
        case none
        case success
        case error(String)
    }
}

struct DocumentItem: Identifiable {
    let id = UUID()
    var name: String
    var data: Data
    var type: String
}

// MARK: - PDF Generator
class PDFGenerator {
    static func generateApplicationPDF(from data: ApplicationData) -> Data? {
        let pdfMetaData = [
            kCGPDFContextCreator: "Islamia College Admission Portal",
            kCGPDFContextAuthor: "\(data.personalInfo.firstName) \(data.personalInfo.lastName)",
            kCGPDFContextTitle: "Admission Application"
        ]
        
        let format = UIGraphicsPDFRendererFormat()
        format.documentInfo = pdfMetaData as [String: Any]
        
        let pageWidth = 8.5 * 72.0
        let pageHeight = 11 * 72.0
        let pageRect = CGRect(x: 0, y: 0, width: pageWidth, height: pageHeight)
        
        let renderer = UIGraphicsPDFRenderer(bounds: pageRect, format: format)
        
        let pdfData = renderer.pdfData { (context) in
            context.beginPage()
            
            var yPosition: CGFloat = 50
            let margin: CGFloat = 50
            let contentWidth = pageWidth - (2 * margin)
            
            // Header
            let headerFont = UIFont.boldSystemFont(ofSize: 24)
            let titleText = "Islamia College - Admission Application"
            let titleRect = CGRect(x: margin, y: yPosition, width: contentWidth, height: 40)
            titleText.draw(in: titleRect, withAttributes: [
                .font: headerFont,
                .foregroundColor: UIColor.systemBlue
            ])
            yPosition += 60
            
            // Reference ID
            if !data.referenceID.isEmpty {
                let refText = "Reference ID: \(data.referenceID)"
                let refRect = CGRect(x: margin, y: yPosition, width: contentWidth, height: 20)
                refText.draw(in: refRect, withAttributes: [
                    .font: UIFont.systemFont(ofSize: 14),
                    .foregroundColor: UIColor.systemGray
                ])
                yPosition += 40
            }
            
            // Personal Information Section
            yPosition = addSectionToPDF(title: "Personal Information", yPosition: yPosition, margin: margin, contentWidth: contentWidth)
            yPosition = addTextToPDF(text: "Name: \(data.personalInfo.firstName) \(data.personalInfo.lastName)", yPosition: yPosition, margin: margin)
            yPosition = addTextToPDF(text: "Email: \(data.personalInfo.email)", yPosition: yPosition, margin: margin)
            yPosition = addTextToPDF(text: "Phone: \(data.personalInfo.phoneNumber)", yPosition: yPosition, margin: margin)
            yPosition = addTextToPDF(text: "Gender: \(data.personalInfo.gender.displayName)", yPosition: yPosition, margin: margin)
            yPosition = addTextToPDF(text: "Address: \(data.personalInfo.temporaryAddress)", yPosition: yPosition, margin: margin)
            yPosition = addTextToPDF(text: "City: \(data.personalInfo.city), ZIP: \(data.personalInfo.zipCode)", yPosition: yPosition, margin: margin)
            yPosition += 20
            
            // Academic Information Section
            yPosition = addSectionToPDF(title: "Academic Information", yPosition: yPosition, margin: margin, contentWidth: contentWidth)
            yPosition = addTextToPDF(text: "Previous School: \(data.academicInfo.previousSchoolName)", yPosition: yPosition, margin: margin)
            yPosition = addTextToPDF(text: "Previous College: \(data.academicInfo.previousCollegeName)", yPosition: yPosition, margin: margin)
            yPosition = addTextToPDF(text: "Matric Roll No: \(data.academicInfo.matricRollNo)", yPosition: yPosition, margin: margin)
            yPosition = addTextToPDF(text: "Inter Roll No: \(data.academicInfo.interRollNo)", yPosition: yPosition, margin: margin)
            yPosition = addTextToPDF(text: "Matric Marks: \(data.academicInfo.matricMarks)", yPosition: yPosition, margin: margin)
            yPosition = addTextToPDF(text: "Inter Marks: \(data.academicInfo.interMarks)", yPosition: yPosition, margin: margin)
            yPosition = addTextToPDF(text: "GPA: \(data.academicInfo.gpa)", yPosition: yPosition, margin: margin)
            yPosition = addTextToPDF(text: "Intended Major: \(data.academicInfo.intendedMajor)", yPosition: yPosition, margin: margin)
            yPosition += 20
            
            // Guardian Information Section
            yPosition = addSectionToPDF(title: "Guardian Information", yPosition: yPosition, margin: margin, contentWidth: contentWidth)
            yPosition = addTextToPDF(text: "Guardian Name: \(data.guardianInfo.guardianName)", yPosition: yPosition, margin: margin)
            yPosition = addTextToPDF(text: "Guardian CNIC: \(data.guardianInfo.guardianCNIC)", yPosition: yPosition, margin: margin)
            yPosition = addTextToPDF(text: "Guardian Phone: \(data.guardianInfo.guardianPhoneNumber)", yPosition: yPosition, margin: margin)
            yPosition = addTextToPDF(text: "Guardian Occupation: \(data.guardianInfo.guardianOccupation)", yPosition: yPosition, margin: margin)
            yPosition = addTextToPDF(text: "Relationship: \(data.guardianInfo.relationship.displayName)", yPosition: yPosition, margin: margin)
            yPosition += 20
            
            // Personal Statement Section
            if !data.personalStatement.isEmpty {
                yPosition = addSectionToPDF(title: "Personal Statement", yPosition: yPosition, margin: margin, contentWidth: contentWidth)
                yPosition = addTextToPDF(text: data.personalStatement, yPosition: yPosition, margin: margin, isMultiline: true)
                yPosition += 20
            }
            
            // Student Photo
            if let photo = data.studentPhoto {
                // Start new page if needed
                if yPosition > pageHeight - 200 {
                    context.beginPage()
                    yPosition = 50
                }
                
                yPosition = addSectionToPDF(title: "Student Photo", yPosition: yPosition, margin: margin, contentWidth: contentWidth)
                let photoRect = CGRect(x: margin, y: yPosition, width: 150, height: 150)
                photo.draw(in: photoRect)
                yPosition += 170
            }
            
            // Documents Section
            if !data.documents.isEmpty {
                yPosition = addSectionToPDF(title: "Uploaded Documents", yPosition: yPosition, margin: margin, contentWidth: contentWidth)
                for document in data.documents {
                    yPosition = addTextToPDF(text: "• \(document.name) (\(document.type))", yPosition: yPosition, margin: margin)
                }
            }
            
            // Footer
            let footerText = "Application submitted on: \(Date().formatted(date: .abbreviated, time: .shortened))"
            let footerRect = CGRect(x: margin, y: pageHeight - 50, width: contentWidth, height: 20)
            footerText.draw(in: footerRect, withAttributes: [
                .font: UIFont.systemFont(ofSize: 10),
                .foregroundColor: UIColor.systemGray
            ])
        }
        
        return pdfData
    }
    
    private static func addSectionToPDF(title: String, yPosition: CGFloat, margin: CGFloat, contentWidth: CGFloat) -> CGFloat {
        let sectionFont = UIFont.boldSystemFont(ofSize: 16)
        let sectionRect = CGRect(x: margin, y: yPosition, width: contentWidth, height: 25)
        title.draw(in: sectionRect, withAttributes: [
            .font: sectionFont,
            .foregroundColor: UIColor.systemBlue
        ])
        return yPosition + 35
    }
    
    private static func addTextToPDF(text: String, yPosition: CGFloat, margin: CGFloat, isMultiline: Bool = false) -> CGFloat {
        let textFont = UIFont.systemFont(ofSize: 12)
        let textRect = CGRect(x: margin, y: yPosition, width: 500, height: isMultiline ? 100 : 20)
        text.draw(in: textRect, withAttributes: [
            .font: textFont,
            .foregroundColor: UIColor.black
        ])
        return yPosition + (isMultiline ? 110 : 25)
    }
}

class EmailService: NSObject, ObservableObject {
    static let shared = EmailService()
    private override init() {
        super.init()
    }
    
    func sendApplicationEmail(data: ApplicationData, completion: @escaping (Result<String, Error>) -> Void) {
        guard MFMailComposeViewController.canSendMail() else {
            completion(.failure(EmailError.mailNotAvailable))
            return
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            let referenceID = "ISL\(Int.random(in: 10000...99999))"
            completion(.success(referenceID))
        }
    }
    
    enum EmailError: LocalizedError {
        case mailNotAvailable
        case sendingFailed
        
        var errorDescription: String? {
            switch self {
            case .mailNotAvailable:
                return "Mail services are not available on this device"
            case .sendingFailed:
                return "Failed to send email"
            }
        }
    }
}


class AdmissionAPIService {
    static let shared = AdmissionAPIService()
    private init() {}
    
    func submitApplication(_ data: ApplicationData) async -> Result<String, Error> {
        try? await Task.sleep(nanoseconds: 2_000_000_000)
        
        guard !data.personalInfo.firstName.isEmpty,
              !data.personalInfo.lastName.isEmpty,
              !data.personalInfo.email.isEmpty,
              data.agreedToTerms else {
            return .failure(APIError.missingRequiredFields)
        }
        let referenceID = "ISL\(Int.random(in: 10000...99999))"
        
        // In a real implementation, you would:
        // 1. Send data to your backend
        // 2. Backend sends email to zaidali786908@gmail.com
        // 3. Return success with reference ID
        return await withCheckedContinuation { continuation in
            EmailService.shared.sendApplicationEmail(data: data) { result in
                switch result {
                case .success(let refID):
                    continuation.resume(returning: .success("Application submitted successfully! Reference ID: \(refID)"))
                case .failure(let error):
                    continuation.resume(returning: .failure(error))
                }
            }
        }
    }
    
    enum APIError: LocalizedError {
        case missingRequiredFields
        case networkError
        case invalidData
        
        var errorDescription: String? {
            switch self {
            case .missingRequiredFields:
                return "Please fill in all required fields"
            case .networkError:
                return "Network error. Please try again."
            case .invalidData:
                return "Invalid data provided"
            }
        }
    }
}

struct AdmissionPortalForm: View {
    @StateObject private var applicationData = ApplicationData()
    @State private var showingImagePicker = false
    @State private var showingDocumentPicker = false
    @State private var selectedPhotosItem: PhotosPickerItem?
    @State private var currentSection = 0
    @State private var showingSuccessAlert = false
    @State private var showingErrorAlert = false
    @State private var alertMessage = ""
    
    var body: some View {
        NavigationView {
            ZStack {
                LinearGradient(
                    colors: [Color.accentColor.opacity(0.1), Color.accentColor.opacity(0.1)],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                
                ScrollView {
                    LazyVStack(spacing: 24) {
                        headerView
                        progressSection
                        personalInformationSection
                        academicInformationSection
                        guardianInformationSection
                        studentPhotoSection
                        documentsUploadSection
                        additionalInformationSection
                        termsAndConditionsSection
                        actionButtons
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 30)
                }
            }
            .navigationBarHidden(true)
        }
        .photosPicker(isPresented: $showingImagePicker, selection: $selectedPhotosItem, matching: .images)
        .onChange(of: selectedPhotosItem) { newItem in
            Task {
                if let data = try? await newItem?.loadTransferable(type: Data.self),
                   let image = UIImage(data: data) {
                    await MainActor.run {
                        applicationData.studentPhoto = image
                    }
                }
            }
        }
        .alert("Success!", isPresented: $showingSuccessAlert) {
            Button("OK") {
                showingSuccessAlert = false
            }
        } message: {
            Text(alertMessage)
        }
        .alert("Error", isPresented: $showingErrorAlert) {
            Button("OK") {
                showingErrorAlert = false
            }
        } message: {
            Text(alertMessage)
        }
    }
    
    private var headerView: some View {
        VStack(spacing: 16) {
            // Logo and Title
            HStack {
                ZStack {
                    Circle()
                        .fill(LinearGradient(colors: [.accentColor, .accentColor], startPoint: .topLeading, endPoint: .bottomTrailing))
                        .frame(width: 60, height: 60)
                    
                    Image(systemName: "graduationcap.fill")
                        .font(.title)
                        .foregroundColor(.white)
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    Text("Islamia College")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.primary)
                    
                    Text("Admission Portal")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
            }
            
            VStack(alignment: .leading, spacing: 8) {
                Text("Welcome to Our Admission Portal")
                    .font(.headline)
                    .fontWeight(.semibold)
                
                Text("Complete your application by filling out all the required information below.")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
        }
        .padding(24)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(.ultraThinMaterial)
                .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: 5)
        )
    }
    
    private var progressSection: some View {
        VStack(spacing: 16) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Application Progress")
                        .font(.headline)
                        .fontWeight(.semibold)
                    
                    Text("\(Int(completionProgress * 100))% Complete")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                ZStack {
                    Circle()
                        .stroke(Color.gray.opacity(0.3), lineWidth: 6)
                        .frame(width: 50, height: 50)
                    
                    Circle()
                        .trim(from: 0, to: completionProgress)
                        .stroke(
                            LinearGradient(colors: [.accentColor, .accentColor], startPoint: .leading, endPoint: .trailing),
                            style: StrokeStyle(lineWidth: 6, lineCap: .round)
                        )
                        .frame(width: 50, height: 50)
                        .rotationEffect(.degrees(-90))
                    
                    Text("\(Int(completionProgress * 100))%")
                        .font(.caption)
                        .fontWeight(.bold)
                }
            }
            
            // Progress bar
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color.gray.opacity(0.2))
                        .frame(height: 8)
                    
                    RoundedRectangle(cornerRadius: 10)
                        .fill(LinearGradient(colors: [.accentColor, .accentColor], startPoint: .leading, endPoint: .trailing))
                        .frame(width: geometry.size.width * completionProgress, height: 8)
                        .animation(.easeInOut(duration: 0.5), value: completionProgress)
                }
            }
            .frame(height: 8)
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(.ultraThinMaterial)
                .shadow(color: .black.opacity(0.05), radius: 5, x: 0, y: 2)
        )
    }
    
    private var completionProgress: Double {
        var completed = 0.0
        let total = 7.0
        
        if !applicationData.personalInfo.firstName.isEmpty { completed += 1 }
        if !applicationData.personalInfo.email.isEmpty { completed += 1 }
        if !applicationData.academicInfo.previousSchoolName.isEmpty { completed += 1 }
        if !applicationData.guardianInfo.guardianName.isEmpty { completed += 1 }
        if applicationData.studentPhoto != nil { completed += 1 }
        if !applicationData.documents.isEmpty { completed += 1 }
        if applicationData.agreedToTerms { completed += 1 }
        
        return completed / total
    }
    
    private var personalInformationSection: some View {
        ModernSectionCard(
            title: "Personal Information",
            icon: "person.crop.circle.fill",
            color: .blue,
            isCompleted: !applicationData.personalInfo.firstName.isEmpty && !applicationData.personalInfo.email.isEmpty
        ) {
            VStack(spacing: 20) {
                HStack(spacing: 16) {
                    ModernTextField(
                        title: "First Name",
                        text: $applicationData.personalInfo.firstName,
                        placeholder: "Enter first name",
                        icon: "person.fill"
                    )
                    
                    ModernTextField(
                        title: "Last Name",
                        text: $applicationData.personalInfo.lastName,
                        placeholder: "Enter last name",
                        icon: "person.fill"
                    )
                }
                
                ModernTextField(
                    title: "Email Address",
                    text: $applicationData.personalInfo.email,
                    placeholder: "your.email@example.com",
                    icon: "envelope.fill"
                )
                .keyboardType(.emailAddress)
                .autocapitalization(.none)
                
                ModernTextField(
                    title: "Phone Number",
                    text: $applicationData.personalInfo.phoneNumber,
                    placeholder: "+92 XXX XXXXXXX",
                    icon: "phone.fill"
                )
                .keyboardType(.phonePad)
                
                // Date picker with modern styling
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Image(systemName: "calendar")
                            .foregroundColor(.blue)
                            .font(.system(size: 16, weight: .medium))
                        Text("Date of Birth")
                            .font(.subheadline)
                            .fontWeight(.medium)
                            .foregroundColor(.primary)
                    }
                    
                    DatePicker("", selection: $applicationData.personalInfo.dateOfBirth, displayedComponents: .date)
                        .datePickerStyle(CompactDatePickerStyle())
                        .padding(.horizontal, 16)
                        .padding(.vertical, 12)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color(.systemGray6))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(Color.blue.opacity(0.3), lineWidth: 1)
                                )
                        )
                }
                
                ModernTextField(
                    title: "Temporary Address",
                    text: $applicationData.personalInfo.temporaryAddress,
                    placeholder: "Current address",
                    icon: "house.fill"
                )
                
                HStack(spacing: 16) {
                    ModernTextField(
                        title: "City",
                        text: $applicationData.personalInfo.city,
                        placeholder: "City name",
                        icon: "building.2.fill"
                    )
                    
                    ModernTextField(
                        title: "ZIP Code",
                        text: $applicationData.personalInfo.zipCode,
                        placeholder: "12345",
                        icon: "number"
                    )
                    .keyboardType(.numberPad)
                }
                
                // Gender selection with modern cards
                VStack(alignment: .leading, spacing: 12) {
                    HStack {
                        Image(systemName: "person.2.fill")
                            .foregroundColor(.blue)
                            .font(.system(size: 16, weight: .medium))
                        Text("Gender")
                            .font(.subheadline)
                            .fontWeight(.medium)
                            .foregroundColor(.primary)
                    }
                    
                    HStack(spacing: 16) {
                        ForEach(Gender.allCases, id: \.self) { gender in
                            Button(action: {
                                withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                    applicationData.personalInfo.gender = gender
                                }
                            }) {
                                HStack(spacing: 8) {
                                    ZStack {
                                        Circle()
                                            .fill(applicationData.personalInfo.gender == gender ? .blue : Color.gray.opacity(0.3))
                                            .frame(width: 20, height: 20)
                                        
                                        if applicationData.personalInfo.gender == gender {
                                            Circle()
                                                .fill(.white)
                                                .frame(width: 8, height: 8)
                                        }
                                    }
                                    
                                    Text(gender.displayName)
                                        .font(.subheadline)
                                        .fontWeight(.medium)
                                        .foregroundColor(.primary)
                                }
                                .padding(.horizontal, 16)
                                .padding(.vertical, 12)
                                .background(
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(applicationData.personalInfo.gender == gender ? .blue.opacity(0.1) : Color(.systemGray6))
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 12)
                                                .stroke(applicationData.personalInfo.gender == gender ? .blue : Color.clear, lineWidth: 2)
                                        )
                                )
                            }
                            .scaleEffect(applicationData.personalInfo.gender == gender ? 1.02 : 1.0)
                            .animation(.spring(response: 0.3, dampingFraction: 0.7), value: applicationData.personalInfo.gender)
                        }
                        Spacer()
                    }
                }
            }
        }
    }
    
    private var academicInformationSection: some View {
        ModernSectionCard(
            title: "Academic Information",
            icon: "book.closed.fill",
            color: .green,
            isCompleted: !applicationData.academicInfo.previousSchoolName.isEmpty
        ) {
            VStack(spacing: 20) {
                ModernTextField(
                    title: "Previous School Name",
                    text: $applicationData.academicInfo.previousSchoolName,
                    placeholder: "Name of your previous school",
                    icon: "building.columns.fill"
                )
                
                ModernTextField(
                    title: "Previous College Name",
                    text: $applicationData.academicInfo.previousCollegeName,
                    placeholder: "Name of your previous college",
                    icon: "graduationcap.fill"
                )
                
                HStack(spacing: 16) {
                    ModernTextField(
                        title: "Matric Roll No",
                        text: $applicationData.academicInfo.matricRollNo,
                        placeholder: "123456",
                        icon: "number"
                    )
                    
                    ModernTextField(
                        title: "Inter Roll No",
                        text: $applicationData.academicInfo.interRollNo,
                        placeholder: "789012",
                        icon: "number"
                    )
                }
                
                HStack(spacing: 16) {
                    ModernTextField(
                        title: "Matric Marks",
                        text: $applicationData.academicInfo.matricMarks,
                        placeholder: "850",
                        icon: "chart.bar.fill"
                    )
                    .keyboardType(.numberPad)
                    
                    ModernTextField(
                        title: "Inter Marks",
                        text: $applicationData.academicInfo.interMarks,
                        placeholder: "980",
                        icon: "chart.bar.fill"
                    )
                    .keyboardType(.numberPad)
                }
                
                HStack(spacing: 16) {
                    ModernTextField(
                        title: "GPA (Optional)",
                        text: $applicationData.academicInfo.gpa,
                        placeholder: "3.85",
                        icon: "chart.line.uptrend.xyaxis"
                    )
                    .keyboardType(.decimalPad)
                    
                    ModernTextField(
                        title: "Graduation Year",
                        text: $applicationData.academicInfo.graduationYear,
                        placeholder: "2025",
                        icon: "calendar"
                    )
                    .keyboardType(.numberPad)
                }
                
                // Major selection dropdown
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Image(systemName: "star.fill")
                            .foregroundColor(.green)
                            .font(.system(size: 16, weight: .medium))
                        Text("Intended Major")
                            .font(.subheadline)
                            .fontWeight(.medium)
                            .foregroundColor(.primary)
                    }
                    
                    Menu {
                        ForEach(majors, id: \.self) { major in
                            Button(major) {
                                applicationData.academicInfo.intendedMajor = major
                            }
                        }
                    } label: {
                        HStack {
                            Text(applicationData.academicInfo.intendedMajor.isEmpty ? "Select your intended major" : applicationData.academicInfo.intendedMajor)
                                .foregroundColor(applicationData.academicInfo.intendedMajor.isEmpty ? .secondary : .primary)
                                .font(.subheadline)
                            Spacer()
                            Image(systemName: "chevron.down")
                                .foregroundColor(.green)
                                .font(.system(size: 12, weight: .medium))
                        }
                        .padding(.horizontal, 16)
                        .padding(.vertical, 12)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color(.systemGray6))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(Color.green.opacity(0.3), lineWidth: 1)
                                )
                        )
                    }
                }
            }
        }
    }
    
    // Complete the majors array
    private let majors = [
        "Computer Science", "Software Engineering", "Information Technology",
        "Business Administration", "Economics", "English Literature",
        "Mathematics", "Physics", "Chemistry", "Biology",
        "Psychology", "Sociology", "Political Science", "History",
        "Islamic Studies", "Arabic", "Urdu", "Philosophy"
    ]
    
    // Guardian Information Section
    private var guardianInformationSection: some View {
        ModernSectionCard(
            title: "Guardian Information",
            icon: "person.2.fill",
            color: .orange,
            isCompleted: !applicationData.guardianInfo.guardianName.isEmpty
        ) {
            VStack(spacing: 20) {
                ModernTextField(
                    title: "Guardian Name",
                    text: $applicationData.guardianInfo.guardianName,
                    placeholder: "Full name of guardian",
                    icon: "person.fill"
                )
                
                ModernTextField(
                    title: "Guardian CNIC",
                    text: $applicationData.guardianInfo.guardianCNIC,
                    placeholder: "12345-1234567-1",
                    icon: "creditcard.fill"
                )
                .keyboardType(.numberPad)
                
                ModernTextField(
                    title: "Guardian Phone Number",
                    text: $applicationData.guardianInfo.guardianPhoneNumber,
                    placeholder: "+92 XXX XXXXXXX",
                    icon: "phone.fill"
                )
                .keyboardType(.phonePad)
                
                ModernTextField(
                    title: "Guardian Occupation",
                    text: $applicationData.guardianInfo.guardianOccupation,
                    placeholder: "Occupation/Job title",
                    icon: "briefcase.fill"
                )
                
                // Relationship selection
                VStack(alignment: .leading, spacing: 12) {
                    HStack {
                        Image(systemName: "heart.fill")
                            .foregroundColor(.orange)
                            .font(.system(size: 16, weight: .medium))
                        Text("Relationship")
                            .font(.subheadline)
                            .fontWeight(.medium)
                            .foregroundColor(.primary)
                    }
                    
                    LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 12) {
                        ForEach(GuardianRelationship.allCases, id: \.self) { relationship in
                            Button(action: {
                                withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                    applicationData.guardianInfo.relationship = relationship
                                }
                            }) {
                                HStack(spacing: 8) {
                                    ZStack {
                                        Circle()
                                            .fill(applicationData.guardianInfo.relationship == relationship ? .orange : Color.gray.opacity(0.3))
                                            .frame(width: 20, height: 20)
                                        
                                        if applicationData.guardianInfo.relationship == relationship {
                                            Circle()
                                                .fill(.white)
                                                .frame(width: 8, height: 8)
                                        }
                                    }
                                    
                                    Text(relationship.displayName)
                                        .font(.subheadline)
                                        .fontWeight(.medium)
                                        .foregroundColor(.primary)
                                    
                                    Spacer()
                                }
                                .padding(.horizontal, 16)
                                .padding(.vertical, 12)
                                .background(
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(applicationData.guardianInfo.relationship == relationship ? .orange.opacity(0.1) : Color(.systemGray6))
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 12)
                                                .stroke(applicationData.guardianInfo.relationship == relationship ? .orange : Color.clear, lineWidth: 2)
                                        )
                                )
                            }
                            .scaleEffect(applicationData.guardianInfo.relationship == relationship ? 1.02 : 1.0)
                            .animation(.spring(response: 0.3, dampingFraction: 0.7), value: applicationData.guardianInfo.relationship)
                        }
                    }
                }
            }
        }
    }
    
    // Student Photo Section
    private var studentPhotoSection: some View {
        ModernSectionCard(
            title: "Student Photo",
            icon: "camera.fill",
            color: .purple,
            isCompleted: applicationData.studentPhoto != nil
        ) {
            VStack(spacing: 20) {
                if let photo = applicationData.studentPhoto {
                    VStack(spacing: 16) {
                        Image(uiImage: photo)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 150, height: 150)
                            .clipShape(RoundedRectangle(cornerRadius: 20))
                            .overlay(
                                RoundedRectangle(cornerRadius: 20)
                                    .stroke(LinearGradient(colors: [.accentColor, .accentColor], startPoint: .topLeading, endPoint: .bottomTrailing), lineWidth: 3)
                            )
                            .shadow(color: .purple.opacity(0.3), radius: 10, x: 0, y: 5)
                        
                        Button("Change Photo") {
                            showingImagePicker = true
                        }
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .foregroundColor(.purple)
                    }
                } else {
                    Button(action: {
                        showingImagePicker = true
                    }) {
                        VStack(spacing: 16) {
                            ZStack {
                                RoundedRectangle(cornerRadius: 20)
                                    .fill(LinearGradient(colors: [.accentColor.opacity(0.1), .accentColor.opacity(0.1)], startPoint: .topLeading, endPoint: .bottomTrailing))
                                    .frame(width: 150, height: 150)
                                
                                VStack(spacing: 12) {
                                    Image(systemName: "camera.fill")
                                        .font(.system(size: 40, weight: .medium))
                                        .foregroundColor(.purple)
                                    
                                    Text("Upload Photo")
                                        .font(.subheadline)
                                        .fontWeight(.medium)
                                        .foregroundColor(.purple)
                                }
                            }
                            .overlay(
                                RoundedRectangle(cornerRadius: 20)
                                    .stroke(style: StrokeStyle(lineWidth: 2, dash: [8]))
                                    .foregroundColor(.purple.opacity(0.5))
                            )
                            
                            Text("Tap to select a photo from your gallery")
                                .font(.caption)
                                .foregroundColor(.secondary)
                                .multilineTextAlignment(.center)
                        }
                    }
                }
            }
        }
    }
    
    // Documents Upload Section
    private var documentsUploadSection: some View {
        ModernSectionCard(
            title: "Upload Documents",
            icon: "doc.fill",
            color: .indigo,
            isCompleted: !applicationData.documents.isEmpty
        ) {
            VStack(spacing: 20) {
                // Document upload button
                Button(action: {
                    showingDocumentPicker = true
                }) {
                    HStack(spacing: 12) {
                        Image(systemName: "plus.circle.fill")
                            .font(.title2)
                            .foregroundColor(.indigo)
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Add Documents")
                                .font(.subheadline)
                                .fontWeight(.semibold)
                                .foregroundColor(.primary)
                            
                            Text("Upload transcripts, certificates, etc.")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        
                        Spacer()
                        
                        Image(systemName: "chevron.right")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(.indigo)
                    }
                    .padding(16)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(.indigo.opacity(0.1))
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(.indigo.opacity(0.3), lineWidth: 1)
                            )
                    )
                }
                
                // Uploaded documents list
                if !applicationData.documents.isEmpty {
                    VStack(spacing: 12) {
                        ForEach(applicationData.documents) { document in
                            HStack(spacing: 12) {
                                Image(systemName: "doc.text.fill")
                                    .font(.title2)
                                    .foregroundColor(.indigo)
                                
                                VStack(alignment: .leading, spacing: 2) {
                                    Text(document.name)
                                        .font(.subheadline)
                                        .fontWeight(.medium)
                                        .foregroundColor(.primary)
                                    
                                    Text(document.type)
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                }
                                
                                Spacer()
                                
                                Button(action: {
                                    if let index = applicationData.documents.firstIndex(where: { $0.id == document.id }) {
                                        applicationData.documents.remove(at: index)
                                    }
                                }) {
                                    Image(systemName: "trash.fill")
                                        .font(.system(size: 16))
                                        .foregroundColor(.red)
                                }
                            }
                            .padding(12)
                            .background(
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(Color(.systemGray6))
                            )
                        }
                    }
                }
            }
        }
        .fileImporter(
            isPresented: $showingDocumentPicker,
            allowedContentTypes: [.pdf, .jpeg, .png, .plainText],
            allowsMultipleSelection: true
        ) { result in
            switch result {
            case .success(let urls):
                for url in urls {
                    if url.startAccessingSecurityScopedResource() {
                        do {
                            let data = try Data(contentsOf: url)
                            let document = DocumentItem(
                                name: url.lastPathComponent,
                                data: data,
                                type: url.pathExtension.uppercased()
                            )
                            applicationData.documents.append(document)
                        } catch {
                            print("Error reading file: \(error)")
                        }
                        url.stopAccessingSecurityScopedResource()
                    }
                }
            case .failure(let error):
                print("Document picker error: \(error)")
            }
        }
    }
    
    // Additional Information Section (Personal Statement)
    private var additionalInformationSection: some View {
        ModernSectionCard(
            title: "Personal Statement",
            icon: "text.quote",
            color: .teal,
            isCompleted: !applicationData.personalStatement.isEmpty
        ) {
            VStack(alignment: .leading, spacing: 12) {
                Text("Tell us about yourself, your goals, and why you want to join Islamia College (Optional)")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                TextEditor(text: $applicationData.personalStatement)
                    .frame(minHeight: 120)
                    .padding(12)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color(.systemGray6))
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(Color.teal.opacity(0.3), lineWidth: 1)
                            )
                    )
                    .overlay(
                        // Placeholder text
                        VStack {
                            HStack {
                                Text(applicationData.personalStatement.isEmpty ? "Write your personal statement here..." : "")
                                    .foregroundColor(.secondary)
                                    .font(.subheadline)
                                    .padding(.top, 12)
                                    .padding(.leading, 16)
                                Spacer()
                            }
                            Spacer()
                        }
                            .allowsHitTesting(false)
                    )
            }
        }
    }
    
    // Terms and Conditions Section
    private var termsAndConditionsSection: some View {
        VStack(spacing: 16) {
            HStack(spacing: 12) {
                Button(action: {
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                        applicationData.agreedToTerms.toggle()
                    }
                }) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 6)
                            .fill(applicationData.agreedToTerms ? .blue : Color.clear)
                            .frame(width: 24, height: 24)
                            .overlay(
                                RoundedRectangle(cornerRadius: 6)
                                    .stroke(applicationData.agreedToTerms ? .blue : .secondary, lineWidth: 2)
                            )
                        
                        if applicationData.agreedToTerms {
                            Image(systemName: "checkmark")
                                .font(.system(size: 16, weight: .bold))
                                .foregroundColor(.white)
                        }
                    }
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    Text("I agree to the Terms and Conditions")
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .foregroundColor(.primary)
                    
                    Text("By checking this box, you confirm that all information provided is accurate and complete.")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
            }
            .padding(16)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(.ultraThinMaterial)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(applicationData.agreedToTerms ? .blue : Color.secondary.opacity(0.3), lineWidth: 1)
                    )
            )
        }
    }
    
    // Action Buttons
    private var actionButtons: some View {
        VStack(spacing: 16) {
            // Submit Application Button
            Button(action: {
                submitApplication()
            }) {
                HStack(spacing: 12) {
                    if applicationData.isSubmitting {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: .white))
                            .scaleEffect(0.8)
                    } else {
                        Image(systemName: "paperplane.fill")
                            .font(.system(size: 18, weight: .medium))
                    }
                    
                    Text(applicationData.isSubmitting ? "Submitting..." : "Submit Application")
                        .font(.headline)
                        .fontWeight(.semibold)
                }
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(
                    LinearGradient(
                        colors: canSubmit ? [.accentColor, .accentColor.opacity(0.8)] : [.gray, .gray.opacity(0.8)],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .clipShape(RoundedRectangle(cornerRadius: 16))
                .shadow(color: canSubmit ? .blue.opacity(0.3) : .clear, radius: 8, x: 0, y: 4)
                .scaleEffect(applicationData.isSubmitting ? 0.98 : 1.0)
                .animation(.spring(response: 0.3, dampingFraction: 0.7), value: applicationData.isSubmitting)
            }
            .disabled(!canSubmit || applicationData.isSubmitting)
            
            // Download PDF Button (only show after successful submission)
            if case .success = applicationData.submissionStatus {
                Button(action: {
                    downloadPDF()
                }) {
                    HStack(spacing: 12) {
                        Image(systemName: "arrow.down.doc.fill")
                            .font(.system(size: 18, weight: .medium))
                        
                        Text("Download PDF")
                            .font(.headline)
                            .fontWeight(.semibold)
                    }
                    .foregroundColor(.green)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(.green.opacity(0.1))
                            .overlay(
                                RoundedRectangle(cornerRadius: 16)
                                    .stroke(.green, lineWidth: 2)
                            )
                    )
                    .shadow(color: .green.opacity(0.2), radius: 6, x: 0, y: 3)
                }
            }
        }
    }
    
    private var canSubmit: Bool {
        !applicationData.personalInfo.firstName.isEmpty &&
        !applicationData.personalInfo.lastName.isEmpty &&
        !applicationData.personalInfo.email.isEmpty &&
        !applicationData.personalInfo.phoneNumber.isEmpty &&
        !applicationData.academicInfo.previousSchoolName.isEmpty &&
        !applicationData.guardianInfo.guardianName.isEmpty &&
        applicationData.agreedToTerms
    }
    
    // MARK: - Functions
    private func submitApplication() {
        applicationData.isSubmitting = true
        
        Task {
            let result = await AdmissionAPIService.shared.submitApplication(applicationData)
            
            await MainActor.run {
                applicationData.isSubmitting = false
                
                switch result {
                case .success(let message):
                    applicationData.submissionStatus = .success
                    applicationData.referenceID = extractReferenceID(from: message)
                    alertMessage = message
                    showingSuccessAlert = true
                    
                case .failure(let error):
                    applicationData.submissionStatus = .error(error.localizedDescription)
                    alertMessage = error.localizedDescription
                    showingErrorAlert = true
                }
            }
        }
    }
    
    private func extractReferenceID(from message: String) -> String {
        let pattern = "ISL\\d{5}"
        if let range = message.range(of: pattern, options: .regularExpression) {
            return String(message[range])
        }
        return "ISL\(Int.random(in: 10000...99999))"
    }
    
    private func downloadPDF() {
        guard let pdfData = PDFGenerator.generateApplicationPDF(from: applicationData) else {
            alertMessage = "Failed to generate PDF"
            showingErrorAlert = true
            return
        }
        
        // Save PDF to Files app
        let fileName = "Islamia_College_Application_\(applicationData.referenceID).pdf"
        let tempURL = FileManager.default.temporaryDirectory.appendingPathComponent(fileName)
        
        do {
            try pdfData.write(to: tempURL)
            
            // Present activity view controller to save to Files
            let activityVC = UIActivityViewController(activityItems: [tempURL], applicationActivities: nil)
            
            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
               let window = windowScene.windows.first {
                window.rootViewController?.present(activityVC, animated: true)
            }
            
        } catch {
            alertMessage = "Failed to save PDF: \(error.localizedDescription)"
            showingErrorAlert = true
        }
    }
    
    // MARK: - Modern UI Components
    struct ModernSectionCard<Content: View>: View {
        let title: String
        let icon: String
        let color: Color
        let isCompleted: Bool
        let content: Content
        
        init(title: String, icon: String, color: Color, isCompleted: Bool, @ViewBuilder content: () -> Content) {
            self.title = title
            self.icon = icon
            self.color = color
            self.isCompleted = isCompleted
            self.content = content()
        }
        
        var body: some View {
            VStack(spacing: 20) {
                // Section Header
                HStack(spacing: 12) {
                    ZStack {
                        Circle()
                            .fill(LinearGradient(colors: [color, color.opacity(0.7)], startPoint: .topLeading, endPoint: .bottomTrailing))
                            .frame(width: 40, height: 40)
                        
                        Image(systemName: icon)
                            .font(.system(size: 18, weight: .medium))
                            .foregroundColor(.white)
                    }
                    
                    VStack(alignment: .leading, spacing: 2) {
                        Text(title)
                            .font(.headline)
                            .fontWeight(.semibold)
                            .foregroundColor(.primary)
                        
                        Text(isCompleted ? "Completed" : "Please fill out this section")
                            .font(.caption)
                            .foregroundColor(isCompleted ? .green : .secondary)
                    }
                    
                    Spacer()
                    
                    if isCompleted {
                        Image(systemName: "checkmark.circle.fill")
                            .font(.title2)
                            .foregroundColor(.green)
                    }
                }
                
                // Section Content
                content
            }
            .padding(24)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(.ultraThinMaterial)
                    .shadow(color: .black.opacity(0.08), radius: 12, x: 0, y: 6)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(isCompleted ? color.opacity(0.3) : Color.clear, lineWidth: 1)
            )
            .scaleEffect(isCompleted ? 1.01 : 1.0)
            .animation(.spring(response: 0.4, dampingFraction: 0.8), value: isCompleted)
        }
    }
    
    struct ModernTextField: View {
        let title: String
        @Binding var text: String
        let placeholder: String
        let icon: String
        
        var body: some View {
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Image(systemName: icon)
                        .foregroundColor(.blue)
                        .font(.system(size: 16, weight: .medium))
                    Text(title)
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .foregroundColor(.primary)
                }
                
                TextField(placeholder, text: $text)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 12)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color(.systemGray6))
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(!text.isEmpty ? .blue.opacity(0.5) : Color.clear, lineWidth: 2)
                            )
                    )
                    .font(.subheadline)
            }
        }
    }
}

#Preview {
    AdmissionPortalForm()
}
