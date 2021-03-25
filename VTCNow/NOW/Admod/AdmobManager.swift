//
//  AdmobManager.swift
//  MangaReader
//
//  Created by Nhuom Tang on 9/9/18.
//  Copyright © 2018 Nhuom Tang. All rights reserved.
//

import UIKit
import GoogleMobileAds


enum adType: Int {
    case facebook
    case admob
}

enum clickType: Int {
    case facebook
    case admob
    case none
    case all
}

let adSize = UIDevice.current.userInterfaceIdiom == .pad ? kGADAdSizeBanner: kGADAdSizeBanner

class AdmobManager: NSObject, GADUnifiedNativeAdDelegate {
    
    static let shared = AdmobManager()
    
    var interstitial: GADInterstitial!
    //    var fbInterstitialAd: FBInterstitialAd!
    
    var isShowAds = false
    var counter = 1
    
    var adType: adType = .admob
    var clickType: clickType = .none
    var fullErrorType: clickType = .none
    var nativeType: adType = .facebook
    
    var fullRootViewController: UIViewController!
    
    //Native ads
    private var adLoader: GADAdLoader!
    var admobNativeAds: [GADUnifiedNativeAd] = []
    var loadErrorNativeAdmob = 0
    var loadErrorFullAdmob = 0
    
    var nativeFBIndex = 0
    var nativeAdmobIndex = 0
    
    var isTimer = true
    
    override init() {
        super.init()
        self.createAndLoadInterstitial()
        self.loadAllNativeAds()
        counter = numberToShowAd - 1
        if randomBool(){
            adType = .admob
            nativeType = .facebook
        }else{
            adType = .facebook
            nativeType = .admob
        }
    }
    
    func randomBool() -> Bool {
        return arc4random_uniform(2) == 0
    }
    
    func openRateView(){
        if #available(iOS 10.3, *) {
            //            SKStoreReviewController.requestReview()
        } else {
        }
    }
    
    func createBannerView(inVC: UIViewController) -> UIView{
        let witdh = DEVICE_WIDTH
        let frame = CGRect.init(x: (witdh - adSize.size.width)/2 , y: 0, width: adSize.size.width, height: adSize.size.height)
        let bannerView = GADBannerView.init(adSize: adSize)
        bannerView.adUnitID = admobBanner
        bannerView.rootViewController = inVC
        bannerView.delegate = self
        bannerView.frame = frame
        inVC.view.addSubview(bannerView)
        let request = GADRequest()
        bannerView.load(request)
        
        let tempView = UIView.init(frame: CGRect.init(x:0 , y: 0, width: DEVICE_WIDTH, height: adSize.size.height))
        tempView.addSubview(bannerView)
        return tempView
    }
    
    func loadAllNativeAds(){
        if !isTimer {
            return
        }
        isTimer = false
        let _ = Timer.scheduledTimer(withTimeInterval: 70, repeats: false) { [weak self] (timer) in
            self?.isTimer = true
        }
        self.loadAdmobNativeAds()
    }
    
    func randoomNativeAds() -> Any?{
        
        if nativeType == .admob{
            if admobNativeAds.count > 0{
                nativeType = .facebook
                return getAdmobNativeAds()
            }else{
                return nil
            }
        }
        return nil
    }
    
    
    func getAdmobNativeAds() -> GADUnifiedNativeAd?{
        if admobNativeAds.count > nativeAdmobIndex{
            let item = admobNativeAds[nativeAdmobIndex]
            nativeAdmobIndex = nativeAdmobIndex + 1
            return item
        }
        return admobNativeAds.last
    }
    
    func loadAdmobNativeAds(){
        
        if loadErrorNativeAdmob >= 1{
            return
        }
        
        if nativeAdmobIndex > 0{
            if admobNativeAds.count > (nativeAdmobIndex){
                return
            }
        }
        
        print("loadAdmobNativeAds")
        adLoader = GADAdLoader(adUnitID: adNativeAd, rootViewController: fullRootViewController, adTypes: [GADAdLoaderAdType.unifiedNative], options: nil)
        adLoader.delegate = self
        let request = GADRequest()
        adLoader.load(request)
    }
    
    func logEvent(){
        counter = counter + 1
        if counter % 3 == 0 {
            if fullErrorType == .all{
                createAndLoadInterstitial()
                
            }else if fullErrorType == .facebook{
                
            }else if fullErrorType == .admob{
                createAndLoadInterstitial()
            }
            fullErrorType = .none
        }
        if  counter >= numberToShowAd {
            isShowAds = true
            if clickType == .admob{
                if interstitial.isReady{
                    adType = .facebook
                    interstitial.present(fromRootViewController: fullRootViewController)
                    counter = 1
                }
            }else{
                if interstitial.isReady{
                    adType = .facebook
                    if fullRootViewController != nil {
                        interstitial.present(fromRootViewController: fullRootViewController)
                    }
                    counter = 1
                }else{
                }
            }
        }else{
            if isShowAds{
                isShowAds = false
                self.openRateView()
            }
        }
    }
    
    func forceShowAdd(){
        counter = numberToShowAd
        self.logEvent()
    }
}

extension AdmobManager: GADBannerViewDelegate {
    func loadBannerView(inVC: UIViewController) {
        let bannerView = GADBannerView.init(adSize: kGADAdSizeSmartBannerPortrait)
        bannerView.translatesAutoresizingMaskIntoConstraints = false
        inVC.view.addSubview(bannerView)
        inVC.view.addConstraints(
            [NSLayoutConstraint(item: bannerView,
                                attribute: .bottom,
                                relatedBy: .equal,
                                toItem: inVC.bottomLayoutGuide,
                                attribute: .top,
                                multiplier: 1,
                                constant: 0),
             NSLayoutConstraint(item: bannerView,
                                attribute: .centerX,
                                relatedBy: .equal,
                                toItem: inVC.view,
                                attribute: .centerX,
                                multiplier: 1,
                                constant: 0)
            ])
        bannerView.adUnitID = admobBanner
        bannerView.rootViewController = inVC
        bannerView.delegate = self
        let request = GADRequest()
        bannerView.load(request)
    }
    
    func adViewDidReceiveAd(_ bannerView: GADBannerView) {
        bannerView.alpha = 0
        UIView.animate(withDuration: 1, animations: {
            bannerView.alpha = 1
        })
    }
}


extension AdmobManager: GADInterstitialDelegate {
    
    func createAndLoadInterstitial() {
        
        interstitial = GADInterstitial(adUnitID: admobFull)
        interstitial.delegate = self
        let request = GADRequest()
        interstitial.load(request)
        
    }
    
    func interstitialDidDismissScreen(_ ad: GADInterstitial) {
        self.createAndLoadInterstitial()
    }
    
    func loadAdFull(inVC: UIViewController) {
        if interstitial.isReady {
            interstitial.present(fromRootViewController: inVC)
        }
    }
    
}

extension AdmobManager: GADVideoControllerDelegate {
    
    func videoControllerDidEndVideoPlayback(_ videoController: GADVideoController) {
    }
}

extension AdmobManager: GADAdLoaderDelegate {
    func adLoader(_ adLoader: GADAdLoader, didFailToReceiveAdWithError error: GADRequestError) {
        print("\(adLoader) failed with error: \(error.localizedDescription)")
    }
}

extension AdmobManager: GADUnifiedNativeAdLoaderDelegate {
    
    func adLoader(_ adLoader: GADAdLoader, didReceive nativeAd: GADUnifiedNativeAd) {
        print("didReceive nativeAd")
        admobNativeAds.append(nativeAd)
    }
}
