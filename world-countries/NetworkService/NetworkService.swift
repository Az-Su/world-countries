//
//  NetworkService.swift
//  world-countries
//
//  Created by Sailau Almaz Maratuly on 15.05.2023.
//

import Foundation

protocol NetworkServiceProtocol {
    func execute<T: Decodable>(with router: Router, completion: @escaping (Result<T, NetworkError>) -> Void)
}

final class NetworkService: NetworkServiceProtocol {
    private let session = URLSession(configuration: .default)
    
    func execute<T: Decodable>(with router: Router, completion: @escaping (Result<T, NetworkError>) -> Void) {
        call(with: router) { result in
            DispatchQueue.main.async {
                completion(result)
            }
        }
    }
    
    private func call<T>(with router: Router, completion: @escaping (Result<T, NetworkError>) -> Void) where T: Decodable {
        guard let request = try? router.request() else {
            completion(.failure(.missingUrl))
            return
        }
        
        let task = session.dataTask(with: request) { data, response, error in
            if let _ = error {
                completion(.failure(.taskError))
            }
            
            guard let response = response as? HTTPURLResponse,
                  case (200...209) = response.statusCode else {
                completion(.failure(.responseError))
                return
            }
            
            guard let data = data else {
                completion(.failure(.responseError))
                return
            }
            
            guard let decodableResult = try? JSONDecoder().decode(T.self, from: data) else {
                completion(.failure(.decodeError))
                return
            }
            completion(.success(decodableResult))
        }
        task.resume()
    }
}
