//
//  SplashView.swift
//  Islamia College Portfolio
//
//  Created by Development on 17/06/2025.
//

import SwiftUI

struct SplashView: View {
    @State private var navigateToDashboard = false
    @State private var imageScale: CGFloat = 0.8
    @State private var contentOpacity: Double = 0
    @State private var buttonScale: CGFloat = 0.95
    @State private var gradientOffset: CGFloat = -200
    
    var body: some View {
        NavigationView {
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
                
                VStack(spacing: 40) {
                    Spacer()
                    
                    Image("Splash Img")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 360, height: 200)
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                        .overlay(
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(Color.white.opacity(0.3), lineWidth: 1)
                        )
                        .shadow(color: .black.opacity(0.15), radius: 20, x: 0, y: 10)
                        .scaleEffect(imageScale)
                        .overlay(
                            RoundedRectangle(cornerRadius: 20)
                                .fill(
                                    LinearGradient(
                                        colors: [
                                            Color.clear,
                                            Color.white.opacity(0.3),
                                            Color.clear
                                        ],
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                )
                                .offset(x: gradientOffset)
                                .clipped()
                        )
                    
                    VStack(spacing: 15) {
                        Text("Islamia College")
                            .font(.system(size: 36, weight: .bold, design: .rounded))
                            .foregroundStyle(
                                LinearGradient(
                                    colors: [
                                        Color.white,
                                        Color.white.opacity(0.9)
                                    ],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .multilineTextAlignment(.center)
                            .shadow(color: .black.opacity(0.3), radius: 2, x: 0, y: 2)
                        
                        Text("Gujranwala")
                            .font(.system(size: 20, weight: .medium, design: .rounded))
                            .foregroundColor(.white.opacity(0.85))
                            .tracking(1.5)
                        
                        HStack(spacing: 8) {
                            ForEach(0..<3, id: \.self) { index in
                                Circle()
                                    .fill(Color.white.opacity(index == 1 ? 0.9 : 0.4))
                                    .frame(width: 8, height: 8)
                                    .scaleEffect(index == 1 ? 1.2 : 1.0)
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
                        }
                        .padding(.horizontal, 40)
                        .padding(.vertical, 16)
                        .background(
                            LinearGradient(
                                colors: [
                                    Color(red: 0.15, green: 0.65, blue: 0.45),
                                    Color(red: 0.1, green: 0.55, blue: 0.35)
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
                    
                    NavigationLink(
                        destination: DashboardView(),
                        isActive: $navigateToDashboard
                    ) {
                        EmptyView()
                    }
                }
                .padding(.horizontal, 30)
                .onAppear {
                    startAnimations()
                }
            }
        }
        .navigationBarHidden(true)
    }
    
    private func handleButtonTap() {
        withAnimation(.easeInOut(duration: 0.1)) {
            buttonScale = 0.92
        }
        
        let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
        impactFeedback.impactOccurred()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                buttonScale = 1.0
            }
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            navigateToDashboard = true
        }
    }
    
    private func startAnimations() {
        withAnimation(.spring(response: 1.2, dampingFraction: 0.8)) {
            imageScale = 1.0
        }
        
        withAnimation(.easeOut(duration: 0.8).delay(0.3)) {
            contentOpacity = 1.0
        }
        
        withAnimation(.spring(response: 0.6, dampingFraction: 0.8).delay(0.6)) {
            buttonScale = 1.0
        }
        
        withAnimation(.linear(duration: 2.0).delay(1.0)) {
            gradientOffset = 400
        }
    }
}

#Preview {
    SplashView()
}
