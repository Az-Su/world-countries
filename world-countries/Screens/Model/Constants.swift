//
//  Constants.swift
//  world-countries
//
//  Created by Sailau Almaz Maratuly on 17.05.2023.
//

import Foundation

struct Constants {
    
    //MARK: - Mock data
    struct Values {
        static var defaultCountry = Country(name: Name(common: "hide", official: "Official Country 1"),
                                            cca2: "CC1",
                                            currencies: ["Currency 1": Currency(name: "Currency 1 Name", symbol: "Currency 1 Symbol")],
                                            capital: ["Capital 1"],
                                            region: "Region 1",
                                            subregion: "Region 1",
                                            latlng: [12.34, 56.78],
                                            area: 1234.56,
                                            timezones: ["Timezone 1"],
                                            continents: ["Loading..."],
                                            flags: Flag(png: "Flag 1 PNG", svg: "Flag 1 SVG"),
                                            population: 1000000
        )
    }
}
