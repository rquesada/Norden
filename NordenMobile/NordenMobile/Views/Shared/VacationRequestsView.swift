//
//  VacationRequestsView.swift
//  NordenMobile
//
//  Created by Roy Quesada on 4/3/25.
//

import SwiftUI

struct VacationRequestsView: View {
    let pendingRequests = ["Vacation Request 1", "Vacation Request 2"]
    let approvedRequests = ["Vacation Request 3"]
    let rejectedRequests = ["Vacation Request 4"]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("My Vacation Requests")
                .font(.headline)
            
            // 🔹 Pending Section
            VacationSectionView(title: "Pending", color: .orange, requests: pendingRequests)
            
            // 🔹 Approved Section
            VacationSectionView(title: "Approved", color: .green, requests: approvedRequests)
            
            // 🔹 Rejected Section
            VacationSectionView(title: "Rejected", color: .red, requests: rejectedRequests)
        }
        .padding()
        .background(Color.white)
        .cornerRadius(8)
        .shadow(radius: 2)
    }
}

// 🔹 Componente Reutilizable para Sección de Vacaciones
struct VacationSectionView: View {
    let title: String
    let color: Color
    let requests: [String]
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(title)
                .font(.subheadline)
                .bold()
                .foregroundColor(color)
            
            if requests.isEmpty {
                Text("No requests")
                    .foregroundColor(.gray)
                    .italic()
            } else {
                ForEach(requests, id: \.self) { request in
                    Text(request)
                }
            }
        }
        .padding(.vertical, 5)
    }
}
