//
//  NetworkManager.swift
//  WorldWeather
//
//  Created by Macbook on 21.10.2020.
//  Copyright © 2020 Igor Simonov. All rights reserved.
//

import Foundation

class NetworkManager {
    
    static let shared = NetworkManager()
    private init() {}
    
    let dataCustomizerManager = DataCustomizerManager()
    
    func fetchCoordinatesFor(city: String, completion: @escaping (Weather) -> Void)  {
        let urlForCoordinates = "https://api.openweathermap.org/data/2.5/weather?q=\(city)&appid=296587b38757a82922339cb00dda4ea3"
        guard let url = URL(string: urlForCoordinates) else { return }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            
            if let error = error {
                print("DataTask error: \(error.localizedDescription)")
                return
            }
            
            guard response == response as? HTTPURLResponse else {
                print("Empty Response")
                return
            }
            
            guard let data = data else { return }
            
            do {
                let decoder = JSONDecoder()
                let coordinates = try decoder.decode(Coordinates.self, from: data)
                self.fetchCityWeatherFrom(coord: coordinates) { weatherData in
                    completion(weatherData)
                }
            } catch let error {
                print(error.localizedDescription)
            }
        }.resume()
    }
    
    private func fetchCityWeatherFrom(coord: Coordinates, completion: @escaping (Weather) -> Void) {
        let lat = coord.coord?.lat ?? 0
        let lon = coord.coord?.lon ?? 0
        
        let urlForWeather = "https://api.openweathermap.org/data/2.5/onecall?lat=\(lat)&lon=\(lon)&lang=ru&units=metric&exclude=current,minutely,daily,alerts&appid=296587b38757a82922339cb00dda4ea3"
        
        guard let url = URL(string: urlForWeather) else { return }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                print("DataTask error: \(error.localizedDescription)")
                return
            }
            
            guard response == response as? HTTPURLResponse else {
                print("Empty Response")
                return
            }
            
            guard let data = data else { return }
            
            do {
                let decoder = JSONDecoder()
                let weatherData = try decoder.decode(Weather.self, from: data)
                completion(weatherData)
            } catch let error {
                print(error.localizedDescription)
            }
        }.resume()
    }
    
}
//MARK: - Get Image
extension NetworkManager {
    
    func getImage(from url: URL, completion: @escaping (Data, URLResponse) -> Void) {
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                print(error)
                return
            }
            guard let data = data, let response = response else { return }
            guard let responseURL = response.url else { return }
            guard responseURL == url else { return }
            completion(data, response)
        }.resume()
    }
}
