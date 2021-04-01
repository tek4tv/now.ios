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
        collView.register(UINib(nibName: Type3ItemCell.className, bundle: nil), forCellWithReuseIdentifier: Type3ItemCell.className)
        collView.register(UINib(nibName: ViewMoreCell.className, bundle: nil), forCellWithReuseIdentifier: ViewMoreCell.className)
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 10 * scaleW
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 20 * scaleW, right: 10 * scaleW)
        collView.collectionViewLayout = layout
    }

}
extension Type5Cell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if data.media.count >= 7 {
            return 7
        }
        return data.media.count
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let item = data.media[indexPath.row]
        switch indexPath.row {
        case 0...5:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Type3ItemCell.className, for: indexPath) as! Type3ItemCell
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
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ViewMoreCell.className, for: indexPath) as! ViewMoreCell
            
            if let url = URL(string: root.cdn.imageDomain + item.thumnail.replacingOccurrences(of: "\\", with: "/" )){
                cell.imgThumb.loadImage(fromURL: url)
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
            idVideoPlaying = indexPath.row
            APIService.shared.getDetailVideo(privateKey: data.media[indexPath.row + 1].privateID) { (data, error) in
                if let data = data as? MediaModel{
                    sharedItem = data
                    sharedList = self.data.media
                    self.delegate?.didSelectItemAt()
                }
            }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch indexPath.row {
        case 0...5:
            return CGSize(width: 160 * scaleW, height: 180 * scaleW)
        default:
            return CGSize(width: 168 * scaleW, height: 180 * scaleW)
        }
    }
}
protocol Type5Delegate{
    func didSelectItemAt()
}
