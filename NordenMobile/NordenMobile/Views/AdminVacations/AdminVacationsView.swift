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
                        viewModel.fetchExceptions(for: newAccountId)
                        viewModel.fetchApprovedVacations(for: newAccountId, year: viewModel.currentYear)
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
                    switch tab {
                    case .approvals:
                        Text("\(tab.rawValue) (\(viewModel.approvals.count))").tag(tab)
                    case .notifications:
                        Text("\(tab.rawValue) (\(viewModel.notifications.count))").tag(tab)
                    case .calendar:
                        Text(tab.rawValue).tag(tab)
                    }
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding(.horizontal)

            // 🔹 Contenido dinámico basado en la selección
            VStack {
                switch selectedTab {
                case .approvals:
                    ApprovalsView(viewModel: viewModel)
                case .calendar:
                    AdminCalendarView(viewModel: viewModel)
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

