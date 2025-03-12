//
//  VacationRequestsView.swift
//  NordenMobile
//
//  Created by Roy Quesada on 4/3/25.
//

import SwiftUI

struct RequestsListView: View {
    let vacationRequests: [VacationRequest]

    private var groupedRequests: [String: [VacationRequest]] {
        Dictionary(grouping: vacationRequests, by: { $0.status })
    }

    var body: some View {
        NavigationStack {
            VStack {
                Text("My Requests")
                    .font(.largeTitle)
                    .bold()
                    .foregroundColor(Color("primaryColor"))

                List {
                    ForEach(["Pending", "Approved", "Rejected"], id: \.self) { status in
                        if let requests = groupedRequests[status], !requests.isEmpty {
                            Section(header: Text(status).font(.headline)) {
                                ForEach(requests) { request in
                                    VacationRequestRow(request: request)
                                        .listRowSeparator(.hidden)
                                        .listRowBackground(Color.clear)
                                        .listRowInsets(.init(top: 5, leading: 0, bottom: 5, trailing: 0))
                                }
                            }
                        }
                    }
                }
                .listStyle(PlainListStyle())
                .scrollContentBackground(.hidden)
            }
            .padding(.horizontal)
        }
    }
}

struct VacationRequestRow: View {
    let request: VacationRequest

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack{
                Text("\(formattedDate(request.startDate, format: "dd/MM/yyyy")) - \(formattedDate(request.endDate, format: "dd/MM/yyyy"))")
                    .font(.headline)
                    .foregroundColor(.black)
                Spacer()
                Text("\(request.numberOfDays) Business Days")
                    .font(.footnote)
                    .foregroundColor(.gray)
            }
            
            
            Text("Requested on: \(formattedDate(request.lastUpdatedDate, format: "dd/MM/yyyy"))")
                .font(.footnote)
                .foregroundColor(.black)
            if request.status.lowercased() == "rejected" {
                Divider()
                    .frame(height: 1) // 🔹 Grosor de la línea
                    .background(Color.red) // 🔹 Color rojo
                
                Text("Comments: \(request.comments.joined(separator: ", "))")
                    .font(.footnote)
                    .foregroundColor(.black)
            }
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(colorForStatus(request.status))
        .cornerRadius(8)
    }

    private func formattedDate(_ dateString: String, format: String = "MMM d, yyyy") -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone(secondsFromGMT: 0)

        if dateString.contains("T") {
            formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        } else {
            formatter.dateFormat = "yyyy-MM-dd"
        }

        if let date = formatter.date(from: dateString) {
            formatter.dateFormat = format
            return formatter.string(from: date)
        }
        
        return dateString
    }

    private func colorForStatus(_ status: String) -> Color {
        switch status {
        case "Approved": return Color("approvedBackground")
        case "Rejected": return Color("rejectedBackground")
        case "Pending": return Color("pendingBackground")
        default: return .gray
        }
    }
}


#Preview {
    RequestsListView(vacationRequests: [
        VacationRequest(
            id: "1",
            startDate: "2025-02-17",
            endDate: "2025-02-18",
            status: "Approved",
            numberOfDays: 2,
            comments: ["Holidays"],
            lastUpdatedDate: "2025-03-01T01:59:56.832Z"
        ),
        VacationRequest(
            id: "2",
            startDate: "2025-03-10",
            endDate: "2025-03-12",
            status: "Pending",
            numberOfDays: 3,
            comments: ["Waiting approval"],
            lastUpdatedDate: "2025-03-02T01:59:56.832Z"
        ),
        VacationRequest(
            id: "3",
            startDate: "2025-01-05",
            endDate: "2025-01-07",
            status: "Rejected",
            numberOfDays: 2,
            comments: ["Overlap with another request"],
            lastUpdatedDate: "2025-02-28T01:59:56.832Z"
        ),
        VacationRequest(
            id: "4",
            startDate: "2025-01-05",
            endDate: "2025-01-07",
            status: "Pending",
            numberOfDays: 2,
            comments: ["Overlap with another request"],
            lastUpdatedDate: "2025-02-28T01:59:56.832Z"
        )
    ])
}
