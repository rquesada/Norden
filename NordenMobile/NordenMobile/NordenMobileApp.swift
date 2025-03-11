//
//  NordenMobileApp.swift
//  NordenMobile
//
//  Created by Roy Quesada on 3/3/25.
//

import SwiftUI
import Amplify
import AWSCognitoAuthPlugin

@main
struct NordenMobileApp: App {
    @StateObject private var authViewModel = AuthViewModel()
    
    init() {
        configureAmplify()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(authViewModel)
        }
    }
    
    private func configureAmplify() {
        do {
            try Amplify.add(plugin: AWSCognitoAuthPlugin())
            try Amplify.configure()
            print("✅ Amplify configured successfully")
        } catch {
            print("❌ Failed to configure Amplify: \(error)")
        }
    }
}
