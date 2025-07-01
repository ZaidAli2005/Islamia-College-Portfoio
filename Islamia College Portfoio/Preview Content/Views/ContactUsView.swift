//
//  ContactUsView.swift
//  Islamia College Portfolio
//
//  Created by Development on 18/06/2025.
//

import SwiftUI
import MessageUI

struct ContactUsView: View {
    @State private var name = ""
    @State private var email = ""
    @State private var subject = ""
    @State private var message = ""
    @State private var showingAlert = false
    @State private var alertMessage = ""
    @State private var showingMailComposer = false
    @State private var canSendMail = MFMailComposeViewController.canSendMail()
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    headerSection
                    contactFormSection
                    quickContactSection
                    collegeInfoSection
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 20)
            }
            .background(
                LinearGradient(
                    colors: [Color(.systemBackground), Color(.systemGray6)],
                    startPoint: .top,
                    endPoint: .bottom
                )
            )
        }
        .sheet(isPresented: $showingMailComposer) {
            MailComposeView(
                recipients: ["zaidali786908@gmail.com"],
                subject: subject.isEmpty ? "Contact Form - Islamia College App" : "Contact Form - \(subject)",
                messageBody: createEmailBody()
            )
        }
        .alert("Contact Us", isPresented: $showingAlert) {
            Button("OK") { }
        } message: {
            Text(alertMessage)
        }
    }
    
    private var headerSection: some View {
        VStack(spacing: 16) {
            Image(systemName: "building.columns.fill")
                .font(.system(size: 60))
                .foregroundStyle(
                    LinearGradient(
                        colors: [.accentColor, .accentColor],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
            
            Text("Get in Touch")
                .font(.largeTitle)
                .fontWeight(.bold)
                .multilineTextAlignment(.center)
            
            Text("We'd love to hear from you. Send us a message and we'll respond as soon as possible.")
                .font(.body)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
        }
        .padding(.top, 20)
    }
    
    private var contactFormSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Send Message")
                .font(.headline)
                .fontWeight(.semibold)
            
            VStack(spacing: 12) {
                CustomTextFields(
                    title: "Full Name",
                    text: $name,
                    icon: "person.fill"
                )
                
                CustomTextFields(
                    title: "Email Address",
                    text: $email,
                    icon: "envelope.fill"
                )
                .keyboardType(.emailAddress)
                .textInputAutocapitalization(.never)
                
                CustomTextFields(
                    title: "Subject",
                    text: $subject,
                    icon: "text.bubble.fill"
                )
                
                VStack(alignment: .leading, spacing: 8) {
                    Label("Message", systemImage: "text.alignleft")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    
                    TextEditor(text: $message)
                        .frame(minHeight: 100)
                        .padding(12)
                        .background(Color(.systemGray6))
                        .cornerRadius(12)
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color(.systemGray4), lineWidth: 1)
                        )
                }
            }
            
            Button(action: sendMessage) {
                HStack {
                    Image(systemName: "paperplane.fill")
                    Text("Send Message")
                        .fontWeight(.semibold)
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(
                    LinearGradient(
                        colors: [.accentColor, .accentColor],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .foregroundColor(.white)
                .cornerRadius(12)
            }
            .disabled(name.isEmpty || email.isEmpty || message.isEmpty)
            .opacity(name.isEmpty || email.isEmpty || message.isEmpty ? 0.6 : 1.0)
        }
        .padding(20)
        .background(Color(.systemBackground))
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.1), radius: 8, x: 0, y: 4)
    }
    
    private var quickContactSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Quick Contact")
                .font(.headline)
                .fontWeight(.semibold)
            
            VStack(spacing: 12) {
                QuickContactRow(
                    icon: "phone.fill",
                    title: "Phone",
                    subtitle: "+92-55-9290279",
                    color: .green
                ) {
                    makePhoneCall("+92559290279")
                }
                
                QuickContactRow(
                    icon: "envelope.fill",
                    title: "Email",
                    subtitle: "zaidali786908@gmail.com",
                    color: .blue
                ) {
                    sendQuickEmail()
                }
                
                QuickContactRow(
                    icon: "message.fill",
                    title: "WhatsApp",
                    subtitle: "+92-300-1234567",
                    color: .green
                ) {
                    openWhatsApp()
                }
                
                QuickContactRow(
                    icon: "location.fill",
                    title: "Visit Us",
                    subtitle: "Circular Road, Gujranwala",
                    color: .red
                ) {
                    openMaps()
                }
            }
        }
    }
    
    private var collegeInfoSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("College Information")
                .font(.headline)
                .fontWeight(.semibold)
            
            VStack(spacing: 12) {
                InfoRow(title: "Address", value: "Circular Road, Gujranwala, Punjab, Pakistan")
                InfoRow(title: "Phone", value: "+92-55-9290279")
                InfoRow(title: "Email", value: "info@islamiacollege.edu.pk")
                InfoRow(title: "Website", value: "www.islamiacollege.edu.pk")
                InfoRow(title: "Office Hours", value: "Mon-Fri: 8:00 AM - 5:00 PM")
            }
        }
        .padding(20)
        .background(Color(.systemBackground))
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.1), radius: 8, x: 0, y: 4)
    }
    
    private func sendMessage() {
        guard !name.isEmpty, !email.isEmpty, !message.isEmpty else {
            alertMessage = "Please fill in all required fields."
            showingAlert = true
            return
        }
        
        guard isValidEmail(email) else {
            alertMessage = "Please enter a valid email address."
            showingAlert = true
            return
        }
        
        if canSendMail {
            showingMailComposer = true
        } else {
            let fullMessage = createEmailBody()
            UIPasteboard.general.string = fullMessage
            alertMessage = "Email content copied to clipboard. Please paste it in your email app."
            showingAlert = true
        }
    }
    
    private func createEmailBody() -> String {
        return """
        Contact Form Submission - Islamia College App
        
        Name: \(name)
        Email: \(email)
        Subject: \(subject.isEmpty ? "General Inquiry" : subject)
        
        Message:
        \(message)
        
        ---
        Submitted on: \(Date().formatted(date: .abbreviated, time: .shortened))
        App: Islamia College Portfolio iOS App
        """
    }
    
    private func sendQuickEmail() {
        if canSendMail {
            subject = "Quick Contact - Islamia College App"
            showingMailComposer = true
        } else {
            if let emailURL = URL(string: "mailto:zaidali786908@gmail.com"),
               UIApplication.shared.canOpenURL(emailURL) {
                UIApplication.shared.open(emailURL)
            } else {
                alertMessage = "No email app found. Please configure your Mail app or install one to send emails."
                showingAlert = true
            }
        }
    }
    
    private func makePhoneCall(_ phoneNumber: String) {
        guard let phoneURL = URL(string: "tel://\(phoneNumber)") else { return }
        UIApplication.shared.open(phoneURL)
    }
    
    private func openWhatsApp() {
        let phoneNumber = "+923001234567"
        let message = "Hello, I'm contacting you from the Islamia College iOS app."
        let encodedMessage = message.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        
        if let whatsappURL = URL(string: "whatsapp://send?phone=\(phoneNumber)&text=\(encodedMessage)") {
            if UIApplication.shared.canOpenURL(whatsappURL) {
                UIApplication.shared.open(whatsappURL)
            } else {
                alertMessage = "WhatsApp is not installed on your device."
                showingAlert = true
            }
        }
    }
    
    private func openMaps() {
        let address = "Islamia College, Circular Road, Gujranwala, Punjab, Pakistan"
        let encodedAddress = address.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        
        if let mapsURL = URL(string: "http://maps.apple.com/?q=\(encodedAddress)") {
            UIApplication.shared.open(mapsURL)
        }
    }
    
    private func isValidEmail(_ email: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: email)
    }
}

