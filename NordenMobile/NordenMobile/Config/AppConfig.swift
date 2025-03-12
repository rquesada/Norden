//
//  AppConfig.swift
//  NordenMobile
//
//  Created by Roy Quesada on 4/3/25.
//

import Foundation

enum Environment: String {
    case dev = "Development"
    case qa = "QA"
    case prod = "Production"
}


struct AppConfig {
    
    static let currentEnvironment: Environment = .dev

    // 🔹 Definir los endpoints por entorno
    static var baseURL: String {
        switch currentEnvironment {
        case .dev:
            return "https://qa-vacations-api.nordhen.com"
        case .qa:
            return "https://qa-vacations-api.nordhen.com"
        case .prod:
            return "https://vacations-api.nordhen.com"
        }
    }
    
    static let requestTimeout: TimeInterval = 15.0
}
