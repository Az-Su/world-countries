//
//  BaseCollectionViewCell.swift
//  world-countries
//
//  Created by Sailau Almaz Maratuly on 13.05.2023.
//

import Foundation
import UIKit

class BaseCollectionViewCell: UICollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        makeUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func makeUI() {
        
    }
    
}
