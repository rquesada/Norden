//
//  ApprovalsView.swift
//  NordenMobile
//
//  Created by Roy Quesada on 12/3/25.
//


import SwiftUI

struct ApprovalsView: View {
    @ObservedObject var viewModel: AdminVacationsViewModel
    
    @State private var selectedRequest: ApprovalRequest?
    
    var body: some View {
        VStack {
            if let errorMessage = viewModel.errorMessage{
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
            else if viewModel.approvals.isEmpty {
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
                List(viewModel.approvals) { request in
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
            ApprovalDetailView(request: request) {
                selectedRequest = nil
                viewModel.fetchApprovals(for: viewModel.selectedAccountId)
            }
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
