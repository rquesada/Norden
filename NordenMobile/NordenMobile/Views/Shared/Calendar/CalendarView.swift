//
//  CalendarView.swift
//  NordenMobile
//
//  Created by Roy Quesada on 4/3/25.
//

import SwiftUI

struct CalendarView: View {
    @Binding var selectedDate: Date
    let approvedVacations: [Vacation]
    let onYearChange: (Int) -> Void
    let onRequestVacation: () -> Void

    @State private var currentMonth: Date

    private let daysOfWeek = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]

    init(selectedDate: Binding<Date>,
         approvedVacations: [Vacation],
         onYearChange: @escaping (Int) -> Void,
         onRequestVacation: @escaping () -> Void){
        self._selectedDate = selectedDate
        self.approvedVacations = approvedVacations
        self.onYearChange = onYearChange
        self.onRequestVacation = onRequestVacation
        self._currentMonth = State(initialValue: selectedDate.wrappedValue)
    }

    var body: some View {
        VStack {
            HStack {
                Spacer()
                Button(action: previousMonth) {
                    Image(systemName: "chevron.left")
                        .padding()
                        .foregroundColor(Color("secondaryColor"))
                }
                
                Text(monthAndYear(currentMonth))
                    .font(.title2)
                    .bold()
                    .foregroundColor(Color("primaryColor"))

                Button(action: nextMonth) {
                    Image(systemName: "chevron.right")
                        .padding()
                        .foregroundColor(Color("secondaryColor"))
                }
                
                Button(action: {
                    onRequestVacation()
                }){
                    Image(systemName: "plus")
                        .padding()
                        .foregroundColor(Color("secondaryColor"))
                }
            }

            HStack {
                ForEach(daysOfWeek, id: \.self) { day in
                    Text(day)
                        .frame(maxWidth: .infinity)
                        .font(.caption)
                        .bold()
                }
            }
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 7)) {
                let days = generateCalendarDays()
                ForEach(days, id: \.self) { day in
                    if let validDate = day {
                        VStack {
                            Text("\(Calendar.current.component(.day, from: validDate))")
                                .frame(width: 40, height: 40)
                                .background(selectedDate == validDate ? Color.blue.opacity(0.5) : Color.clear)
                                .clipShape(Circle())
                                .onTapGesture {
                                    selectedDate = validDate
                                }
                            
                            
                            if isVacationDay(validDate) {
                                Circle()
                                    .fill(Color.blue)
                                    .frame(width: 5, height: 5)
                            }
                        }
                    } else {
                        Text("")
                            .frame(width: 40, height: 40)
                    }
                }
            }

            Spacer()
        }
        .padding()
    }

    private func monthAndYear(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        return formatter.string(from: date)
    }

    private func nextMonth() {
        updateMonth(by: 1)
    }

    private func previousMonth() {
        updateMonth(by: -1)
    }

    private func updateMonth(by value: Int) {
        if let newMonth = Calendar.current.date(byAdding: .month, value: value, to: currentMonth) {
            currentMonth = newMonth
            selectedDate = newMonth
        }
    }

    // 🔹 Genera una lista de días del mes actual
    private func generateCalendarDays() -> [Date?] {
        var days: [Date?] = []
        let calendar = Calendar.current
        let firstOfMonth = calendar.date(from: calendar.dateComponents([.year, .month], from: currentMonth))!
        let firstWeekday = calendar.component(.weekday, from: firstOfMonth) - 1
        let numDays = calendar.range(of: .day, in: .month, for: firstOfMonth)!.count

        // Agregar espacios vacíos para alinear los días correctamente
        for _ in 0..<firstWeekday {
            days.append(nil)
        }

        // Agregar los días del mes
        for day in 1...numDays {
            if let date = calendar.date(byAdding: .day, value: day - 1, to: firstOfMonth) {
                days.append(date)
            }
        }
        return days
    }

    // 🔹 Verifica si hay vacaciones aprobadas en un día específico
    private func isVacationDay(_ date: Date) -> Bool {
        return approvedVacations.contains { vacation in
            guard let start = vacation.startDateFormatted, let end = vacation.endDateFormatted else { return false }
            return (start...end).contains(date)
        }
    }
}


#Preview {
    struct CalendarViewPreview: View {
        @State private var selectedDate = Date()

        var body: some View {
            CalendarView(
                selectedDate: $selectedDate,
                approvedVacations: [],
                onYearChange: { _ in },
                onRequestVacation: {}
            )
        }
    }

    return CalendarViewPreview()
}
