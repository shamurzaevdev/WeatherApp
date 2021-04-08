//
//  CurrentWeather.swift
//  WeatherApp
//
//  Created by Эл on 05.04.2021.
//

import Foundation

struct CurrentWeather {
    let cityName : String
    
    let temperature : Double
    var temperatureString : String {
        return String(format: "Temp: %.0f℃", temperature)
    }
    
    let feelsLikeTemperature : Double
    var feelsLikeTemperatureString : String {
        return String(format: "Feels like: %.0f℃", temperature)
    }
    
    let conditionalCode : Int
    var systemIconNameString : String {
        switch conditionalCode {
        case 200...232:
            return "cloud.bolt.rain.fill"
        case 300...321:
            return "cloud.drizzle.fill"
        case 500...531:
            return "cloud.rain.fill"
        case 600...622:
            return "cloud.snow.fill"
        case 701...781:
            return "smoke.fill"
        case 800:
            return "sun.max.fill"
        case 801...804:
            return "cloud.fill"
        
        default:
            return "nosign"
        }
    }
    
    init?(currentWeatherData : CurrentWeatherData) {
        cityName = currentWeatherData.name
        temperature = currentWeatherData.main.temp
        feelsLikeTemperature = currentWeatherData.main.feelsLike
        conditionalCode = currentWeatherData.weather.first!.id
    }
}
