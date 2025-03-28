//
//  DayEventRow.swift
//  NordenMobile
//
//  Created by Roy Quesada on 27/3/25.
//
import SwiftUI

struct DayEventRow: View {
    let date: Date
    let exceptions: [Exception]
    let vacations: [Vacation]

    @State private var showAllEvents = false

    var allEvents: [AnyIdentifiableEvent] {
        let vacationEvents = vacations.map { AnyIdentifiableEvent(id: $0.id, type: .vacation, title: $0.fullName) }
        let exceptionEvents = exceptions.map {
            AnyIdentifiableEvent(
                id: $0.id,
                type: $0.exceptionType == "Holidays" ? .holiday : .generalException,
                title: $0.reason
            )
        }
        return vacationEvents + exceptionEvents
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(dateFormatted(date))
                .font(.headline)
                .foregroundColor(.gray)

            ForEach(displayedEvents.prefix(3)) { event in
                HStack {
                    Image(systemName: event.icon)
                        .foregroundColor(event.color)
                    VStack(alignment: .leading) {
                        Text(event.type.displayName)
                            .font(.caption)
                            .foregroundColor(event.color)
                        Text(event.title)
                            .font(.subheadline)
                    }
                    Spacer()
                }
                .padding(8)
                .background(event.color.opacity(0.15))
                .cornerRadius(6)
            }

            if allEvents.count > 3 {
                Button(action: {
                    showAllEvents = true
                }) {
                    Text("Show \(allEvents.count - 3) more")
                        .font(.footnote)
                        .foregroundColor(.blue)
                }
                .sheet(isPresented: $showAllEvents) {
                    FullDayEventListView(date: date, events: allEvents)
                }
            }
            Spacer(minLength: 0)
        }
        .frame(maxWidth: .infinity, minHeight: 100, alignment: .topLeading)
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(8)
        .shadow(color: Color.black.opacity(0.05), radius: 2, x: 0, y: 1)
    }

    private var displayedEvents: [AnyIdentifiableEvent] {
        allEvents
    }

    private func dateFormatted(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd EEE"
        return formatter.string(from: date)
    }
}
