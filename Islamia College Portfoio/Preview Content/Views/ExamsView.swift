//
//  ExamsView.swift
//  Islamia College Portfolio
//
//  Created by Development on 01/07/2025.
//

import SwiftUI

enum ExamLevel: String, CaseIterable {
    case inter = "Inter"
    case bs = "BS"
}

struct ExamsView: View {
    @State private var selectedLevel: ExamLevel? = nil
    @State private var showingExamDetails = false
    
    var body: some View {
        NavigationView {
            if selectedLevel == nil {
                GeometryReader { geometry in
                    ZStack {
                        LinearGradient(
                            gradient: Gradient(colors: [Color.accentColor.opacity(0.1), Color.accentColor.opacity(0.1)]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                        .ignoresSafeArea()
                        
                        VStack(spacing: 0) {
                            VStack(spacing: 10) {
                                Text("Select Exam Level")
                                    .font(.title)
                                    .fontWeight(.bold)
                                    .foregroundColor(.primary)
                                
                                Text("Choose your academic level to view exam details")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                                    .multilineTextAlignment(.center)
                            }
                            .padding(.horizontal)
                            .padding(.bottom, 40)
                            
                            VStack(spacing: 20) {
                                ForEach(ExamLevel.allCases, id: \.self) { level in
                                    Button(action: {
                                        selectedLevel = level
                                        showingExamDetails = true
                                    }) {
                                        HStack(spacing: 20) {
                                            ZStack {
                                                Circle()
                                                    .fill(level == .inter ? Color.accentColor.opacity(0.2) : Color.accentColor.opacity(0.2))
                                                    .frame(width: 60, height: 60)
                                                
                                                Image(systemName: level == .inter ? "graduationcap.fill" : "graduationcap.fill")
                                                    .font(.title2)
                                                    .foregroundColor(level == .inter ? .accentColor : .accentColor)
                                            }
                                            
                                            VStack(alignment: .leading, spacing: 5) {
                                                Text(level.rawValue)
                                                    .font(.title2)
                                                    .fontWeight(.bold)
                                                    .foregroundColor(.primary)
                                                
                                                Text(level == .inter ? "Intermediate Level" : "Bachelor's Degree")
                                                    .font(.subheadline)
                                                    .foregroundColor(.secondary)
                                                
                                                Text(level == .inter ? "2 Year Program" : "4 Year Program")
                                                    .font(.caption)
                                                    .foregroundColor(.blue)
                                                    .fontWeight(.medium)
                                            }
                                            
                                            Spacer()
                                            
                                            Image(systemName: "chevron.right")
                                                .font(.title3)
                                                .foregroundColor(.gray)
                                        }
                                        .padding(20)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                        .background(
                                            RoundedRectangle(cornerRadius: 16)
                                                .fill(Color.white)
                                                .shadow(color: .gray.opacity(0.15), radius: 8, x: 0, y: 2)
                                        )
                                    }
                                    .buttonStyle(PlainButtonStyle())
                                }
                            }
                            .padding(.horizontal, 20)
                            
                            Spacer()
                            
                            VStack(spacing: 8) {
                                Text("Islamia College")
                                    .font(.caption)
                                    .fontWeight(.medium)
                                    .foregroundColor(.blue)
                                
                                Text("Academic Excellence Since 1947")
                                    .font(.caption2)
                                    .foregroundColor(.secondary)
                            }
                            .padding(.bottom, 20)
                        }
                    }
                }
            } else {
                ExamDetailsView(level: selectedLevel!) {
                    selectedLevel = nil
                    showingExamDetails = false
                }
            }
        }
    }
}

struct ExamDetailsView: View {
    let level: ExamLevel
    let onBack: () -> Void
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                VStack(alignment: .leading, spacing: 15) {
                    
                    if level == .inter {
                        PolicyCard(
                            icon: "percent",
                            title: "Mid Exam Passing Marks",
                            description: "40% minimum required to pass mid-term examinations",
                            color: .green
                        )
                        
                        PolicyCard(
                            icon: "clock",
                            title: "Exam Duration",
                            description: "2 hours for each subject",
                            color: .orange
                        )
                        
                        PolicyCard(
                            icon: "book.closed",
                            title: "Total Subjects",
                            description: "4 core subjects: Physics, Chemistry, Mathematics, English",
                            color: .purple
                        )
                        
                        PolicyCard(
                            icon: "calendar",
                            title: "Exam Schedule",
                            description: "Mid-term: January & June\nFinal: May & November",
                            color: .blue
                        )
                        
                        PolicyCard(
                            icon: "exclamationmark.triangle",
                            title: "Attendance Policy",
                            description: "Minimum 75% attendance required to appear in exams",
                            color: .red
                        )
                        
                        PolicyCard(
                            icon: "doc.text",
                            title: "Result Criteria",
                            description: "Overall 45% required for annual promotion",
                            color: .indigo
                        )
                        
                    } else {
                        PolicyCard(
                            icon: "percent",
                            title: "Mid Exam Passing Marks",
                            description: "50% minimum required to pass mid-term examinations",
                            color: .green
                        )
                        
                        PolicyCard(
                            icon: "clock",
                            title: "Exam Duration",
                            description: "3 hours for each subject",
                            color: .orange
                        )
                        
                        PolicyCard(
                            icon: "graduationcap",
                            title: "Degree Requirements",
                            description: "4-year program with 8 semesters\nMinimum 2.0 CGPA required",
                            color: .purple
                        )
                        
                        PolicyCard(
                            icon: "calendar",
                            title: "Exam Schedule",
                            description: "Mid-term: March & October\nFinal: June & December",
                            color: .blue
                        )
                        
                        PolicyCard(
                            icon: "exclamationmark.triangle",
                            title: "Attendance Policy",
                            description: "Minimum 80% attendance required to appear in exams",
                            color: .red
                        )
                        
                        PolicyCard(
                            icon: "chart.line.uptrend.xyaxis",
                            title: "GPA System",
                            description: "4.0 scale grading system\nA+ = 4.0, A = 3.7, B+ = 3.3, etc.",
                            color: .indigo
                        )
                        
                        PolicyCard(
                            icon: "book.closed",
                            title: "Credit Hours",
                            description: "Total 136 credit hours required for graduation",
                            color: .teal
                        )
                    }
                }
                .padding(.horizontal)
                
                VStack(alignment: .leading, spacing: 15) {
                    Text("Important Guidelines")
                        .font(.title2)
                        .fontWeight(.semibold)
                        .foregroundColor(.blue)
                        .padding(.top)
                    
                    VStack(alignment: .leading, spacing: 10) {
                        GuidelineRow(text: "Bring valid student ID card to exam hall")
                        GuidelineRow(text: "Mobile phones are strictly prohibited")
                        GuidelineRow(text: "Arrive 30 minutes before exam time")
                        GuidelineRow(text: "Use only blue/black ink pens")
                        GuidelineRow(text: "No eating or drinking during exam")
                        GuidelineRow(text: "Maintain complete silence in exam hall")
                    }
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color(.systemGray6))
                    )
                }
                .padding(.horizontal)
                
