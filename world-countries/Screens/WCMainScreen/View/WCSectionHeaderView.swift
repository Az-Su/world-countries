//
//  WCSectionHeaderView.swift
//  world-countries
//
//  Created by Sailau Almaz Maratuly on 14.05.2023.
//

import UIKit
import SnapKit

final class WCSectionHeaderView: UICollectionReusableView {
    
     var continentLabel = configure(UILabel())  {
         $0.textColor = .textGray
         $0.font = UIFont.boldSystemFont(ofSize: 15)
         $0.sizeToFit()
     }
    
     override init(frame: CGRect) {
         super.init(frame: frame)

         configureViews()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//MARK: - Configure views

private extension WCSectionHeaderView {
    func configureViews() {
        addSubview(continentLabel)
        
        continentLabel.snp.makeConstraints {
            $0.top.right.bottom.equalToSuperview()
            $0.left.equalToSuperview().offset(25)
        }

    }
}
