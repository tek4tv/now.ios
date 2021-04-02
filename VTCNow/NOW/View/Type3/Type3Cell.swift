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
        collView.register(UINib(nibName: Type3ItemCell.className, bundle: nil), forCellWithReuseIdentifier: Type3ItemCell.className)
        collView.register(UINib(nibName: ViewFullCell.className, bundle: nil), forCellWithReuseIdentifier: ViewFullCell.className)
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 10 * scaleW
        layout.sectionInset = UIEdgeInsets(top: 0, left: 10 * scaleW, bottom: 20 * scaleW, right: 10 * scaleW)
        collView.collectionViewLayout = layout
    }
    func refresh(){
        collView.reloadData()
    }
}
extension Type3Cell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // 6 1 6 1 6 1 6
        switch section {
        case 0, 2, 4, 6:
            return 6
        default:
            return 1
        }
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 7
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.section {
        case 0:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Type3ItemCell.className, for: indexPath) as! Type3ItemCell
            let item = data.media[indexPath.row]
            cell.lblTitle.text = item.name
            cell.lblTime.text = item.getTimePass()
            if let url = URL(string: root.cdn.imageDomain + item.thumnail.replacingOccurrences(of: "\\", with: "/" )){
                cell.thumbImage.loadImage(fromURL: url)
                cell.thumbImage.contentMode = .scaleAspectFill
            }
            return cell
        case 2:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Type3ItemCell.className, for: indexPath) as! Type3ItemCell
            let item = data.media[indexPath.row + 6]
            cell.lblTitle.text = item.name
            cell.lblTime.text = item.getTimePass()
            if let url = URL(string: root.cdn.imageDomain + item.thumnail.replacingOccurrences(of: "\\", with: "/" )){
                cell.thumbImage.loadImage(fromURL: url)
                cell.thumbImage.contentMode = .scaleAspectFill
            }
            return cell
        case 4:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Type3ItemCell.className, for: indexPath) as! Type3ItemCell
            let item = data.media[indexPath.row + 12]
            cell.lblTitle.text = item.name
            cell.lblTime.text = item.getTimePass()
            if let url = URL(string: root.cdn.imageDomain + item.thumnail.replacingOccurrences(of: "\\", with: "/" )){
                cell.thumbImage.loadImage(fromURL: url)
                cell.thumbImage.contentMode = .scaleAspectFill
            }
            return cell
        case 6:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Type3ItemCell.className, for: indexPath) as! Type3ItemCell
            let item = data.media[indexPath.row + 18]
            cell.lblTitle.text = item.name
            cell.lblTime.text = item.getTimePass()
            if let url = URL(string: root.cdn.imageDomain + item.thumnail.replacingOccurrences(of: "\\", with: "/" )){
                cell.thumbImage.loadImage(fromURL: url)
                cell.thumbImage.contentMode = .scaleAspectFill
            }
            return cell
        case 1, 3, 5:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ViewFullCell.className, for: indexPath) as! ViewFullCell
            cell.listData = Array(data.media.prefix(6))
            return cell
        default:
            return UICollectionViewCell()
        }
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
        switch indexPath.section {
        case 0, 2, 4, 6:
            return CGSize(width: 190 * scaleW, height: 200 * scaleW)
        default:
            return CGSize(width: 414 * scaleW, height: 260 * scaleW)
        }
        
    }
}
