//
//  NewsVideoModel.swift
//  NOW
//
//  Created by dovietduy on 3/9/21.
//

import Foundation
class NewsVideoModel{
    var videoURL = ""
    func initLoad(_ json: [String: Any]) -> NewsVideoModel{
        if let temp = json["VideoURL"] as? String { videoURL = temp}
        return self
    }
}
