//
//  APIService.swift
//  VTCNow
//
//  Created by dovietduy on 1/25/21.
//

import Foundation
import Alamofire

class APIService{
    static let shared = APIService()

    func getRootPlaylist(closure: @escaping (_ response: Any?, _ error: Error?) -> Void) {
        AF.request("https://dev.caching.tek4tv.vn/api/playlist/json/c2064177-6af9-4de5-9428-271099183247", method: .get, parameters: nil, encoding: URLEncoding.default, headers: nil, interceptor: nil).responseJSON(completionHandler: { (response) in
            switch response.result {
            case .success(let data):
                var root = RootModel()
                if let data = data as? [String: Any]{
                    root = root.initLoad(data)
                }
                closure(root, nil)
            case .failure(let error):
                print(error)
            }
        })
    }
    func getPlaylist(privateKey: String, closure: @escaping (_ response: Any?, _ error: Error?) -> Void) {
        AF.request("https://dev.caching.tek4tv.vn/api/playlist/json/" + privateKey, method: .get, parameters: nil, encoding: URLEncoding.default, headers: nil, interceptor: nil).responseJSON(completionHandler: { (response) in
            switch response.result {
            case .success(let data):
                var category = CategoryModel()
                if let data = data as? [String: Any]{
                    category = category.initLoad(data)
                }
                closure(category, nil)
            case .failure(let error):
                print(error)
            }
        })
    }
    func searchWithTag(privateKey: String, keySearch: String, closure: @escaping (_ response: Any?, _ error: Error?) -> Void) {
        let json: [String : Any] = [
            "KeySearch": keySearch,
            "Tag": privateKey,
            "Page":5,
            "Size":20
        ]
        AF.request("https://dev.caching.tek4tv.vn/api/Video/Search/tag", method: .post, parameters: json, encoding: URLEncoding.default).responseJSON(completionHandler: { (response) in
            switch response.result {
            case .success(let data):
                var listMedia: [MediaModel] = []
                if let data = data as? [[String: Any]]{
                    for item in data{
                        var mediaAdd = MediaModel()
                        mediaAdd = mediaAdd.initLoad(item)
                        listMedia.append(mediaAdd)
                    }
                }
                closure(listMedia, nil)
            case .failure(let error):
                print(error)
            }
        })
    }
    func searchAll(keySearch: String, closure: @escaping (_ response: Any?, _ error: Error?) -> Void) {
        let json: [String : Any] = [
            "KeySearch": keySearch
        ]
        AF.request("http://dev.caching.tek4tv.vn/api/Video/Search", method: .post, parameters: json, encoding: JSONEncoding.default).responseJSON(completionHandler: { (response) in
            switch response.result {
            case .success(let data):
                var listMedia: [MediaModel] = []
                if let data = data as? [[String: Any]]{
                    for item in data{
                        var mediaAdd = MediaModel()
                        mediaAdd = mediaAdd.initLoad(item)
                        listMedia.append(mediaAdd)
                    }
                }
                closure(listMedia, nil)
            case .failure(let error):
                print(error)
            }
        })
    }
    func getSuggestion(keySearch: String, closure: @escaping (_ response: Any?, _ error: Error?) -> Void){
        let json: [String : Any] = [
            "KeySearch": keySearch,
            "Size": 100
        ]
        AF.request("https://dev.caching.tek4tv.vn/api/Video/suggestion/search", method: .post, parameters: json, encoding: JSONEncoding.default).responseJSON(completionHandler: { (response) in
            switch response.result {
            case .success(let data):
                var listString : [String] = []
                if let data = data as? [[String: Any]]{
                    for json in data{
                        if let temp = json["string"] as? String{
                            listString.append(temp)
                        }
                    }
                }
                closure(listString, nil)
            case .failure(let error):
                print(error)
            }
        })
    }
    func getRadio(closure: @escaping (_ response: Any?, _ error: Error?) -> Void) {
        AF.request("https://appnow.tek4tv.vn/api/now/v1/radio/", method: .get, parameters: nil, encoding: URLEncoding.default, headers: nil, interceptor: nil).responseJSON(completionHandler: { (response) in
            switch response.result {
            case .success(let data):
                var radios: [ChannelModel] = []
                if let data = data as? [[String: Any]]{
                    for json in data{
                        var itemAdd = ChannelModel()
                        itemAdd = itemAdd.initLoad(json)
                        radios.append(itemAdd)
                    }
                }
                closure(radios, nil)
            case .failure(let error):
                print(error)
            }
        })
    }
    func getLive(closure: @escaping (_ response: Any?, _ error: Error?) -> Void) {
        AF.request("https://appnow.tek4tv.vn/api/now/v1/live/", method: .get, parameters: nil, encoding: URLEncoding.default, headers: nil, interceptor: nil).responseJSON(completionHandler: { (response) in
            switch response.result {
            case .success(let data):
                var radios: [ChannelModel] = []
                if let data = data as? [[String: Any]]{
                    for json in data{
                        var itemAdd = ChannelModel()
                        itemAdd = itemAdd.initLoad(json)
                        radios.append(itemAdd)
                    }
                }
                closure(radios, nil)
            case .failure(let error):
                print(error)
            }
        })
    }
    func getReadVideo(id: Int, closure: @escaping (_ response: Any?, _ error: Error?) -> Void) {
        AF.request("https://api.vtcnews.tek4tv.vn/api/home/news/GetVideoDetail/" + id.description, method: .get, parameters: nil, encoding: URLEncoding.default, headers: nil, interceptor: nil).responseJSON(completionHandler: { (response) in
            switch response.result {
            case .success(let data):
                var item = NewsVideoModel()
                if let data = data as? [[String: Any]]{
                    item = item.initLoad(data[0])
                }
                closure(item, nil)
            case .failure(let error):
                print(error)
            }
        })
    }
    func getRead(page: String = "1", closure: @escaping (_ response: Any?, _ error: Error?) -> Void) {
        AF.request("https://api.vtcnews.tek4tv.vn/api/home/news/trending/" + page, method: .get, parameters: nil, encoding: URLEncoding.default, headers: nil, interceptor: nil).responseJSON(completionHandler: { (response) in
            switch response.result {
            case .success(let data):
                var reads: [ReadModel] = []
                if let data = data as? [[String: Any]]{
                    for json in data{
                        var itemAdd = ReadModel()
                        itemAdd = itemAdd.initLoad(json)
                        reads.append(itemAdd)
                    }
                }
                closure(reads, nil)
            case .failure(let error):
                print(error)
            }
        })
    }
    func getReadDetail(id: String, closure: @escaping (_ response: Any?, _ error: Error?) -> Void) {
        AF.request("https://api.vtcnews.tek4tv.vn/api//home/news/detail/" + id, method: .get, parameters: nil, encoding: URLEncoding.default, headers: nil, interceptor: nil).responseJSON(completionHandler: { (response) in
            switch response.result {
            case .success(let data):
                var item = ReadDetailModel()
                if let data = data as? [String: Any]{
                    if let temp = data["DetailData"] as? [String: Any]{
                        item = item.initLoad(temp)
                    }
                }
                
                
                closure(item, nil)
            case .failure(let error):
                print(error)
            }
        })
    }
    func getMoreVideoPlaylist(privateKey: String, page: String, closure: @escaping (_ response: Any?, _ error: Error?) -> Void) {
        AF.request("https://dev.caching.tek4tv.vn/api/Video/\(privateKey)/\(page)/36" + page, method: .get, parameters: nil, encoding: URLEncoding.default, headers: nil, interceptor: nil).responseJSON(completionHandler: { (response) in
            switch response.result {
            case .success(let data):
                var list: [MediaModel] = []
                if let data = data as? [[String: Any]]{
                    for json in data{
                        let itemAdd = MediaModel().initLoad(json)
                        list.append(itemAdd)
                    }
                }
                closure(list, nil)
            case .failure(let error):
                print(error)
            }
        })
    }
    func getDetailVideo(privateKey: String, closure: @escaping (_ response: Any?, _ error: Error?) -> Void) {
        AF.request("https://dev.caching.tek4tv.vn/api/Video/json/" + privateKey, method: .get, parameters: nil, encoding: URLEncoding.default, headers: nil, interceptor: nil).responseJSON(completionHandler: { (response) in
            switch response.result {
            case .success(let data):
                var item = MediaModel()
                if let data = data as? [String: Any]{
                    item = item.initLoad(data)
                }
                closure(item, nil)
            case .failure(let error):
                print(error)
            }
        })
    }
    func getEpisode(privateKey: String, closure: @escaping (_ response: Any?, _ error: Error?) -> Void) {
        AF.request("https://now.vtc.vn/api/now/v1/videos/\(privateKey)/episode", method: .get, parameters: nil, encoding: URLEncoding.default, headers: nil, interceptor: nil).responseJSON(completionHandler: { (response) in
            switch response.result {
            case .success(let data):
                var list: [MediaModel] = []
                if let data = data as? [[String: Any]]{
                    for json in data{
                        let itemAdd = MediaModel().initLoad(json)
                        list.append(itemAdd)
                    }
                }
                closure(list, nil)
            case .failure(let error):
                print(error)
            }
        })
    }

    func getWeather(_ latitude : String,_ longitude: String, closure: @escaping (_ response: Any?, _ list: Any?, _ error: Error?) -> Void) {
        AF.request("https://api.darksky.net/forecast/f3ce92e52d7509098b59805b2e280a60/\(latitude),\(longitude)?units=si", method: .get, parameters: nil, encoding: URLEncoding.default, headers: nil, interceptor: nil).responseJSON(completionHandler: { (response) in
            switch response.result {
            case .success(let data):
                if let data = data as? [String : Any] {
                    if let currentData = data["currently"] as? [String: Any]{
                        var today = TodayModel()
                        today = today.initLoad(currentData)
                        if let daily = data["daily"] as? [String: Any]{
                            if let listData = daily["data"] as? [[String: Any]]{
                                var listDaily = [DailyModel]()
                                for day in listData{
                                    var dayAdd = DailyModel()
                                    dayAdd = dayAdd.initLoad(day)
                                    listDaily.append(dayAdd)
                                }
                                closure(today, listDaily, nil)
                            }
                        }
                        
                    }
                }
            case .failure(let error):
                print(error)
            }
        })
    }
}
