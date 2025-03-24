//
//  AdminVacations.swift
//  NordenMobile
//
//  Created by Roy Quesada on 4/3/25.
//

import SwiftUI

struct AdminVacationsView: View {
    @State private var selectedTab: AdminTab = .approvals
    @StateObject private var viewModel = AdminVacationsViewModel()

    var body: some View {
        VStack {
            VStack {
                HStack {
                    Text("Admin Vacations")
                        .font(.title)
                        .bold()
                        .foregroundColor(Color("primaryColor"))
                    Spacer()
                }
                .padding(.horizontal)

                HStack {
                    Picker("Account", selection: $viewModel.selectedAccountId) {
                        ForEach(viewModel.accounts, id: \.id) { account in
                            Text(account.name).tag(account.id)
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                    .frame(maxWidth: .infinity)
                    .onChange(of: viewModel.selectedAccountId){ oldAccountId, newAccountId in
                        viewModel.fetchCollaborators(for: newAccountId)
                        viewModel.fetchNotifications(for: newAccountId)
                        viewModel.fetchApprovals(for: newAccountId)
                    }

                    Picker("Collaborator", selection: $viewModel.selectedCollaboratorId) {
                        ForEach(viewModel.collaborators, id: \.id) { collaborator in
                            Text(collaborator.fullName).tag(collaborator.id)
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                    .frame(maxWidth: .infinity)
                }
                .padding(.horizontal)
            }
            .padding(.bottom, 10)

            Picker("Section", selection: $selectedTab) {
                ForEach(AdminTab.allCases, id: \.self) { tab in
                    Text(tab.rawValue).tag(tab)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding(.horizontal)

            // 🔹 Contenido dinámico basado en la selección
            VStack {
                switch selectedTab {
                case .approvals:
                    ApprovalsView(approvalRequests: viewModel.approvals)
                case .calendar:
                    AdminCalendarView()
                case .notifications:
                    NotificationsView(notifications: viewModel.notifications, errorMessage: viewModel.errorMessage)
                }
            }
            .padding(.top, 10)

            Spacer()
        }
    }
}

// 🔹 Enum para las secciones
enum AdminTab: String, CaseIterable {
    case approvals = "Approvals"
    case calendar = "Calendar"
    case notifications = "Notifications"
}

#Preview {
    AdminVacationsView()
}

