//
//  DateFormatter+Extensions.swift
//  NordenMobile
//
//  Created by Roy Quesada on 5/3/25.
//

import Foundation

extension String {
    // 🔹 Convierte una cadena con formato "yyyy-MM-dd" en Date
    func toDate() -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.date(from: self)
    }
}

extension Date {
    // 🔹 Convierte un Date en una cadena con formato "yyyy-MM-dd"
    func toString() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: self)
    }
}
