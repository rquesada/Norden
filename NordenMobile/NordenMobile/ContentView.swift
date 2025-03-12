//
//  ContentView.swift
//  NordenMobile
//
//  Created by Roy Quesada on 3/3/25.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var authViewModel = AuthViewModel()

    var body: some View {
        NavigationStack {
            if authViewModel.isAuthenticated {
                HomeView()
            } else {
                LoginView()
            }
        }
        .environmentObject(authViewModel) // Permite compartir el estado en toda la app
    }
}

#Preview {
    ContentView()
}
