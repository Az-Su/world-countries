//
//  FormatHelper.swift
//  world-countries
//
//  Created by Sailau Almaz Maratuly on 16.05.2023.
//

import Foundation

enum FormatHelper {
    
    static func formatPopulation(_ population: Int) -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        
        let million = 1_000_000
        let billion = 1_000_000_000
        let trillion = 1_000_000_000_000
        
        if population >= trillion {
            let formattedPopulation = (Double(population) / Double(trillion)).rounded(.up)
            return "\(numberFormatter.string(from: NSNumber(value: formattedPopulation)) ?? "") trl"
        } else if population >= billion {
            let formattedPopulation = (Double(population) / Double(billion)).rounded(.up)
            return "\(numberFormatter.string(from: NSNumber(value: formattedPopulation)) ?? "") bln"
        } else if population >= million {
            let formattedPopulation = (Double(population) / Double(million)).rounded(.up)
            return "\(numberFormatter.string(from: NSNumber(value: formattedPopulation)) ?? "") mln"
        } else {
            return "\(numberFormatter.string(from: NSNumber(value: population)) ?? "")"
        }
    }
    
    static func formatArea(_ area: Double) -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        
        let million = 1_000_000
        let billion = 1_000_000_000
        let trillion = 1_000_000_000_000
        
        if area >= Double(trillion) {
            let formattedArea = (Double(area) / Double(trillion))
            return "\(numberFormatter.string(from: NSNumber(value: formattedArea)) ?? "") trl km²"
        } else if area >= Double(billion) {
            let formattedArea = (Double(area) / Double(billion))
            return "\(numberFormatter.string(from: NSNumber(value: formattedArea)) ?? "") bln km²"
        } else if area >= Double(million) {
            let formattedArea = (Double(area) / Double(million))
            return "\(numberFormatter.string(from: NSNumber(value: formattedArea)) ?? "") mln km²"
        } else {
            return "\(numberFormatter.string(from: NSNumber(value: area)) ?? "") km²"
        }
    }
    
    static func formatCurrency(_ model: Country) -> String {
        guard let currencies = model.currencies else {
            return ""
        }
        
        for currency in currencies {
            guard let currencyName = currency.value.name else {
                continue
            }
            
            guard let currencySymbol = currency.value.symbol else {
                continue
            }
            
            return "\(currencyName) (\(currencySymbol))"
        }
        return ""
    }
    
}
