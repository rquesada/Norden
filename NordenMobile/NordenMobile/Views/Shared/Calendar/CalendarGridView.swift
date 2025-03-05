//
//  CalendarGridView.swift
//  NordenMobile
//
//  Created by Roy Quesada on 4/3/25.
//

import SwiftUI

struct CalendarGridView: View {
    @Binding var selectedDate: Date
    @Binding var currentMonth: Date

    private let daysOfWeek = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]

    var body: some View {
        VStack {
            // 🔹 Encabezado con los días de la semana
            HStack {
                ForEach(daysOfWeek, id: \.self) { day in
                    Text(day)
                        .font(.caption)
                        .frame(maxWidth: .infinity)
                }
            }

            // 🔹 Generar las celdas del calendario
            let days = generateCalendarDays()
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 7)) {
                ForEach(days, id: \.self) { day in
                    Text(dayText(day))
                        .frame(width: 40, height: 40)
                        .background(selectedDate == day ? Color.blue.opacity(0.5) : Color.clear)
                        .clipShape(Circle())
                        .onTapGesture {
                            selectedDate = day
                        }
                }
            }
        }
    }

    // 🔹 Genera la lista de días para el mes actual
    private func generateCalendarDays() -> [Date] {
        var days: [Date] = []
        let calendar = Calendar.current
        let firstOfMonth = calendar.date(from: calendar.dateComponents([.year, .month], from: currentMonth))!
        let firstWeekday = calendar.component(.weekday, from: firstOfMonth) - 1
        let numDays = calendar.range(of: .day, in: .month, for: firstOfMonth)!.count

        // Agrega días vacíos al inicio del mes
        for _ in 0..<firstWeekday {
            days.append(Date.distantPast)
        }

        // Agrega los días del mes
        for day in 1...numDays {
            if let date = calendar.date(byAdding: .day, value: day - 1, to: firstOfMonth) {
                days.append(date)
            }
        }
        return days
    }

    // 🔹 Formatea los días (oculta los placeholders)
    private func dayText(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "d"
        return date == Date.distantPast ? "" : formatter.string(from: date)
    }
}

