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
        self.kf.setImage(with: imageURL, options:[.cacheOriginalImage])
    }
}

