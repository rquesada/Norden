//
//  Notification.swift
//  NordenMobile
//
//  Created by Roy Quesada on 14/3/25.
//
import Foundation

struct NotificationItem: Identifiable, Codable {
    let id: String
    let title: String
    let subTitle: String
    let color: String
    let isGroupable: Bool
    let details: [NotificationDetail]
    
    enum CodingKeys: String, CodingKey {
        case title, subTitle, color, isGroupable, details
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = UUID().uuidString
        title = try container.decode(String.self, forKey: .title)
        subTitle = try container.decode(String.self, forKey: .subTitle)
        color = try container.decode(String.self, forKey: .color)
        isGroupable = try container.decode(Bool.self, forKey: .isGroupable)
        details = try container.decode([NotificationDetail].self, forKey: .details)
    }
}

struct NotificationDetail: Identifiable, Codable {
    let id: String
    let title: String
    let collaboratorId: String
    let fullName: String
    let startDate: String?
    let endDate: String?
    let numberDays: String?
    let availableDays: String?
    let totalDays: String?
    let expirationDate: String?
    let currentAnniversaryNumber: String?
    
}

struct FlattenedNotification: Identifiable, Codable {
    let id: String
    let title: String
    let color: String
    let fullName: String
    let startDate: String
    let endDate: String
    let availableDays: String
    let expirationDate: String
    let numberDays: String
}

