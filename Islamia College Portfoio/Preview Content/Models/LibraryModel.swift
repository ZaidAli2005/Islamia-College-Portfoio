//
//  LibraryModels.swift
//  Islamia College Portfolio
//
//  Created by Development on 17/06/2025.
//

import Foundation

// MARK: - Book Model
struct Book: Identifiable, Codable {
    var id = UUID()
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

enum SortOption: String, CaseIterable {
    case title = "Title"
    case author = "Author"
    case year = "Year"
    case rating = "Rating"
    
    var displayName: String {
        return self.rawValue
    }
}

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
            isAvailable: true,
            category: .books
        ),
        Book(
            title: "The Lord of the Rings",
            author: "J.R.R. Tolkien",
            publisher: "Allen & Unwin",
            year: 1954,
            isbn: "978-0-618-00222-8",
            pages: 1178,
            location: "Floor 2, Section FANT-100",
            dateAdded: Calendar.current.date(byAdding: .day, value: -130, to: Date()) ?? Date(),
            description: "An epic high-fantasy novel that defined the modern fantasy genre.",
            rating: 4.9,
            isAvailable: true,
            category: .books
        ),
        Book(
            title: "Harry Potter and the Sorcerer's Stone",
            author: "J.K. Rowling",
            publisher: "Bloomsbury",
            year: 1997,
            isbn: "978-0-7475-3269-9",
            pages: 309,
            location: "Floor 2, Section FANT-120",
            dateAdded: Calendar.current.date(byAdding: .day, value: -90, to: Date()) ?? Date(),
            description: "The first book in the Harry Potter series, introducing the wizarding world.",
            rating: 4.8,
            isAvailable: false,
            category: .books
        ),
        Book(
            title: "The Hobbit",
            author: "J.R.R. Tolkien",
            publisher: "George Allen & Unwin",
            year: 1937,
            isbn: "978-0-618-00221-1",
            pages: 310,
            location: "Floor 2, Section FANT-110",
            dateAdded: Calendar.current.date(byAdding: .day, value: -85, to: Date()) ?? Date(),
            description: "A fantasy novel and prelude to The Lord of the Rings.",
            rating: 4.7,
            isAvailable: true,
            category: .books
        ),
        Book(
            title: "The Diary of a Young Girl",
            author: "Anne Frank",
            publisher: "Contact Publishing",
            year: 1947,
            isbn: "978-0-553-29698-3",
            pages: 283,
            location: "Floor 3, Section BIOG-200",
            dateAdded: Calendar.current.date(byAdding: .day, value: -100, to: Date()) ?? Date(),
            description: "The poignant diary of a Jewish girl hiding during WWII.",
            rating: 4.8,
            isAvailable: true,
            category: .books
        ),
        Book(
            title: "The Road",
            author: "Cormac McCarthy",
            publisher: "Alfred A. Knopf",
            year: 2006,
            isbn: "978-0-307-26524-4",
            pages: 287,
            location: "Floor 2, Section LIT-350",
            dateAdded: Calendar.current.date(byAdding: .day, value: -60, to: Date()) ?? Date(),
            description: "A bleak post-apocalyptic journey of a father and son.",
            rating: 4.3,
            isAvailable: true,
            category: .books
        ),
        Book(
            title: "The Book Thief",
            author: "Markus Zusak",
            publisher: "Picador",
            year: 2005,
            isbn: "978-0-375-84220-7",
            pages: 552,
            location: "Floor 2, Section HIST-100",
            dateAdded: Calendar.current.date(byAdding: .day, value: -70, to: Date()) ?? Date(),
            description: "A powerful story narrated by Death set in Nazi Germany.",
            rating: 4.6,
            isAvailable: false,
            category: .books
        ),
        Book(
            title: "The Shining",
            author: "Stephen King",
            publisher: "Doubleday",
            year: 1977,
            isbn: "978-0-385-12167-5",
            pages: 447,
            location: "Floor 3, Section HORR-100",
            dateAdded: Calendar.current.date(byAdding: .day, value: -55, to: Date()) ?? Date(),
            description: "A psychological horror novel set in an isolated hotel.",
            rating: 4.4,
            isAvailable: true,
            category: .books
        ),
        Book(
            title: "The Fault in Our Stars",
            author: "John Green",
            publisher: "Dutton Books",
            year: 2012,
            isbn: "978-0-525-47881-2",
            pages: 313,
            location: "Floor 1, Section YA-100",
            dateAdded: Calendar.current.date(byAdding: .day, value: -40, to: Date()) ?? Date(),
            description: "A young adult novel about love and terminal illness.",
            rating: 4.5,
            isAvailable: false,
            category: .books
        )

    ]
}
