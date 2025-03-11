//
//  Menu3View.swift
//  NordenMobile
//
//  Created by Roy Quesada on 10/3/25.
//

import SwiftUI

struct Menu3View: View {
    let menuOptions: [SideMenuOption] = [
        SideMenuOption(id: 1, name: "My Vacations", url: "", icon: "chart.bar.fill"),
        SideMenuOption(id: 2, name: "Admin Vacations", url: "", icon: "person.3.fill"),
        SideMenuOption(id: 3, name: "Logout", url: "", icon: "folder.fill")
    ]
    
    @State private var searchText = ""

    var filteredOptions: [SideMenuOption] {
        if searchText.isEmpty {
            return menuOptions
        } else {
            return menuOptions.filter { $0.name.lowercased().contains(searchText.lowercased()) }
        }
    }

    var body: some View {
        NavigationView {
            List(filteredOptions, id: \.id) { option in
                NavigationLink(destination: DetailView(option: option)) {
                    HStack {
                        Image(systemName: option.icon ?? "doc.text")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 30, height: 30)
                            .foregroundColor(.blue)
                        
                        VStack(alignment: .leading) {
                            Text(option.name)
                                .font(.headline)
                            Text(option.url ?? "")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                    }
                    .padding(.vertical, 6)
                }
            }
            .navigationTitle("Select a Section")
            .searchable(text: $searchText, prompt: "Search options...")
        }
    }
}

#Preview {
    Menu3View()
}
