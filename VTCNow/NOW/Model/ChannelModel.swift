//
//  ChannelModel.swift
//  NOW
//
//  Created by dovietduy on 3/1/21.
//

import Foundation
class ChannelModel{
    var name = ""
    var description = ""
    var image: [ImageModel] = []
    var url : [URLModel] = []
    func initLoad(_ json: [String: Any]) -> ChannelModel{
        if let temp = json["Name"] as? String { name = temp}
        if let temp = json["Description"] as? String { description = temp}
        if let temp = json["Image"] as? String {
            for item in temp.toJsonArray(){
                let imageAdd = ImageModel().initLoad(item)
                image.append(imageAdd)
            }
        }
        if let temp = json["Url"] as? String {
            for item in temp.toJsonArray(){
                let itemAdd = URLModel().initLoad(item)
                url.append(itemAdd)
            }
        }
        return self
    }
}
class URLModel{
    var name = ""
    var link = ""
    func initLoad(_ json: [String: Any]) -> URLModel{
        if let temp = json["Name"] as? String { name = temp}
        if let temp = json["Link"] as? String { link = temp}
        return self
    }
}