                Spacer(minLength: 20)
            }
        }
        .background(
            LinearGradient(
                gradient: Gradient(colors: [Color.accentColor.opacity(0.1), Color.accentColor.opacity(0.1)]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        .navigationTitle(level.rawValue)
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: onBack) {
                    HStack {
                        Image(systemName: "chevron.left")
                        Text("Back")
                    }
                }
            }
        }
    }
}

struct PolicyCard: View {
    let icon: String
    let title: String
    let description: String
    let color: Color
    
    var body: some View {
        HStack(alignment: .top, spacing: 15) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(color)
                .frame(width: 30)
            
            VStack(alignment: .leading, spacing: 5) {
                Text(title)
                    .font(.headline)
                    .fontWeight(.semibold)
                
                Text(description)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.leading)
            }
            
            Spacer()
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.white)
                .shadow(color: .gray.opacity(0.2), radius: 3, x: 0, y: 2)
        )
    }
}

struct GuidelineRow: View {
    let text: String
    
    var body: some View {
        HStack(alignment: .top, spacing: 10) {
            Image(systemName: "checkmark.circle.fill")
                .foregroundColor(.green)
                .font(.caption)
            
            Text(text)
                .font(.subheadline)
                .foregroundColor(.primary)
            
            Spacer()
        }
    }
}

#Preview {
    ExamsView()
}
