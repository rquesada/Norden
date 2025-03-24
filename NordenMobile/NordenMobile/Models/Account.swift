//
//  Account.swift
//  NordenMobile
//
//  Created by Roy Quesada on 4/3/25.
//

import Foundation

struct Account: Codable, Identifiable, Hashable {
    let id: String
    let name: String
}
