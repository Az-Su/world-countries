//
//  Router.swift
//  world-countries
//
//  Created by Sailau Almaz Maratuly on 15.05.2023.
//

import Foundation

protocol Router {
    typealias Headers = [String: String]
    typealias Parameters = [String: Any]
    typealias Body = [String: Any]
    
    var baseUrl: String { get }
    var path: String { get }
    var headers: Headers {get }
    var method: HTTPMethod { get }
    var parameters: Parameters { get }
    var body: Body { get }
    
    func request() throws -> URLRequest
}

extension Router {
    var headers: Headers {
        [:]
    }
    var body: Body {
        [:]
    }
    
    var httpBody: Data? {
        guard !body.isEmpty else { return nil }
        return try? JSONSerialization.data(withJSONObject: body, options: [])
    }
}

extension Router {
    func request() throws -> URLRequest {
        let urlString = baseUrl + path
        guard let url = URL(string: urlString) else {
            throw NetworkError.missingUrl
        }
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.httpBody = httpBody
        
        addHeaders(to: &request)
        addParameters(to: &request)
        
        return request
    }
        
    private func addHeaders(to request: inout URLRequest) {
        for (key, value) in headers {
            request.addValue(value, forHTTPHeaderField: key)
        }
    }
    
    private func addParameters(to request: inout URLRequest) {
        guard let url = request.url else { return  }
        if var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false) {
            urlComponents.queryItems = []
            for (key, value) in parameters {
                let queryItem = URLQueryItem(name: key, value: "\(value)")
                urlComponents.queryItems?.append(queryItem)
            }
            request.url = urlComponents.url
        }
    }
}
