//
//  Exception.swift
//  NordenMobile
//
//  Created by Roy Quesada on 27/3/25.
//

struct Exception: Codable, Identifiable {
    let id: String
    let reason: String
    let description: String?
    let exceptionType: String // "General" or "Holidays"
    let reference: String
    let startDate: String
    let endDate: String
    let months: [Int]
    let years: [Int]
}
