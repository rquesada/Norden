//
//  VacationRequest.swift
//  NordenMobile
//
//  Created by Roy Quesada on 5/3/25.
//

import Foundation

struct VacationRequest: Identifiable, Decodable {
    let id: String
    let startDate: String
    let endDate: String
    let status: String
    let numberOfDays: Int
    let comments: [String]
    let lastUpdatedDate: String
}
