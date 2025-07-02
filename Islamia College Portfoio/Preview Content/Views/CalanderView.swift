//
//  CalendarView.swift
//  Islamia College Portfolio
//
//  Created by Development on 02/07/2025.
//

import SwiftUI

struct CalendarEvent {
    let id = UUID()
    let title: String
    let date: Date
    let color: Color
    let category: EventsCategory
    let description: String
    let startTime: String?
    let endTime: String?
    let location: String?
}

enum EventsCategory: String, CaseIterable {
    case national = "National"
    case religious = "Religious"
    case academic = "Academic"
    case college = "College"
    
    var color: Color {
        switch self {
        case .national: return .green
        case .religious: return .purple
        case .academic: return .blue
        case .college: return .orange
        }
    }
}

struct CalendarView: View {
    @State private var selectedDate = Date()
    @State private var currentMonth = Date()
    @State private var events: [CalendarEvent] = []
    @State private var showingEventDetail = false
    @State private var selectedEvents: [CalendarEvent] = []
    @State private var selectedEvent: CalendarEvent?
    
    private let calendar = Calendar.current
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        return formatter
    }()
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                headerView
                calendarGrid
                eventsSection
                Spacer()
            }
            .background(
                LinearGradient(
                    gradient: Gradient(colors: [Color.accentColor.opacity(0.1), Color.accentColor.opacity(0.1)]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            .navigationTitle("Calendar")
            .navigationBarTitleDisplayMode(.large)
            .onAppear {
                loadEvents()
            }
            .sheet(isPresented: $showingEventDetail) {
                EventsDetailView(
                    events: selectedEvents,
                    selectedDate: selectedDate,
                    selectedEvent: $selectedEvent
                )
            }
        }
    }
    
    private var headerView: some View {
        HStack {
            Button(action: previousMonth) {
                Image(systemName: "chevron.left")
                    .font(.title2)
                    .foregroundColor(.primary)
            }
            
            Spacer()
            
            Text(dateFormatter.string(from: currentMonth))
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.primary)
            
            Spacer()
            
            Button(action: nextMonth) {
                Image(systemName: "chevron.right")
                    .font(.title2)
                    .foregroundColor(.primary)
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 10)
        .background(Color.white.opacity(0.8))
        .cornerRadius(15)
        .shadow(color: .gray.opacity(0.3), radius: 5, x: 0, y: 2)
        .padding(.horizontal)
        .padding(.top, 10)
    }
    
    private var calendarGrid: some View {
        VStack(spacing: 0) {
            HStack {
                ForEach(["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"], id: \.self) { day in
                    Text(day)
                        .font(.caption)
                        .fontWeight(.semibold)
                        .foregroundColor(.secondary)
                        .frame(maxWidth: .infinity)
                }
            }
            .padding(.horizontal)
            .padding(.vertical, 8)
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 7), spacing: 8) {
                ForEach(getDaysInMonth(), id: \.self) { date in
                    DayView(
                        date: date,
                        isSelected: calendar.isDate(date, inSameDayAs: selectedDate),
                        isToday: calendar.isDate(date, inSameDayAs: Date()),
                        hasEvents: hasEvents(for: date),
                        events: getEvents(for: date)
                    )
                    .onTapGesture {
                        selectedDate = date
                        selectedEvents = getEvents(for: date)
                        if !selectedEvents.isEmpty {
                            showingEventDetail = true
                        }
                    }
                }
            }
            .padding(.horizontal)
        }
        .background(Color.white.opacity(0.9))
        .cornerRadius(20)
        .shadow(color: .gray.opacity(0.2), radius: 10, x: 0, y: 5)
        .padding(.horizontal)
        .padding(.top, 10)
    }
    
    private var eventsSection: some View {
        VStack(alignment: .leading, spacing: 15) {
            HStack {
                Text("Events")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.primary)
                
                Spacer()
                
                Text(selectedDate, style: .date)
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(8)
            }
            
            if selectedEvents.isEmpty {
                VStack(spacing: 8) {
                    Image(systemName: "calendar.badge.exclamationmark")
                        .font(.system(size: 40))
                        .foregroundColor(.gray.opacity(0.5))
                    
                    Text("No events for this day")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                .frame(maxWidth: .infinity, minHeight: 100)
                .background(Color.gray.opacity(0.05))
                .cornerRadius(15)
            } else {
                ScrollView {
                    LazyVStack(spacing: 12) {
                        ForEach(selectedEvents, id: \.id) { event in
                            EventCard(event: event) {
                                selectedEvent = event
                                showingEventDetail = true
                            }
                        }
                    }
                }
                .frame(maxHeight: 200)
            }
        }
        .padding(.horizontal)
        .padding(.top, 20)
    }
    
    private func previousMonth() {
        withAnimation(.easeInOut(duration: 0.3)) {
            currentMonth = calendar.date(byAdding: .month, value: -1, to: currentMonth) ?? currentMonth
        }
    }
    
    private func nextMonth() {
        withAnimation(.easeInOut(duration: 0.3)) {
            currentMonth = calendar.date(byAdding: .month, value: 1, to: currentMonth) ?? currentMonth
        }
    }
    
    private func getDaysInMonth() -> [Date] {
        guard let monthInterval = calendar.dateInterval(of: .month, for: currentMonth) else {
            return []
        }
        
        let firstOfMonth = monthInterval.start
        let firstWeekday = calendar.component(.weekday, from: firstOfMonth)
        
        var days: [Date] = []
        
        for i in 1..<firstWeekday {
            if let date = calendar.date(byAdding: .day, value: -i, to: firstOfMonth) {
                days.insert(date, at: 0)
            }
        }
        
        let daysInMonth = calendar.range(of: .day, in: .month, for: currentMonth)?.count ?? 0
        for i in 0..<daysInMonth {
            if let date = calendar.date(byAdding: .day, value: i, to: firstOfMonth) {
                days.append(date)
            }
        }
        
        let remainingDays = 42 - days.count
        for i in 1...remainingDays {
            if let date = calendar.date(byAdding: .day, value: i, to: days.last ?? Date()) {
                days.append(date)
            }
        }
        
        return days
    }
    
    private func hasEvents(for date: Date) -> Bool {
        return !getEvents(for: date).isEmpty
    }
    
    private func getEvents(for date: Date) -> [CalendarEvent] {
        return events.filter { calendar.isDate($0.date, inSameDayAs: date) }
    }
    
    private func loadEvents() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        
        events = [
            CalendarEvent(
                title: "New Year's Day",
                date: dateFormatter.date(from: "01/01/2025") ?? Date(),
                color: .green,
                category: .national,
                description: "Celebration of the beginning of the new year. A public holiday observed worldwide.",
                startTime: "All Day",
                endTime: nil,
                location: "Nationwide"
            ),
            CalendarEvent(
                title: "Kashmir Solidarity Day",
                date: dateFormatter.date(from: "05/02/2025") ?? Date(),
                color: .green,
                category: .national,
                description: "A day to express solidarity with the people of Kashmir and support their right to self-determination.",
                startTime: "All Day",
                endTime: nil,
                location: "Pakistan"
            ),
            CalendarEvent(
                title: "Pakistan Day",
                date: dateFormatter.date(from: "23/03/2025") ?? Date(),
                color: .green,
                category: .national,
                description: "Commemorates the Lahore Resolution and the adoption of the first constitution of Pakistan.",
                startTime: "All Day",
                endTime: nil,
                location: "Nationwide"
            ),
            CalendarEvent(
                title: "Spring Semester Begins",
                date: dateFormatter.date(from: "15/01/2025") ?? Date(),
                color: .blue,
                category: .academic,
                description: "Start of the spring academic semester. All students must report to their respective classes.",
                startTime: "8:00 AM",
                endTime: "5:00 PM",
                location: "Campus Wide"
            ),
            CalendarEvent(
                title: "New Student Orientation",
                date: dateFormatter.date(from: "10/01/2025") ?? Date(),
                color: .orange,
                category: .college,
                description: "Welcome session for new students including campus tour, registration process, and introduction to college facilities.",
                startTime: "9:00 AM",
                endTime: "4:00 PM",
                location: "Main Auditorium"
            ),
            CalendarEvent(
                title: "Mid-Term Exams Begin",
                date: dateFormatter.date(from: "15/03/2025") ?? Date(),
                color: .blue,
                category: .academic,
                description: "Commencement of mid-term examinations for all departments. Students must bring their admit cards.",
                startTime: "9:00 AM",
                endTime: "12:00 PM",
                location: "Examination Halls"
            ),
            CalendarEvent(
                title: "Annual Sports Day",
                date: dateFormatter.date(from: "20/04/2025") ?? Date(),
                color: .orange,
                category: .college,
                description: "Inter-departmental sports competition including cricket, football, badminton, and athletics.",
                startTime: "8:00 AM",
                endTime: "6:00 PM",
                location: "Sports Ground"
            ),
            CalendarEvent(
                title: "Eid ul-Fitr",
                date: dateFormatter.date(from: "31/03/2025") ?? Date(),
                color: .purple,
                category: .religious,
                description: "Festival of breaking the fast, marking the end of Ramadan. A joyous celebration for Muslims worldwide.",
                startTime: "All Day",
                endTime: nil,
                location: "Nationwide"
            ),
            CalendarEvent(
                title: "Graduation Ceremony",
                date: dateFormatter.date(from: "20/06/2025") ?? Date(),
                color: .orange,
                category: .college,
                description: "Annual convocation ceremony for graduating students. Degrees and diplomas will be awarded.",
                startTime: "10:00 AM",
                endTime: "1:00 PM",
                location: "Main Auditorium"
            ),
            CalendarEvent(
                title: "Independence Day",
                date: dateFormatter.date(from: "14/08/2025") ?? Date(),
                color: .green,
                category: .national,
                description: "Celebrating Pakistan's independence from British rule in 1947. Flag hoisting and cultural programs.",
                startTime: "All Day",
                endTime: nil,
                location: "Nationwide"
            )
        ]
    }
}

