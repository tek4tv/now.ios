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
    func getOverView(closure: @escaping (_ response: Any?, _ error: Error?) -> Void) {
        AF.request("https://dev.caching.tek4tv.vn/api/playlist/json/outlook_home", method: .get, parameters: nil, encoding: URLEncoding.default, headers: nil, interceptor: nil).responseJSON(completionHandler: { (response) in
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
    func getOverViewVideo(closure: @escaping (_ response: Any?, _ error: Error?) -> Void) {
        AF.request("https://dev.caching.tek4tv.vn/api/playlist/json/outlook_videos", method: .get, parameters: nil, encoding: URLEncoding.default, headers: nil, interceptor: nil).responseJSON(completionHandler: { (response) in
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
    func getBanner(closure: @escaping (_ response: Any?, _ error: Error?) -> Void) {
        AF.request("https://dev.caching.tek4tv.vn/api/playlist/json/app_banner_home", method: .get, parameters: nil, encoding: URLEncoding.default, headers: nil, interceptor: nil).responseJSON(completionHandler: { (response) in
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
    func getSmallBanner(closure: @escaping (_ response: Any?, _ error: Error?) -> Void) {
        AF.request("https://dev.caching.tek4tv.vn/api/playlist/json/5e24f01d-447e-4bc5-a1f0-0c6309b68416", method: .get, parameters: nil, encoding: URLEncoding.default, headers: nil, interceptor: nil).responseJSON(completionHandler: { (response) in
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
    func getVideoHot(privateKey: String = "62aa4db4-9750-439e-baeb-b717685a1e7d" , closure: @escaping (_ response: Any?, _ error: Error?) -> Void) {
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
    func getKeyWord(closure: @escaping (_ response: Any?, _ error: Error?) -> Void) {
        AF.request("https://dev.caching.tek4tv.vn/api/playlist/json/vtcnow_keyword", method: .get, parameters: nil, encoding: URLEncoding.default, headers: nil, interceptor: nil).responseJSON(completionHandler: { (response) in
            switch response.result {
            case .success(let data):
                var list: [KeyWordModel] = []
                if let data = data as? [[String: Any]]{
                    for json in data{
                        var item = KeyWordModel()
                        item = item.initLoad(json)
                        list.append(item)
                    }
                }
                closure(list, nil)
            case .failure(let error):
                print(error)
            }
        })
    }
    func getKeySearch(closure: @escaping (_ response: Any?, _ error: Error?) -> Void) {
        AF.request("https://dev.caching.tek4tv.vn/api/playlist/json/vtcnow_keysearch", method: .get, parameters: nil, encoding: URLEncoding.default, headers: nil, interceptor: nil).responseJSON(completionHandler: { (response) in
            switch response.result {
            case .success(let data):
                var list: [String] = []
                if let data = data as? [[String: Any]]{
                    for json in data{
                        if let name = json["Name"] as? String {
                            list.append(name)
                        }
                    }
                }
                closure(list, nil)
            case .failure(let error):
                print(error)
            }
        })
    }
    func getKeyUser(closure: @escaping (_ response: Any?, _ error: Error?) -> Void) {
        AF.request("https://dev.caching.tek4tv.vn/api/playlist/json/vtcnow_keyuser", method: .get, parameters: nil, encoding: URLEncoding.default, headers: nil, interceptor: nil).responseJSON(completionHandler: { (response) in
            switch response.result {
            case .success(let data):
                var list: [String] = []
                if let data = data as? [[String: Any]]{
                    for json in data{
                        if let name = json["KeyWord"] as? String {
                            list.append(name)
                        }
                    }
                }
                closure(list, nil)
            case .failure(let error):
                print(error)
            }
        })
    }
    func searchWithTag(privateKey: String, keySearch: String, closure: @escaping (_ response: Any?, _ error: Error?) -> Void) {
        let json: [String : Any] = [
            "KeySearch": keySearch,
            "Tag": privateKey,
            "Page":0,
            "Size":20
        ]
        AF.request("https://dev.caching.tek4tv.vn/api/Video/Search/tag", method: .post, parameters: json, encoding: JSONEncoding.default).responseJSON(completionHandler: { (response) in
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
//    func getMoreVideoPlaylist(privateKey: String, page: String, closure: @escaping (_ response: Any?, _ error: Error?) -> Void) {
//        AF.request("https://dev.caching.tek4tv.vn/api/Video/\(privateKey)/\(page)/36" + page, method: .get, parameters: nil, encoding: URLEncoding.default, headers: nil, interceptor: nil).responseJSON(completionHandler: { (response) in
//            switch response.result {
//            case .success(let data):
//                var list: [MediaModel] = []
//                if let data = data as? [[String: Any]]{
//                    for json in data{
//                        let itemAdd = MediaModel().initLoad(json)
//                        list.append(itemAdd)
//                    }
//                }
//                closure(list, nil)
//            case .failure(let error):
//                print(error)
//            }
//        })
//    }
    func getMoreVideoPlaylist(privateKey: String, page: String, closure: @escaping (_ response: Any?, _ error: Error?) -> Void) {
        AF.request("https://ovp.tek4tv.vn/redis/v1/accounts/103e5b3a-3971-4fcb-bf44-5b15c5bbb88e/playlists/\(privateKey)/desc/20/\(page)", method: .get, parameters: nil, encoding: URLEncoding.default, headers: nil, interceptor: nil).responseJSON(completionHandler: { (response) in
            switch response.result {
            case .success(let data):
                var category = CategoryModel()
                if let data = data as? [String: Any]{
                    category = category.initLoad(data)
                }
                closure(category.media, nil)
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
    func getRelatedEpisode(code: String, closure: @escaping (_ response: Any?, _ error: Error?) -> Void) {
        AF.request("https://dev.caching.tek4tv.vn/api/Video/related/\(code.replacingOccurrences(of: " ", with: ""))/0/50", method: .get, parameters: nil, encoding: URLEncoding.default, headers: nil, interceptor: nil).responseJSON(completionHandler: { (response) in
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
    func getVideoByDate(privateId: String, date: String, closure: @escaping (_ response: Any?, _ error: Error?) -> Void) {
        AF.request("https://dev.caching.tek4tv.vn/api/Video/\(privateId)/\(date)/0/15", method: .get, parameters: nil, encoding: URLEncoding.default, headers: nil, interceptor: nil).responseJSON(completionHandler: { (response) in
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
    func getWeatherHN(closure: @escaping (_ response: Any?, _ list: Any?, _ error: Error?) -> Void) {
        AF.request("https://dev.caching.tek4tv.vn/api/playlist/json/weather_hn", method: .get, parameters: nil, encoding: URLEncoding.default, headers: nil, interceptor: nil).responseJSON(completionHandler: { (response) in
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
    func getWeatherHCM(closure: @escaping (_ response: Any?, _ list: Any?, _ error: Error?) -> Void) {
        AF.request("https://dev.caching.tek4tv.vn/api/playlist/json/weather_hcm", method: .get, parameters: nil, encoding: URLEncoding.default, headers: nil, interceptor: nil).responseJSON(completionHandler: { (response) in
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
    func getWeatherHP(closure: @escaping (_ response: Any?, _ list: Any?, _ error: Error?) -> Void) {
        AF.request("https://dev.caching.tek4tv.vn/api/playlist/json/weather_hp", method: .get, parameters: nil, encoding: URLEncoding.default, headers: nil, interceptor: nil).responseJSON(completionHandler: { (response) in
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
    func getWeatherDN(closure: @escaping (_ response: Any?, _ list: Any?, _ error: Error?) -> Void) {
        AF.request("https://dev.caching.tek4tv.vn/api/playlist/json/weather_dn", method: .get, parameters: nil, encoding: URLEncoding.default, headers: nil, interceptor: nil).responseJSON(completionHandler: { (response) in
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
    func getWeatherCT(closure: @escaping (_ response: Any?, _ list: Any?, _ error: Error?) -> Void) {
        AF.request("https://dev.caching.tek4tv.vn/api/playlist/json/weather_ct", method: .get, parameters: nil, encoding: URLEncoding.default, headers: nil, interceptor: nil).responseJSON(completionHandler: { (response) in
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
