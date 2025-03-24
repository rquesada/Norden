//
//  ApprovalDetailView.swift
//  NordenMobile
//
//  Created by Roy Quesada on 19/3/25.
//

import SwiftUI

struct ApprovalDetailView: View {
    let request: ApprovalRequest
    @StateObject private var detailViewModel = ApprovalDetailViewModel()
    @State private var comments: String = ""

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(request.title)
                .font(.title)
                .bold()
            
            if let detail = request.details.first {
                VStack(alignment: .leading) {
                    Text("**Collaborator:** \(detail.fullName)")
                    Text("**Date Range:** \(detail.startDate) - \(detail.endDate)")
                    Text("**Status:** \(detail.status)")
                    Text("**Seniority:** \(detail.seniority) (\(detail.tenure) years)")
                }
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(8)
            }
            
            if detailViewModel.isLoading {
                ProgressView("Loading conflicts...")
            } else if !detailViewModel.conflicts.isEmpty {
                Text("Conflicts Detected:")
                ForEach(detailViewModel.conflicts, id: \.self) { conflict in
                    Text("⚠️ \(conflict)")
                        .foregroundColor(.red)
                }
            }
            
            Text("Your Comments")
                .font(.headline)
            
            TextField("Add your comments...", text: $comments)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.bottom)
            
            HStack {
                Button(action: {
                    print("Request Rejected")
                }) {
                    Text("Reject")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.red)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
                
                Button(action: {
                    print("Request Approved")
                }) {
                    Text("Approve")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
            }
        }
        .padding()
        .onAppear {
            if let referenceId = request.details.first?.referenceEntityId {
                //detailViewModel.fetchConflicts(referenceEntityId: referenceId)
                print("Fetch conflicts?")
            }
        }
        .navigationTitle("Request Details")
    }
}
