import SwiftUI

struct SplashView: View {
    @State private var navigateToDashboard = false
    @State private var imageScale: CGFloat = 0.5
    @State private var imageOpacity: Double = 0
    @State private var imageOffset: CGFloat = 50
    @State private var contentOpacity: Double = 0
    @State private var buttonScale: CGFloat = 0.95
    @State private var gradientOffset: CGFloat = -200
    @State private var titleOffset: CGFloat = -50
    @State private var subtitleOffset: CGFloat = 50
    @State private var dotsAnimation = false
    @State private var pulseAnimation = false
    @State private var backgroundOffset: CGFloat = 0

    var body: some View {
        NavigationStack {
            ZStack {
                LinearGradient(
                    gradient: Gradient(colors: [
                        Color.accentColor.opacity(0.9),
                        Color.accentColor.opacity(0.7),
                        Color.white.opacity(0.1)
                    ]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                .offset(x: backgroundOffset)

                ForEach(0..<6, id: \.self) { index in
                    Circle()
                        .fill(Color.white.opacity(0.1))
                        .frame(width: CGFloat.random(in: 20...40))
                        .position(
                            x: CGFloat.random(in: 50...350),
                            y: CGFloat.random(in: 100...700)
                        )
                        .scaleEffect(pulseAnimation ? 1.2 : 0.8)
                        .animation(
                            .easeInOut(duration: Double.random(in: 2...4))
                            .repeatForever(autoreverses: true)
                            .delay(Double(index) * 0.3),
                            value: pulseAnimation
                        )
                }

                VStack(spacing: 40) {
                    Spacer()

                    Image("Splash Img")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 360, height: 200)
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                        .shadow(color: .black.opacity(0.15), radius: 20, x: 0, y: 10)
                        .scaleEffect(imageScale)
                        .opacity(imageOpacity)
                        .offset(y: imageOffset)

                    VStack(spacing: 15) {
                        Text("Islamia College")
                            .font(.system(size: 36, weight: .bold, design: .rounded))
                            .foregroundStyle(
                                LinearGradient(
                                    colors: [Color.white, Color.white.opacity(0.9)],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .multilineTextAlignment(.center)
                            .shadow(color: .black.opacity(0.3), radius: 2, x: 0, y: 2)
                            .offset(y: titleOffset)

                        Text("Gujranwala")
                            .font(.system(size: 20, weight: .medium, design: .rounded))
                            .foregroundColor(.white.opacity(0.85))
                            .tracking(1.5)
                            .offset(y: subtitleOffset)

                        HStack(spacing: 8) {
                            ForEach(0..<3, id: \.self) { index in
                                Circle()
                                    .fill(Color.white.opacity(0.4))
                                    .frame(width: 8, height: 8)
                                    .scaleEffect(dotsAnimation ? 1.5 : 1.0)
                                    .opacity(dotsAnimation ? 0.9 : 0.4)
                                    .animation(
                                        .easeInOut(duration: 0.6)
                                        .repeatForever(autoreverses: true)
                                        .delay(Double(index) * 0.2),
                                        value: dotsAnimation
                                    )
                            }
                        }
                        .padding(.top, 10)
                    }
                    .opacity(contentOpacity)

                    Spacer()

                    Button(action: handleButtonTap) {
                        HStack(spacing: 12) {
                            Text("Let's Go")
                                .font(.system(size: 18, weight: .semibold, design: .rounded))
                                .foregroundColor(.white)

                            Image(systemName: "arrow.right")
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundColor(.white)
                                .rotationEffect(.degrees(buttonScale < 1.0 ? 10 : 0))
                        }
                        .padding(.horizontal, 40)
                        .padding(.vertical, 16)
                        .background(
                            LinearGradient(
                                colors: [
                                    Color(red: 0.1, green: 0.55, blue: 0.35),
                                    Color(red: 0.15, green: 0.65, blue: 0.45)
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .clipShape(Capsule())
                        .overlay(
                            Capsule()
                                .stroke(Color.white.opacity(0.2), lineWidth: 1)
                        )
                        .shadow(color: .black.opacity(0.2), radius: 10, x: 0, y: 5)
                    }
                    .scaleEffect(buttonScale)
                    .padding(.bottom, 200)
                }
                .padding(.horizontal, 30)
                .onAppear {
                    startAnimations()
                }
                .navigationDestination(isPresented: $navigateToDashboard) {
                    DashboardView()
                }
            }
        }
        .navigationBarHidden(true)
    }

    private func handleButtonTap() {
        withAnimation(.easeInOut(duration: 0.1)) {
            buttonScale = 0.92
        }

        let impactFeedback = UIImpactFeedbackGenerator(style: .heavy)
        impactFeedback.impactOccurred()

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            withAnimation(.spring(response: 0.4, dampingFraction: 0.6)) {
                buttonScale = 1.05
            }
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                buttonScale = 1.0
            }
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
            navigateToDashboard = true
        }
    }

    private func startAnimations() {
        // Updated image animation
        withAnimation(.spring(response: 1.2, dampingFraction: 0.6)) {
            imageScale = 1.05
            imageOpacity = 1.0
            imageOffset = 0
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            withAnimation(.spring(response: 0.5, dampingFraction: 0.5)) {
                imageScale = 1.0
            }
        }

        withAnimation(.spring(response: 1.0, dampingFraction: 0.8).delay(0.3)) {
            titleOffset = 0
        }
        withAnimation(.spring(response: 1.0, dampingFraction: 0.8).delay(0.5)) {
            subtitleOffset = 0
        }
        withAnimation(.easeOut(duration: 0.8).delay(0.4)) {
            contentOpacity = 1.0
        }
        withAnimation(.spring(response: 0.8, dampingFraction: 0.6).delay(0.7)) {
            buttonScale = 1.0
        }
        withAnimation(.linear(duration: 2.5).delay(1.0)) {
            gradientOffset = 400
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
            dotsAnimation = true
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            pulseAnimation = true
        }
        Timer.scheduledTimer(withTimeInterval: 4.0, repeats: true) { _ in
            gradientOffset = -200
            withAnimation(.linear(duration: 2.5)) {
                gradientOffset = 400
            }
        }
    }
}

#Preview {
    SplashView()
}
