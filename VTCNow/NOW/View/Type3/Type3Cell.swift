//
//  TinMoiCell.swift
//  VTCNow
//
//  Created by dovietduy on 1/25/21.
//

import UIKit
import GoogleMobileAds
class Type3Cell: UICollectionViewCell {

    @IBOutlet weak var collView: UICollectionView!
    @IBOutlet weak var lblTitle: UILabel!
//    var delegate: Type3CellDelegate!
    var admobNativeAds: GADUnifiedNativeAd?
    var data = CategoryModel(){
        didSet{
            lblTitle.text = data.name
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
        collView.register(UINib(nibName: "Type3ItemCell", bundle: nil), forCellWithReuseIdentifier: "Type3ItemCell")
        collView.register(UINib(nibName: nativeAdmobCLVCell.className, bundle: nil), forCellWithReuseIdentifier: nativeAdmobCLVCell.className)
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 10 * scaleW
        collView.collectionViewLayout = layout
    }
    func refresh(){
        collView.reloadData()
    }
}
extension Type3Cell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if data.media.count >= 6 {
            return 6
        }
        return data.media.count
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Type3ItemCell.className, for: indexPath) as! Type3ItemCell
        let item = data.media[indexPath.row]
        cell.lblTitle.text = item.name
        cell.lblTime.text = item.getTimePass()
        
        
        if let url = URL(string: root.cdn.imageDomain + item.thumnail.replacingOccurrences(of: "\\", with: "/" )){
            cell.thumbImage.loadImage(fromURL: url)
            cell.thumbImage.contentMode = .scaleAspectFill
        }
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        switch indexPath.section {
//        case 0:
//            sharedItem = data.media[0]
//            idVideoPlaying = 0
//        default:
//            sharedItem = data.media[indexPath.row + 1]
//            idVideoPlaying = indexPath.row + 1
//        }
//        sharedList = data.media
//        NotificationCenter.default.post(name: NSNotification.Name("openVideo"), object: nil)
        idVideoPlaying = indexPath.row
        APIService.shared.getDetailVideo(privateKey: data.media[indexPath.row].privateID) { (data, error) in
            if let data = data as? MediaModel{
                sharedItem = data
                sharedList = self.data.media
                NotificationCenter.default.post(name: NSNotification.Name("openVideo"), object: nil)
            }
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 190 * scaleW, height: 200 * scaleW)
    }
}
