//
//  AuthService.swift
//  NordenMobile
//
//  Created by Roy Quesada on 4/3/25.
//

import Foundation
import Combine

class AuthService {
    func login(username: String, password: String) -> AnyPublisher<User, Error> {
        return Future { promise in
            DispatchQueue.global().asyncAfter(deadline: .now() + 2) {
                if username == "test" && password == "password" {
                    let user = User(id: UUID().uuidString, name: "John Doe", role: "Collaborator")
                    promise(.success(user))
                } else {
                    promise(.failure(NSError(domain: "Invalid credentials", code: 401, userInfo: nil)))
                }
            }
        }
        .receive(on: DispatchQueue.main)
        .eraseToAnyPublisher()
    }
}
