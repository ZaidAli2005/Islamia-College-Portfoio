import SwiftUI

struct LabsView: View {
    @State private var labs = Lab.sampleLabs
    @State private var selectedLab: Lab?
    @Environment(\.presentationMode) var presentationMode
    @State private var animateHeader = false
    
    var body: some View {
        VStack(spacing: 0) {
            headerView
            
            ScrollView {
                LazyVStack(spacing: 20) {
                    ForEach(Array(labs.enumerated()), id: \.element.id) { index, lab in
                        LabRowView(lab: lab) {
                            print("Selected lab: \(lab.name)")
                            selectedLab = lab
                        }
                        .animation(.spring(response: 0.6, dampingFraction: 0.8).delay(Double(index) * 0.1), value: animateHeader)
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 24)
                .padding(.bottom, 20)
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
        .navigationBarHidden(true)
        .background(Color(.systemBackground))
        .sheet(item: $selectedLab) { lab in
            LabDetailView(lab: lab)
        }
        .onAppear {
            print("Available labs: \(labs.map { $0.name })")
            withAnimation(.spring(response: 0.8, dampingFraction: 0.8).delay(0.2)) {
                animateHeader = true
            }
        }
    }
    
    private var headerView: some View {
        VStack(spacing: 0) {
            HStack {
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    HStack(spacing: 6) {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 18, weight: .semibold))
                        Text("")
                            .font(.system(size: 16, weight: .medium))
                    }
                    .foregroundColor(.green)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 8)
                    .cornerRadius(20)
                }
                
                Spacer()
                
                HStack(spacing: 12) {
                    Text("Labs")
                        .font(.system(size: 32, weight: .bold, design: .rounded))
                        .foregroundStyle(
                            LinearGradient(
                                gradient: Gradient(colors: [Color.black, Color.black]),
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .offset(x: animateHeader ? 0 : 20)
                        .opacity(animateHeader ? 1 : 0)
                        .animation(.spring(response: 0.6, dampingFraction: 0.8).delay(0.4), value: animateHeader)
                }
                
                Spacer()
            }
            .padding(.horizontal, 20)
            .padding(.top, 8)
            .padding(.bottom, 16)
            Rectangle()
                .fill(Color.gray.opacity(0.2))
                .frame(height: 1)
                .padding(.horizontal, 20)
        }
        .background(
            LinearGradient(
                gradient: Gradient(colors: [
                    Color(.systemBackground),
                    Color(.systemGray6).opacity(0.1)
                ]),
                startPoint: .top,
                endPoint: .bottom
            )
        )
    }
}

struct LabRowView: View {
    let lab: Lab
    let onTap: () -> Void
    @State private var isPressed = false
    
    var body: some View {
        HStack(spacing: 20) {
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            gradient: Gradient(colors: [
                                Color(.systemGray6),
                                Color(.systemGray5)
                            ]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 76, height: 76)
                    .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
                
                Image(lab.imageName)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 68, height: 68)
                    .clipShape(Circle())
                    .overlay(
                        Circle()
                            .stroke(Color.white, lineWidth: 2)
                    )
            }
            
            VStack(alignment: .leading, spacing: 8) {
                Text(lab.name)
                    .font(.system(size: 20, weight: .bold, design: .rounded))
                    .foregroundColor(.primary)
                    .multilineTextAlignment(.leading)
                
                HStack(spacing: 8) {
                    ZStack {
                        Circle()
                            .fill(lab.isActive ? Color.green : Color.red)
                            .frame(width: 10, height: 10)
                        
                        Circle()
                            .fill(lab.isActive ? Color.green.opacity(0.3) : Color.red.opacity(0.3))
                            .frame(width: 20, height: 20)
                            .scaleEffect(isPressed ? 1.2 : 1.0)
                            .animation(.easeInOut(duration: 1.0).repeatForever(autoreverses: true), value: isPressed)
                    }
                    
                    Text(lab.statusText)
                        .font(.system(size: 15, weight: .medium))
                        .foregroundColor(.secondary)
                    
                    Spacer()
                }
            }
            
            Spacer()
            
            VStack(spacing: 4) {
                Image(systemName: "chevron.right")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.gray)
                    .scaleEffect(isPressed ? 1.2 : 1.0)
                
                Circle()
                    .fill(Color.blue.opacity(0.2))
                    .frame(width: 4, height: 4)
                    .scaleEffect(isPressed ? 1.5 : 1.0)
            }
        }
        .padding(.horizontal, 24)
        .padding(.vertical, 20)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color(.systemBackground))
                .shadow(
                    color: Color.black.opacity(0.08),
                    radius: isPressed ? 8 : 4,
                    x: 0,
                    y: isPressed ? 4 : 2
                )
        )
        .scaleEffect(isPressed ? 0.98 : 1.0)
        .animation(.spring(response: 0.3, dampingFraction: 0.8), value: isPressed)
        .contentShape(Rectangle())
        .onTapGesture {
            onTap()
        }
        .onLongPressGesture(minimumDuration: 0) { pressing in
            isPressed = pressing
        } perform: {
            onTap()
        }
        .onAppear {
            isPressed = lab.isActive
        }
    }
}

