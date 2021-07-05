//
//  ScheduleModel.swift
//  VNews
//
//  Created by dovietduy on 5/27/21.
//

import Foundation
class ScheduleModel {
    var name = ""
    var description = ""
    var startTime = ""
    var endTime = ""
    var currentEvent = false
    var url = ""
    
    func initLoad(_ json: [String: Any]) -> ScheduleModel{
        if let temp = json["Description"] as? String { description = temp}
        if let temp = json["Name"] as? String { name = temp}
        if let temp = json["StartTime"] as? String { startTime = temp}
        if let temp = json["EndTime"] as? String { endTime = temp}
        if let temp = json["CurrentEvent"] as? Bool { currentEvent = temp}
        if let temp = json["Url"] as? String { url = temp}
        return self
    }
    
}
