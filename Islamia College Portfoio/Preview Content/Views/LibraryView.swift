//
//  LibraryView.swift
//  Islamia College Portfolio
//
//  Created by Development on 17/06/2025.
//

import SwiftUI

struct LibraryView: View {
    @State private var searchText = ""
    @State private var selectedCategory: BookCategory = .all
    @State private var selectedSortOption: SortOption = .title
    @State private var isGridView = false
    @State private var showingBookDetails = false
    @State private var selectedBook: Book?
    @State private var books: [Book] = SampleData.books
    
    var filteredBooks: [Book] {
        var filtered = books
        if selectedCategory != .all {
            filtered = filtered.filter { $0.category == selectedCategory }
        }
        if !searchText.isEmpty {
            filtered = filtered.filter { book in
                book.title.localizedCaseInsensitiveContains(searchText) ||
                book.author.localizedCaseInsensitiveContains(searchText) ||
                book.isbn.localizedCaseInsensitiveContains(searchText)
            }
        }
        switch selectedSortOption {
        case .title:
            filtered.sort { $0.title < $1.title }
        case .author:
            filtered.sort { $0.author < $1.author }
        case .year:
            filtered.sort { $0.year > $1.year }
        case .rating:
            filtered.sort { $0.rating > $1.rating }
        case .timesBorrowed:
            filtered.sort { $0.timesBorrowed > $1.timesBorrowed }
        }
        
        return filtered
    }
    
    var libraryStats: LibraryStats {
        let total = books.count
        let available = books.filter { $0.isAvailable }.count
        let avgRating = books.map { $0.rating }.reduce(0, +) / Double(books.count)
        
        return LibraryStats(totalBooks: total, availableBooks: available, averageRating: avgRating)
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                ScrollView {
                    LazyVStack(spacing: 0) {
                        searchAndTitleSection
                        filterTabsView
                        statisticsView
                        booksListView
                    }
                }
            }
            .navigationBarHidden(true)
            .background(Color(.systemGroupedBackground))
        }
        .sheet(isPresented: $showingBookDetails) {
            if let book = selectedBook {
                BookDetailsView(book: book)
            }
        }
    }
    
    private var searchAndTitleSection: some View {
        VStack(alignment: .leading, spacing: 20) {
            
            HStack(spacing: 12) {
                Image(systemName: "magnifyingglass")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.secondary)
                
                TextField("Search books, authors, ISBN...", text: $searchText)
                    .font(.system(size: 16))
                    .textFieldStyle(PlainTextFieldStyle())
                
                if !searchText.isEmpty {
                    Button(action: {
                        searchText = ""
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .font(.system(size: 16))
                            .foregroundColor(.secondary)
                    }
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 14)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color(.white))
                    .shadow(color: Color.black.opacity(0.04), radius: 4, x: 0, y: 2)
            )
            .padding(.horizontal, 20)
        }
        .padding(.top, 16)
        .padding(.bottom, 14)
        .background(Color(.systemGroupedBackground))
    }
    private var filterTabsView: some View {
        VStack(spacing: 16) {
            HStack(spacing: 0) {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 12) {
                        ForEach(BookCategory.allCases, id: \.self) { category in
                            Button(action: {
                                withAnimation(.easeInOut(duration: 0.3)) {
                                    selectedCategory = category
                                }
                            }) {
                                Text(category.displayName)
                                    .font(.system(size: 15, weight: .semibold))
                                    .padding(.horizontal, 20)
                                    .padding(.vertical, 10)
                                    .background(
                                        RoundedRectangle(cornerRadius: 25)
                                            .fill(selectedCategory == category ?
                                                  Color.accentColor : Color(.systemBackground))
                                            .shadow(color: Color.black.opacity(selectedCategory == category ? 0.15 : 0.05),
                                                   radius: selectedCategory == category ? 6 : 2,
                                                   x: 0, y: selectedCategory == category ? 3 : 1)
                                    )
                                    .foregroundColor(selectedCategory == category ? .white : .primary)
                            }
                        }
                    }
                    .padding(.top, 3)
                    .padding(.horizontal, 20)
                }
                HStack(spacing: 12) {
                    Menu {
                        ForEach(SortOption.allCases, id: \.self) { option in
                            Button(action: {
                                selectedSortOption = option
                            }) {
                                HStack {
                                    Text(option.displayName)
                                    if selectedSortOption == option {
                                        Image(systemName: "checkmark")
                                            .foregroundColor(.accentColor)
                                    }
                                }
                            }
                        }
                    } label: {
                        HStack(spacing: 6) {
                            Image(systemName: "arrow.up.arrow.down")
                                .font(.system(size: 14, weight: .medium))
                            Text("Sort")
                                .font(.system(size: 14, weight: .medium))
                        }
                        .foregroundColor(.primary)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 8)
                        .background(
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Color(.systemBackground))
                                .shadow(color: Color.black.opacity(0.05), radius: 2, x: 0, y: 1)
                        )
                    }
                    
                    Button(action: {
                        withAnimation(.spring()) {
                            isGridView.toggle()
                        }
                    }) {
                        Image(systemName: isGridView ? "list.bullet" : "square.grid.2x2")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(.primary)
                            .padding(8)
                            .background(
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(Color(.systemBackground))
                                    .shadow(color: Color.black.opacity(0.05), radius: 2, x: 0, y: 1)
                            )
                    }
                }
                .padding(.trailing, 20)
            }
        }
        .padding(.top, 15)
        .padding(.bottom, 30)
        .background(Color(.systemGroupedBackground))
    }
    
    private var statisticsView: some View {
        HStack(spacing: 0) {
            StatisticView(
                value: "\(libraryStats.totalBooks)",
                label: "Total Books",
                color: .blue,
                icon: "books.vertical"
            )
            
            Spacer()
            
            StatisticView(
                value: "\(libraryStats.availableBooks)",
                label: "Available",
                color: .accentColor,
                icon: "checkmark.circle"
            )
            
            Spacer()
            
            StatisticView(
                value: libraryStats.formattedAverageRating,
                label: "Avg Rating",
                color: .orange,
                icon: "star.fill"
            )
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 20)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(.systemBackground))
                .shadow(color: Color.black.opacity(0.04), radius: 8, x: 0, y: 4)
        )
        .padding(.horizontal, 20)
        .padding(.bottom, 24)
    }
    
    private var booksListView: some View {
        LazyVStack(spacing: 12) {
            ForEach(filteredBooks) { book in
                BookRowView(book: book) {
                    selectedBook = book
                    showingBookDetails = true
                }
            }
        }
        .padding(.horizontal, 20)
        .padding(.bottom, 20)
    }
}