struct LabDetailView: View {
    let lab: Lab
    @Environment(\.presentationMode) var presentationMode
    @State private var animateContent = false
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                headerView
                
                ScrollView {
                    VStack(spacing: 32) {
                        labImageView
                        labTitleSection
                        labDescriptionSection
                        
                        Spacer(minLength: 40)
                    }
                    .padding(.top, 24)
                }
                .background(
                    LinearGradient(
                        gradient: Gradient(colors: [
                            Color(.systemBackground),
                            Color(.systemGray6).opacity(0.2)
                        ]),
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
            }
            .navigationBarHidden(true)
            .background(Color(.systemBackground))
        }
        .onAppear {
            print("Showing detail for: \(lab.name)")
            withAnimation(.spring(response: 0.8, dampingFraction: 0.8).delay(0.1)) {
                animateContent = true
            }
        }
    }
    
    private var headerView: some View {
        HStack {
            Button(action: {
                presentationMode.wrappedValue.dismiss()
            }) {
                HStack(spacing: 8) {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 16, weight: .semibold))
                    Text("")
                        .font(.system(size: 16, weight: .medium))
                }
                .foregroundColor(.green)
                .padding(.horizontal, 16)
                .padding(.vertical, 10)
                .cornerRadius(25)
            }
            
            Spacer()
        }
        .padding(.horizontal, 20)
        .padding(.top, 8)
        .padding(.bottom, 16)
    }
    
    private var labImageView: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 24)
                .fill(
                    LinearGradient(
                        gradient: Gradient(colors: [
                            Color(.systemGray6),
                            Color(.systemGray5)
                        ]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .frame(height: 220)
                .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 5)
            
            Image(lab.imageName)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(height: 220)
                .clipped()
                .cornerRadius(24)
        }
        .padding(.horizontal, 20)
        .scaleEffect(animateContent ? 1.0 : 0.9)
        .opacity(animateContent ? 1.0 : 0.0)
        .animation(.spring(response: 0.6, dampingFraction: 0.8).delay(0.2), value: animateContent)
    }
    
    private var labTitleSection: some View {
        VStack(spacing: 24) {
            Text(lab.name)
                .font(.system(size: 32, weight: .bold, design: .rounded))
                .foregroundStyle(
                    LinearGradient(
                        gradient: Gradient(colors: [Color.primary, Color.primary]),
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .multilineTextAlignment(.center)
                .offset(y: animateContent ? 0 : 20)
                .opacity(animateContent ? 1.0 : 0.0)
                .animation(.spring(response: 0.6, dampingFraction: 0.8).delay(0.3), value: animateContent)
            
            if let hodName = lab.hodName {
                VStack(spacing: 12) {
                    Text("Head of Department")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.secondary)
                        .textCase(.uppercase)
                        .tracking(1.2)
                    
                    Text(hodName)
                        .font(.system(size: 24, weight: .bold, design: .rounded))
                        .foregroundColor(.primary)
                        .padding(.horizontal, 24)
                        .padding(.vertical, 16)
                        .background(
                            RoundedRectangle(cornerRadius: 16)
                                .fill(Color(.systemGray6))
                                .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 2)
                        )
                }
                .offset(y: animateContent ? 0 : 30)
                .opacity(animateContent ? 1.0 : 0.0)
                .animation(.spring(response: 0.6, dampingFraction: 0.8).delay(0.4), value: animateContent)
            }
        }
        .padding(.horizontal, 20)
    }
    
    private var labDescriptionSection: some View {
        VStack(spacing: 16) {
            HStack {
                Image(systemName: "info.circle.fill")
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundColor(.blue)
                
                Text("Lab Information")
                    .font(.system(size: 22, weight: .bold, design: .rounded))
                    .foregroundColor(.primary)
                
                Spacer()
            }
            .padding(.horizontal, 30)
            .offset(y: animateContent ? 0 : 40)
            .opacity(animateContent ? 1.0 : 0.0)
            .animation(.spring(response: 0.6, dampingFraction: 0.8).delay(0.5), value: animateContent)
            
            VStack(alignment: .leading, spacing: 16) {
                Text(lab.description)
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.primary)
                    .lineSpacing(4)
                    .multilineTextAlignment(.leading)
            }
            .padding(.horizontal, 24)
            .padding(.vertical, 20)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color(.systemBackground))
                    .shadow(
                        color: Color.black.opacity(0.08),
                        radius: 6,
                        x: 0,
                        y: 3
                    )
            )
            .padding(.horizontal, 20)
            .offset(y: animateContent ? 0 : 50)
            .opacity(animateContent ? 1.0 : 0.0)
            .animation(.spring(response: 0.6, dampingFraction: 0.8).delay(0.6), value: animateContent)
        }
    }
}

#Preview {
    LabsView()
}
