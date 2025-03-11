//
//  VacationRequestsView.swift
//  NordenMobile
//
//  Created by Roy Quesada on 4/3/25.
//

import SwiftUI

struct RequestsListView: View {
    let vacationRequests: [VacationRequest] // 🔹 Ahora recibe datos reales

    // 🔹 Agrupar solicitudes por estado
    private var groupedRequests: [String: [VacationRequest]] {
        Dictionary(grouping: vacationRequests, by: { $0.status })
    }

    var body: some View {
        NavigationStack {
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
                            }
                        }
                    }
                }
            }
        }
    }
}

// 🔹 Componente para cada solicitud de vacaciones
struct VacationRequestRow: View {
    let request: VacationRequest

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("\(formattedDate(request.startDate)) - \(formattedDate(request.endDate))")
                .font(.headline)

            Text("Status: \(request.status)")
                .font(.subheadline)
                .foregroundColor(colorForStatus(request.status))

            if !request.comments.isEmpty {
                Text("Comments: \(request.comments.joined(separator: ", "))")
                    .font(.footnote)
                    .foregroundColor(.gray)
            }

            Text("Last Updated: \(formattedDate(request.lastUpdatedDate))")
                .font(.footnote)
                .foregroundColor(.gray)
        }
        .padding()
    }

    // 🔹 Formatear fecha
    private func formattedDate(_ dateString: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        if let date = formatter.date(from: dateString) {
            formatter.dateFormat = "MMM d, yyyy"
            return formatter.string(from: date)
        }
        return dateString
    }

    // 🔹 Asignar colores a los estados
    private func colorForStatus(_ status: String) -> Color {
        switch status {
        case "Approved": return .green
        case "Rejected": return .red
        case "Pending": return .orange
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
        )
    ])
}
