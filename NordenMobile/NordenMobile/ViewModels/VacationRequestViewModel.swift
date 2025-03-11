//
//  VacationRequestViewModel.swift
//  NordenMobile
//
//  Created by Roy Quesada on 5/3/25.
//

import Foundation
import Combine

import Foundation
import Combine

class VacationRequestViewModel: ObservableObject {
    @Published var pendingMessages: [String] = []
    @Published var conflictMessages: [String] = [] // 🔹 Almacena mensajes de conflicto
    @Published var startDate: String = ""
    @Published var endDate: String = ""
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    @Published var isSubmitting: Bool = false
    @Published var reason: String = ""
    @Published var requestSuccess: Bool = false

    private var cancellables = Set<AnyCancellable>()
    private var teamId: String
    private var collaboratorId: String
    

    init(teamId: String, collaboratorId: String) {
        self.teamId = teamId
        self.collaboratorId = collaboratorId
        fetchPendingVacationSuggestions()
    }

    func fetchPendingVacationSuggestions() {
        isLoading = true
        VacationsService.shared.fetchPendingVacationSuggestions { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                switch result {
                case .success(let messages):
                    self?.pendingMessages = messages
                case .failure(let error):
                    self?.errorMessage = error.localizedDescription
                }
            }
        }
    }
    
    func checkForVacationConflicts() {
        guard !startDate.isEmpty, !endDate.isEmpty else { return } // Solo ejecutar si ambas fechas están seleccionadas

        isLoading = true
        VacationsService.shared.fetchVacationConflicts(teamId: teamId, startDate: startDate, endDate: endDate) { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                switch result {
                case .success(let messages):
                    self?.conflictMessages = messages
                case .failure(let error):
                    self?.errorMessage = error.localizedDescription
                }
            }
        }
    }
    
    func submitVacationRequest() {
        isSubmitting = true
        errorMessage = nil

        VacationsService.shared.submitVacationRequest(
            collaboratorId: collaboratorId,
            teamId: teamId,
            startDate: startDate,
            endDate: endDate,
            reason: reason
        ) { [weak self] result in
            DispatchQueue.main.async {
                self?.isSubmitting = false
                switch result {
                case .success(let response):
                    if response.error == nil || response.error?.isEmpty == true {
                        self?.requestSuccess = true // ✅ Ahora se ejecutará correctamente
                    } else {
                        self?.errorMessage = response.error
                    }
                case .failure(let error):
                    self?.errorMessage = error.localizedDescription
                }
            }
        }
    }
}
