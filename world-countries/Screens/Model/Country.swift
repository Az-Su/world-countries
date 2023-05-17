//
//  Country.swift
//  world-countries
//
//  Created by Sailau Almaz Maratuly on 15.05.2023.
//

struct Country: Codable {
    let name: Name?
    let cca2: String?
    let currencies: [String: Currency]?
    let capital: [String]?
    let region: String?
    let subregion: String?
    let latlng: [Double]?
    let area: Double?
    let timezones: [String]?
    let continents: [String]?
    let flags: Flag?
    let population: Int?
}

struct Name: Codable {
    let common: String?
    let official: String?
}

struct Currency: Codable {
    let name: String?
    let symbol: String?
}

struct Flag: Codable {
    let png: String?
    let svg: String?
}