struct DayView: View {
    let date: Date
    let isSelected: Bool
    let isToday: Bool
    let hasEvents: Bool
    let events: [CalendarEvent]
    
    private let calendar = Calendar.current
    
    var body: some View {
        VStack(spacing: 2) {
            Text("\(calendar.component(.day, from: date))")
                .font(.system(size: 16, weight: isToday ? .bold : .medium))
                .foregroundColor(textColor)
            
            if hasEvents {
                HStack(spacing: 2) {
                    ForEach(Array(events.prefix(3)), id: \.id) { event in
                        Circle()
                            .fill(event.category.color)
                            .frame(width: 6, height: 6)
                    }
                    if events.count > 3 {
                        Text("+")
                            .font(.system(size: 8))
                            .foregroundColor(.secondary)
                    }
                }
            }
        }
        .frame(width: 40, height: 40)
        .background(backgroundColor)
        .cornerRadius(8)
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(borderColor, lineWidth: borderWidth)
        )
        .scaleEffect(isSelected ? 1.1 : 1.0)
        .animation(.easeInOut(duration: 0.1), value: isSelected)
    }
    
    private var textColor: Color {
        if isSelected {
            return .white
        } else if isToday {
            return .accentColor
        } else if !calendar.isDate(date, equalTo: Date(), toGranularity: .month) {
            return .gray
        } else {
            return .primary
        }
    }
    
    private var backgroundColor: Color {
        if isSelected {
            return .accentColor
        } else if isToday {
            return .blue.opacity(0.1)
        } else {
            return .clear
        }
    }
    
    private var borderColor: Color {
        if isToday && !isSelected {
            return .accentColor
        } else {
            return .clear
        }
    }
    
    private var borderWidth: CGFloat {
        isToday && !isSelected ? 2 : 0
    }
}

