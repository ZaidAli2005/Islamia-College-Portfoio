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
        VStack(spacing: 0) {
            HStack {
                Button(action: {
                    dismiss()
                }) {
                    HStack(spacing: 5) {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 16, weight: .medium))
                        Text("")
                            .font(.body)
                    }
                    .foregroundColor(.green)
                    .padding(.vertical, 8)
                    .padding(.horizontal, 12)
                    .background(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(Color.accentColor)
                    )
                }
                
                Spacer()
                
                Text("Principal")
                    .font(.title2)
                    .fontWeight(.semibold)
                    .foregroundColor(.black)
                
                Spacer()
                Color.clear
                    .frame(width: 80, height: 40)
            }
            .padding(.horizontal, 20)
            .padding(.top, 10)
            .padding(.bottom, 20)
            
            ScrollView {
                VStack(spacing: 30) {
                    VStack(spacing: 20) {
                        ZStack {
                            Circle()
                                .stroke(Color.accentColor, lineWidth: 4)
                                .frame(width: 120, height: 120)
                                .background(
                                    Circle()
                                        .fill(Color.white)
                                )
                            Image("Principel")
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 112, height: 112)
                                .clipShape(Circle())
                        }
                        .scaleEffect(showContent ? 1 : 0.8)
                        .opacity(showContent ? 1 : 0)
                        .animation(.spring(response: 0.6, dampingFraction: 0.8), value: showContent)
                        
                        Text("Dr. M. Akram Virk")
                            .font(.title)
                            .fontWeight(.semibold)
                            .foregroundColor(.black)
                            .opacity(showContent ? 1 : 0)
                            .offset(y: showContent ? 0 : 20)
                            .animation(.easeOut(duration: 0.6).delay(0.2), value: showContent)
                    }
                    .padding(.top, 20)
                    VStack(spacing: 20) {
                        HStack {
                            Image(systemName: "quote.opening")
                                .font(.title2)
                                .foregroundColor(.green)
                            
                            Text("Principal's Message")
                                .font(.title2)
                                .fontWeight(.medium)
                                .foregroundColor(.accentColor)
                            
                            Image(systemName: "quote.closing")
                                .font(.title2)
                                .foregroundColor(.green)
                        }
                        .padding(.horizontal)
                        .padding(.vertical, 15)
                        .background(
                            RoundedRectangle(cornerRadius: 15)
                                .fill(Color.gray.opacity(0.1))
                        )
                        .opacity(showContent ? 1 : 0)
                        .offset(y: showContent ? 0 : 30)
                        .animation(.easeOut(duration: 0.6).delay(0.4), value: showContent)
                        VStack(alignment: .leading, spacing: 16) {
                            Text("Dear Students,")
                                .font(.body)
                                .fontWeight(.medium)
                                .foregroundColor(.black)
                            
                            Text("As the honored Principal of this College, I feel privileged to welcome you all to the Govt. Islamia Graduate College Gujranwala in this new session, 2023-24.")
                                .font(.body)
                                .foregroundColor(.black)
                                .lineSpacing(4)
                            
                            Text("We are delighted that you are considering this college as a suitable institution to start or further your professional and academic higher education. We are driven by our guiding principle of providing good quality educational services.")
                                .font(.body)
                                .foregroundColor(.black)
                                .lineSpacing(4)
                            
                            Text("As a result, Govt. Islamia Graduate College Gujranwala has undergone outstanding transformations and enhancements since its inception in 1918.")
                                .font(.body)
                                .foregroundColor(.black)
                                .lineSpacing(4)
                            
                            Text("We believe in fostering an environment where academic excellence meets moral values, preparing our students not just for careers, but for meaningful contributions to society.")
                                .font(.body)
                                .foregroundColor(.black)
                                .lineSpacing(4)
                            
                            Text("I encourage you to make the most of the opportunities available here and wish you all the best in your academic journey.")
                                .font(.body)
                                .foregroundColor(.black)
                                .lineSpacing(4)
                            
                            VStack(alignment: .trailing, spacing: 4) {
                                Text("With warm regards,")
                                    .font(.body)
                                    .italic()
                                    .foregroundColor(.black)
                                
                                Text("Dr. M. Akram Virk")
                                    .font(.body)
                                    .fontWeight(.semibold)
                                    .foregroundColor(.green)
                                
                                Text("Principal")
                                    .font(.caption)
                                    .foregroundColor(.gray)
                            }
                            .frame(maxWidth: .infinity, alignment: .trailing)
                            .padding(.top, 10)
                        }
                        .padding(.horizontal, 20)
                        .padding(.vertical, 25)
                        .background(
                            RoundedRectangle(cornerRadius: 15)
                                .fill(Color.gray.opacity(0.05))
                        )
                        .opacity(showContent ? 1 : 0)
                        .offset(y: showContent ? 0 : 50)
                        .animation(.easeOut(duration: 0.8).delay(0.6), value: showContent)
                    }
                    
                    Spacer(minLength: 100)
                }
                .padding(.horizontal, 20)
            }
        }
        .navigationBarHidden(true)
        .onAppear {
            withAnimation {
                showContent = true
            }
        }
    }
}

#Preview {
    PrincipalView()
}
