//
//  ApiModel.swift
//  WorldWeather
//
//  Created by Macbook on 21.10.2020.
//  Copyright © 2020 Igor Simonov. All rights reserved.
//

import Foundation

struct Coordinates: Decodable {
    var coord: LatitudeAndLongitude? = nil
}

struct LatitudeAndLongitude: Decodable {
    let lon: Double?
    let lat: Double?
}