struct EventCard: View {
    let event: CalendarEvent
    let onTap: () -> Void
    
    var body: some View {
        HStack(spacing: 12) {
            Rectangle()
                .fill(event.category.color)
                .frame(width: 4)
                .cornerRadius(2)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(event.title)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(.primary)
                
                HStack {
                    Text(event.category.rawValue)
                        .font(.caption)
                        .foregroundColor(event.category.color)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 2)
                        .background(event.category.color.opacity(0.1))
                        .cornerRadius(4)
                    
                    if let startTime = event.startTime {
                        Text(startTime)
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
            }
            
            Spacer()
            
            VStack {
                Image(systemName: "calendar")
                    .foregroundColor(event.category.color)
                    .font(.system(size: 16))
                
                Image(systemName: "chevron.right")
                    .foregroundColor(.secondary)
                    .font(.system(size: 12))
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: .gray.opacity(0.1), radius: 3, x: 0, y: 1)
        .onTapGesture {
            onTap()
        }
    }
}

struct EventsDetailView: View {
    let events: [CalendarEvent]
    let selectedDate: Date
    @Binding var selectedEvent: CalendarEvent?
    @Environment(\.dismiss) private var dismiss
    
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .full
        return formatter
    }()
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                if let event = selectedEvent {
                    singleEventDetail(event)
                } else {
                    multipleEventsView
                }
            }
            .navigationTitle("Event Details")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
                
                if selectedEvent != nil {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button("Back") {
                            selectedEvent = nil
                        }
                    }
                }
            }
        }
    }
    
    private var multipleEventsView: some View {
        VStack(alignment: .leading, spacing: 20) {
            VStack(alignment: .leading, spacing: 8) {
                Text(dateFormatter.string(from: selectedDate))
                    .font(.title2)
                    .fontWeight(.bold)
                
                Text("\(events.count) event\(events.count == 1 ? "" : "s")")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            .padding(.horizontal)
            
            ScrollView {
                LazyVStack(spacing: 16) {
                    ForEach(events, id: \.id) { event in
                        EventDetailCard(event: event) {
                            selectedEvent = event
                        }
                    }
                }
                .padding(.horizontal)
            }
            
            Spacer()
        }
        .padding(.top)
    }
    
    private func singleEventDetail(_ event: CalendarEvent) -> some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                VStack(alignment: .leading, spacing: 16) {
                    HStack {
                        Rectangle()
                            .fill(event.category.color)
                            .frame(width: 6, height: 60)
                            .cornerRadius(3)
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text(event.title)
                                .font(.title2)
                                .fontWeight(.bold)
                                .foregroundColor(.primary)
                            
                            Text(event.category.rawValue)
                                .font(.subheadline)
                                .foregroundColor(event.category.color)
                                .padding(.horizontal, 12)
                                .padding(.vertical, 6)
                                .background(event.category.color.opacity(0.1))
                                .cornerRadius(8)
                        }
                        
                        Spacer()
                    }
                }
                .padding(.horizontal)
                
                VStack(spacing: 20) {
                    DetailRow(
                        icon: "calendar",
                        title: "Date",
                        value: dateFormatter.string(from: event.date),
                        color: event.category.color
                    )
                    
                    if let startTime = event.startTime {
                        DetailRow(
                            icon: "clock",
                            title: "Time",
                            value: event.endTime != nil ? "\(startTime) - \(event.endTime!)" : startTime,
                            color: event.category.color
                        )
                    }
                    
                    if let location = event.location {
                        DetailRow(
                            icon: "location",
                            title: "Location",
                            value: location,
                            color: event.category.color
                        )
                    }
                    
                    VStack(alignment: .leading, spacing: 12) {
                        HStack {
                            Image(systemName: "text.alignleft")
                                .foregroundColor(event.category.color)
                                .frame(width: 24)
                            
                            Text("Description")
                                .font(.headline)
                                .foregroundColor(.primary)
                        }
                        
                        Text(event.description)
                            .font(.body)
                            .foregroundColor(.secondary)
                            .padding(.leading, 32)
                    }
                    .padding(.horizontal)
                }
                
                Spacer(minLength: 50)
            }
            .padding(.top)
        }
    }
}

