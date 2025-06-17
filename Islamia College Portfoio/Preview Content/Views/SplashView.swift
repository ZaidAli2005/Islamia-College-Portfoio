//
//  SplashView.swift
//  Islamia College Portfolio
//
//  Created by Development on 17/06/2025.
//

import SwiftUI

struct SplashView: View {
    @State private var navigateToDashboard = false
    @State private var currentPage = 0
    @State private var animationOffset: CGFloat = 0
    @State private var imageScale: CGFloat = 0.3
    @State private var textOpacity: Double = 0
    @State private var buttonScale: CGFloat = 0.8
    @State private var buttonRotation: Double = 0
    @State private var gradientAnimation = false
    @State private var floatingOffset: CGFloat = 0
    
    var body: some View {
        NavigationView {
            ZStack {
                LinearGradient(
                    gradient: Gradient(colors: [
                        Color.accentColor,
                        Color.accentColor.opacity(0.8),
                        Color.accentColor.opacity(0.5),
                        Color.white
                    ]),
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()
                ForEach(0..<6, id: \.self) { index in
                    Circle()
                        .fill(Color.white.opacity(0.1))
                        .frame(width: CGFloat.random(in: 20...60))
                        .position(
                            x: CGFloat.random(in: 50...350),
                            y: CGFloat.random(in: 100...700) + floatingOffset
                        )
                        .animation(
                            .easeInOut(duration: Double.random(in: 2...4))
                            .repeatForever(autoreverses: true)
                            .delay(Double(index) * 0.3),
                            value: floatingOffset
                        )
                }
                
                VStack(spacing: 40) {
                    Spacer()
                    
                    Image("Splash Img")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 350, height: 200)
                        .clipShape(RoundedRectangle(cornerRadius: 25))
                        .overlay(
                            RoundedRectangle(cornerRadius: 25)
                                .stroke(
                                    LinearGradient(
                                        colors: [Color.white.opacity(0.3), Color.clear],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    ),
                                    lineWidth: 2
                                )
                        )
                        .shadow(color: .black.opacity(0.4), radius: 20, x: 0, y: 10)
                        .scaleEffect(imageScale)
                        .rotation3DEffect(
                            .degrees(imageScale < 1 ? 15 : 0),
                            axis: (x: 1, y: 0, z: 0)
                        )
                    
                    VStack(spacing: 25) {
                        Text("Islamia College")
                            .font(.system(size: 38, weight: .heavy, design: .rounded))
                            .foregroundStyle(
                                LinearGradient(
                                    colors: [Color.white, Color.white.opacity(0.8)],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .multilineTextAlignment(.center)
                            .shadow(color: .black.opacity(0.3), radius: 2, x: 0, y: 2)
                            .opacity(textOpacity)
                            .offset(y: textOpacity == 0 ? 20 : 0)
                        
                        Text("Gujranwala")
                            .font(.system(size: 22, weight: .medium, design: .rounded))
                            .foregroundColor(.white.opacity(0.9))
                            .opacity(textOpacity)
                            .offset(y: textOpacity == 0 ? 20 : 0)
                        
                        HStack(spacing: 12) {
                            ForEach(0..<3, id: \.self) { index in
                                Circle()
                                    .fill(
                                        index == currentPage ?
                                        LinearGradient(
                                            colors: [Color.white, Color.white.opacity(0.8)],
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing
                                        ) :
                                        LinearGradient(
                                            colors: [Color.white.opacity(0.4), Color.white.opacity(0.2)],
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing
                                        )
                                    )
                                    .frame(
                                        width: index == currentPage ? 12 : 8,
                                        height: index == currentPage ? 12 : 8
                                    )
                                    .scaleEffect(index == currentPage ? 1.3 : 1.0)
                                    .shadow(
                                        color: index == currentPage ? .white.opacity(0.5) : .clear,
                                        radius: 4
                                    )
                                    .animation(.spring(response: 0.4, dampingFraction: 0.6), value: currentPage)
                            }
                        }
                        .padding(.top, 10)
                        .opacity(textOpacity)
                    }
                    
                    Spacer()
                    
                    Button(action: {
                        withAnimation(.spring(response: 0.4, dampingFraction: 0.6)) {
                            buttonScale = 0.95
                            buttonRotation += 360
                        }
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                            withAnimation(.spring(response: 0.4, dampingFraction: 0.6)) {
                                buttonScale = 1.0
                            }
                        }
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                            navigateToDashboard = true
                        }
                    }) {
                        HStack(spacing: 15) {
                            Text("Let's Go")
                                .font(.system(size: 20, weight: .bold, design: .rounded))
                                .foregroundColor(.white)
                            
                            Image(systemName: "arrow.right.circle.fill")
                                .font(.system(size: 18, weight: .bold))
                                .foregroundColor(.white)
                                .rotationEffect(.degrees(buttonRotation))
                        }
                        .padding(.horizontal, 50)
                        .padding(.vertical, 18)
                        .background(
                            LinearGradient(
                                colors: [
                                    Color(red: 0.15, green: 0.55, blue: 0.35),
                                    Color(red: 0.25, green: 0.65, blue: 0.45)
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
                        .shadow(color: .black.opacity(0.3), radius: 10, x: 0, y: 5)
                        .shadow(color: Color(red: 0.2, green: 0.6, blue: 0.4).opacity(0.5), radius: 20, x: 0, y: 10)
                    }
                    .scaleEffect(buttonScale)
                    .padding(.bottom, 60)
                    
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
    
    private func startAnimations() {
        floatingOffset = 30
        
        withAnimation(.spring(response: 1.2, dampingFraction: 0.7, blendDuration: 0)) {
            imageScale = 1.0
        }
        
        withAnimation(.easeOut(duration: 0.8).delay(0.3)) {
            textOpacity = 1.0
        }
        withAnimation(.spring(response: 0.8, dampingFraction: 0.6).delay(0.6)) {
            buttonScale = 1.0
        }
        startDotAnimation()
    }
    
    private func startDotAnimation() {
        Timer.scheduledTimer(withTimeInterval: 0.8, repeats: true) { _ in
            withAnimation(.spring(response: 0.4, dampingFraction: 0.6)) {
                currentPage = (currentPage + 1) % 3
            }
        }
    }
}

#Preview {
    SplashView()
}
