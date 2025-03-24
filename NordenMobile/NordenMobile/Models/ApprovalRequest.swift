//
//  ApprovalRequest.swift
//  NordenMobile
//
//  Created by Roy Quesada on 19/3/25.
//

import Foundation

struct ApprovalRequest: Codable, Identifiable{
    let id:String
    let title: String
    let subTitle: String
    let color: String
    let isGroupable: Bool
    let details:[ApprovalRequestDetail]
    
    enum CodingKeys: String, CodingKey {
        case title, subTitle, color, isGroupable, details
    }
    
    init(from decoder: Decoder) throws{
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = UUID().uuidString
        title = try container.decode(String.self, forKey: .title)
        subTitle = try container.decode(String.self, forKey: .subTitle)
        color = try container.decode(String.self, forKey: .color)
        isGroupable = try container.decode(Bool.self, forKey: .isGroupable)
        details = try container.decode([ApprovalRequestDetail].self, forKey: .details)
    }
    
    init(id: String = UUID().uuidString, title: String, subTitle: String, color: String, isGroupable: Bool, details: [ApprovalRequestDetail]) {
        self.id = id
        self.title = title
        self.subTitle = subTitle
        self.color = color
        self.isGroupable = isGroupable
        self.details = details
    }
}

struct ApprovalRequestDetail: Codable{
    let id: String
    let title: String
    let collaboratorId: String
    let fullName: String
    let startDate: String
    let endDate: String
    let numberDays: String
    let availableDays: String
    let totalDays: String
    let expirationDate: String
    let currentAnniversaryNumber: String
    let status: String
    let referenceEntityId: String
    let seniority: String
    let tenure: Int
    let createdAt: String
}
