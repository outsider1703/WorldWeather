//
//  WeatherModel.swift
//  WorldWeather
//
//  Created by Macbook on 21.10.2020.
//  Copyright © 2020 Igor Simonov. All rights reserved.
//

import Foundation

struct Weather: Codable {
    let lat: Double?
    let lon: Double?
    let hourly: [Hourly]
}

struct Hourly: Codable {
    let dt: Double?
    let temp: Double?
    let weather: [ParametersWeather]
}

struct ParametersWeather: Codable {
    let icon: String?
    let description: String?
}
