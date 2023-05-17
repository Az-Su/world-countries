//
//  Assembler.swift
//  world-countries
//
//  Created by Sailau Almaz Maratuly on 15.05.2023.
//

import UIKit

final class Assembler {
    static let shared: Assembler = .init()
    private let network = NetworkService()
    
    private init() {}
    
    func wcMainModule() -> UIViewController {
        
        
        let countriesVC = WCMainViewController()
        countriesVC.title = "World countries"
        let countriesViewModel = WCMainViewModel()
        let countriesService = CountriesService(network: network)

        countriesVC.output = countriesViewModel
        countriesViewModel.view = countriesVC
        countriesViewModel.countriesService = countriesService
        
        return countriesVC
    }
    
    func detailVC(with cca2Code: String?) -> UIViewController {
        let countryDetailVC = WCDetailViewController()
        countryDetailVC.title = "World countries"
        let countryDetailViewModel = WCDetailViewModel()
        countryDetailViewModel.cca2Code = cca2Code
        let countryDetailService = CountriesService(network: network)
        
        countryDetailVC.output = countryDetailViewModel
        countryDetailViewModel.view = countryDetailVC
        countryDetailViewModel.countriesService = countryDetailService
        
        return countryDetailVC
    }
    
    func createMainNavigationController() -> UIViewController {
        let navController = UINavigationController(rootViewController: wcMainModule())
        return navController
    }
}
