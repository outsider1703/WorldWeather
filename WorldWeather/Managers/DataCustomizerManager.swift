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
        let dateToday = dateFormatorFor(date: Date())
        let dateTomorrow = dateFormatorFor(date: Date(timeIntervalSinceNow: 86400))
        
        let lat = data.lat ?? 0
        let lon = data.lon ?? 0
        
        var customWeather = [CustomDataModelForWeather]()
        var customHourlsForToday = [CustomHourl]()
        var customHourlsForTomorrow = [CustomHourl]()
        
        let today = "Сегодня \(dateToday.fullDate)"
        let tomorrow = "Завтра \(dateTomorrow.fullDate)"
        
        for hourl in data.hourly {
            let parametersWeather = getDataFrom(hourl.weather)
            let dateAndTime = dateFormaterFor(interval: hourl.dt ?? 0)
            
            let customHourl = CustomHourl(date: dateAndTime.time,
                                          temp: hourl.temp ?? 0,
                                          icon: parametersWeather.icon,
                                          description: parametersWeather.description)
            if dateAndTime.day == dateToday.day {
                customHourlsForToday.append(customHourl)
            }
            if dateAndTime.day == dateTomorrow.day {
                customHourlsForTomorrow.append(customHourl)
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
    
    private func dateFormatorFor(date: Date) -> (day: String, fullDate: String) {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "Ru_ru")
        formatter.dateFormat = "d"
        let day = formatter.string(from: date)
        
        formatter.dateFormat = "d MMM yyyy"
        formatter.dateStyle = .full
        let fullDate = formatter.string(from: date)
        return (day, fullDate)
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
    
    private func dateFormaterFor(interval: Double) -> (day: String, time: String) {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        let date = Date(timeIntervalSince1970: interval)
        let day = dateFormatorFor(date: date).day
        let time = formatter.string(from: date)
        return (day, time)
    }
    
}
