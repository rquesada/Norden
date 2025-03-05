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
                if let role = authViewModel.role{
                    switch role{
                    case "Collaborator":
                        MyVacationsView()
                    case "TeamLead":
                        AdminVacations()
                    default:
                        Text("Role not recognized")
                    }
                }
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
