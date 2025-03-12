//
//  Menu.swift
//  NordenMobile
//
//  Created by Roy Quesada on 10/3/25.
//

import Foundation

struct MenuOption {
    let name: String
    let url: String
    let icon: String
}

enum Destination: String {
    case myVacations
    case adminVacations
}

struct SideMenuOption: Identifiable, Hashable {
    let id: Int
    let name: String
    let icon: String
    let destination: Destination
}

let MenuOptions: [RoleName: [SideMenuOption]] = [
    .admin: [
        SideMenuOption(id:1, name: "Admin Vacations", icon: "person.3.fill", destination: .adminVacations)
    ],
    .collaborator: [
        SideMenuOption(id:2, name: "My Vacations", icon: "chart.bar.fill", destination: .myVacations)
    ],
    .talentDevelopment: [
        SideMenuOption(id:3, name: "Admin Vacations", icon: "person.3.fill", destination: .adminVacations)
    ]
]
