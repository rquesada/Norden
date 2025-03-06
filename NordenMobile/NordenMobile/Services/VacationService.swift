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

            var request = URLRequest(url: url)
            request.setValue(AppConfig.hardcodedAuthToken, forHTTPHeaderField: "Authorization")
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
                    let requests = try JSONDecoder().decode([VacationRequest].self, from: data)
                    completion(.success(requests))
                } catch {
                    completion(.failure(error))
                }
            }.resume()
        }
    
    func fetchApprovedVacations(teamId: String, year: Int, completion: @escaping (Result<[Vacation], Error>) -> Void) {
        guard let url = URL(string: "\(AppConfig.baseURL)/vacation_requests/approved?year=\(year)&teamId=\(teamId)") else {
            completion(.failure(NSError(domain: "Invalid URL", code: 400)))
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue(AppConfig.hardcodedAuthToken, forHTTPHeaderField: "Authorization")
        request.timeoutInterval = AppConfig.requestTimeout

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let data = data else {
                completion(.failure(NSError(domain: "No Data", code: 500)))
                return
            }

            do {
                let vacations = try JSONDecoder().decode([Vacation].self, from: data)
                completion(.success(vacations))
            } catch {
                completion(.failure(error))
            }
        }
        
        task.resume()
    }

    func fetchCollaboratorProfile(completion: @escaping (Result<CollaboratorProfile, Error>) -> Void) {
        guard let url = URL(string: "\(AppConfig.baseURL)/collaborator/collaborators/profile") else {
            completion(.failure(NSError(domain: "Invalid URL", code: 400)))
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue(AppConfig.hardcodedAuthToken, forHTTPHeaderField: "Authorization")
        request.timeoutInterval = AppConfig.requestTimeout

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let data = data else {
                completion(.failure(NSError(domain: "No Data", code: 500)))
                return
            }

            do {
                let profile = try JSONDecoder().decode(CollaboratorProfile.self, from: data)
                completion(.success(profile))
            } catch {
                completion(.failure(error))
            }
        }
        
        task.resume()
    }
    
    func fetchCollaboratorAccounts(completion: @escaping (Result<[Account], Error>) -> Void) {
        guard let url = URL(string: "\(AppConfig.baseURL)/team/listByLeader") else {
            completion(.failure(NSError(domain: "Invalid URL", code: 400)))
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue(AppConfig.hardcodedAuthToken, forHTTPHeaderField: "Authorization")
        request.timeoutInterval = AppConfig.requestTimeout

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let data = data else {
                completion(.failure(NSError(domain: "No Data", code: 500)))
                return
            }

            do {
                let accounts = try JSONDecoder().decode([Account].self, from: data)
                completion(.success(accounts))
            } catch {
                completion(.failure(error))
            }
        }
        task.resume()
    }
    
    // 🔹 Obtener mensajes de advertencia sobre vacaciones pendientes
    func fetchPendingVacationSuggestions(completion: @escaping (Result<[String], Error>) -> Void) {
        guard let url = URL(string: "\(AppConfig.baseURL)/suggestions/pending-vacations") else {
            completion(.failure(NSError(domain: "Invalid URL", code: 400, userInfo: nil)))
            return
        }

        var request = URLRequest(url: url)
        request.setValue(AppConfig.hardcodedAuthToken, forHTTPHeaderField: "Authorization")
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
                completion(.success(response.messages))
            } catch {
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

            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            request.setValue(AppConfig.hardcodedAuthToken, forHTTPHeaderField: "Authorization")
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
                    completion(.success(response.messages))
                } catch {
                    completion(.failure(error))
                }
            }.resume()
        }
    
}
