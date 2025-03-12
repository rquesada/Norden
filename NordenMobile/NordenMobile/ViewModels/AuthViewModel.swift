//
//  AuthViewModel.swift
//  NordenMobile
//
//  Created by Roy Quesada on 4/3/25.
//

import Foundation
import Combine
import Amplify

class AuthViewModel: ObservableObject {
    @Published var username: String = ""
    @Published var password: String = ""
    @Published var isLoading: Bool = false
    @Published var isAuthenticated: Bool = false
    @Published var errorMessage: String?
    @Published var roles: [RoleName]?
    @Published var token: String?
    

    private let authService: AuthService
    private var cancellables = Set<AnyCancellable>()

    init(authService: AuthService = AuthService()) {
        self.authService = authService
        checkAuthStatus()
        
        #if DEBUG
        self.username = "paladin1968@mailcuk.com"
        self.password = "Myp4ssword#"
        #endif
    }
    
    func checkAuthStatus() {
        Task {
            do {
                let session = try await Amplify.Auth.fetchAuthSession()
                
                if session.isSignedIn {
                    DispatchQueue.main.async {
                        self.isAuthenticated = true
                        self.token = KeychainHelper.shared.retrieve(key: "authToken")
                        if let savedRoles = UserDefaults.standard.array(forKey: "userRoles") as? [String] {
                            self.roles = savedRoles.compactMap { RoleName(rawValue: $0) }
                        }

                    }
                }
            } catch {
                DispatchQueue.main.async {
                    self.isAuthenticated = false
                    self.token = nil
                    self.roles = nil
                }
            }
        }
    }
    
    func login() {
        isLoading = true
        errorMessage = nil
        
        authService.login(username: username, password: password)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                self.isLoading = false
                if case let .failure(error) = completion {
                    self.errorMessage = error.localizedDescription
                }
            }, receiveValue: { user in
                self.isAuthenticated = true
                self.roles = user.roles
                self.token = user.token
                
                if let token = self.token {
                    KeychainHelper.shared.save(key: "authToken", value: token)
                    UserDefaults.standard.set(user.roles.map { $0.rawValue }, forKey: "userRoles")
                }
            })
            .store(in: &cancellables)
    }
    
    func logout() {
        Task { 
            do {
                try await Amplify.Auth.signOut()
                DispatchQueue.main.async {
                    self.isAuthenticated = false
                    self.username = ""
                    self.password = ""
                    self.roles = nil
                    self.token = nil
                    KeychainHelper.shared.delete(key: "authToken")
                    UserDefaults.standard.removeObject(forKey: "userRoles")
                }
            } catch {
                DispatchQueue.main.async {
                    self.errorMessage = "Logout failed: \(error.localizedDescription)"
                }
            }
        }
    }

}

