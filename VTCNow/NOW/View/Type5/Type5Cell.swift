//
//  AmThucCell.swift
//  VTCNow
//
//  Created by dovietduy on 1/27/21.
//

import UIKit
import GoogleMobileAds

class Type5Cell: UICollectionViewCell {

    @IBOutlet weak var collView: UICollectionView!
    @IBOutlet weak var lblTitle: UILabel!
    var delegate: Type5Delegate!
    var admobNativeAds: GADUnifiedNativeAd?
    var data = CategoryModel(){
        didSet{
            lblTitle.text = data.name + " >"
            if data.name != oldValue.name{
                collView.reloadData()
            }
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        collView.delegate = self
        collView.dataSource = self
        collView.register(UINib(nibName: Type3ItemCell.className, bundle: nil), forCellWithReuseIdentifier: Type3ItemCell.className)
        collView.register(UINib(nibName: nativeAdmobCLVCell.className, bundle: nil), forCellWithReuseIdentifier: nativeAdmobCLVCell.className)
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        collView.collectionViewLayout = layout
        
        AdmobManager.shared.loadAllNativeAds()
    }

}
extension Type5Cell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            if data.media.count >= 6 {
                return 6
            }
            return data.media.count
        default:
            return 1
        }
        
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 3
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.section {
        case 0:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Type3ItemCell.className, for: indexPath) as! Type3ItemCell
            var item = MediaModel()
            item = data.media[0]
            cell.lblTitle.text = item.name
            if let url = URL(string: root.cdn.imageDomain + item.thumnail.replacingOccurrences(of: "\\", with: "/" )){
                cell.thumbImage.loadImage(fromURL: url)
            }
            if item.cast != ""{
                cell.lblTime.text = item.cast
            }else{
                cell.lblTime.text = item.timePass
            }
            return cell
        case 1:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Type3ItemCell.className, for: indexPath) as! Type3ItemCell
            var item = MediaModel()
            item = data.media[indexPath.row + 1]
            cell.lblTitle.text = item.name
            if let url = URL(string: root.cdn.imageDomain + item.thumnail.replacingOccurrences(of: "\\", with: "/" )){
                cell.thumbImage.loadImage(fromURL: url)
            }
            if item.cast != ""{
                cell.lblTime.text = item.cast
            }else{
                cell.lblTime.text = item.timePass
            }
            return cell
        default:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: nativeAdmobCLVCell.className, for: indexPath) as! nativeAdmobCLVCell
            if let native = AdmobManager.shared.getAdmobNativeAds(){
                admobNativeAds = native
            }
            if let native = self.admobNativeAds {
                cell.setupHeader(nativeAd: native)
            }
            return cell
        }
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        switch indexPath.section {
//        case 0:
//            sharedItem = data.media[0]
//        default:
//            sharedItem = data.media[indexPath.row + 1]
//        }
//        sharedList = data.media
//        delegate?.didSelectItemAt()
        switch indexPath.section {
        case 0:
            idVideoPlaying = 0
            APIService.shared.getDetailVideo(privateKey: data.media[0].privateID) { (data, error) in
                if let data = data as? MediaModel{
                    sharedItem = data
                    sharedList = self.data.media
                    self.delegate?.didSelectItemAt()
                }
            }
        case 1:
            idVideoPlaying = indexPath.row + 1
            APIService.shared.getDetailVideo(privateKey: data.media[indexPath.row + 1].privateID) { (data, error) in
                if let data = data as? MediaModel{
                    sharedItem = data
                    sharedList = self.data.media
                    self.delegate?.didSelectItemAt()
                }
            }
        default:
            break
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch indexPath.section {
        case 0:
            return CGSize(width: collectionView.bounds.width, height: 300 * scaleW)
        case 1:
            return CGSize(width: 190 * scaleW, height: 200 * scaleW)
        default:
            return CGSize(width: 380 * scaleW, height: 250 * scaleW)
        }
    }
}
protocol Type5Delegate{
    func didSelectItemAt()
}
