//
//  StreamHelper.swift
//  NOW
//
//  Created by dovietduy on 2/23/21.
//

import Foundation
import UIKit
class StreamHelper{
    static let shared = StreamHelper()
    
    func getPlaylist(from url: URL, completion: @escaping (Result<RawPlaylist, Error>) -> Void) {
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data, let string = String(data: data, encoding: .utf8) {
                completion(.success(RawPlaylist(url: url, content: string)))
            }else if let error = error {
                completion(.failure(error))
            }
            
        }
        task.resume()
    }

    func getStreamResolutions(from playlist: RawPlaylist) -> [StreamResolution] {
        var resolutions = [StreamResolution]()
        playlist.content.enumerateLines { line, shouldStop in
            let infoline = line.replacingOccurrences(of: "#EXT-X-STREAM-INF", with: "")
            let infoItems = infoline.components(separatedBy: ",")
            let bandwidthItem = infoItems.first(where: { $0.contains(":BANDWIDTH") })
            let resolutionItem = infoItems.first(where: { $0.contains("RESOLUTION")})
            if let bandwidth = bandwidthItem?.components(separatedBy: "=").last,
               let numericBandwidth = Double(bandwidth),
               let resolution = resolutionItem?.components(separatedBy: "=").last?.components(separatedBy: "x"),
               let strignWidth = resolution.first,
               let stringHeight = resolution.last,
               let width = Double(strignWidth),
               let height = Double(stringHeight) {
                resolutions.append(StreamResolution(maxBandwidth: numericBandwidth,
                                                    averageBandwidth: numericBandwidth,
                                                    resolution: CGSize(width: width, height: height)))
            }
        }
        return resolutions
    }
}
class RawPlaylist{
    var url: URL!
    var content: String = ""
    init(url: URL, content: String){
        self.url = url
        self.content = content
    }
}
class StreamResolution{
    var isTicked = false
    var maxBandwidth: Double = 0.0
    var averageBandwidth: Double = 0.0
    var resolution: CGSize!
    init(maxBandwidth: Double,
        averageBandwidth: Double,
        resolution: CGSize) {
        self.maxBandwidth = maxBandwidth
        self.averageBandwidth = averageBandwidth
        self.resolution = resolution
    }
    init(){
        
    }
}
