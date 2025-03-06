//
//  AuthService.swift
//  NordenMobile
//
//  Created by Roy Quesada on 4/3/25.
//

import Foundation
import Combine

class AuthService {
    
    //ToDo: remove
    let collaboratorToken = "eyJraWQiOiJqenJSelJZXC9MYUhcLzEzR3FpNTJ3Q20zQ1JzbTk2ZVJnRU5BdXNuZHd6djg9IiwiYWxnIjoiUlMyNTYifQ.eyJzdWIiOiJiMzhhYTFiMy1kOTlkLTQ3ZDQtYmRjNy04N2Y4MDUwNjE2MmIiLCJjb2duaXRvOmdyb3VwcyI6WyJjb2xsYWJvcmF0b3IiXSwiaXNzIjoiaHR0cHM6XC9cL2NvZ25pdG8taWRwLnVzLXdlc3QtMS5hbWF6b25hd3MuY29tXC91cy13ZXN0LTFfTnNyaFpNNVZaIiwiY2xpZW50X2lkIjoiNmJndjA2ZGlkdjh2dTkwYnNjM2JyMDZsODkiLCJvcmlnaW5fanRpIjoiZmJmMTM4NmYtZDRkYi00NDE5LTkxMzMtZjhiNWMyZTMwOWQ1IiwiZXZlbnRfaWQiOiJkZjI0MGFjNy1kMGMwLTQ0ZTMtODFlNS0zYWMwNTgzZGRhY2IiLCJ0b2tlbl91c2UiOiJhY2Nlc3MiLCJzY29wZSI6ImF3cy5jb2duaXRvLnNpZ25pbi51c2VyLmFkbWluIiwiYXV0aF90aW1lIjoxNzQxMTMzNTgwLCJleHAiOjE3NDEyMTk5ODAsImlhdCI6MTc0MTEzMzU4MCwianRpIjoiNmQ4NmFjZTQtY2I4NC00YzI3LWI2YjYtY2YxMzQ5MTk2OTA3IiwidXNlcm5hbWUiOiJiMzhhYTFiMy1kOTlkLTQ3ZDQtYmRjNy04N2Y4MDUwNjE2MmIifQ.bB9rONVfoUVyP_E6YmDg2bg-8HnkEtNFzGasUq2nQ86qhGyQarKamdlQTNVwP1mKgpUXfWPaTM-X0CqynEjS6Tcp56yq2vPpZmOtcRcsVABJq9kiXc46feXiJx6KX97xOWkNJsbx-M_D_O661JK34eVLNWwg2g2S0b-jZevSBRkcCreyXCmDH-MHX6C7Gauqd9MiBMtV65d0SVF0wUEB8pyl9FzrKQ4h-A0SYWehtj5XpbPIpP3wFHKeicO_rPK0_uugJaperF3kF81F85O1nTElqCAvlQUB3KAjYnXETg6-EcOMeAd1a3U_CF4_2UEaltuH9DNyHH6bu5inge9Tog"
    
    
    func login(username: String, password: String) -> AnyPublisher<User, Error> {
        return Future { promise in
            DispatchQueue.global().asyncAfter(deadline: .now() + 1) {
                if username == "test" && password == "password" {
                    let user = User(id: UUID().uuidString, name: "John Doe", role: "Collaborator", token: self.collaboratorToken)
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
