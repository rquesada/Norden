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
    @Published var role: String?
    @Published var token: String?

    private let authService: AuthService
    private var cancellables = Set<AnyCancellable>()

    init(authService: AuthService = AuthService()) {
        self.authService = authService
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
                self.role = user.role
                self.token = user.token
                UserDefaults.standard.set(self.token, forKey: "token")
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
                    self.role = nil
                    self.token = nil
                    UserDefaults.standard.removeObject(forKey: "token")
                }
            } catch {
                DispatchQueue.main.async {
                    self.errorMessage = "Logout failed: \(error.localizedDescription)"
                }
            }
        }
    }
}

