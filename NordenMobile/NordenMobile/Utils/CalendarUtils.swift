//
//  CalendarUtils.swift
//  NordenMobile
//
//  Created by Roy Quesada on 27/3/25.
//
import Foundation

class CalendarUtils {
    static func monthName(from date: Date) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "MMMM"
        return formatter.string(from: date)
    }

    static func daysInMonth(year: Int, month: Int) -> [Date] {
        var dates: [Date] = []
        let calendar = Calendar.current
        let components = DateComponents(year: year, month: month)
        
        guard let startOfMonth = calendar.date(from: components),
              let range = calendar.range(of: .day, in: .month, for: startOfMonth) else {
            return []
        }

        for day in range {
            if let date = calendar.date(from: DateComponents(year: year, month: month, day: day)) {
                dates.append(date)
            }
        }

        return dates
    }
}

