//
//  VacationsViewModel.swift
//  NordenMobile
//
//  Created by Roy Quesada on 4/3/25.
//

//
//  VacationsViewModel.swift
//  NordenMobile
//
//  Created by Roy Quesada on 4/3/25.
//

import Foundation
import Combine

class VacationsViewModel: ObservableObject {
    @Published var collaboratorProfile: CollaboratorProfile?
    @Published var accountName: String?
    @Published var approvedVacations: [Vacation] = []
    @Published var vacationRequests: [VacationRequest] = [] // 🔹 Nuevo estado para las solicitudes de vacaciones
    @Published var selectedDate: Date = Date()
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?

    private var currentYear: Int = Calendar.current.component(.year, from: Date())
    var teamId: String?
    private var cancellables = Set<AnyCancellable>()
    
    // 🔹 Filtrar vacaciones aprobadas según el mes seleccionado
    func getVacationsForMonth() -> [Vacation] {
        let calendar = Calendar.current
        let selectedMonth = calendar.component(.month, from: selectedDate)
        let selectedYear = calendar.component(.year, from: selectedDate)

        return approvedVacations.filter { vacation in
            vacation.years.contains(selectedYear) && vacation.months.contains(selectedMonth)
        }
    }
    
    // 🔹 Cargar todos los datos iniciales
    func loadData() {
        isLoading = true
        errorMessage = nil

        let group = DispatchGroup()
        
        // 🔹 Cargar perfil del colaborador
        group.enter()
        VacationsService.shared.fetchCollaboratorProfile { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let profile):
                    self?.collaboratorProfile = profile
                    self?.teamId = profile.accountId
                case .failure(let error):
                    self?.errorMessage = error.localizedDescription
                }
                group.leave()
            }
        }
        
        // 🔹 Cargar cuentas del colaborador
        group.enter()
        VacationsService.shared.fetchCollaboratorAccounts { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let accounts):
                    self?.accountName = accounts.first?.name ?? "Unknown"
                case .failure(let error):
                    self?.errorMessage = error.localizedDescription
                }
                group.leave()
            }
        }
        
        // 🔹 Cargar solicitudes de vacaciones del colaborador
        group.enter()
        fetchVacationRequests {
            group.leave()
        }
        
        // 🔹 Cuando todos los endpoints terminan, cargar vacaciones aprobadas
        group.notify(queue: .main) {
            self.isLoading = false
            if let teamId = self.teamId {
                self.fetchApprovedVacations(year: self.currentYear)
            }
        }
    }

    // Get approved vacations
    func fetchApprovedVacations(year: Int) {
        guard let teamId = teamId else { return }
        isLoading = true
        
        VacationsService.shared.fetchApprovedVacations(teamId: teamId, year: year) { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                switch result {
                case .success(let vacations):
                    self?.approvedVacations = vacations
                case .failure(let error):
                    self?.errorMessage = error.localizedDescription
                }
            }
        }
    }

    // 🔹 Cargar solicitudes de vacaciones del colaborador
    func fetchVacationRequests(completion: @escaping () -> Void) {
        VacationsService.shared.fetchVacationRequests { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let requests):
                    self?.vacationRequests = requests
                case .failure(let error):
                    self?.errorMessage = error.localizedDescription
                }
                completion() // ✅ Indicar que la tarea ha finalizado
            }
        }
    }

    // 🔹 Manejar cambio de año en el calendario
    func updateYear(newYear: Int) {
        if newYear != currentYear {
            currentYear = newYear
            fetchApprovedVacations(year: newYear)
        }
    }
}


