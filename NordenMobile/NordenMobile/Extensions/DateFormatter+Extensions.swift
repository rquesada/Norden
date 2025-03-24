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
    
    /// 🔹 Devuelve un string formateado "MMM dd" si la cadena es una fecha válida
    func toMonthDayFormatted() -> String {
        return self.toDate()?.toMonthDayString() ?? self
    }
}

extension Date {
    // 🔹 Convierte un Date en una cadena con formato "yyyy-MM-dd"
    func toString() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: self)
    }
    
    /// 🔹 Devuelve la fecha en formato "MMM dd", por ejemplo: "Apr 03"
    func toMonthDayString() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM dd"
        formatter.locale = Locale(identifier: "en_US_POSIX") // Asegura nombres de meses en inglés
        return formatter.string(from: self)
    }
}
