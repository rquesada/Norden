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
    
    /// List of exceptions for current team organized by year and month
    @Published var organizedExceptions: [String: [String: [Exception]]] = [:]
    
    /// Vacation calendar organized by year and month
    @Published var organizedVacations: [String: [String: [Vacation]]] = [:]
    
    @Published var currentMonth: Int = Calendar.current.component(.month, from: Date())
    @Published var currentYear: Int = Calendar.current.component(.year, from: Date())


    private var cancellables = Set<AnyCancellable>()
    
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?

    /// Initializes the ViewModel and fetches accounts upon creation.
    init() {
        fetchAccounts()
    }
    
    func goToPreviousMonth() {
        if currentMonth == 1 {
            currentMonth = 12
            currentYear -= 1
            fetchApprovedVacations(for: selectedAccountId, year: currentYear) // 🔁
        } else {
            currentMonth -= 1
        }
    }

    func goToNextMonth() {
        if currentMonth == 12 {
            currentMonth = 1
            currentYear += 1
            fetchApprovedVacations(for: selectedAccountId, year: currentYear) // 🔁
        } else {
            currentMonth += 1
        }
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
    
    /// Fetches the exception days for selectect team
    ///
    /// - Parameter teamId: The ID of the team whose approvals should be fetched.
    ///
    /// - Note: If the API returns an error, the `errorMessage` is updated accordingly
    func fetchExceptions(for teamId: String){
        isLoading = true
        errorMessage = nil
        
        VacationsService.shared.fetchVacationExceptions(teamId: teamId){ [weak self] result in
            DispatchQueue.main.async{
                self?.isLoading = false;
                switch result{
                    case .success(let fetchedExceptions):
                    self?.organizedExceptions =  self?.organizeExceptionsByYearAndMonth(fetchedExceptions) ?? [:]
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
    
    /// Fetches the vacation days for selectect team
    ///
    /// - Parameter teamId: The ID of the team whose approvals should be fetched.
    /// - Parameter year: The year of the vacation get
    ///
    /// - Note: If the API returns an error, the `errorMessage` is updated accordingly
    func fetchApprovedVacations(for teamId: String, year: Int) {
            isLoading = true
            errorMessage = nil

            VacationsService.shared.fetchApprovedVacations(teamId: teamId, year: year) { [weak self] result in
                DispatchQueue.main.async {
                    self?.isLoading = false
                    switch result {
                    case .success(let vacations):
                        self?.organizedVacations = self?.organizeVacationsByYearAndMonth(vacations) ?? [:]
                    case .failure(let error):
                        self?.errorMessage = error.localizedDescription
                    }
                }
            }
        }
    
    func organizeExceptionsByYearAndMonth(_ exceptions: [Exception]) -> [String: [String: [Exception]]] {
        var organized: [String: [String: [Exception]]] = [:]
        let calendar = Calendar.current
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"

        for exception in exceptions {
            guard let start = formatter.date(from: exception.startDate),
                  let end = formatter.date(from: exception.endDate) else {
                continue
            }

            var current = start
            while current <= end {
                let year = String(calendar.component(.year, from: current))
                let month = String(calendar.component(.month, from: current))

                organized[year, default: [:]][month, default: []].append(exception)

                guard let nextDay = calendar.date(byAdding: .day, value: 1, to: current) else { break }
                current = nextDay
            }
        }

        return organized
    }
    
    func getExceptions(forYear year: Int, month: Int) -> [Exception] {
        let yearKey = String(year)
        let monthKey = String(month)
        return organizedExceptions[yearKey]?[monthKey] ?? []
    }
    
    func organizeVacationsByYearAndMonth(_ vacations: [Vacation]) -> [String: [String: [Vacation]]] {
        var organized: [String: [String: [Vacation]]] = [:]
        let calendar = Calendar.current
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"

        for vacation in vacations {
            guard let start = formatter.date(from: vacation.startDate),
                  let end = formatter.date(from: vacation.endDate) else {
                continue
            }

            var current = start
            while current <= end {
                let year = String(calendar.component(.year, from: current))
                let month = String(calendar.component(.month, from: current))

                organized[year, default: [:]][month, default: []].append(vacation)

                guard let nextDay = calendar.date(byAdding: .day, value: 1, to: current) else { break }
                current = nextDay
            }
        }
        
        return organized
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
    
    func exceptionsFor(date: Date) -> [Exception] {
        let calendar = Calendar.current
        let yearKey = String(calendar.component(.year, from: date))
        let monthKey = String(calendar.component(.month, from: date))
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"

        let exceptions = organizedExceptions[yearKey]?[monthKey]?.filter { exception in
            guard let start = formatter.date(from: exception.startDate),
                  let end = formatter.date(from: exception.endDate) else {
                return false
            }
            return start <= date && date <= end
        } ?? []

        let uniqueById = Dictionary(grouping: exceptions, by: { $0.id }).compactMap { $0.value.first }

        return uniqueById
    }


    func vacationsFor(date: Date) -> [Vacation] {
        let calendar = Calendar.current
        let yearKey = String(calendar.component(.year, from: date))
        let monthKey = String(calendar.component(.month, from: date))
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"

        let vacations = organizedVacations[yearKey]?[monthKey]?.filter { vacation in
            guard let start = formatter.date(from: vacation.startDate),
                  let end = formatter.date(from: vacation.endDate) else {
                return false
            }
            return start <= date && date <= end
        } ?? []

        // 🔹 Agrupar por id y devolver solo uno por id
        let uniqueById = Dictionary(grouping: vacations, by: { $0.id }).compactMap { $0.value.first }

        return uniqueById
    }


}
