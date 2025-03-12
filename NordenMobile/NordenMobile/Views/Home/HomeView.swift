//
//  HomeView.swift
//  NordenMobile
//
//  Created by Roy Quesada on 4/3/25.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @State private var searchText = ""
    @State private var selectedDestination: Destination?

    var filteredOptions: [SideMenuOption] {
        let userRoles = authViewModel.roles ?? []
        let allOptions = userRoles.flatMap { MenuOptions[$0] ?? [] }
        let uniqueOptions = Array(Set(allOptions))
        
        if searchText.isEmpty {
            return uniqueOptions
        } else {
            return uniqueOptions.filter { $0.name.lowercased().contains(searchText.lowercased()) }
        }
    }

    var body: some View {
        NavigationStack {
            VStack {
                Text("Welcome to Norden Mobile!")
                    .font(.largeTitle)
                    .bold()
                    .foregroundColor(Color("primaryColor"))
                    .padding(.top)

                Spacer(minLength: 10)
                
                List(filteredOptions, id: \.id) { option in
                    Button(action: {
                        selectedDestination = option.destination
                    }) {
                        HStack {
                            Image(systemName: option.icon)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 30, height: 30)
                                .foregroundColor(.blue)

                            Text(option.name)
                                .font(.headline)
                        }
                        .padding(.vertical, 6)
                    }
                }
                .searchable(text: $searchText, prompt: "Search options...")

                Spacer()

                // 🔹 Logout Button en la parte inferior
                Button(action: {
                    authViewModel.logout()
                }) {
                    HStack {
                        Image(systemName: "rectangle.portrait.and.arrow.right")
                            .foregroundColor(.white)
                        Text("Logout")
                            .font(.headline)
                            .foregroundColor(.white)
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.red)
                    .cornerRadius(8)
                }
                .padding(.horizontal)
                .padding(.bottom, 20) // Espaciado para que no esté pegado al borde inferior
            }
            .navigationDestination(item: $selectedDestination) { destination in
                switch destination {
                case .myVacations:
                    MyVacationsView()
                case .adminVacations:
                    AdminVacations()
                }
            }
        }
    }
}

#Preview {
    HomeView()
        .environmentObject(AuthViewModel())
}


