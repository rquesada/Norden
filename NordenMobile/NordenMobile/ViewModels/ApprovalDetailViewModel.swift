//
//  ApprovalDetailViewModel.swift
//  NordenMobile
//
//  Created by Roy Quesada on 19/3/25.
//

import Foundation
import Combine

class ApprovalDetailViewModel : ObservableObject {
    @Published var suggestion: String?
    @Published var errorMessage: String?
    @Published var isLoading: Bool = false
    
    private var cancellables = Set<AnyCancellable>()
    
    func fetchSuggestion(vacationRequestId: String) {
        isLoading = true
        errorMessage = nil
        suggestion = nil

        VacationsService.shared.fetchAdminSuggestions(vacationRequestId: vacationRequestId) { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                switch result {
                case .success(let message):
                    self?.suggestion = message
                case .failure(let error):
                    self?.errorMessage = error.localizedDescription
                }
            }
        }
    }
    
    func submitApproval(notificationId: String, comment: String, isApproved: Bool, onComplete: @escaping (Result<String, Error>) -> Void) {
        isLoading = true
        VacationsService.shared.updateApproval(notificationId: notificationId, comment: comment, isApproved: isApproved) { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                onComplete(result)
            }
        }
    }
    
}
