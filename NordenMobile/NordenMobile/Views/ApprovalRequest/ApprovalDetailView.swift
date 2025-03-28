//
//  ApprovalDetailView.swift
//  NordenMobile
//
//  Created by Roy Quesada on 19/3/25.
//

import SwiftUI

struct ApprovalDetailView: View {
    let request: ApprovalRequest
    var onSuccess: () -> Void
    
    @StateObject private var detailViewModel = ApprovalDetailViewModel()
    @State private var comments: String = ""
    @State private var showAlert: Bool = false
    @State private var alertMessage: String = ""

    var body: some View {
        VStack(spacing: 0) {
            VStack(alignment: .leading, spacing: 16) {
                HStack {
                    Text("Vacation Request Details")
                        .font(.title2)
                        .bold()
                }

                Text("Review the request and check for any conflicts")
                    .font(.footnote)
                    .foregroundColor(.gray)
                
                Divider()

                // Collaborator
                HStack(alignment: .top, spacing: 12) {
                    Circle()
                        .fill(Color("personlightBlue"))
                        .frame(width: 50, height: 50)
                        .overlay(Image(systemName: "person.fill").foregroundColor(.blue))
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text(request.details.first?.fullName ?? "")
                            .font(.headline)
                        Text("Requested on \(request.details.first?.createdAt.toDisplayDate() ?? "-")")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                        HStack(spacing: 16) {
                            HStack(spacing: 4) {
                                Image(systemName: "star")
                                    .foregroundColor(.orange)
                                Text(request.details.first?.seniority ?? "")
                                    .foregroundColor(Color("secondaryColor"))
                            }

                            HStack(spacing: 4) {
                                Image(systemName: "clock")
                                    .foregroundColor(.orange)
                                Text("\(request.details.first?.tenure ?? 0) years")
                                    .foregroundColor(Color("secondaryColor"))
                            }
                        }

                        .font(.footnote)
                    }
                }

                // 🔹 Dates
                HStack(alignment: .top, spacing: 12) {
                    Circle()
                        .fill(Color("calendarGreen"))
                        .frame(width: 50, height: 50)
                        .overlay(Image(systemName: "calendar").foregroundColor(.green))
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Date Range:")
                            .font(.headline)
                        Text("\(request.details.first?.startDate.toDisplayDate() ?? "") - \(request.details.first?.endDate.toDisplayDate() ?? "")")
                            .foregroundColor(.gray)
                            .font(.subheadline)
                        Text("\(request.details.first?.numberDays ?? "-") business days")
                            .foregroundColor(Color("secondaryColor"))
                            .font(.footnote)
                    }
                }

                // 🔹 Suggestions
                if detailViewModel.isLoading {
                    ProgressView("Loading suggestion...")
                } else if let suggestion = detailViewModel.suggestion {
                    VStack(alignment: .leading, spacing: 6) {
                        Text(suggestion)
                            .padding()
                            .background(Color.orange.opacity(0.1))
                            .cornerRadius(8)
                            .font(.footnote)
                            .foregroundColor(.gray)
                    }
                }

                // 🔹 Comments
                HStack(alignment: .top, spacing: 12) {
                    Circle()
                        .fill(Color.purple.opacity(0.2))
                        .frame(width: 50, height: 50)
                        .overlay(Image(systemName: "bubble.left.and.bubble.right").foregroundColor(.purple))

                    VStack(alignment: .leading, spacing: 8) {
                        Text("Your Comments:")
                            .font(.headline)
                        TextEditor(text: $comments)
                            .frame(height: 80)
                            .padding(8)
                            .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.gray.opacity(0.2)))
                    }
                }

                // 🔹 Buttons
                HStack(spacing: 12) {
                    
                    Button("Reject") {
                        guard !comments.isEmpty else {
                            alertMessage = "Please provide a comment before rejecting the request."
                            showAlert = true
                            return
                        }
                        detailViewModel.submitApproval(
                            notificationId: request.id,
                            comment: comments,
                            isApproved: false
                        ) { result in
                            switch result {
                            case .success(let msg):
                                print("✅ \(msg)")
                                onSuccess()
                            case .failure(let error):
                                print("❌ \(error.localizedDescription)")
                                alertMessage = error.localizedDescription
                                showAlert = true
                            }
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.red)
                    .foregroundColor(.white)
                    .cornerRadius(8)

                    Button("Approve") {
                        guard !comments.isEmpty else {
                            alertMessage = "Please provide a comment before approving the request."
                            showAlert = true
                            return
                        }
                        detailViewModel.submitApproval(
                            notificationId: request.id,
                            comment: comments,
                            isApproved: true
                        ) { result in
                            switch result {
                            case .success(let msg):
                                print("✅ \(msg)")
                                onSuccess()
                            case .failure(let error):
                                print("❌ \(error.localizedDescription)")
                                alertMessage = error.localizedDescription
                                showAlert = true
                            }
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.green)
                    .foregroundColor(.white)
                    .cornerRadius(8)
                }
            }
            .padding()
        }
        .background(Color.white)
        .cornerRadius(12)
        .padding()
        .onAppear {
            if let id = request.details.first?.referenceEntityId {
                detailViewModel.fetchSuggestion(vacationRequestId: id)
            }
        }
        .alert("Error", isPresented: $showAlert) {
            Button("OK", role: .cancel) { }
        } message: {
            Text(alertMessage)
        }

        
    }
}

