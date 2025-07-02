//
//  Teacher.swift
//  Islamia College Portfolio
//
//  Created by Development on 20/06/2025.
//

import Foundation

struct Teacher: Identifiable, Hashable {
    let id = UUID()
    let name: String
    let department: String
    let designation: String
    let imageName: String
    let education: [String]
    let email: String
    let contactNumbers: [String]
    
    static let mockData: [Teacher] = [
        Teacher(
            name: "Prof. Usman",
            department: "HOD OF IT Department",
            designation: "Associate Professor",
            imageName: "Usman",
            education: [
                "Master in Computer Science (MCS)",
                "Master of Science in Computer Science"
            ],
            email: "usmanahmadawan@gmail.com",
            contactNumbers: ["+92 554 210116", "+92 321 6433134"]
        ),
        Teacher(
            name: "Prof. Muhammad Asif",
            department: "IT Department",
            designation: "Assistant Professor",
            imageName: "Asif",
            education: [
                "Master in Computer Science (MCS)",
                "Bachelor of Science in Computer Science"
            ],
            email: "asif.muhammad@gmail.com",
            contactNumbers: ["+92 300 1234567"]
        ),
        Teacher(
            name: "Prof. Imran Shafique",
            department: "IT Department",
            designation: "Lecturer",
            imageName: "Imran",
            education: [
                "Master in Computer Science (MCS)"
            ],
            email: "imran.shafique@gmail.com",
            contactNumbers: ["+92 301 9876543"]
        ),
        Teacher(
            name: "Prof. Jameel Ahmed",
            department: "HOD OF English Department",
            designation: "Associate Professor",
            imageName: "Jameel Ahmad",
            education: [
                "Master of Arts in English Literature",
                "Bachelor of Arts in English"
            ],
            email: "jameel.ahmed@gmail.com",
            contactNumbers: ["+92 302 5551234"]
        ),
        Teacher(
            name: "Prof. Bilawal",
            department: "English Department",
            designation: "Lecturer",
            imageName: "Bilawal",
            education: [
                "Master of Arts in English Literature"
            ],
            email: "bilawal.prof@gmail.com",
            contactNumbers: ["+92 303 7778888"]
        ),
        Teacher(
            name: "Prof. Muhammad Awais",
            department: "English Department",
            designation: "Assistant Professor",
            imageName: "Awais",
            education: [
                "Master of Arts in English Literature",
                "Bachelor of Arts in English"
            ],
            email: "awais.muhammad@gmail.com",
            contactNumbers: ["+92 304 9990000"]
        ),
        Teacher(
            name: "Prof. Muhammad Abdul Shakoor",
            department: "Math Department",
            designation: "Assistant Professor",
            imageName: "Abdul Shakoor",
            education: [
                "Bachelor of Arts in Math"
            ],
            email: "abdulshakoor@gmail.com",
            contactNumbers: ["+92 304 9990000"]
        ),
        Teacher(
            name: "Prof. Muhammad Bilal",
            department: "Math Department",
            designation: "Assistant Professor",
            imageName: "Bilal",
            education: [
                "Bachelor of Arts in Math"
            ],
            email: "bilal@gmail.com",
            contactNumbers: ["+92 304 9990000"]
        ),
    ]
}

enum Departments: String, CaseIterable {
    case all = "All"
    case it = "IT"
    case english = "English"
    case zoology = "Zoology"
    case economics = "Economics"
}
