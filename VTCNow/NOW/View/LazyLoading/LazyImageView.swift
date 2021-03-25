//
//  LazyImageView.swift
//  VTCNow
//
//  Created by dovietduy on 1/27/21.
//

import Foundation
import UIKit
import Kingfisher
//class LazyImageView: UIImageView{
//
//    private let imageCache = NSCache<AnyObject, UIImage>()
//
//    func loadImage(fromURL imageURL: URL){
//
//        if let cachedImage = self.imageCache.object(forKey: imageURL as AnyObject){
//            self.image = cachedImage
//            return
//        }
//
//        DispatchQueue.global().async {[weak self] in
//            if let imageData = try? Data(contentsOf: imageURL){
//                if let image = UIImage(data: imageData){
//
//                    DispatchQueue.main.async {
//                        self?.image = image
//                        self?.imageCache.setObject(image, forKey: imageURL as AnyObject)
//
//                    }
//                }
//            }
//        }
//    }
//}
class LazyImageView: UIImageView{
    func loadImage(fromURL imageURL: URL){
        ImageCache.default.diskStorage.config.expiration = .days(7)
        self.kf.setImage(with: imageURL,placeholder: #imageLiteral(resourceName: "placeHolderImage"), options:[.cacheOriginalImage,.transition(.fade(1))]) { (result) in
        }
       
    }
}

