//
//  LibraryModels.swift
//  Islamia College Portfolio
//
//  Created by Development on 17/06/2025.
//

import Foundation

// MARK: - Book Model
struct Book: Identifiable, Codable {
    let id = UUID()
    let title: String
    let author: String
    let publisher: String
    let year: Int
    let isbn: String
    let pages: Int
    let location: String
    let dateAdded: Date
    let description: String
    let rating: Double
    let timesBorrowed: Int
    let isAvailable: Bool
    let category: BookCategory
    
    var isCheckedOut: Bool {
        return !isAvailable
    }
    
    var formattedRating: String {
        return String(format: "%.1f", rating)
    }
    
    var formattedDateAdded: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        return formatter.string(from: dateAdded)
    }
}

// MARK: - Book Category
enum BookCategory: String, CaseIterable, Codable {
    case all = "All"
    case books = "Books"
    case journals = "Journals"
    case research = "Research"
    
    var displayName: String {
        return self.rawValue
    }
}

// MARK: - Library Statistics
struct LibraryStats {
    let totalBooks: Int
    let availableBooks: Int
    let averageRating: Double
    
    var formattedAverageRating: String {
        return String(format: "%.1f", averageRating)
    }
}

// MARK: - Sort Options
enum SortOption: String, CaseIterable {
    case title = "Title"
    case author = "Author"
    case year = "Year"
    case rating = "Rating"
    case timesBorrowed = "Times Borrowed"
    
    var displayName: String {
        return self.rawValue
    }
}

