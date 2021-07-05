//
//  AmThucCell.swift
//  VTCNow
//
//  Created by dovietduy on 1/27/21.
//

import UIKit
//import GoogleMobileAds

class Type5Cell: UICollectionViewCell {
    static let reuseIdentifier = "Type5Cell"
    @IBOutlet weak var collView: UICollectionView!
    @IBOutlet weak var lblTitle: UILabel!
    var delegate: Type5CellDelegate!
//    var admobNativeAds: GADUnifiedNativeAd?
    var numberOfItem = 0
    var data = CategoryModel(){
        didSet{
            lblTitle.text = data.name
            if data.name != oldValue.name{
                collView.reloadData()
            }
            if data.media.count >= 10 {
                numberOfItem = 10
            } else {
                numberOfItem = data.media.count
            }
            
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        collView.delegate = self
        collView.dataSource = self
        collView.register(UINib(nibName: Type3ItemCell.reuseIdentifier, bundle: nil), forCellWithReuseIdentifier: Type3ItemCell.reuseIdentifier)
        collView.register(UINib(nibName: ViewMoreCell.reuseIdentifier, bundle: nil), forCellWithReuseIdentifier: ViewMoreCell.reuseIdentifier)
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 20 * scaleW
        layout.sectionInset = UIEdgeInsets(top: 0, left: 20 * scaleW, bottom: 0, right: 20 * scaleW)
        collView.collectionViewLayout = layout
    }

}
extension Type5Cell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
//    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
//        if data.media.count < 7 {
//            APIService.shared.getMoreVideoPlaylist(privateKey: data.privateKey, page: "0") { (data, error) in
//                if let data = data as? [MediaModel]{
//                    self.data.media += data
//                    self.collView.reloadData()
//                }
//            }
//        }
//    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        if data.media.count >= 10 {
//            return 10
//        }
//        return data.media.count
        return numberOfItem
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let item = data.media[indexPath.row]
        switch indexPath.row {
        case 0...numberOfItem-2:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Type3ItemCell.reuseIdentifier, for: indexPath) as! Type3ItemCell
            cell.lblTitle.text = item.name
            if item.episode != "" {
                cell.viewEpisode.isHidden = false
                cell.lblEpisode.text = item.episode
                cell.lblTotalEpisode.text = item.totalEpisode
            }
            cell.row = indexPath.row
            cell.data = item
            cell.delegate = self
            if let url = URL(string: root.cdn.imageDomain + item.thumnail.replacingOccurrences(of: "\\", with: "/" )){
                cell.thumbImage.loadImage(fromURL: url)
            }
            cell.lblTime.isHidden = true
            cell.viewShare.isHidden = true
            return cell
        default:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ViewMoreCell.reuseIdentifier, for: indexPath) as! ViewMoreCell
            
            if let url = URL(string: root.cdn.imageDomain + item.thumnail.replacingOccurrences(of: "\\", with: "/" )){
                cell.imgThumb.loadImage(fromURL: url)
            }
            return cell
        }
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0...numberOfItem-2:
            break
        default:
            delegate?.didSelectViewMore(self)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch indexPath.row {
        case 0...numberOfItem-2:
            return CGSize(width: 160 * scaleW, height: 200 * scaleW)
        default:
            return CGSize(width: 168 * scaleW, height: 200 * scaleW)
        }
    }
}
extension Type5Cell: Type3ItemCellDelegate{
    func didSelectViewImage(_ cell: Type3ItemCell) {
        let temp = self.data.copy()
        let item = cell.data
//        print(cell.row)
        temp.media.remove(at: cell.row)
        temp.media.insert(item, at: 0)
        news = temp
        delegate?.didSelectViewImage()
    }
    
    func didSelectViewBookmark(_ cell: Type3ItemCell) {
        
    }
    
    func didSelectViewShare(_ cell: Type3ItemCell) {
        self.delegate?.didSelectView2Share(cell)
    }
    
    
}
protocol Type5CellDelegate: HighLightController{
    func didSelectViewImage()
    func didSelectView2Share(_ cell: Type3ItemCell)
    func didSelectViewMore(_ cell: Type5Cell)
}
