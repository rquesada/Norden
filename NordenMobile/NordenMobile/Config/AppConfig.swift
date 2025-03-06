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
            return "https://qa-vacations-api.nordhen.com"
        }
    }
    
    static let hardcodedAuthToken = "Bearer eyJraWQiOiJqenJSelJZXC9MYUhcLzEzR3FpNTJ3Q20zQ1JzbTk2ZVJnRU5BdXNuZHd6djg9IiwiYWxnIjoiUlMyNTYifQ.eyJzdWIiOiJiMzhhYTFiMy1kOTlkLTQ3ZDQtYmRjNy04N2Y4MDUwNjE2MmIiLCJjb2duaXRvOmdyb3VwcyI6WyJjb2xsYWJvcmF0b3IiXSwiaXNzIjoiaHR0cHM6XC9cL2NvZ25pdG8taWRwLnVzLXdlc3QtMS5hbWF6b25hd3MuY29tXC91cy13ZXN0LTFfTnNyaFpNNVZaIiwiY2xpZW50X2lkIjoiNmJndjA2ZGlkdjh2dTkwYnNjM2JyMDZsODkiLCJvcmlnaW5fanRpIjoiN2ViNjc1M2YtN2FhMy00YWFjLWIwYTQtMWRjYmJjODcwOTkyIiwiZXZlbnRfaWQiOiJjZWNmMDVlNS1kZjY3LTRkYmEtYWZlZC1jNTc4MGMyM2E4ZDgiLCJ0b2tlbl91c2UiOiJhY2Nlc3MiLCJzY29wZSI6ImF3cy5jb2duaXRvLnNpZ25pbi51c2VyLmFkbWluIiwiYXV0aF90aW1lIjoxNzQxMjIwNjcwLCJleHAiOjE3NDEzMDcwNzAsImlhdCI6MTc0MTIyMDY3MCwianRpIjoiYTgxMmMxNDctNTEyYS00NmYwLTljYTItMDU5MmVkMTBiOTBhIiwidXNlcm5hbWUiOiJiMzhhYTFiMy1kOTlkLTQ3ZDQtYmRjNy04N2Y4MDUwNjE2MmIifQ.ijz9IuKFQ3k9FP_GqS2ZL1sQc6uMl4oI36KHnhu9XqbhY-rLsoZtAy_PHhJciZ4_k-tsnyOnMUioXsf-HOwW8yUehAxvygGaIqk0gLK5RhzLt507a6nWbExDr6rKsXlhDRo3on8x5Mbpyq3g_03hVgXFnPZ3ufwBwQkRz9sgg9t0urJ90PiEuPzNHBGnttZeqzAAjfREcqC--pNi3oFpAWBfR25Ve7vHhXTZecCUzO_YvSqBu_t-Dg0v_eZynSqbCM3sWi3qvscygMBG7_azVaSPQ4RGldw-IT3xN7vuGjuru3vl1_IorqGGMIMBTV1kozHGI-9ezItbw4cUmjnShg"

    // 🔹 Otras configuraciones globales
    static let requestTimeout: TimeInterval = 15.0
}