// MARK: - Sample Data
struct SampleData {
    static let books: [Book] = [
        Book(
            title: "1984",
            author: "George Orwell",
            publisher: "Secker & Warburg",
            year: 1949,
            isbn: "978-0-452-28423-4",
            pages: 328,
            location: "Floor 2, Section LIT-100",
            dateAdded: Date(),
            description: "A dystopian social science fiction novel and cautionary tale.",
            rating: 4.9,
            timesBorrowed: 234,
            isAvailable: false,
            category: .books
        ),
        Book(
            title: "A Brief History of Time",
            author: "Stephen Hawking",
            publisher: "Bantam Books",
            year: 1988,
            isbn: "978-0-553-38016-3",
            pages: 256,
            location: "Floor 2, Section PHYS-400",
            dateAdded: Calendar.current.date(byAdding: .day, value: -30, to: Date()) ?? Date(),
            description: "Hawking's attempt to explain cosmology to the general public.",
            rating: 4.8,
            timesBorrowed: 201,
            isAvailable: true,
            category: .books
        ),
        Book(
            title: "Becoming",
            author: "Michelle Obama",
            publisher: "Crown Publishing",
            year: 2018,
            isbn: "978-1-524-76313-8",
            pages: 448,
            location: "Floor 1, Section BIOG-100",
            dateAdded: Calendar.current.date(byAdding: .day, value: -60, to: Date()) ?? Date(),
            description: "A memoir by former First Lady Michelle Obama.",
            rating: 4.8,
            timesBorrowed: 456,
            isAvailable: true,
            category: .books
        ),
        Book(
            title: "To Kill a Mockingbird",
            author: "Harper Lee",
            publisher: "J.B. Lippincott & Co.",
            year: 1960,
            isbn: "978-0-06-112008-4",
            pages: 376,
            location: "Floor 2, Section LIT-200",
            dateAdded: Calendar.current.date(byAdding: .day, value: -90, to: Date()) ?? Date(),
            description: "A novel about racial injustice and moral growth in the American South.",
            rating: 4.7,
            timesBorrowed: 189,
            isAvailable: true,
            category: .books
        ),
        Book(
            title: "The Great Gatsby",
            author: "F. Scott Fitzgerald",
            publisher: "Charles Scribner's Sons",
            year: 1925,
            isbn: "978-0-7432-7356-5",
            pages: 180,
            location: "Floor 2, Section LIT-150",
            dateAdded: Calendar.current.date(byAdding: .day, value: -45, to: Date()) ?? Date(),
            description: "A classic American novel set in the Jazz Age.",
            rating: 4.2,
            timesBorrowed: 145,
            isAvailable: false,
            category: .books
        ),
        Book(
            title: "Sapiens: A Brief History of Humankind",
            author: "Yuval Noah Harari",
            publisher: "Harvill Secker",
            year: 2011,
            isbn: "978-0-06-231609-7",
            pages: 443,
            location: "Floor 3, Section HIST-300",
            dateAdded: Calendar.current.date(byAdding: .day, value: -15, to: Date()) ?? Date(),
            description: "An exploration of how Homo sapiens came to dominate the world.",
            rating: 4.6,
            timesBorrowed: 278,
            isAvailable: true,
            category: .books
        ),
        Book(
            title: "The Catcher in the Rye",
            author: "J.D. Salinger",
            publisher: "Little, Brown and Company",
            year: 1951,
            isbn: "978-0-316-76948-0",
            pages: 277,
            location: "Floor 2, Section LIT-120",
            dateAdded: Calendar.current.date(byAdding: .day, value: -75, to: Date()) ?? Date(),
            description: "A coming-of-age story following teenager Holden Caulfield.",
            rating: 4.0,
            timesBorrowed: 167,
            isAvailable: true,
            category: .books
        ),
        Book(
            title: "Pride and Prejudice",
            author: "Jane Austen",
            publisher: "T. Egerton",
            year: 1813,
            isbn: "978-0-14-143951-8",
            pages: 432,
            location: "Floor 2, Section LIT-180",
            dateAdded: Calendar.current.date(byAdding: .day, value: -120, to: Date()) ?? Date(),
            description: "A romantic novel dealing with issues of marriage, money, and social status.",
            rating: 4.5,
            timesBorrowed: 298,
            isAvailable: false,
            category: .books
        ),
        Book(
            title: "The Origin of Species",
            author: "Charles Darwin",
            publisher: "John Murray",
            year: 1859,
            isbn: "978-0-14-043205-0",
            pages: 502,
            location: "Floor 3, Section SCI-250",
            dateAdded: Calendar.current.date(byAdding: .day, value: -100, to: Date()) ?? Date(),
            description: "Darwin's groundbreaking work on the theory of evolution.",
            rating: 4.3,
            timesBorrowed: 112,
            isAvailable: true,
            category: .books
        ),
        Book(
            title: "Educated",
            author: "Tara Westover",
            publisher: "Random House",
            year: 2018,
            isbn: "978-0-399-59050-4",
            pages: 334,
            location: "Floor 1, Section BIOG-150",
            dateAdded: Calendar.current.date(byAdding: .day, value: -20, to: Date()) ?? Date(),
            description: "A memoir about education and the struggle for self-invention.",
            rating: 4.7,
            timesBorrowed: 203,
            isAvailable: true,
            category: .books
        ),
        Book(
            title: "Nature Biotechnology Journal",
            author: "Various Authors",
            publisher: "Nature Publishing Group",
            year: 2024,
            isbn: "ISSN-1087-0156",
            pages: 120,
            location: "Floor 4, Section JOUR-BIO",
            dateAdded: Calendar.current.date(byAdding: .day, value: -5, to: Date()) ?? Date(),
            description: "Monthly journal covering biotechnology research and applications.",
            rating: 4.4,
            timesBorrowed: 89,
            isAvailable: true,
            category: .journals
        ),
        Book(
            title: "Computer Science Review",
            author: "Various Authors",
            publisher: "Elsevier",
            year: 2024,
            isbn: "ISSN-1574-0137",
            pages: 95,
            location: "Floor 4, Section JOUR-CS",
            dateAdded: Calendar.current.date(byAdding: .day, value: -10, to: Date()) ?? Date(),
            description: "Quarterly review journal in computer science and engineering.",
            rating: 4.2,
            timesBorrowed: 67,
            isAvailable: false,
            category: .journals
        ),
        Book(
            title: "Journal of Islamic Studies",
            author: "Various Authors",
            publisher: "Oxford University Press",
            year: 2024,
            isbn: "ISSN-0955-2340",
            pages: 150,
            location: "Floor 1, Section JOUR-IS",
            dateAdded: Calendar.current.date(byAdding: .day, value: -7, to: Date()) ?? Date(),
            description: "Academic journal focusing on Islamic civilization and contemporary issues.",
            rating: 4.6,
            timesBorrowed: 134,
            isAvailable: true,
            category: .journals
        ),
        Book(
            title: "Machine Learning in Healthcare",
            author: "Dr. Sarah Johnson",
            publisher: "Academic Press",
            year: 2023,
            isbn: "978-0-323-85245-6",
            pages: 289,
            location: "Floor 5, Section RES-ML",
            dateAdded: Calendar.current.date(byAdding: .day, value: -25, to: Date()) ?? Date(),
            description: "Research compilation on AI applications in medical diagnosis and treatment.",
            rating: 4.5,
            timesBorrowed: 78,
            isAvailable: true,
            category: .research
        ),
        Book(
            title: "Climate Change Impact Studies",
            author: "Dr. Michael Green",
            publisher: "Environmental Research Press",
            year: 2023,
            isbn: "978-0-128-82456-3",
            pages: 412,
            location: "Floor 5, Section RES-ENV",
            dateAdded: Calendar.current.date(byAdding: .day, value: -35, to: Date()) ?? Date(),
            description: "Comprehensive research on global climate patterns and environmental changes.",
            rating: 4.3,
            timesBorrowed: 92,
            isAvailable: false,
            category: .research
        ),
        Book(
            title: "Quantum Computing Fundamentals",
            author: "Dr. Lisa Chen",
            publisher: "Tech Research Publications",
            year: 2022,
            isbn: "978-1-119-64432-1",
            pages: 356,
            location: "Floor 5, Section RES-QC",
            dateAdded: Calendar.current.date(byAdding: .day, value: -50, to: Date()) ?? Date(),
            description: "Advanced research on quantum algorithms and computing applications.",
            rating: 4.1,
            timesBorrowed: 56,
            isAvailable: true,
            category: .research
        ),
        Book(
            title: "The Alchemist",
            author: "Paulo Coelho",
            publisher: "HarperCollins",
            year: 1988,
            isbn: "978-0-06-112241-5",
            pages: 163,
            location: "Floor 2, Section LIT-300",
            dateAdded: Calendar.current.date(byAdding: .day, value: -80, to: Date()) ?? Date(),
            description: "A philosophical novel about following one's dreams.",
            rating: 4.4,
            timesBorrowed: 312,
            isAvailable: true,
            category: .books
        ),
        Book(
            title: "Thinking, Fast and Slow",
            author: "Daniel Kahneman",
            publisher: "Farrar, Straus and Giroux",
            year: 2011,
            isbn: "978-0-374-27563-1",
            pages: 499,
            location: "Floor 3, Section PSYC-200",
            dateAdded: Calendar.current.date(byAdding: .day, value: -40, to: Date()) ?? Date(),
            description: "Insights into how the mind makes decisions and forms judgments.",
            rating: 4.6,
            timesBorrowed: 187,
            isAvailable: true,
            category: .books
        ),
        Book(
            title: "The Power of Habit",
            author: "Charles Duhigg",
            publisher: "Random House",
            year: 2012,
            isbn: "978-0-8129-8160-8",
            pages: 371,
            location: "Floor 3, Section SELF-100",
            dateAdded: Calendar.current.date(byAdding: .day, value: -65, to: Date()) ?? Date(),
            description: "Why we do what we do in life and business - the science of habit formation.",
            rating: 4.2,
            timesBorrowed: 245,
            isAvailable: false,
            category: .books
        ),
        Book(
            title: "Atomic Habits",
            author: "James Clear",
            publisher: "Avery",
            year: 2018,
            isbn: "978-0-7352-1129-2",
            pages: 320,
            location: "Floor 3, Section SELF-120",
            dateAdded: Calendar.current.date(byAdding: .day, value: -12, to: Date()) ?? Date(),
            description: "An easy and proven way to build good habits and break bad ones.",
            rating: 4.8,
            timesBorrowed: 389,
            isAvailable: true,
            category: .books
        )
    ]
}
