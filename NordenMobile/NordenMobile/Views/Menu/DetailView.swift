//
//  DetailView.swift
//  NordenMobile
//
//  Created by Roy Quesada on 10/3/25.
//

import SwiftUI

struct DetailView: View {
    let option: SideMenuOption

    var body: some View {
        VStack {
            Text("You selected: \(option.name)")
                .font(.title)
                .padding()
        }
        .navigationTitle(option.name)
    }
}

#Preview {
    DetailView(option: SideMenuOption(id: 1, name: "Business Intelligence", url: "/", icon: "chart.bar.fill"))
}
