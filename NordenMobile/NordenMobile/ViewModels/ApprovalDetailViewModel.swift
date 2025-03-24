//
//  ApprovalDetailViewModel.swift
//  NordenMobile
//
//  Created by Roy Quesada on 19/3/25.
//

import Foundation
import Combine

class ApprovalDetailViewModel : ObservableObject {
    @Published var conflicts: [String] = []
    @Published var suggestions: [String] = []
    @Published var isLoading: Bool = false
    
    private var cancellables = Set<AnyCancellable>()
    
}
