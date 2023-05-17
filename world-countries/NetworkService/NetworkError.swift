//
//  NetworkError.swift
//  world-countries
//
//  Created by Sailau Almaz Maratuly on 15.05.2023.
//

import Foundation

enum NetworkError: Error {
    case missingUrl
    case unavailableNetwork
    case responseError
    case decodeError
    case taskError
    
    var message: String {
        switch self {
        case .missingUrl:
            return "URL is missing..."
        case .unavailableNetwork:
            return "Network is unavailable..."
        case .responseError:
            return "Bad response..."
        case .decodeError:
            return "Failed in decoding code..."
        case .taskError:
            return "Error in URLSession data task.."
        }
    }
}
