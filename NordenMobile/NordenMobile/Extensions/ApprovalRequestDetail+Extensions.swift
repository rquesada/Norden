//
//  ApprovalRequestDetail+Extensions.swift
//  NordenMobile
//
//  Created by Roy Quesada on 24/3/25.
//

import SwiftUI

extension ApprovalRequestDetail {
    var statusColor: Color {
        switch status {
        case "Pending":
            return Color(hex: "#f2951b") ?? .orange
        case "Approved":
            return Color(hex: "#21b812") ?? .green
        case "Rejected":
            return Color(hex: "#ff2600") ?? .red
        default:
            return Color(hex: "#cccccc") ?? .gray // fallback
        }
    }
}

