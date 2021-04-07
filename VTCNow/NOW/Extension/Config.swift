//
//  Config.swift
//  NOW
//
//  Created by dovietduy on 3/1/21.
//

import Foundation
import UIKit
var sharedItem : MediaModel!
var sharedList : [MediaModel] = []
var root = RootModel()
var categorys: [CategoryModel] = []
var idBookPlaying = 0
var idVideoPlaying = 0
var reads : [ReadModel] = []
var tabBarIndex = 0
var isMessaging = false
var bookCate: CategoryModel!


let admobBanner = "ca-app-pub-3940256099942544/2934735716"
let admobFull = "ca-app-pub-5372862349743986/9369434422"
let adNativeAd = "ca-app-pub-3940256099942544/3986624511"
var numberToShowAd = 6
let DEVICE_WIDTH = UIScreen.main.bounds.width
let DEVICE_HEIGHT = UIScreen.main.bounds.height
let IS_IPAD = UIDevice.current.userInterfaceIdiom == .pad
