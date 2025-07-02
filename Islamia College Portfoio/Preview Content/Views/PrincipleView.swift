//
//  PrincipalView.swift
//  Islamia College Portfolio
//
//  Created by Development on 17/06/2025.
//

import SwiftUI

struct PrincipalView: View {
    @State private var showContent = false
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [Color.white, Color.blue.opacity(0.05)]),
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            
            VStack(spacing: 0) {
                HStack {
                    Button(action: {
                        dismiss()
                    }) {
                        HStack(spacing: 8) {
                            Image(systemName: "chevron.left")
                                .font(.system(size: 22, weight: .semibold))
                        }
                        .foregroundColor(.accentColor)
                        .padding(.vertical, 12)
                        .padding(.horizontal, 20)
                    }
                    
                    Spacer()
                }
                .padding(.horizontal, 20)
                .padding(.top, 10)
                .padding(.bottom, 20)
                
                ScrollView {
                    VStack(spacing: 35) {
                        VStack(spacing: 25) {
                            ZStack {
                                Circle()
                                    .stroke(
                                        LinearGradient(
                                            gradient: Gradient(colors: [Color.accentColor, Color.accentColor]),
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing
                                        )
                                    )
                                    .frame(width: 130, height: 130)
                                    .shadow(color: Color.accentColor.opacity(0.3), radius: 10, x: 0, y: 5)
                                
                                Circle()
                                    .fill(Color.white)
                                    .frame(width: 122, height: 122)
                                    .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
                                
                                Image("Principel")
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 115, height: 115)
                                    .clipShape(Circle())
                            }
                            .scaleEffect(showContent ? 1 : 0.8)
                            .opacity(showContent ? 1 : 0)
                            .animation(.spring(response: 0.6, dampingFraction: 0.8), value: showContent)
                            
                            VStack(spacing: 8) {
                                Text("Dr. M. Akram Virk")
                                    .font(.system(size: 28, weight: .bold, design: .rounded))
                                    .foregroundColor(.primary)
                                    .multilineTextAlignment(.center)
                                
                                Text("Principal")
                                    .font(.system(size: 16, weight: .medium))
                                    .foregroundColor(.secondary)
                                    .padding(.horizontal, 20)
                                    .padding(.vertical, 6)
                                    .background(
                                        RoundedRectangle(cornerRadius: 15)
                                            .fill(Color.accentColor.opacity(0.1))
                                    )
                            }
                            .opacity(showContent ? 1 : 0)
                            .offset(y: showContent ? 0 : 20)
                            .animation(.easeOut(duration: 0.6).delay(0.2), value: showContent)
                        }
                        .padding(.top, 20)
                        
                        VStack(spacing: 25) {
                            HStack(spacing: 12) {
                                Image(systemName: "quote.opening")
                                    .font(.system(size: 20, weight: .semibold))
                                    .foregroundColor(.accentColor)
                                
                                Text("Principal's Message")
                                    .font(.system(size: 22, weight: .bold, design: .rounded))
                                    .foregroundColor(.accentColor)
                                
                                Image(systemName: "quote.closing")
                                    .font(.system(size: 20, weight: .semibold))
                                    .foregroundColor(.accentColor)
                            }
                            .padding(.horizontal, 25)
                            .padding(.vertical, 18)
                            .background(
                                RoundedRectangle(cornerRadius: 20)
                                    .fill(
                                        LinearGradient(
                                            gradient: Gradient(colors: [Color.white, Color.gray.opacity(0.05)]),
                                            startPoint: .top,
                                            endPoint: .bottom
                                        )
                                    )
                                    .shadow(color: Color.black.opacity(0.08), radius: 8, x: 0, y: 4)
                            )
                            .opacity(showContent ? 1 : 0)
                            .offset(y: showContent ? 0 : 30)
                            .animation(.easeOut(duration: 0.6).delay(0.4), value: showContent)
                            
                            VStack(alignment: .leading, spacing: 20) {
                                Text("Dear Students,")
                                    .font(.system(size: 18, weight: .semibold, design: .rounded))
                                    .foregroundColor(.accentColor)
                                
                                VStack(alignment: .leading, spacing: 16) {
                                    MessageParagraph(text: "As the honored Principal of this College, I feel privileged to welcome you all to the Govt. Islamia Graduate College Gujranwala in this new session, 2023-24.")
                                    
                                    MessageParagraph(text: "We are delighted that you are considering this college as a suitable institution to start or further your professional and academic higher education. We are driven by our guiding principle of providing good quality educational services.")
                                    
                                    MessageParagraph(text: "As a result, Govt. Islamia Graduate College Gujranwala has undergone outstanding transformations and enhancements since its inception in 1918.")
                                    
                                    MessageParagraph(text: "We believe in fostering an environment where academic excellence meets moral values, preparing our students not just for careers, but for meaningful contributions to society.")
                                    
                                    MessageParagraph(text: "I encourage you to make the most of the opportunities available here and wish you all the best in your academic journey.")
                                }
                                
                                VStack(alignment: .trailing, spacing: 8) {
                                    Divider()
                                        .padding(.vertical, 10)
                                    
                                    Text("With warm regards,")
                                        .font(.system(size: 16, weight: .medium))
                                        .italic()
                                        .foregroundColor(.secondary)
                                    
                                    Text("Dr. M. Akram Virk")
                                        .font(.system(size: 18, weight: .bold, design: .rounded))
                                        .foregroundColor(.accentColor)
                                    
                                    Text("Principal")
                                        .font(.system(size: 14, weight: .medium))
                                        .foregroundColor(.secondary)
                                        .padding(.horizontal, 12)
                                        .padding(.vertical, 4)
                                        .background(
                                            RoundedRectangle(cornerRadius: 8)
                                                .fill(Color.gray.opacity(0.1))
                                        )
                                }
                                .frame(maxWidth: .infinity, alignment: .trailing)
                                .padding(.top, 15)
                            }
                            .padding(.horizontal, 25)
                            .padding(.vertical, 30)
                            .background(
                                RoundedRectangle(cornerRadius: 20)
                                    .fill(Color.white)
                                    .shadow(color: Color.black.opacity(0.08), radius: 12, x: 0, y: 6)
                            )
                            .opacity(showContent ? 1 : 0)
                            .offset(y: showContent ? 0 : 50)
                            .animation(.easeOut(duration: 0.8).delay(0.6), value: showContent)
                        }
                        
                        Spacer(minLength: 80)
                    }
                    .padding(.horizontal, 20)
                }
            }
        }
        .background(
            LinearGradient(
                gradient: Gradient(colors: [Color.accentColor.opacity(0.1), Color.accentColor.opacity(0.1)]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        .navigationBarHidden(true)
        .onAppear {
            withAnimation {
                showContent = true
            }
        }
    }
}

struct MessageParagraph: View {
    let text: String
    
    var body: some View {
        Text(text)
            .font(.system(size: 16, weight: .regular))
            .foregroundColor(.primary)
            .lineSpacing(6)
            .multilineTextAlignment(.leading)
    }
}

#Preview {
    PrincipalView()
}
