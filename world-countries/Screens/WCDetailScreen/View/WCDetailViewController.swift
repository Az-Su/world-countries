//
//  WCDetailViewController.swift
//  world-countries
//
//  Created by Sailau Almaz Maratuly on 15.05.2023.
//

import Foundation
import UIKit
import SnapKit

protocol WCDetailViewProtocol: AnyObject {
    func display(country: Country)
    func showErrorAlert(message: String)
    
}

final class WCDetailViewController: BaseViewController, WCDetailViewProtocol {
    
    /// This variable is necessary for a single sample of a country
    /// Empty properties were set because initialization is required
    private var country = Constants.Values.defaultCountry
    
    
    var output: WCDetailViewModelProtocol?
    
    private lazy var descriptionTableView = configure(UITableView()) {
        $0.separatorStyle = .none
        $0.showsVerticalScrollIndicator = false
        $0.dataSource = self
        $0.delegate = self
        $0.alwaysBounceVertical = false
        $0.register(WCDetailViewCell.self, forCellReuseIdentifier: WCDetailViewCell.typeName)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        output?.didLoad()
        configureViews()
    }
    
    func display(country: Country) {
        self.country = country
        self.title = country.name?.common
        descriptionTableView.reloadData()
    }
    
    func showErrorAlert(message: String) {
        let alert = UIAlertController(
            title: "Error occurs.",
            message: message,
            preferredStyle: .alert)
        let action = UIAlertAction(title: "Ok", style: .default)
        alert.addAction(action)
        present(alert, animated: true)
    }
}

extension WCDetailViewController: UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 8
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: WCDetailViewCell.typeName, for: indexPath) as! WCDetailViewCell
        
        switch indexPath.row {
        case 0:
            cell.configure(title: "Region:", with: country.subregion ?? "")
        case 1:
            cell.configure(title: "Country name:", with: country.name?.common ?? "")
        case 2:
            cell.configure(title: "Capital:", with: country.capital?.first ?? "")
        case 3:
            cell.configure(title: "Capital coordinates:", with: convertToGPS(latlng: country.latlng) ?? "")
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(labelTapped(_:)))
            cell.valueLabel.isUserInteractionEnabled = true
            cell.valueLabel.addGestureRecognizer(tapGesture)
        case 4:
            cell.configure(title: "Population:", with: String(FormatHelper.formatPopulation(country.population ?? 0)))
        case 5:
            cell.configure(title: "Area:", with: String(FormatHelper.formatArea(country.area ?? 0)))
        case 6:
            cell.configure(title: "Currency:", with: FormatHelper.formatCurrency(country))
        case 7:
            cell.configure(title: "Timezones:", with: country.timezones?.first ?? "")
        default:
            cell.configure(title: ":", with: "")
        }
        
        return cell
    }
    
    func convertToGPS(latlng: [Double]?) -> String? {
        guard let coordinates = latlng, coordinates.count == 2 else {
            return nil
        }
        
        let latitude = coordinates[0]
        let longitude = coordinates[1]
        
        // Convert latitude and longitude to degrees, minutes and seconds
        let latitudeDegrees = Int(latitude)
        let latitudeMinutes = Int((latitude - Double(latitudeDegrees)) * 60)
        let latitudeSeconds = (latitude - Double(latitudeDegrees) - Double(latitudeMinutes) / 60) * 3600
        
        let longitudeDegrees = Int(longitude)
        let longitudeMinutes = Int((longitude - Double(longitudeDegrees)) * 60)
        let longitudeSeconds = (longitude - Double(longitudeDegrees) - Double(longitudeMinutes) / 60) * 3600
        
        // Formatting GPS coordinates
        let latitudeDirection = latitude >= 0 ? "N" : "S"
        let longitudeDirection = longitude >= 0 ? "E" : "W"
        
        let latitudeFormatted = String(format: "%d°%02d'%04.1f\"%@", abs(latitudeDegrees), abs(latitudeMinutes), abs(latitudeSeconds), latitudeDirection)
        let longitudeFormatted = String(format: "%d°%02d'%04.1f\"%@", abs(longitudeDegrees), abs(longitudeMinutes), abs(longitudeSeconds), longitudeDirection)
        
        return "\(latitudeFormatted) \(longitudeFormatted)"
    }
    
    
    func getGoogleMapsURL(latlng: [Double]?) -> URL? {
        guard let coordinates = latlng, coordinates.count == 2 else {
            return nil
        }
        
        let latitude = coordinates[0]
        let longitude = coordinates[1]
        
        return URL(string: "https://www.google.com/maps/search/?api=1&query=\(latitude),\(longitude)")
    }
    
}

extension WCDetailViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 67
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = WCDetailsHeaderView()
        
        guard let url = URL(string: country.flags?.png ?? "") else {
            return nil
        }
        
        header.flagImageView.kf.setImage(with: url)
        
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 220
    }
}

// MARK: - Configure views

private extension WCDetailViewController {
    private func configureViews() {
        
        makeConstraints()
    }
    
    private func makeConstraints() {
        view.addSubview(descriptionTableView)
        descriptionTableView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(20)
            $0.left.equalToSuperview().offset(16)
            $0.right.equalToSuperview().offset(-16)
            $0.bottom.equalToSuperview()
        }
    }
    
    @objc func labelTapped(_ gesture: UITapGestureRecognizer) {
        
        guard let url = getGoogleMapsURL(latlng: country.latlng) else {
            return
        }
        
        UIApplication.shared.open(url, options: [:]) { success in
            if success {
                print("Safari page opened successfully")
            } else {
                print("Couldn't open Safari page")
            }
        }
    }
    
}
