//
//  WCMainViewController.swift
//  world-countries
//
//  Created by Sailau Almaz Maratuly on 12.05.2023.
//

import UIKit
import UserNotifications

protocol WCMainViewProtocol: AnyObject {
    func display(countries: [[Country]])
    func updateView(withLoader isLoading: Bool)
    func showErrorAlert(message: String)
}

final class WCMainViewController: BaseViewController, WCMainViewProtocol {
    
    var output: WCMainViewModelProtocol?
    
    let notificationCenter = UNUserNotificationCenter.current()
    
    private var groupedCountries: [[Country]] = [[]]
    
    /// This variable is necessary for a single sample of a country
    /// Empty properties were set because initialization is required
    private var randomCountry = Constants.Values.defaultCountry
    
    
    // MARK: Cell for CollectionView
    
    private let sizingCell = WCExpandableCell()
    
    private lazy var collectionView: UICollectionView = {
        let layout = JumpAvoidingFlowLayout()
        layout.scrollDirection = .vertical
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.register(WCExpandableCell.self, forCellWithReuseIdentifier: WCExpandableCell.typeName)
        view.showsVerticalScrollIndicator = false
        view.allowsMultipleSelection = true
        view.alwaysBounceVertical = true
        view.delegate = self
        view.dataSource = self
        return view
    }()
    
    //MARK: - Lyfe cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        output?.didLoad()
        
        notificationCenter.requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            guard granted else { return }

            self.notificationCenter.getNotificationSettings { settings in
                guard settings.authorizationStatus == .authorized else { return }
            }
        }
        
    }
    
    // MARK: - WCMainViewProtocol
    
    func display(countries: [[Country]]) {
        self.groupedCountries = countries
        notificationCenter.delegate = self
        sendNotifications()
        collectionView.reloadData()
    }
    
    func updateView(withLoader isLoading: Bool) {
        if isLoading {
            for _ in 1..<10 {
                groupedCountries[0].append(Constants.Values.defaultCountry)
            }
        }
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
    
    // MARK: - Private methods
    
    override func makeUI() {
        view.backgroundColor = .white
        collectionView.backgroundColor = .white
        
        view.addSubview(collectionView)
        
        collectionView.snp.makeConstraints {
            $0.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    private func sendNotifications() {
        var countries: [Country] = []
        for group in groupedCountries {
            countries += group
        }
        
        let randomIndex = Int.random(in: 0..<countries.count)
        randomCountry = countries[randomIndex]
        
        
        let content = UNMutableNotificationContent()
        content.title = randomCountry.name?.common ?? ""
        content.body = randomCountry.capital?[0] ?? ""
        content.sound = UNNotificationSound.default
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: Double.random(in: 1...5), repeats: false)
        
        let request = UNNotificationRequest(identifier: "Notification", content: content, trigger: trigger)
        notificationCenter.add(request)
    }
}

//MARK: - UNUserNotificationCenterDelegate

extension WCMainViewController: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.list, .banner, .sound])
        
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        let detailedVC = Assembler.shared.detailVC(with: randomCountry.cca2)
        navigationController?.pushViewController(detailedVC, animated: true)
    }
}


// MARK: - UICollectionViewDataSource

extension WCMainViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: WCExpandableCell.typeName, for: indexPath) as! WCExpandableCell
        cell.learnMoreButtonTapped = { [weak self] in
            let cca2 = self?.groupedCountries[indexPath.section][indexPath.row].cca2
            self?.goToDetailedScreen(cca2Code: cca2)
        }
        let country = groupedCountries[indexPath.section][indexPath.row]
        cell.configure(with: country)
        return cell
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        groupedCountries.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        groupedCountries[section].count
    }
}

//MARK: - UICollectionViewDelegateFlowLayout

extension WCMainViewController: UICollectionViewDelegateFlowLayout {
    
    /// Dynamic height calculation
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let isSelected = collectionView.indexPathsForSelectedItems?.contains(indexPath) ?? false
        
        sizingCell.frame = CGRect(
            origin: .zero,
            size: CGSize(width: collectionView.bounds.width - 40, height: 1000)
        )
        
        sizingCell.isSelected = isSelected
        sizingCell.setNeedsLayout()
        sizingCell.layoutIfNeeded()
        
        let size = sizingCell.systemLayoutSizeFitting(
            CGSize(width: collectionView.bounds.width - 40, height: .greatestFiniteMagnitude),
            withHorizontalFittingPriority: .required,
            verticalFittingPriority: .defaultLow
        )
        
        return size
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            self.collectionView.register(WCSectionHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "header")
            
            let sectionHeader = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "header", for: indexPath) as! WCSectionHeaderView
            
            sectionHeader.continentLabel.text = groupedCountries[indexPath.section].first?.continents?.first ?? ""
            return sectionHeader
        } else {
            return UICollectionReusableView()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 54)
    }
}

//MARK: - UICollectionViewDelegate

extension WCMainViewController: UICollectionViewDelegate {
    
    /// Redefining the method for animated cell collapse
    func collectionView(_ collectionView: UICollectionView, shouldDeselectItemAt indexPath: IndexPath) -> Bool {
        collectionView.deselectItem(at: indexPath, animated: true)
        collectionView.performBatchUpdates(nil)
        return true
    }
    
    /// Redefining the method for animated cell unfolding
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        collectionView.selectItem(at: indexPath, animated: true, scrollPosition: [])
        collectionView.performBatchUpdates(nil)
        
        
        DispatchQueue.main.async {
            guard let attributes = collectionView.collectionViewLayout.layoutAttributesForItem(at: indexPath) else {
                return
            }
            
            let desiredOffset = attributes.frame.origin.y - 20
            let contentHeight = collectionView.collectionViewLayout.collectionViewContentSize.height
            let maxPossibleOffset = contentHeight - collectionView.bounds.height
            let finalOffset = max(min(desiredOffset, maxPossibleOffset), 0)
            
            collectionView.setContentOffset(
                CGPoint(x: 0, y: finalOffset),
                animated: true
            )
        }
        
        return true
    }
}

//MARK: - Navigation

extension WCMainViewController {
    private func goToDetailedScreen(cca2Code: String?) {
        let detailedVC = Assembler.shared.detailVC(with: cca2Code)
        navigationController?.pushViewController(detailedVC, animated: true)
    }
}
