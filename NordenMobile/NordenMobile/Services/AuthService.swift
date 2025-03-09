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
                                    print("accessToken: \(accessToken)")
                                    let user = User(id: username, name: username, role: "Collaborator", token: accessToken)
                                    promise(.success(user))

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
}