struct BookRowView: View {
    let book: Book
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 16) {
                ZStack {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(LinearGradient(
                            gradient: Gradient(colors: [
                                Color.blue.opacity(0.1),
                                Color.blue.opacity(0.2)
                            ]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ))
                        .frame(width: 50, height: 50)
                    
                    Image(systemName: "book.closed")
                        .font(.system(size: 22, weight: .medium))
                        .foregroundColor(.blue)
                }
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Text(book.title)
                            .font(.system(size: 17, weight: .semibold))
                            .foregroundColor(.primary)
                            .lineLimit(2)
                            .multilineTextAlignment(.leading)
                        
                        Spacer()
                        HStack(spacing: 4) {
                            Circle()
                                .fill(book.isAvailable ? Color.accentColor : Color.red)
                                .frame(width: 6, height: 6)
                            Text(book.isAvailable ? "Available" : "Checked Out")
                                .font(.system(size: 11, weight: .medium))
                                .foregroundColor(book.isAvailable ? .accentColor : .red)
                        }
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill((book.isAvailable ? Color.accentColor : Color.red).opacity(0.1))
                        )
                    }
                    
                    Text("by \(book.author)")
                        .font(.system(size: 15))
                        .foregroundColor(.secondary)
                        .lineLimit(1)
                    
                    HStack {
                        Label("\(book.publisher)", systemImage: "building.2")
                            .font(.system(size: 12))
                            .foregroundColor(.secondary)
                            .labelStyle(.titleAndIcon)
                        
                        Spacer()
                        
                        HStack(spacing: 3) {
                            Image(systemName: "star.fill")
                                .font(.system(size: 11))
                                .foregroundColor(.orange)
                            Text(book.formattedRating)
                                .font(.system(size: 13, weight: .semibold))
                                .foregroundColor(.primary)
                        }
                    }
                    
                    HStack {
                        Label(book.location, systemImage: "location")
                            .font(.system(size: 12, weight: .medium))
                            .foregroundColor(.blue)
                            .labelStyle(.titleAndIcon)
                        Spacer()
                    }
                }
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(.secondary.opacity(0.6))
            }
            .padding(20)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color(.systemBackground))
                    .shadow(color: Color.black.opacity(0.04), radius: 6, x: 0, y: 3)
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct StatisticView: View {
    let value: String
    let label: String
    let color: Color
    let icon: String
    
    var body: some View {
        VStack(spacing: 8) {
            HStack(spacing: 6) {
                Image(systemName: icon)
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(color)
                
                Text(value)
                    .font(.system(size: 24, weight: .bold, design: .rounded))
                    .foregroundColor(color)
            }
            
            Text(label)
                .font(.system(size: 13, weight: .medium))
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
    }
}

struct BookDetailsView: View {
    let book: Book
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 28) {
                    bookHeaderView
                    bookDetailsSection
                    descriptionSection
                    
                    Spacer(minLength: 50)
                }
                .padding(24)
            }
            .navigationBarHidden(true)
            .background(Color(.systemGroupedBackground))
        }
    }
    
    private var bookHeaderView: some View {
        VStack(spacing: 24) {
            HStack {
                Text("Resource Details")
                    .font(.system(size: 22, weight: .bold))
                    .foregroundColor(.primary)
                
                Spacer()
                
                Button("Done") {
                    presentationMode.wrappedValue.dismiss()
                }
                .font(.system(size: 17, weight: .semibold))
                .foregroundColor(.accentColor)
            }
            HStack(alignment: .top, spacing: 20) {
                ZStack {
                    RoundedRectangle(cornerRadius: 16)
                        .fill(LinearGradient(
                            gradient: Gradient(colors: [
                                Color.blue.opacity(0.1),
                                Color.blue.opacity(0.2)
                            ]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ))
                        .frame(width: 70, height: 70)
                    
                    Image(systemName: "book.closed")
                        .font(.system(size: 32, weight: .medium))
                        .foregroundColor(.blue)
                }
                
                VStack(alignment: .leading, spacing: 8) {
                    Text(book.title)
                        .font(.system(size: 22, weight: .bold))
                        .foregroundColor(.primary)
                        .lineLimit(3)
                    
                    Text("by \(book.author)")
                        .font(.system(size: 17))
                        .foregroundColor(.secondary)
                    
                    HStack(spacing: 6) {
                        Circle()
                            .fill(book.isAvailable ? Color.accentColor : Color.red)
                            .frame(width: 8, height: 8)
                        Text(book.isAvailable ? "Available" : "Checked Out")
                            .font(.system(size: 15, weight: .semibold))
                            .foregroundColor(book.isAvailable ? .accentColor : .red)
                    }
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill((book.isAvailable ? Color.accentColor : Color.red).opacity(0.1))
                    )
                }
                
                Spacer()
            }
            HStack(spacing: 0) {
                VStack(spacing: 8) {
                    HStack(spacing: 3) {
                        ForEach(1...5, id: \.self) { star in
                            Image(systemName: star <= Int(book.rating) ? "star.fill" : "star")
                                .font(.system(size: 18))
                                .foregroundColor(.orange)
                        }
                    }
                    Text("Rating")
                        .font(.system(size: 13, weight: .medium))
                        .foregroundColor(.secondary)
                }
            }
            .padding(.top, 8)
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color(.systemBackground))
                .shadow(color: Color.black.opacity(0.05), radius: 10, x: 0, y: 5)
        )
    }
    
    private var bookDetailsSection: some View {
        VStack(spacing: 0) {
            Text("Book Information")
                .font(.system(size: 20, weight: .bold))
                .foregroundColor(.primary)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.bottom, 16)
            
            VStack(spacing: 16) {
                detailRow(label: "Category", value: book.category.displayName, icon: "tag")
                detailRow(label: "Publisher", value: book.publisher, icon: "building.2")
                detailRow(label: "Year", value: "\(book.year)", icon: "calendar")
                detailRow(label: "ISBN", value: book.isbn, icon: "barcode")
                detailRow(label: "Pages", value: "\(book.pages)", icon: "doc.text")
                detailRow(label: "Location", value: book.location, icon: "location")
                detailRow(label: "Date Added", value: book.formattedDateAdded, icon: "clock")
            }
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color(.systemBackground))
                .shadow(color: Color.black.opacity(0.05), radius: 10, x: 0, y: 5)
        )
    }
    
    private var descriptionSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Description")
                .font(.system(size: 20, weight: .bold))
                .foregroundColor(.primary)
            
            Text(book.description)
                .font(.system(size: 16))
                .foregroundColor(.secondary)
                .lineSpacing(6)
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color(.systemBackground))
                .shadow(color: Color.black.opacity(0.05), radius: 10, x: 0, y: 5)
        )
    }
    
    private func detailRow(label: String, value: String, icon: String) -> some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(.blue)
                .frame(width: 20)
            
            Text(label)
                .font(.system(size: 16))
                .foregroundColor(.secondary)
                .frame(width: 90, alignment: .leading)
            
            Text(value)
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(.primary)
            
            Spacer()
        }
        .padding(.vertical, 4)
    }
}

#Preview {
    LibraryView()
}
