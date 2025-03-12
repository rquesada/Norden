//
//  User.swift
//  NordenMobile
//
//  Created by Roy Quesada on 4/3/25.
//

import Foundation

struct User: Identifiable {
    let id: String
    let name: String
    let roles: [RoleName]
    let token: String
}
