//
//  AdminVacationsViewModel.swift
//  NordenMobile
//
//  Created by Roy Quesada on 14/3/25.
//

//
//  AdminVacationsViewModel.swift
//  NordenMobile
//
//  Created by Roy Quesada on 4/3/25.
//

import Foundation
import Combine

/// ViewModel responsible for managing  vacation-related data for administrators.
class AdminVacationsViewModel: ObservableObject {
    
    /// List of accounts associated with the administrator.
    @Published var accounts: [Account] = []
    
    /// List of collaborators belonging to the selected account.
    @Published var collaborators: [Collaborator] = [Collaborator(id: "all", fullName: "All Collaborators")]
    
    /// ID of the currently selected account.
    @Published var selectedAccountId: String = "all"
    
    /// ID of the currently selected collaborator.
    @Published var selectedCollaboratorId: String = "all"
    
    /// List of notifications related to vacations.
    @Published var notifications: [FlattenedNotification] = []
    
    /// List of approvals pending to review
    @Published var approvals: [ApprovalRequest] = []

    private var cancellables = Set<AnyCancellable>()
    
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?

    /// Initializes the ViewModel and fetches accounts upon creation.
    init() {
        fetchAccounts()
    }

    
    /// Fetches the list of accounts associated with the administrator.
    ///
    /// - Note: Sets `selectedAccountId` to the first available account and automatically fetches collaborators for that account.
    func fetchAccounts() {
        isLoading = true
        errorMessage = nil

        VacationsService.shared.fetchCollaboratorAccounts { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                switch result {
                case .success(let fetchedAccounts):
                    self?.accounts = fetchedAccounts
                    self?.selectedAccountId = fetchedAccounts.first?.id ?? ""
                    if let firstAccountId = self?.selectedAccountId {
                        self?.fetchCollaborators(for: firstAccountId)
                    }
                case .failure(let error):
                    self?.errorMessage = error.localizedDescription
                }
            }
        }
    }
    
    /// Fetches the list of collaborators for the given account.
    ///
    /// - Parameter accountId: The ID of the selected account.
    ///
    /// - Note: Resets `selectedCollaboratorId` to `"all"` before fetching the data.
    func fetchCollaborators(for accountId: String) {
        isLoading = true
        errorMessage = nil
        selectedCollaboratorId = "all"

        VacationsService.shared.fetchCollaborators(for: accountId) { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                switch result {
                case .success(let fetchedCollaborators):
                    self?.collaborators = [Collaborator(id: "all", fullName: "All Collaborators")] + fetchedCollaborators
                case .failure(let error):
                    self?.errorMessage = error.localizedDescription
                }
            }
        }
    }
    
    /// Updates the selected account and triggers fetching of collaborators for the new account.
    ///
    /// - Parameter accountId: The ID of the newly selected account.
    func updateSelectedAccount(_ accountId: String) {
        selectedAccountId = accountId
        fetchCollaborators(for: accountId)
    }
    
    /// Fetches the notifications for the selected team.
    ///
    /// - Parameter teamId: The ID of the team whose notifications should be fetched.
    ///
    /// - Note: If the API returns an error, the `errorMessage` is updated accordingly.
    func fetchNotifications(for teamId: String) {
        isLoading = true
        errorMessage = nil

        VacationsService.shared.fetchNotifications(for: teamId) { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                switch result {
                case .success(let fetchedNotifications):
                    self?.notifications = self?.formatNotifications(fetchedNotifications) ?? []
                case .failure(let error):
                    if let nsError = error as NSError?,
                       let serverMessage = nsError.userInfo[NSLocalizedDescriptionKey] as? String{
                        self?.errorMessage = serverMessage
                    } else {
                        self?.errorMessage = error.localizedDescription
                    }
                }
            }
        }
    }

    /// Fetches the approvals for selectect team
    ///
    /// - Parameter teamId: The ID of the team whose approvals should be fetched.
    ///
    /// - Note: If the API returns an error, the `errorMessage` is updated accordingly
    
    func fetchApprovals(for teamId: String) {
        isLoading = true
        errorMessage = nil
        
        VacationsService.shared.fetchApprovals(for: teamId) { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                switch result {
                case .success(let fetchedApprovals):
                    self?.approvals = fetchedApprovals
                case .failure(let error):
                    if let nsError = error as NSError?,
                       let serverMessage = nsError.userInfo[NSLocalizedDescriptionKey] as? String{
                        self?.errorMessage = serverMessage
                    } else {
                        self?.errorMessage = "Something went wrong. Please try again later."
                    }
                }
            }
        }
    }
    
    private func formatNotifications(_ data: [NotificationItem]) -> [FlattenedNotification] {
        return data.flatMap { notif in
            notif.details.map { detail in
                FlattenedNotification(
                    id: detail.id,
                    title: notif.title,
                    color: notif.color,
                    fullName: detail.fullName,
                    startDate: detail.startDate ?? "",
                    endDate: detail.endDate ?? "",
                    availableDays: detail.availableDays ?? "",
                    expirationDate: detail.expirationDate ?? "",
                    numberDays: detail.numberDays ?? ""
                )
            }
        }
    }
}
