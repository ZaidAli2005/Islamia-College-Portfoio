import Foundation

struct Department: Identifiable, Hashable {
    let id = UUID()
    let name: String
    let imageName: String
    let headOfDepartment: String?
    let description: String?
    let studentCount: Int?
    let teacherCount: Int?
    let establishedYear: Int?
    let programs: [String]?
    let facilities: [String]?
    let contactEmail: String?
    let contactPhone: String?
    
    static let sampleDepartments: [Department] = [
        Department(
            name: "BS IT Department",
            imageName: "IT",
            headOfDepartment: "Mr. Usman Ahmad Awan",
            description: "Our college environment is dedicated to providing a conducive atmosphere for studying and academic growth. Within our campus, you will find engaging classrooms that promote active learning and encourage student participation. Our faculty members are passionate about their subjects and are committed to helping you reach your full potential.",
            studentCount: 450,
            teacherCount: 12,
            establishedYear: 2010,
            programs: ["BS Information Technology", "MS Information Technology"],
            facilities: ["Computer Lab", "Software Development Lab", "Networking Lab", "Research Center"],
            contactEmail: "it@islamiacollege.edu.pk",
            contactPhone: "+92-300-1234567"
        ),
        Department(
            name: "BS Math Department",
            imageName: "Mathematics",
            headOfDepartment: "Mr. Fazal Ur Rehman",
            description: "The Mathematics Department is committed to excellence in teaching and research. We offer comprehensive programs that develop analytical thinking and problem-solving skills essential for various career paths.",
            studentCount: 320,
            teacherCount: 8,
            establishedYear: 1995,
            programs: ["BS Mathematics", "MS Mathematics"],
            facilities: ["Mathematics Lab", "Statistical Analysis Center", "Research Library"],
            contactEmail: "math@islamiacollege.edu.pk",
            contactPhone: "+92-300-2345678"
        ),
        Department(
            name: "BS Physics Department",
            imageName: "Physics",
            headOfDepartment: "Dr. M. Yousaf",
            description: "The Physics Department provides students with a strong foundation in theoretical and experimental physics. Our modern laboratories and experienced faculty ensure quality education in physical sciences.",
            studentCount: 280,
            teacherCount: 10,
            establishedYear: 1992,
            programs: ["BS Physics", "MS Physics"],
            facilities: ["Physics Lab", "Optics Lab", "Electronics Lab", "Research Workshop"],
            contactEmail: "physics@islamiacollege.edu.pk",
            contactPhone: "+92-300-3456789"
        ),
        Department(
            name: "BS Chemistry Department",
            imageName: "Chemistry",
            headOfDepartment: "Rana Khalid Mehmood",
            description: "The Chemistry Department offers comprehensive programs in chemical sciences with emphasis on both theoretical knowledge and practical laboratory skills. Our state-of-the-art facilities support advanced research.",
            studentCount: 350,
            teacherCount: 9,
            establishedYear: 1988,
            programs: ["BS Chemistry", "MS Chemistry"],
            facilities: ["Organic Chemistry Lab", "Inorganic Chemistry Lab", "Analytical Lab", "Instrumentation Lab"],
            contactEmail: "chemistry@islamiacollege.edu.pk",
            contactPhone: "+92-300-4567890"
        ),
        Department(
            name: "BS Zoology Department",
            imageName: "Zoology",
            headOfDepartment: "Dr. Iftikhar Ahmad",
            description: "The Zoology Department focuses on the study of animal life and biological systems. Our programs combine field work with laboratory research to provide comprehensive understanding of biological sciences.",
            studentCount: 220,
            teacherCount: 7,
            establishedYear: 1985,
            programs: ["BS Zoology", "MS Zoology"],
            facilities: ["Zoology Lab", "Microscopy Lab", "Specimen Museum", "Field Research Station"],
            contactEmail: "zoology@islamiacollege.edu.pk",
            contactPhone: "+92-300-5678901"
        ),
        Department(
            name: "BS English Department",
            imageName: "English",
            headOfDepartment: "Mr. Jameel Ahmed",
            description: "The English Department offers comprehensive programs in literature, linguistics, and communication skills. Our focus is on developing critical thinking and effective communication abilities.",
            studentCount: 400,
            teacherCount: 11,
            establishedYear: 1980,
            programs: ["BS English", "MS English Literature"],
            facilities: ["Language Lab", "Digital Library", "Writing Center", "Drama Studio"],
            contactEmail: "english@islamiacollege.edu.pk",
            contactPhone: "+92-300-7890123"
        ),
        Department(
            name: "BS Economics Department",
            imageName: "Economics",
            headOfDepartment: "Mr. Muhammad Mushtaq",
            description: "The Economics Department provides analytical tools and theoretical frameworks for understanding economic systems and policy making. Our programs prepare students for careers in finance and policy analysis.",
            studentCount: 300,
            teacherCount: 8,
            establishedYear: 1993,
            programs: ["BS Economics", "MS Economics"],
            facilities: ["Economics Lab", "Data Analysis Center", "Policy Research Unit"],
            contactEmail: "economics@islamiacollege.edu.pk",
            contactPhone: "+92-300-8901234"
        ),
        Department(
            name: "BS Political Science Department",
            imageName: "Political Science",
            headOfDepartment: "Mr. Farooq Ahmad",
            description: "The Political Science Department studies political systems, governance, and public policy. Our programs prepare students for careers in government, diplomacy, and public service.",
            studentCount: 180,
            teacherCount: 2,
            establishedYear: 1987,
            programs: ["BS Political Science", "MS Political Science"],
            facilities: ["Mock Parliament", "Policy Analysis Lab", "International Relations Center"],
            contactEmail: "political@islamiacollege.edu.pk",
            contactPhone: "+92-300-1234560"
        )
    ]
}