struct EventDetailCard: View {
    let event: CalendarEvent
    let onTap: () -> Void
    
    var body: some View {
        HStack(spacing: 16) {
            Rectangle()
                .fill(event.category.color)
                .frame(width: 6)
                .cornerRadius(3)
            
            VStack(alignment: .leading, spacing: 8) {
                Text(event.title)
                    .font(.headline)
                    .foregroundColor(.primary)
                
                Text(event.category.rawValue)
                    .font(.caption)
                    .foregroundColor(event.category.color)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(event.category.color.opacity(0.1))
                    .cornerRadius(6)
                
                if let startTime = event.startTime {
                    HStack {
                        Image(systemName: "clock")
                            .foregroundColor(.secondary)
                            .font(.system(size: 12))
                        
                        Text(startTime)
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
                
                if let location = event.location {
                    HStack {
                        Image(systemName: "location")
                            .foregroundColor(.secondary)
                            .font(.system(size: 12))
                        
                        Text(location)
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
            }
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .foregroundColor(.secondary)
                .font(.system(size: 14))
        }
        .padding(16)
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: .gray.opacity(0.1), radius: 5, x: 0, y: 2)
        .onTapGesture {
            onTap()
        }
    }
}

struct DetailRow: View {
    let icon: String
    let title: String
    let value: String
    let color: Color
    
    var body: some View {
        HStack(alignment: .top, spacing: 16) {
            Image(systemName: icon)
                .foregroundColor(color)
                .frame(width: 24)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.headline)
                    .foregroundColor(.primary)
                
                Text(value)
                    .font(.body)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
        }
        .padding(.horizontal)
    }
}

#Preview {
    CalendarView()
}
