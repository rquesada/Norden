//
//  VacationEvent.swift
//  NordenMobile
//
//  Created by Roy Quesada on 4/3/25.
//

import SwiftUI

struct VacationEvent: Identifiable, Hashable {
    let id = UUID()
    let name: String
    let color: Color
}

// 🔹 Datos de prueba
let sampleVacations: [Date: [VacationEvent]] = [
    Calendar.current.date(byAdding: .day, value: 1, to: Date())!: [VacationEvent(name: "Holiday", color: .green)],
    Calendar.current.date(byAdding: .day, value: 5, to: Date())!: [VacationEvent(name: "Blocked Day", color: .red)],
    Calendar.current.date(byAdding: .day, value: 10, to: Date())!: [VacationEvent(name: "John Doe Vacation", color: .blue)]
]

