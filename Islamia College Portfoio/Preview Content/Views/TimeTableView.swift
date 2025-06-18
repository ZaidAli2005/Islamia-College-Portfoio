//
//  TimeTableView.swift
//  Islamia College Portfolio
//
//  Created by Development on 17/06/2025.
//

import SwiftUI

struct TimeTableView: View {
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 0) {
                    VStack(alignment: .leading, spacing: 16) {
                        HStack {
                            Image(systemName: "sun.max.fill")
                                .foregroundColor(.green)
                                .font(.title2)
                            Text("Morning Schedule")
                                .font(.title2)
                                .fontWeight(.semibold)
                                .foregroundColor(.green)
                            Spacer()
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 20)
                        
                        VStack(spacing: 12) {
                            SubjectCard(
                                subject: "Mathematics",
                                time: "7:00 AM - 11:15 AM",
                                days: "Mon - Thurs",
                                professor: "Prof. Fazal Ur Rehman"
                            )
                            
                            SubjectCard(
                                subject: "Physics",
                                time: "7:00 AM - 11:15 AM",
                                days: "Mon - Thurs",
                                professor: "Prof. Dr. M. Yousaf"
                            )
                            
                            SubjectCard(
                                subject: "Chemistry",
                                time: "7:00 AM - 11:15 PM",
                                days: "Mon - Thurs",
                                professor: "Prof. Rana Khalid Mehmood"
                            )
                            
                            SubjectCard(
                                subject: "IT",
                                time: "7:00 AM - 11:15 PM",
                                days: "Mon - Thurs",
                                professor: "Prof. Usman"
                            )
                            
                            SubjectCard(
                                subject: "Zology",
                                time: "7:00 AM - 11:15 PM",
                                days: "Mon - Thurs",
                                professor: "Dr. Brown"
                            )
                            
                            SubjectCard(
                                subject: "Statics",
                                time: "7:00 AM - 11:15 PM",
                                days: "Mon - Thurs",
                                professor: "Dr. Brown"
                            )
                            
                            SubjectCard(
                                subject: "Chemistry",
                                time: "7:00 AM - 11:15 PM",
                                days: "Mon - Thurs",
                                professor: "Dr. Brown"
                            )
                        }
                        .padding(.horizontal, 20)
                        .padding(.bottom, 20)
                    }
                    .background(Color.blue.opacity(0.1))
                    .cornerRadius(16)
                    .padding(.horizontal, 16)
                    VStack(alignment: .leading, spacing: 16) {
                        HStack {
                            Image(systemName: "moon.fill")
                                .foregroundColor(.green)
                                .font(.title2)
                            Text("Evening Schedule")
                                .font(.title2)
                                .fontWeight(.semibold)
                                .foregroundColor(.green)
                            Spacer()
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 20)
                        
                        VStack(spacing: 12) {
                            SubjectCard(
                                subject: "Mathematics",
                                time: "11:30 AM - 3:00 PM",
                                days: "Mon - Thurs",
                                professor: "Prof. Fazal Ur Rehman"
                            )
                            
                            SubjectCard(
                                subject: "Physics",
                                time: "11:30 AM - 3:00 PM",
                                days: "Mon - Thurs",
                                professor: "Prof. Dr. M. Yousaf"
                            )
                            
                            SubjectCard(
                                subject: "Chemistry",
                                time: "11:30 AM - 3:00 PM",
                                days: "Mon - Thurs",
                                professor: "Prof. Rana Khalid Mehmood"
                            )
                            
                            SubjectCard(
                                subject: "IT",
                                time: "11:30 AM - 3:00 PM",
                                days: "Mon - Thurs",
                                professor: "Prof. Usman"
                            )
                            
                            SubjectCard(
                                subject: "Zology",
                                time: "11:30 AM - 3:00 PM",
                                days: "Mon - Thurs",
                                professor: "Dr. Brown"
                            )
                            
                            SubjectCard(
                                subject: "Statics",
                                time: "11:30 AM - 3:00 PM",
                                days: "Mon - Thurs",
                                professor: "Dr. Brown"
                            )
                            
                            SubjectCard(
                                subject: "Chemistry",
                                time: "11:30 AM - 3:00 PM",
                                days: "Mon - Thurs",
                                professor: "Dr. Brown"
                            )
                        }
                        .padding(.horizontal, 20)
                        .padding(.bottom, 20)
                    }
                    .background(Color.orange.opacity(0.1))
                    .cornerRadius(16)
                    .padding(.horizontal, 16)
                    .padding(.top, 24)
                    
                    Spacer(minLength: 100)
                }
            }
            .navigationTitle("Time Table")
            .navigationBarTitleDisplayMode(.large)
            .navigationBarBackButtonHidden(false)
        }
    }
}

struct SubjectCard: View {
    let subject: String
    let time: String
    let days: String
    let professor: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(subject)
                        .font(.headline)
                        .fontWeight(.semibold)
                        .foregroundColor(.primary)
                    
                    Text(time)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: 4) {
                    Text(days)
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .foregroundColor(.green)
                    
                    Text(professor)
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.trailing)
                }
            }
        }
        .padding(16)
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.05), radius: 2, x: 0, y: 1)
    }
}

#Preview {
    TimeTableView()
}
