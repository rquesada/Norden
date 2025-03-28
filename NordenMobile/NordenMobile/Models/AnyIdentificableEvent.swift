//
//  AnyIdentificableEvent.swift
//  NordenMobile
//
//  Created by Roy Quesada on 27/3/25.
//
import SwiftUI

struct AnyIdentifiableEvent: Identifiable {
    let id: String
    let type: EventType
    let title: String

    enum EventType {
        case vacation
        case holiday
        case generalException

        var displayName: String {
            switch self {
            case .vacation: return "Vacations"
            case .holiday: return "Holidays"
            case .generalException: return "General Exception"
            }
        }

        var icon: String {
            switch self {
            case .vacation: return "briefcase.fill"
            case .holiday: return "calendar.badge.clock"
            case .generalException: return "exclamationmark.triangle.fill"
            }
        }

        var color: Color {
            switch self {
            case .vacation: return .blue
            case .holiday: return .yellow
            case .generalException: return .red
            }
        }
    }

    var icon: String { type.icon }
    var color: Color { type.color }
}
