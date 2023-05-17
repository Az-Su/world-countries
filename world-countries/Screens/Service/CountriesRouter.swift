//
//  CountriesRouter.swift
//  world-countries
//
//  Created by Sailau Almaz Maratuly on 15.05.2023.
//

enum CountriesRouter: Router {
    case getCountries
    case getCountry(cca2Code: String)
   
    var baseUrl: String {
        return "https://restcountries.com"
    }
    
    var path: String {
        switch self {
        case .getCountries:
            return "/v3.1/all"
        case .getCountry(let code):
            return "/v3.1/alpha/\(code)"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .getCountries, .getCountry:
            return .get
        }
    }
    
    var parameters: Parameters {
        switch self {
        case .getCountries, .getCountry:
            return [:]
        }
    }
}
