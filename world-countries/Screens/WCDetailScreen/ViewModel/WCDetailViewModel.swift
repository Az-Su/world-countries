//
//  WCDetailViewModel.swift
//  world-countries
//
//  Created by Sailau Almaz Maratuly on 16.05.2023.
//

import Foundation

protocol WCDetailViewModelProtocol {
    func didLoad()
}

final class WCDetailViewModel: WCDetailViewModelProtocol {
    weak var view: WCDetailViewProtocol?
    var countriesService: CountriesServiceProtocol?
    var cca2Code: String?

    // MARK: - WCMainViewProtocol
    
    func didLoad() {
        guard let cca2Code = cca2Code else {
            return
        }
        
        getCountry(by: cca2Code)

    }
    
    // MARK: - Private methods
    
    private func getCountry(by cca2Code: String) {
        // start loading
        countriesService?.getCountry(by: cca2Code) { [weak self] result in
            // stop loading
            switch result {
            case .success(let countries):
                if let country = countries.first {
                    self?.view?.display(country: country)
                }
            case .failure(let error):
                // show error alert
                self?.view?.showErrorAlert(message: error.message)
            }
        }
    }
}



