//
//  AuthViewModel.swift
//  NordenMobile
//
//  Created by Roy Quesada on 4/3/25.
//

import Foundation
import Combine

class AuthViewModel: ObservableObject {
    @Published var username: String = ""
    @Published var password: String = ""
    @Published var isLoading: Bool = false
    @Published var isAuthenticated: Bool {
        didSet {
            UserDefaults.standard.set(isAuthenticated, forKey: "isAuthenticated")
        }
    }
    @Published var errorMessage: String?
    @Published var role: String? {
        didSet{
            UserDefaults.standard.set(role, forKey: "userRole")
        }
    }
    
    private let authService: AuthService
    private var cancellables = Set<AnyCancellable>()

    init(authService: AuthService = AuthService()) {
        self.authService = authService
        self.isAuthenticated = UserDefaults.standard.bool(forKey: "isAuthenticated")
        self.role = UserDefaults.standard.string(forKey: "userRole")
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
            })
            .store(in: &cancellables)
    }
    
    func logout() {
        isAuthenticated = false
        username = ""
        password = ""
        role = nil
        //UserDefaults.standard.removeObject(forKey: "userRole")
    }
}
