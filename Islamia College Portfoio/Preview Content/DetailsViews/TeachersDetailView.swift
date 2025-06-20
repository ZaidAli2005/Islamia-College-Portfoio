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
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    HStack(spacing: 4) {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 16, weight: .medium))
                        Text("Back")
                            .font(.system(size: 17, weight: .regular))
                    }
                    .foregroundColor(.accentColor)
                }
                
                Spacer()
                
                Text("Details")
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundColor(.black)
                
                Spacer()
                HStack(spacing: 4) {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 16, weight: .medium))
                    Text("Back")
                        .font(.system(size: 17, weight: .regular))
                }
                .opacity(0)
            }
            .padding(.horizontal, 16)
            .padding(.top, 10)
            .padding(.bottom, 30)
            
            ScrollView {
                VStack(spacing: 24) {
                    VStack(spacing: 16) {
                        AsyncImage(url: URL(string: "https://via.placeholder.com/120")) { image in
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                        } placeholder: {
                            Circle()
                                .fill(Color.blue.opacity(0.3))
                                .overlay(
                                    Text(String(teacher.name.prefix(1)))
                                        .font(.system(size: 40, weight: .medium))
                                        .foregroundColor(.white)
                                )
                        }
                        .frame(width: 120, height: 120)
                        .clipShape(Circle())
                        VStack(spacing: 8) {
                            Text(teacher.name)
                                .font(.system(size: 24, weight: .bold))
                                .foregroundColor(.black)
                            
                            Text(teacher.department)
                                .font(.system(size: 16, weight: .regular))
                                .foregroundColor(.gray)
                        }
                    }
                    .padding(.top, 20)
                    VStack(spacing: 0) {
                        DetailSectionView(
                            icon: "book.fill",
                            iconColor: .accentColor,
                            title: "Education",
                            content: AnyView(
                                VStack(alignment: .leading, spacing: 8) {
                                    ForEach(teacher.education, id: \.self) { edu in
                                        Text(edu)
                                            .font(.system(size: 16, weight: .medium))
                                            .foregroundColor(.black)
                                    }
                                }
                            )
                        )
                        
                        Divider()
                            .padding(.vertical, 16)
                        DetailSectionView(
                            icon: "graduationcap.fill",
                            iconColor: .accentColor,
                            title: "Designation",
                            content: AnyView(
                                Text(teacher.designation)
                                    .font(.system(size: 16, weight: .medium))
                                    .foregroundColor(.black)
                            )
                        )
                        
                        Divider()
                            .padding(.vertical, 16)
                        DetailSectionView(
                            icon: "envelope.fill",
                            iconColor: .accentColor,
                            title: "Email",
                            content: AnyView(
                                Text(teacher.email)
                                    .font(.system(size: 16, weight: .medium))
                                    .foregroundColor(.black)
                            )
                        )
                        
                        Divider()
                            .padding(.vertical, 16)
                        DetailSectionView(
                            icon: "phone.fill",
                            iconColor: .accentColor,
                            title: "Contact",
                            content: AnyView(
                                Text(teacher.contactNumbers.joined(separator: "  "))
                                    .font(.system(size: 16, weight: .medium))
                                    .foregroundColor(.black)
                            )
                        )
                    }
                    .padding(20)
                    .background(Color(UIColor.systemGray6))
                    .cornerRadius(12)
                    .padding(.horizontal, 16)
                    
                    Spacer(minLength: 100)
                }
            }
        }
        .background(Color(UIColor.systemBackground))
        .navigationBarHidden(true)
    }
}

struct DetailSectionView: View {
    let icon: String
    let iconColor: Color
    let title: String
    let content: AnyView
    
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(iconColor)
                .frame(width: 20)
            
            VStack(alignment: .leading, spacing: 8) {
                Text(title)
                    .font(.system(size: 14, weight: .regular))
                    .foregroundColor(.gray)
                
                content
            }
            
            Spacer()
        }
    }
}

#Preview() {
    TeachersDetailView(teacher: Teacher.mockData[0])
}
