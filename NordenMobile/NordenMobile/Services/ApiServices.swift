//
//  ApiServices.swift
//  NordenMobile
//
//  Created by Roy Quesada on 4/3/25.
//

import Foundation

class ApiService {
    static let shared = ApiService()
    
    func fetchExampleData(completion: @escaping (Result<Data, Error>) -> Void) {
        guard let url = URL(string: "\(AppConfig.baseURL)/example-endpoint") else {
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

            completion(.success(data))
        }
        
        task.resume()
    }
}