struct CustomTextFields: View {
    let title: String
    @Binding var text: String
    let icon: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Label(title, systemImage: icon)
                .font(.subheadline)
                .foregroundColor(.secondary)
            
            TextField(title, text: $text)
                .textFieldStyle(PlainTextFieldStyle())
                .padding(12)
                .background(Color(.systemGray6))
                .cornerRadius(12)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color(.systemGray4), lineWidth: 1)
                )
        }
    }
}

struct QuickContactRow: View {
    let icon: String
    let title: String
    let subtitle: String
    let color: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 16) {
                Image(systemName: icon)
                    .font(.title2)
                    .foregroundColor(.white)
                    .frame(width: 44, height: 44)
                    .background(color)
                    .cornerRadius(12)
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(title)
                        .font(.headline)
                        .foregroundColor(.primary)
                    
                    Text(subtitle)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            .padding()
            .background(Color(.systemBackground))
            .cornerRadius(12)
            .shadow(color: .black.opacity(0.05), radius: 4, x: 0, y: 2)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct InfoRow: View {
    let title: String
    let value: String
    
    var body: some View {
        HStack(alignment: .top) {
            Text(title)
                .font(.subheadline)
                .fontWeight(.medium)
                .foregroundColor(.secondary)
                .frame(width: 100, alignment: .leading)
            
            Text(value)
                .font(.subheadline)
                .foregroundColor(.primary)
                .multilineTextAlignment(.leading)
            
            Spacer()
        }
        .padding(.vertical, 4)
    }
}

struct MailComposeView: UIViewControllerRepresentable {
    let recipients: [String]
    let subject: String
    let messageBody: String
    @Environment(\.presentationMode) var presentationMode
    
    func makeUIViewController(context: Context) -> MFMailComposeViewController {
        let mailComposer = MFMailComposeViewController()
        mailComposer.mailComposeDelegate = context.coordinator
        mailComposer.setToRecipients(recipients)
        mailComposer.setSubject(subject)
        mailComposer.setMessageBody(messageBody, isHTML: false)
        return mailComposer
    }
    
    func updateUIViewController(_ uiViewController: MFMailComposeViewController, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, MFMailComposeViewControllerDelegate {
        let parent: MailComposeView
        
        init(_ parent: MailComposeView) {
            self.parent = parent
        }
        
        func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
            parent.presentationMode.wrappedValue.dismiss()
        }
    }
}

#Preview {
    ContactUsView()
}
