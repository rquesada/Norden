//
//  Vacation.swift
//  NordenMobile
//
//  Created by Roy Quesada on 4/3/25.
//

import Foundation

struct Vacation: Codable, Identifiable {
    let id: String
    let collaboratorId: String
    let fullName: String
    let team: String
    let startDate: String
    let endDate: String
    let status: String
    let period: String
    let months: [Int]
    let years: [Int]
    let usedDays: Int
    
    // Convertir `startDate` y `endDate` a `Date`
    var startDateFormatted: Date? {
        return DateFormatter.vacationDateFormatter.date(from: startDate)
    }
    
    var endDateFormatted: Date? {
        return DateFormatter.vacationDateFormatter.date(from: endDate)
    }
}

// 🔹 Extensión para formatear fechas correctamente
extension DateFormatter {
    static let vacationDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
}
