//
//  TeachersDetailView.swift
//  Islamia College Portfolio
//
//  Created by Development on 20/06/2025.
//

import SwiftUI

struct TeachersDetailView: View {
    let teacher: Teacher
    @Environment(\.presentationMode) var presentationMode
    @State private var showFullScreenImage = false
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    HStack(spacing: 6) {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 22, weight: .semibold))
                    }
                    .foregroundColor(.accentColor)
                }
                
                Spacer()
                
                Text("Faculty Details")
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(.primary)
                
                Spacer()
                
                Color.clear
                    .frame(width: 60, height: 20)
            }
            .padding(.horizontal, 16)
            .padding(.top, 10)
            .padding(.bottom, 20)
            
            ScrollView {
                VStack(spacing: 32) {
                    VStack(spacing: 20) {
                        Group {
                            if !teacher.imageName.isEmpty {
                                Button(action: {
                                    showFullScreenImage = true
                                }) {
                                    Image(teacher.imageName)
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .frame(width: 130, height: 130)
                                        .clipShape(Circle())
                                }
                                .buttonStyle(PlainButtonStyle())
                            } else {
                                Circle()
                                    .fill(
                                        LinearGradient(
                                            colors: [.accentColor, .accentColor],
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing
                                        )
                                    )
                                    .frame(width: 130, height: 130)
                                    .overlay(
                                        Text(String(teacher.name.prefix(1)))
                                            .font(.system(size: 48, weight: .bold))
                                            .foregroundColor(.white)
                                    )
                            }
                        }
                        .shadow(color: .black, radius: 8, x: 0, y: 4)
                        
                        VStack(spacing: 8) {
                            Text(teacher.name)
                                .font(.system(size: 26, weight: .bold))
                                .foregroundColor(.primary)
                                .multilineTextAlignment(.center)
                            
                            Text(teacher.department)
                                .font(.system(size: 18, weight: .medium))
                                .foregroundColor(.secondary)
                                .multilineTextAlignment(.center)
                        }
                    }
                    .padding(.top, 20)
                    
                    VStack(spacing: 24) {
                        DetailSectionView(
                            icon: "graduationcap.fill",
                            iconColor: .accentColor,
                            title: "Designation",
                            content: AnyView(
                                Text(teacher.designation)
                                    .font(.system(size: 16, weight: .medium))
                                    .foregroundColor(.primary)
                            )
                        )
                        
                        Divider()
                            .background(Color(.systemGray4))
                        
                        DetailSectionView(
                            icon: "book.fill",
                            iconColor: .accentColor,
                            title: "Education",
                            content: AnyView(
                                VStack(alignment: .leading, spacing: 8) {
                                    ForEach(teacher.education, id: \.self) { edu in
                                        HStack {
                                            Circle()
                                                .fill(Color.accentColor)
                                                .frame(width: 6, height: 6)
                                            Text(edu)
                                                .font(.system(size: 16, weight: .medium))
                                                .foregroundColor(.primary)
                                            Spacer()
                                        }
                                    }
                                }
                            )
                        )
                        
                        Divider()
                            .background(Color(.systemGray4))
                        
                        DetailSectionView(
                            icon: "envelope.fill",
                            iconColor: .accentColor,
                            title: "Email",
                            content: AnyView(
                                Button(action: {
                                    if let url = URL(string: "mailto:\(teacher.email)") {
                                        UIApplication.shared.open(url)
                                    }
                                }) {
                                    Text(teacher.email)
                                        .font(.system(size: 16, weight: .medium))
                                        .foregroundColor(.blue)
                                        .underline()
                                }
                                .buttonStyle(PlainButtonStyle())
                            )
                        )
                        
                        Divider()
                            .background(Color(.systemGray4))
                        
                        DetailSectionView(
                            icon: "phone.fill",
                            iconColor: .accentColor,
                            title: "Contact",
                            content: AnyView(
                                VStack(alignment: .leading, spacing: 8) {
                                    ForEach(teacher.contactNumbers, id: \.self) { contact in
                                        Button(action: {
                                            if let url = URL(string: "tel:\(contact)") {
                                                UIApplication.shared.open(url)
                                            }
                                        }) {
                                            Text(contact)
                                                .font(.system(size: 16, weight: .medium))
                                                .foregroundColor(.blue)
                                                .underline()
                                        }
                                        .buttonStyle(PlainButtonStyle())
                                    }
                                }
                            )
                        )
                    }
                    .padding(24)
                    .background(Color.white)
                    .cornerRadius(20)
                    .shadow(color: .black, radius: 8, x: 0, y: 4)
                    .padding(.horizontal, 16)
                    
                    Spacer(minLength: 100)
                }
            }
        }
        .background(Color(.systemGroupedBackground))
        .navigationBarHidden(true)
        .fullScreenCover(isPresented: $showFullScreenImage) {
            FullScreenImageView(imageName: teacher.imageName, isPresented: $showFullScreenImage)
        }
    }
}

struct FullScreenImageView: View {
    let imageName: String
    @Binding var isPresented: Bool
    @State private var scale: CGFloat = 1.0
    @State private var offset: CGSize = .zero
    @State private var lastOffset: CGSize = .zero
    
    var body: some View {
        ZStack {
            Color.black
                .ignoresSafeArea()
            
            VStack {
                HStack {
                    Spacer()
                    Button(action: {
                        isPresented = false
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .font(.system(size: 30))
                            .foregroundColor(.white)
                            .background(Color.black.opacity(0.6))
                            .clipShape(Circle())
                    }
                    .padding()
                }
                
                Spacer()
                
                Image(imageName)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .scaleEffect(scale)
                    .offset(offset)
                    .gesture(
                        SimultaneousGesture(
                            MagnificationGesture()
                                .onChanged { value in
                                    scale = value
                                }
                                .onEnded { value in
                                    if scale < 1.0 {
                                        withAnimation(.spring()) {
                                            scale = 1.0
                                        }
                                    } else if scale > 3.0 {
                                        withAnimation(.spring()) {
                                            scale = 3.0
                                        }
                                    }
                                },
                            DragGesture()
                                .onChanged { value in
                                    offset = CGSize(
                                        width: lastOffset.width + value.translation.width,
                                        height: lastOffset.height + value.translation.height
                                    )
                                }
                                .onEnded { value in
                                    lastOffset = offset
                                }
                        )
                    )
                    .onTapGesture(count: 2) {
                        withAnimation(.spring()) {
                            if scale > 1.0 {
                                scale = 1.0
                                offset = .zero
                                lastOffset = .zero
                            } else {
                                scale = 2.0
                            }
                        }
                    }
                
                Spacer()
            }
        }
    }
}

struct DetailSectionView: View {
    let icon: String
    let iconColor: Color
    let title: String
    let content: AnyView
    
    var body: some View {
        HStack(alignment: .top, spacing: 16) {
            ZStack {
                Circle()
                    .fill(iconColor)
                    .frame(width: 36, height: 36)
                
                Image(systemName: icon)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.white)
            }
            
            VStack(alignment: .leading, spacing: 8) {
                Text(title)
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(.secondary)
                    .textCase(.uppercase)
                    .tracking(0.5)
                
                content
            }
            
            Spacer()
        }
    }
}

#Preview() {
    TeachersDetailView(teacher: Teacher.mockData[0])
}
