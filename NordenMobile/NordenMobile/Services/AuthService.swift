import Foundation
import AWSPluginsCore
import Combine
import Amplify

class AuthService {
    
    func login(username: String, password: String) -> AnyPublisher<User, Error> {
        return Future { promise in
            Task {
                do {
                    let signInResult = try await Amplify.Auth.signIn(username: username, password: password)

                    if signInResult.isSignedIn {
                        let session = try await Amplify.Auth.fetchAuthSession()

                        // 🔹 Ensure we are getting a Cognito session
                        if let cognitoSession = session as? AuthCognitoTokensProvider {
                            let tokensResult = cognitoSession.getCognitoTokens()

                            switch tokensResult {
                                
                                case .success(let tokens):
                                
                                
                                let accessToken = tokens.accessToken
                                let idToken = tokens.idToken
                                
                                if let decodedPayload = self.decodeJWT(token: idToken),
                                   let roleList = decodedPayload["cognito:groups"] as? [String] {
                                    
                                    let userRoles = roleList.compactMap { RoleName(rawValue: $0) }
                                    print("User roles: \(userRoles)")
                                    
                                    let user = User(id: username, name: username, roles: userRoles, token: accessToken)
                                    promise(.success(user))
                                }

                                case .failure(let authError):
                                    promise(.failure(authError))
                            }
                        } else {
                            promise(.failure(NSError(domain: "Failed to retrieve tokens", code: 500, userInfo: nil)))
                        }
                    } else {
                        promise(.failure(NSError(domain: "Sign-in failed", code: 401, userInfo: nil)))
                    }
                } catch {
                    promise(.failure(error))
                }
            }
        }
        .receive(on: DispatchQueue.main)
        .eraseToAnyPublisher()
    }
    
    private func decodeJWT(token: String) -> [String: Any]? {
        let segments = token.split(separator: ".")
        guard segments.count > 1 else { return nil }

        var base64String = String(segments[1])
            .replacingOccurrences(of: "-", with: "+")
            .replacingOccurrences(of: "_", with: "/")

        while base64String.count % 4 != 0 {
            base64String.append("=")
        }

        guard let decodedData = Data(base64Encoded: base64String, options: .ignoreUnknownCharacters),
              let jsonObject = try? JSONSerialization.jsonObject(with: decodedData, options: []),
              let payload = jsonObject as? [String: Any] else {
            print("❌ Error: No se pudo decodificar el JWT")
            return nil
        }

        return payload
    }
}
