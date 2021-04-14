//
//  CategoryModel.swift
//  NOW
//
//  Created by dovietduy on 1/29/21.
//

import Foundation
class CategoryModel{
    var privateKey = ""
    var name = ""
    var cdn = CDNModel()
    var layout = LayoutModel()
    var media: [MediaModel] = []
    var components: [ComponentModel] = []
    func initLoad(_ json: [String: Any]) -> CategoryModel{
        if let temp = json["PrivateKey"] as? String { privateKey = temp}
        if let temp = json["Name"] as? String { name = temp}
        if let temp = json["Media"] as? [[String: Any]] {
            for item in temp {
                let mediaAdd = MediaModel().initLoad(item)
                media.append(mediaAdd)
            }
        }
        if let temp = json["CDN"] as? String  {
            cdn = CDNModel().initLoad(temp.toJson())
        }
        if let temp = json["LayoutType"] as? String {
            layout = LayoutModel().initLoad(temp.toJson())
        }
        if let temp = json["Components"] as? String {
            for item in temp.toJsonArray(){
                let componentAdd = ComponentModel().initLoad(item)
                components.append(componentAdd)
            }
        }
        return self
    }
    func copy() -> CategoryModel{
        let copy = CategoryModel()
        copy.privateKey = self.privateKey
        copy.name = self.name
        copy.cdn = self.cdn
        copy.layout = self.layout
        copy.media = self.media
        copy.components = self.components
        return copy
    }
}
class MediaModel{
    var privateID = ""
    var descripTion = ""
    var image: [ImageModel] = []
    var name = ""
    var path = ""
    var schedule = ""
    var timePass = ""
    var duration = ""
    var minutes = ""
    var metaData: [MetaDataModel] = []
    var country = ""
    var episode = ""
    var genred = ""
    var thumnail = ""
    var portrait = ""
    var author = ""
    var cast = ""
    var fileCode = ""
    var square = ""
    func initLoad(_ json: [String: Any]) -> MediaModel{
        if let temp = json["PrivateID"] as? String { privateID = temp}
        if let temp = json["Description"] as? String { descripTion = temp}
        if let temp = json["Image"] as? [[String:Any]] {
            for item in temp{
                let imageAdd = ImageModel().initLoad(item)
                if imageAdd.type == "Thumbnail"{
                    //let str = imageAdd.url.split(separator: ".")
                    let str = imageAdd.url
                    let prefix = str[..<str.index(str.endIndex, offsetBy: -4)]
                    let last4 = str.suffix(4)
                    let path = prefix + "_800_450" + last4
                    thumnail = String(path)
                }
                if imageAdd.type == "Portrait"{
                    portrait = imageAdd.url
                }
                if imageAdd.type == "Square"{
                    square = imageAdd.url
                }
                image.append(imageAdd)
            }
        }
        if let temp = json["Image"] as? String {
            for item in temp.toJsonArray(){
                let imageAdd = ImageModel().initLoad(item)
                if imageAdd.type == "Thumbnail"{
                    //let str = imageAdd.url.split(separator: ".")
                    let str = imageAdd.url
                    let prefix = str[..<str.index(str.endIndex, offsetBy: -4)]
                    let last4 = str.suffix(4)
                    let path = prefix + "_800_450" + last4
                    thumnail = String(path)
                }
                if imageAdd.type == "Portrait"{
                    portrait = imageAdd.url
                }
                if imageAdd.type == "Square"{
                    square = imageAdd.url
                }
                image.append(imageAdd)
            }
        }
        if let temp = json["Name"] as? String { name = temp}
        if let temp = json["Title"] as? String { name = temp}
        if let temp = json["Path"] as? String { path = temp}
        if let temp = json["Schedule"] as? String { schedule = temp}
        if let temp = json["Duration"] as? String {
            duration = temp
            minutes = duration.toMinute()
        }
        if let previousDate = schedule.toDate(){
            let interval = Date() - previousDate
            if let month = interval.month, month != 0{
                if month > 0 {
                    timePass = "\(month) tháng trước"
                } else{
                    timePass = "Còn \(-month) tháng"
                }
            } else if let day = interval.day, day != 0{
                if day > 0{
                    timePass = "\(day) ngày trước"
                } else{
                    timePass = "Còn \(-day) ngày"
                }
            }else if let hour = interval.hour, hour != 0{
                if hour > 0{
                    timePass = "\(hour) giờ trước"
                }else{
                    timePass = "Còn \(-hour) giờ"
                }
            }else if let minute = interval.minute, minute != 0{
                if minute > 0{
                    timePass = "\(minute) phút trước"
                }else{
                    timePass = "Còn \(-minute) phút"
                }
            }else if let second = interval.second, second != 0{
                if second > 0{
                    timePass = "\(-second) giây trước"
                }else{
                    timePass = "Còn \(second) giây"
                }
            }else {
                timePass = "trực tiếp"
            }
        }
        if let temp = json["Metadata"] as? [[String: Any]]{
            for item in temp{
                let metaDataAdd = MetaDataModel().initLoad(item)
                if metaDataAdd.name == "Country"{
                    country = metaDataAdd.value
                }
                if metaDataAdd.name == "Episode"{
                    episode = " - Tập " + metaDataAdd.value
                }
                if metaDataAdd.name == "GenredDescription"{
                    genred = metaDataAdd.value
                }
                if metaDataAdd.name == "FileCode"{
                    //path = metaDataAdd.value
                    fileCode = metaDataAdd.value
                }
                if metaDataAdd.name == "Director"{
                    author = metaDataAdd.value
                }
                if metaDataAdd.name == "Cast"{
                    cast = metaDataAdd.value
                }
                metaData.append(metaDataAdd)
            }
        }
        if let data = json["Metadata"] as? [String: Any]{
            
            if let temp = data["Episode"] as? String {
                if temp != ""{
                    episode = " - Tập " + temp
                }
            }
            if let temp = data["Country"] as? String { country = temp}
            if let temp = data["Cast"] as? String { cast = temp}
            if let temp = data["GenredDescription"] as? String { genred = temp}
            if let temp = data["Director"] as? String { author = temp}
            if let temp = data["FileCode"] as? String {
                fileCode = temp
            }
        }
        return self
    }
    func getTimePass() -> String{
        if let previousDate = schedule.toDate(){
            let interval = Date() - previousDate
            if let month = interval.month, month != 0{
                if month > 0 {
                    timePass = "\(month) tháng trước"
                } else{
                    timePass = "Còn \(-month) tháng"
                }
            } else if let day = interval.day, day != 0{
                if day > 0{
                    timePass = "\(day) ngày trước"
                } else{
                    timePass = "Còn \(-day) ngày"
                }
            }else if let hour = interval.hour, hour != 0{
                if hour > 0{
                    timePass = "\(hour) giờ trước"
                }else{
                    timePass = "Còn \(hour) giờ"
                }
            }else if let minute = interval.minute, minute != 0{
                if minute > 0{
                    timePass = "\(minute) phút trước"
                }else{
                    timePass = "Còn \(minute) phút"
                }
            }else if let second = interval.second, second != 0{
                if second > 0{
                    timePass = "\(second) giây trước"
                }else{
                    timePass = "Còn \(second) giây"
                }
            }else {
                timePass = "trực tiếp"
            }
        }
        return timePass
    }
}
class ImageModel{
    var type = ""
    var url = ""
    
    func initLoad(_ json: [String: Any]) -> ImageModel{
        if let temp = json["Url"] as? String { url = temp}
        if let temp = json["Type"] as? String { type = temp}
        return self
    }
}
class MetaDataModel{
    var name = ""
    var value = ""
    
    func initLoad(_ json: [String: Any]) -> MetaDataModel{
        if let temp = json["Name"] as? String { name = temp}
        if let temp = json["Value"] as? String { value = temp}
        return self
    }
}

class LayoutModel{
    var type = "1"
    var subType = "1"
    func initLoad(_ json: [String: Any]) -> LayoutModel{
        if let temp = json["Type"] as? String { type = temp}
        if let temp = json["SubType"] as? String { subType = temp}
        return self
    }
}
