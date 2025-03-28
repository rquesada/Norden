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
    
    func fetchVacationExceptions(teamId: String, completion: @escaping (Result<[Exception], Error>) -> Void) {
            guard let url = URL(string: "\(AppConfig.baseURL)/exception/exceptions/vacations?teamId=\(teamId)") else {
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
                if let error = error {
                    completion(.failure(error))
                    return
                }

                guard let data = data else {
                    completion(.failure(NSError(domain: "No data", code: 500)))
                    return
                }

                do {
                    let exceptions = try JSONDecoder().decode([Exception].self, from: data)
                    completion(.success(exceptions))
                } catch {
                    completion(.failure(error))
                }
            }.resume()
        }
}


//Extension used for Admins
extension VacationsService {
    func fetchCollaborators(for teamId: String, completion: @escaping (Result<[Collaborator], Error>) -> Void) {
        guard let url = URL(string: "\(AppConfig.baseURL)/collaborator/collaborators/by-team?teamId=\(teamId)") else {
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
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let data = data else {
                completion(.failure(NSError(domain: "No data", code: 500)))
                return
            }

            do {
                let collaborators = try JSONDecoder().decode([Collaborator].self, from: data)
                completion(.success(collaborators))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
    
    func fetchApprovals(for teamId: String, completion: @escaping (Result<[ApprovalRequest], Error>) -> Void) {
        let urlString = "\(AppConfig.baseURL)/notification/for-approval?teamId=\(teamId)"
        
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
                completion(.failure(NSError(domain: "No Data", code: 500, userInfo: nil)))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                completion(.failure(NSError(domain: "No response", code: 500, userInfo: [NSLocalizedDescriptionKey: "No response from server"])))
                return
            }
            
            // 🔹 Si hay un error en la respuesta del servidor, intentamos extraer el mensaje
            if httpResponse.statusCode >= 400 {
                do {
                    if let errorResponse = try? JSONDecoder().decode([String: String].self, from: data),
                       let message = errorResponse["message"] {
                        completion(.failure(NSError(domain: "Server Error", code: httpResponse.statusCode, userInfo: [NSLocalizedDescriptionKey: message])))
                    } else {
                        let responseString = String(data: data, encoding: .utf8) ?? "No Data"
                        print("🔴 Error Response: \(responseString)")
                        completion(.failure(NSError(domain: "Server Error", code: httpResponse.statusCode, userInfo: [NSLocalizedDescriptionKey: "Unexpected server response"])))
                    }
                }
                return
            }
            
            // 🔹 Imprimimos el JSON antes de intentar decodificar
            if let jsonString = String(data: data, encoding: .utf8) {
                print("📄 JSON Response:\n\(jsonString)")
            } else {
                print("❌ Could not convert JSON to String")
            }
            
            do {
                let decodedResponse = try JSONDecoder().decode([ApprovalRequest].self, from: data)
                completion(.success(decodedResponse))
            } catch let decodingError as DecodingError {
                // 🔹 Desglosamos el error de decodificación para obtener más información
                switch decodingError {
                case .dataCorrupted(let context):
                    print("❌ Data Corrupted Error: \(context.debugDescription)")
                case .keyNotFound(let key, let context):
                    print("❌ Key Not Found: \(key.stringValue) in \(context.debugDescription)")
                case .typeMismatch(let type, let context):
                    print("❌ Type Mismatch: \(type) in \(context.debugDescription)")
                case .valueNotFound(let type, let context):
                    print("❌ Value Not Found: \(type) in \(context.debugDescription)")
                @unknown default:
                    print("❌ Unknown Decoding Error")
                }
                
                print("🛑 Full Error: \(decodingError)")
                completion(.failure(decodingError))
            } catch {
                print("❌ General Decoding Error: \(error)")
                completion(.failure(error))
            }
        }
        .resume()
    }

    
    func fetchNotifications(for teamId: String, completion: @escaping (Result<[NotificationItem], Error>) -> Void) {
        let urlString = "\(AppConfig.baseURL)/notification/?teamId=\(teamId)&isAdmin=true"
        
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
            
            guard let httpResponse = response as? HTTPURLResponse else {
                completion(.failure(NSError(domain: "No response", code: 500, userInfo: [NSLocalizedDescriptionKey: "No response from server"])))
                return
            }
            
            if httpResponse.statusCode == 500 {
                do {
                    let errorResponse = try JSONDecoder().decode([String: String].self, from: data)
                    let message = errorResponse["message"] ?? "Internal Server Error"
                    completion(.failure(NSError(domain: "Server Error", code: 500, userInfo: [NSLocalizedDescriptionKey: message])))
                } catch {
                    completion(.failure(NSError(domain: "Server Error", code: 500, userInfo: [NSLocalizedDescriptionKey: "Unexpeted server response"])))
                }
                return
            }
            
            do {
                let decodedResponse = try JSONDecoder().decode([NotificationItem].self, from: data)
                completion(.success(decodedResponse))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
    
    func fetchAdminSuggestions(vacationRequestId: String, completion: @escaping (Result<String, Error>) -> Void) {
        guard let url = URL(string: "\(AppConfig.baseURL)/suggestions?vacationRequestId=\(vacationRequestId)") else {
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

        URLSession.shared.dataTask(with: request) { data, _, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let data = data else {
                completion(.failure(NSError(domain: "No data", code: 500)))
                return
            }

            do {
                let result = try JSONDecoder().decode(SuggestionResponse.self, from: data)
                completion(.success(result.reason))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
    
    func updateApproval(notificationId: String, comment: String, isApproved: Bool, completion: @escaping (Result<String, Error>) -> Void) {
        guard let url = URL(string: "\(AppConfig.baseURL)/notification/approval"),
              let token = AuthTokenManager.shared.getAuthToken() else {
            completion(.failure(NSError(domain: "Invalid request data", code: 400)))
            return
        }

        let body: [String: Any] = [
            "notificationId": notificationId,
            "comment": comment,
            "isApproved": isApproved
        ]

        guard let jsonData = try? JSONSerialization.data(withJSONObject: body) else {
            completion(.failure(NSError(domain: "Invalid JSON body", code: 500)))
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonData

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let data = data,
                  let response = try? JSONDecoder().decode([String: String].self, from: data),
                  let message = response["message"] else {
                completion(.failure(NSError(domain: "Invalid response", code: 500)))
                return
            }

            completion(.success(message))
        }.resume()
    }


}

