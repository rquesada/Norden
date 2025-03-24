//
//  ApprovalsView.swift
//  NordenMobile
//
//  Created by Roy Quesada on 12/3/25.
//


import SwiftUI

struct ApprovalsView: View {
    
    let approvalRequests: [ApprovalRequest]
    @State private var selectedRequest: ApprovalRequest?
    
    var body: some View {
        NavigationView {
            List(approvalRequests) { request in
                Button(action: {
                    selectedRequest = request
                }) {
                    HStack {
                        VStack(alignment: .leading) {
                            Text(request.subTitle)
                                .font(.headline)
                            Text("\(request.details.first?.startDate ?? "") - \(request.details.first?.endDate ?? "")")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                        Spacer()
                        if let status = request.details.first?.status {
                            Text(status)
                                .foregroundColor(.white)
                                .padding(6)
                                .background(status == "Pending" ? Color.yellow : Color.green)
                                .cornerRadius(8)
                        }
                    }
                }
            }
            .navigationTitle("Approval Requests")
            .sheet(item: $selectedRequest) { request in
                ApprovalDetailView(request: request)
            }
        }
    }
}

// MARK: - Preview with Dummy Data
#Preview {
    ApprovalsView(approvalRequests: dummyApprovals)
}

// MARK: - Dummy Data for Preview
let dummyApprovals: [ApprovalRequest] = [
    ApprovalRequest(
        id: UUID().uuidString,
        title: "Approval Request",
        subTitle: "John Doe (Apr 15 - Apr 20)",
        color: "#FFD700",
        isGroupable: false,
        details: [
            ApprovalRequestDetail(
                id: UUID().uuidString,
                title: "Approval Request",
                collaboratorId: UUID().uuidString,
                fullName: "John Doe",
                startDate: "2025-04-15",
                endDate: "2025-04-20",
                numberDays: "5",
                availableDays: "10",
                totalDays: "15",
                expirationDate: "2025-12-31",
                currentAnniversaryNumber: "2",
                status: "Pending",
                referenceEntityId: UUID().uuidString,
                seniority: "Senior",
                tenure: 3,
                createdAt: "2025-03-01"
            )
        ]
    ),
    ApprovalRequest(
        id: UUID().uuidString,
        title: "Approval Request",
        subTitle: "Jane Smith (May 05 - May 10)",
        color: "#FFD700",
        isGroupable: false,
        details: [
            ApprovalRequestDetail(
                id: UUID().uuidString,
                title: "Approval Request",
                collaboratorId: UUID().uuidString,
                fullName: "Jane Smith",
                startDate: "2025-05-05",
                endDate: "2025-05-10",
                numberDays: "6",
                availableDays: "8",
                totalDays: "12",
                expirationDate: "2025-11-20",
                currentAnniversaryNumber: "1",
                status: "Approved",
                referenceEntityId: UUID().uuidString,
                seniority: "Middle",
                tenure: 2,
                createdAt: "2025-03-01"
            )
        ]
    )
]

