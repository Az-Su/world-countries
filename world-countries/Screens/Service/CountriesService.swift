//
//  CountriesService.swift
//  world-countries
//
//  Created by Sailau Almaz Maratuly on 15.05.2023.
//

protocol CountriesServiceProtocol {
    func getAllCountries(completion: @escaping (Result<[Country], NetworkError>) -> Void)
    func getCountry(by cca2Code: String, completion: @escaping (Result<[Country], NetworkError>) -> Void)
    
}

final class CountriesService: CountriesServiceProtocol {
    
   private let network: NetworkServiceProtocol
    
    init(network: NetworkServiceProtocol) {
        self.network = network
    }
    
    // MARK: - UsersServiceProtocol
    
    func getAllCountries(completion: @escaping (Result<[Country], NetworkError>) -> Void) {
        network.execute(with: CountriesRouter.getCountries, completion: completion)
    }
    
    func getCountry(by cca2Code: String, completion: @escaping (Result<[Country], NetworkError>) -> Void) {
        network.execute(with: CountriesRouter.getCountry(cca2Code: cca2Code), completion: completion)
    }
}
