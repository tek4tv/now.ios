//
//  nativeAdmobCLVCell.swift
//  MangaTop
//
//  Created by MRXXX on 3/19/20.
//  Copyright © 2020 Nhuom Tang. All rights reserved.
//

import UIKit
import GoogleMobileAds

class nativeAdmobCLVCell: UICollectionViewCell {

      
    @IBOutlet weak var nativeAdView: GADUnifiedNativeAdView!
    @IBOutlet weak var colorView: UIView!

    override func awakeFromNib() {
        super.awakeFromNib()
        colorView.backgroundColor = UIColor.white
        nativeAdView.backgroundColor = UIColor.clear
        self.backgroundColor = UIColor.clear
    }
    
    func setupHeader(nativeAd: GADUnifiedNativeAd) {
        nativeAdView.nativeAd = nativeAd
        
        (nativeAdView.headlineView as? UILabel)?.text = nativeAd.headline
        nativeAdView.mediaView?.mediaContent = nativeAd.mediaContent
        
        (nativeAdView.bodyView as? UILabel)?.text = nativeAd.body
        nativeAdView.bodyView?.isHidden = nativeAd.body == nil
        
        (nativeAdView.callToActionView as? UIButton)?.setTitle(nativeAd.callToAction, for: .normal)
        nativeAdView.callToActionView?.isHidden = nativeAd.callToAction == nil
        
        (nativeAdView.iconView as? UIImageView)?.image = nativeAd.icon?.image
        nativeAdView.iconView?.isHidden = nativeAd.icon == nil
        nativeAdView.callToActionView?.isUserInteractionEnabled = false
    }
}
