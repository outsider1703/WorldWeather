//
//  SectionsForWeather.swift
//  WorldWeather
//
//  Created by Macbook on 23.10.2020.
//  Copyright © 2020 Igor Simonov. All rights reserved.
//

import Foundation

struct CustomDataModelForWeather: Hashable {
    let day: String
    let lat: Double
    let lon: Double
    let hourlyData: [CustomHourl]
}

struct CustomHourl: Hashable {
    let date: String
    let temp: Double
    let icon: String
    let description: String
}
