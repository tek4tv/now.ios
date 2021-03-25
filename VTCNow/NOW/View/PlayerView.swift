//
//  PlayerView.swift
//  NOW
//
//  Created by dovietduy on 2/3/21.
//
import AVFoundation

import UIKit

class PlayerView: UIView {


override class var layerClass: AnyClass {
  get {
    return AVPlayerLayer.self
  }
}


var player:AVPlayer? {
  set {
      if let layer = layer as? AVPlayerLayer {
        layer.videoGravity = .resizeAspect
        layer.player = newValue
      }
  }
  get {
      if let layer = layer as? AVPlayerLayer {
          return layer.player
      } else {
          return nil
      }
  }
}
}
