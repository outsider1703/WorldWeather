//
//  SettingWeatherData.swift
//  WorldWeather
//
//  Created by Macbook on 23.10.2020.
//  Copyright © 2020 Igor Simonov. All rights reserved.
//

import Foundation

class DataCustomizerManager {
    
    func customizingForWeather(data: Weather) -> [CustomDataModelForWeather] {
        let lat = data.lat ?? 0
        let lon = data.lon ?? 0
        
        let formatter = DateFormatter()
        formatter.dateFormat = "d"
        
        var customWeather = [CustomDataModelForWeather]()
        
        var customHourlsForToday = [CustomHourl]()
        var customHourlsForTomorrow = [CustomHourl]()
        
        var today = "kek"
        var tomorrow = ""
        
        for hourl in data.hourly {
            let parametersWeather = getDataFrom(hourl.weather)
            let dateAndTime = dateFormaterFor(interval: hourl.dt ?? 0)
            
            let customHourl = CustomHourl(date: dateAndTime.time,
                                          temp: hourl.temp ?? 0,
                                          icon: parametersWeather.icon,
                                          description: parametersWeather.description)
            
            if dateFormatorFor(date: dateAndTime.date) == true {
                customHourlsForToday.append(customHourl)
                today = formatter.string(from: dateAndTime.date)
            } else {
                customHourlsForTomorrow.append(customHourl)
                tomorrow = formatter.string(from: dateAndTime.date)
            }
        }
        customWeather.append(CustomDataModelForWeather(day: today,
                                                       lat: lat,
                                                       lon: lon,
                                                       hourlyData: customHourlsForToday))
        customWeather.append(CustomDataModelForWeather(day: tomorrow,
                                                       lat: lat,
                                                       lon: lon,
                                                       hourlyData: customHourlsForTomorrow))
        return customWeather
    }
    
    private func dateFormatorFor(date: Date) -> Bool {
        let formatter = DateFormatter()
        formatter.dateFormat = "d"
        let weatherToday = formatter.string(from: date)
        let today = formatter.string(from: Date())
        
        return weatherToday == today
    }
    
    private func getDataFrom(_ parametersWeather: [ParametersWeather]) -> (icon: String, description: String) {
        var icon = ""
        var description = ""
        
        for element in parametersWeather {
            icon = element.icon ?? ""
            description = element.description ?? ""
        }
        return (icon: icon, description: description )
    }
    
    private func dateFormaterFor(interval: Double) -> (date: Date, time: String) {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        let date = Date(timeIntervalSince1970: interval)
        let time = formatter.string(from: date)
        return (date, time)
    }
    
}