struct DepartmentStats {
    let totalDepartments: Int
    let totalStudents: String
    let totalTeachers: String
    
    static let collegeStats = DepartmentStats(
        totalDepartments: 11,
        totalStudents: "2.5K+",
        totalTeachers: "40+"
    )
    var actualStudentCount: Int {
        return Department.sampleDepartments.compactMap { $0.studentCount }.reduce(0, +)
    }
    
    var actualTeacherCount: Int {
        return Department.sampleDepartments.compactMap { $0.teacherCount }.reduce(0, +)
    }
}

enum DepartmentCategory: String, CaseIterable {
    case science = "Science"
    case arts = "Arts"
    case socialSciences = "Social Sciences"
    case technology = "Technology"
    
    var departments: [Department] {
        switch self {
        case .science:
            return Department.sampleDepartments.filter { dept in
                dept.name.contains("Physics") || dept.name.contains("Chemistry") ||
                dept.name.contains("Math") || dept.name.contains("Zoology") ||
                dept.name.contains("Botany")
            }
        case .technology:
            return Department.sampleDepartments.filter { dept in
                dept.name.contains("IT")
            }
        case .arts:
            return Department.sampleDepartments.filter { dept in
                dept.name.contains("English")
            }
        case .socialSciences:
            return Department.sampleDepartments.filter { dept in
                dept.name.contains("Psychology") || dept.name.contains("Sociology") ||
                dept.name.contains("Economics") || dept.name.contains("Political")
            }
        }
    }
}

struct FacultyMember: Identifiable, Hashable {
    let id = UUID()
    let name: String
    let designation: String
    let department: String
    let email: String?
    let phone: String?
    let specialization: [String]?
    let experience: Int?
    let education: [String]?
    let imageName: String?
}

struct CollegeInfo {
    static let name = "Islamia College"
    static let establishedYear = 1975
    static let location = "Gujranwala, Punjab, Pakistan"
    static let motto = "Knowledge, Excellence, Service"
    static let vision = "To be a leading institution of higher education committed to academic excellence and character development."
    static let mission = "To provide quality education and foster an environment that promotes intellectual growth, critical thinking, and moral values."
}
