//
//  TodayModel.swift
//  NOW
//
//  Created by dovietduy on 4/16/21.
//

import Foundation
class TodayModel{
    var time = 0
    var icon = ""
    var temperature = 0.0
    func initLoad(_ json:  [String: Any]) -> TodayModel{
        if let temp = json["time"] as? Int { time = temp }
        if let temp = json["icon"] as? String { icon = temp }
        if let temp = json["temperature"] as? Double { temperature = temp }
        return self
    }
}
class WeatherModel {
    var name = ""
    var lat = ""
    var long = ""
    var data = TodayModel()
    var daily: [DailyModel] = []
    
    init(_ name: String, lat: String, long: String) {
        self.name = name
        self.lat = lat
        self.long = long
    }
}
class DailyModel: Codable{
    var time = 0
    var icon = ""
    var temperatureHigh = 0.0
    var temperatureLow = 0.0
    func initLoad(_ json:  [String: Any]) -> DailyModel{
        if let temp = json["time"] as? Int { time = temp }
        if let temp = json["icon"] as? String { icon = temp }
        if let temp = json["temperatureHigh"] as? Double { temperatureHigh = temp }
        if let temp = json["temperatureLow"] as? Double { temperatureLow = temp }
        return self
    }
}
