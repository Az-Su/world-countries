//
//  WCMainViewModel.swift
//  world-countries
//
//  Created by Sailau Almaz Maratuly on 15.05.2023.
//

import Foundation

protocol WCMainViewModelProtocol {
    func didLoad()
}

enum Continent: String {
    case europe = "Europe"
    case asia = "Asia"
    case northAmerica = "North America"
    case southAmerica = "South America"
    case africa = "Africa"
    case oceania = "Oceania"
    case antarctica = "Antarctica"
}

final class WCMainViewModel: WCMainViewModelProtocol {
    
    weak var view: WCMainViewProtocol?
    var countriesService: CountriesServiceProtocol?
    private var grouoedCountries: [[Country]] = [[]]

    // MARK: - WCMainViewProtocol
    
    func didLoad() {
        getCountries()
    }
    
    // MARK: - Private methods
    
    private func getCountries() {
        // start loading
        view?.updateView(withLoader: true)
        
        countriesService?.getAllCountries { [weak self] result in
            // stop loading
            self?.view?.updateView(withLoader: false)
            switch result {
            case .success(let countries):
                let groupedCountries = self?.divideCountriesByContinent(countries: countries) ?? []
                self?.view?.display(countries: groupedCountries)
            case .failure(let error):
                // show error alert
                self?.view?.showErrorAlert(message: error.message)
            }
        }
    }
    
    private func divideCountriesByContinent(countries: [Country]) -> [[Country]] {
        var groupedCountries: [[Country]] = []
        var dict: [String: [Country]] = [
            Continent.europe.rawValue : [],
            Continent.asia.rawValue : [],
            Continent.northAmerica.rawValue : [],
            Continent.southAmerica.rawValue : [],
            Continent.africa.rawValue : [],
            Continent.oceania.rawValue : [],
            Continent.antarctica.rawValue : []
        ]
        countries.forEach {
            if let key = $0.continents?.first {
                dict[key]?.append($0)
            }
        }
        dict.forEach { groupedCountries.append($0.value) }
        self.grouoedCountries = groupedCountries
        return groupedCountries
    }
}
