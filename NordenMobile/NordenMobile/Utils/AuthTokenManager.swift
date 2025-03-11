//
//  AuthTokenManager.swift
//  NordenMobile
//
//  Created by Roy Quesada on 7/3/25.
//

import Foundation

class AuthTokenManager {
    static let shared = AuthTokenManager()

    func getAuthToken() -> String? {
        return KeychainHelper.shared.retrieve(key: "authToken")
    }
}
