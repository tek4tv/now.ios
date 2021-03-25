//
//  ReadModel.swift
//  NOW
//
//  Created by dovietduy on 3/2/21.
//

import Foundation
class ReadModel{
    var id = 0
    var title = ""
    var description = ""
    var publishedDate = ""
    var image16_9 = ""
    var detailUrl = ""
    var timePass = ""
    var isVideoArticle = 0
    func initLoad(_ json: [String: Any]) -> ReadModel{
        if let temp = json["Id"] as? Int { id = temp}
        if let temp = json["Title"] as? String { title = temp}
        if let temp = json["Description"] as? String { description = temp}
        if let temp = json["PublishedDate"] as? String { publishedDate = temp}
        if let temp = json["DetailURL"] as? String {detailUrl = "https://vtc.vn" + temp}
        if let temp = json["image16_9"] as? String { image16_9 = temp}
        if let temp = json["IsVideoArticle"] as? Int { isVideoArticle = temp}
        if let previousDate = publishedDate.toDate(){
            let interval = Date() - previousDate
            if let month = interval.month, month != 0{
                timePass = "\(month) tháng trước"
            } else if let day = interval.day, day != 0{
                timePass = "\(day) ngày trước"
            }else if let hour = interval.hour, hour != 0{
                timePass = "\(hour) giờ trước"
            }else if let minute = interval.minute, minute != 0{
                timePass = "\(minute) phút trước"
            }else if let second = interval.second, second != 0{
                    timePass = "\(second) giây trước"
            }else {
                timePass = "trực tiếp"
            }
        }
        return self
    }
}
class ReadDetailModel{
    var content = ""
    var title = ""
    
    func initLoad(_ json: [String: Any]) -> ReadDetailModel{
        if let temp = json["Content"] as? String { content = temp}
        if let temp = json["Title"] as? String { title = temp}
        return self
    }
}
