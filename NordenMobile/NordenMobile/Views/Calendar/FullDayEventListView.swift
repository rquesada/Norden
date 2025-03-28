//
//  FullDayEventListView.swift
//  NordenMobile
//
//  Created by Roy Quesada on 27/3/25.
//

import SwiftUI

struct FullDayEventListView: View {
    let date: Date
    let events: [AnyIdentifiableEvent]

    var body: some View {
        NavigationView {
            List {
                ForEach(events) { event in
                    VStack(alignment: .leading, spacing: 4) {
                        HStack {
                            Image(systemName: event.icon)
                                .foregroundColor(event.color)
                            Text(event.type.displayName)
                                .font(.caption)
                                .foregroundColor(event.color)
                        }
                        Text(event.title)
                    }
                    .padding(6)
                }
            }
            .navigationTitle(dateFormatted(date))
            .navigationBarTitleDisplayMode(.inline)
        }
    }

    private func dateFormatted(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM dd"
        return formatter.string(from: date)
    }
}
