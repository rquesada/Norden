//
//  ApprovalsView.swift
//  NordenMobile
//
//  Created by Roy Quesada on 12/3/25.
//


import SwiftUI

struct ApprovalsView: View {
    let approvalRequests: [ApprovalRequest]
    let errorMessage: String?
    
    @State private var selectedRequest: ApprovalRequest?
    
    var body: some View {
        VStack {
            if let errorMessage = errorMessage{
                VStack{
                    Image(systemName: "exclamationmark.triangle.fill")
                        .foregroundColor(.red)
                        .font(.largeTitle)
                        .padding()
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .multilineTextAlignment(.center)
                        .foregroundColor(.gray)
                }
                .padding()
            }
            else if approvalRequests.isEmpty {
                VStack{
                    Image(systemName: "tray.fill")
                        .foregroundColor(.gray)
                        .font(.largeTitle)
                        .padding()
                    Text("No vacation requests to review.")
                        .font(.headline)
                        .foregroundColor(.gray)
                }
                .padding()
            }
            else{
                List(approvalRequests) { request in
                    Button(action: {
                        selectedRequest = request
                    }) {
                        ApprovalsItemView(request: request)
                    }
                    .buttonStyle(PlainButtonStyle())
                    .listRowSeparator(.hidden)
                    .listRowBackground(Color.clear)
                    .listRowInsets(.init(top: 5, leading: 0, bottom: 5, trailing: 0))
                }
                .listStyle(PlainListStyle())
            }
        }
        .padding(.horizontal)
        .sheet(item: $selectedRequest) { request in
            ApprovalDetailView(request: request)
        }
    }
}

struct ApprovalsItemView: View{
    
    let request:ApprovalRequest
    
    var body: some View {
        HStack {
            //Line
            Rectangle()
                .fill(request.details.first?.statusColor ?? Color.gray)
                   .frame(width: 2)
            //Text
            VStack(alignment: .leading) {
                Text(request.details.first?.fullName ?? request.title)
                    .font(.headline)
                Text("\(request.details.first?.startDate.toMonthDayFormatted() ?? "") - \(request.details.first?.endDate.toMonthDayFormatted() ?? "")")
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color("lightGrayBackground"))
        .cornerRadius(8)
    }
}

// MARK: - Preview with Dummy Data
#Preview {
    ApprovalsView(approvalRequests: dummyApprovals, errorMessage: nil)
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

