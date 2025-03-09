//
//  VacationService.swift
//  NordenMobile
//
//  Created by Roy Quesada on 4/3/25.
//

import Foundation

class VacationsService {
    static let shared = VacationsService()

    func fetchVacationRequests(completion: @escaping (Result<[VacationRequest], Error>) -> Void) {
        guard let url = URL(string: "\(AppConfig.baseURL)/vacation_requests/my-vacations-requests") else {
            completion(.failure(NSError(domain: "Invalid URL", code: 400, userInfo: nil)))
            return
        }
        
        guard let token = AuthTokenManager.shared.getAuthToken() else {
            completion(.failure(NSError(domain: "Missing Auth Token", code: 401, userInfo: nil)))
            return
        }

        var request = URLRequest(url: url)
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.timeoutInterval = AppConfig.requestTimeout
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            self.handleResponse(data: data, response: response, error: error, completion: completion)
        }.resume()
    }

    func fetchApprovedVacations(teamId: String, year: Int, completion: @escaping (Result<[Vacation], Error>) -> Void) {
        guard let url = URL(string: "\(AppConfig.baseURL)/vacation_requests/approved?year=\(year)&teamId=\(teamId)") else {
            completion(.failure(NSError(domain: "Invalid URL", code: 400)))
            return
        }
        
        guard let token = AuthTokenManager.shared.getAuthToken() else {
            completion(.failure(NSError(domain: "Missing Auth Token", code: 401)))
            return
        }

        var request = URLRequest(url: url)
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.timeoutInterval = AppConfig.requestTimeout

        URLSession.shared.dataTask(with: request) { data, response, error in
            self.handleResponse(data: data, response: response, error: error, completion: completion)
        }.resume()
    }

    func fetchCollaboratorProfile(completion: @escaping (Result<CollaboratorProfile, Error>) -> Void) {
        guard let url = URL(string: "\(AppConfig.baseURL)/collaborator/collaborators/profile") else {
            completion(.failure(NSError(domain: "Invalid URL", code: 400)))
            return
        }
        
        guard let token = AuthTokenManager.shared.getAuthToken() else {
            completion(.failure(NSError(domain: "Missing Auth Token", code: 401)))
            return
        }

        var request = URLRequest(url: url)
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.timeoutInterval = AppConfig.requestTimeout

        URLSession.shared.dataTask(with: request) { data, response, error in
            self.handleResponse(data: data, response: response, error: error, completion: completion)
        }.resume()
    }

    func fetchCollaboratorAccounts(completion: @escaping (Result<[Account], Error>) -> Void) {
        guard let url = URL(string: "\(AppConfig.baseURL)/team/listByLeader") else {
            completion(.failure(NSError(domain: "Invalid URL", code: 400)))
            return
        }

        guard let token = AuthTokenManager.shared.getAuthToken() else {
            completion(.failure(NSError(domain: "Missing Auth Token", code: 401)))
            return
        }

        var request = URLRequest(url: url)
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.timeoutInterval = AppConfig.requestTimeout

        URLSession.shared.dataTask(with: request) { data, response, error in
            self.handleResponse(data: data, response: response, error: error, completion: completion)
        }.resume()
    }

    func fetchPendingVacationSuggestions(completion: @escaping (Result<[String], Error>) -> Void) {
        guard let url = URL(string: "\(AppConfig.baseURL)/suggestions/pending-vacations") else {
            completion(.failure(NSError(domain: "Invalid URL", code: 400, userInfo: nil)))
            return
        }

        guard let token = AuthTokenManager.shared.getAuthToken() else {
            completion(.failure(NSError(domain: "Missing Auth Token", code: 401, userInfo: nil)))
            return
        }

        var request = URLRequest(url: url)
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.timeoutInterval = AppConfig.requestTimeout

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let data = data else {
                completion(.failure(NSError(domain: "No data", code: 500, userInfo: nil)))
                return
            }

            do {
                let response = try JSONDecoder().decode(PendingVacationResponse.self, from: data)
                completion(.success(response.messages)) // 🔹 Extraemos solo el array de mensajes
            } catch {
                print("❌ JSON Decoding Error: \(error)")
                print("🔹 Response JSON: \(String(data: data, encoding: .utf8) ?? "No Data")")
                completion(.failure(error))
            }
        }.resume()
    }

    func fetchVacationConflicts(teamId: String, startDate: String, endDate: String, completion: @escaping (Result<[String], Error>) -> Void) {
        let urlString = "\(AppConfig.baseURL)/suggestions/conflict?teamId=\(teamId)&startDate=\(startDate)&endDate=\(endDate)"
        
        guard let url = URL(string: urlString) else {
            completion(.failure(NSError(domain: "Invalid URL", code: 400, userInfo: nil)))
            return
        }

        guard let token = AuthTokenManager.shared.getAuthToken() else {
            completion(.failure(NSError(domain: "Missing Auth Token", code: 401, userInfo: nil)))
            return
        }

        var request = URLRequest(url: url)
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.timeoutInterval = AppConfig.requestTimeout

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NSError(domain: "No data", code: 500, userInfo: nil)))
                return
            }
            
            do {
                let response = try JSONDecoder().decode(PendingVacationResponse.self, from: data)
                completion(.success(response.messages)) // 🔹 Extraemos solo el array de mensajes
            } catch {
                print("❌ JSON Decoding Error: \(error)")
                print("🔹 Response JSON: \(String(data: data, encoding: .utf8) ?? "No Data")")
                completion(.failure(error))
            }
            
            
        }.resume()
    }

    // 🔹 Manejo de respuestas genérico para todas las funciones
    private func handleResponse<T: Decodable>(data: Data?, response: URLResponse?, error: Error?, completion: @escaping (Result<T, Error>) -> Void) {
        if let error = error {
            completion(.failure(error))
            return
        }

        guard let data = data else {
            completion(.failure(NSError(domain: "No Data", code: 500)))
            return
        }
        
        if let jsonString = String(data: data, encoding: .utf8) {
            print("🔹 Response JSON: \(jsonString)")
        } else {
            print("❌ Could not convert data to String")
        }

        do {
            let decodedData = try JSONDecoder().decode(T.self, from: data)
            completion(.success(decodedData))
        } catch {
            completion(.failure(error))
        }
    }
    
    func submitVacationRequest(
        collaboratorId: String,
        teamId: String,
        startDate: String,
        endDate: String,
        reason: String,
        completion: @escaping (Result<VacationRequestResponse, Error>) -> Void
    ) {
        guard let url = URL(string: "\(AppConfig.baseURL)/vacation_requests/create"),
              let token = AuthTokenManager.shared.getAuthToken() else {
            completion(.failure(NSError(domain: "Invalid request data", code: 400, userInfo: nil)))
            return
        }

        let requestBody: [String: Any] = [
            "collaboratorId": collaboratorId,
            "teamId": teamId,
            "dateRanges": [["startDate": startDate, "endDate": endDate]],
            "reason": reason,
            "createdBy": collaboratorId,
            "isAdmin": false
        ]

        guard let jsonData = try? JSONSerialization.data(withJSONObject: requestBody) else {
            completion(.failure(NSError(domain: "Failed to encode request", code: 500, userInfo: nil)))
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonData

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let data = data else {
                completion(.failure(NSError(domain: "No response data", code: 500, userInfo: nil)))
                return
            }
            
            print(String(data: data, encoding: .utf8) ?? "No data")

            do {
                let decodedResponse = try JSONDecoder().decode(VacationRequestResponse.self, from: data)
                completion(.success(decodedResponse))
            } catch {
                if let errorResponse = try? JSONDecoder().decode([String: String].self, from: data),
                   let errorMessage = errorResponse["error"] {
                    
                    completion(.failure(NSError(domain: "Server Error", code: 500, userInfo: [NSLocalizedDescriptionKey: errorMessage])))
                } else {
                    completion(.failure(NSError(domain: "Unexpected response format", code: 500, userInfo: nil)))
                }
            }
        }.resume()
    }
}
