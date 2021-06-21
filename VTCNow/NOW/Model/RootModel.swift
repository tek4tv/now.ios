//
//  RootModel.swift
//  NOW
//
//  Created by dovietduy on 1/29/21.
//

import Foundation

class RootModel{
    var cdn = CDNModel()
    var components: [ComponentModel] = []
    
    func initLoad(_ json: [String: Any]) -> RootModel{
        if let temp = json["Components"] as? String {
            for item in temp.toJsonArray(){
                let componentAdd = ComponentModel().initLoad(item)
                components.append(componentAdd)
            }
        }
        if let temp = json["CDN"] as? String {
            cdn = CDNModel().initLoad(temp.toJson())
        }
        return self
    }
}
class ComponentModel{
    var privateKey = ""
    var name = ""
    var icon = ""
    var descripTion = ""
    var category = CategoryModel()
    func initLoad(_ json: [String: Any]) -> ComponentModel{
        if let temp = json["PrivateKey"] as? String { privateKey = temp}
        if let temp = json["Name"] as? String { name = temp}
        if let temp = json["Icon"] as? String { icon = temp}
        if let temp = json["Description"] as? String { descripTion = temp}
        return self
    }
}
class CDNModel{
    var liveDomain = ""
    var videoDomain = ""
    var imageDomain = ""
    func initLoad(_ json: [String: Any]) -> CDNModel{
        if let temp = json["LiveDomain"] as? String { liveDomain = temp}
        if let temp = json["VideoDomain"] as? String { liveDomain = temp}
        if let temp = json["ImageDomain"] as? String { imageDomain = temp}
        return self
    }
}
