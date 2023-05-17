//
//  UIHelper.swift
//  world-countries
//
//  Created by Sailau Almaz Maratuly on 16.05.2023.
//

import UIKit

enum UIHelper {
    
    static func changeTextColor(title: String, value: String, for label: UILabel) {
        let myMutableString = NSMutableAttributedString()
        
        myMutableString.append(NSAttributedString(string: title, attributes: [NSAttributedString.Key.foregroundColor: UIColor.textGray]));
        myMutableString.append(NSAttributedString(string: value, attributes: [NSAttributedString.Key.foregroundColor: UIColor.black]));
        
        label.attributedText = myMutableString
    }
    
}
