//
//  AmThucCell.swift
//  VTCNow
//
//  Created by dovietduy on 1/27/21.
//

import UIKit
//import GoogleMobileAds

class Type5Cell: UICollectionViewCell {

    @IBOutlet weak var collView: UICollectionView!
    @IBOutlet weak var lblTitle: UILabel!
    var delegate: Type5CellDelegate!
//    var admobNativeAds: GADUnifiedNativeAd?
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
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 20 * scaleW
        layout.sectionInset = UIEdgeInsets(top: 0, left: 20 * scaleW, bottom: 10 * scaleW, right: 20 * scaleW)
        collView.collectionViewLayout = layout
    }

}
extension Type5Cell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if data.media.count < 7 {
            APIService.shared.getMoreVideoPlaylist(privateKey: data.privateKey, page: "0") { (data, error) in
                if let data = data as? [MediaModel]{
                    self.data.media += data
                    self.collView.reloadData()
                }
            }
        }
    }
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
            if item.country != ""{
                cell.lblTime.text = item.country
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
        switch indexPath.row {
        case 0...5:
            break
        default:
            delegate?.didSelectViewMore(self)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch indexPath.row {
        case 0...5:
            return CGSize(width: 160 * scaleW, height: 200 * scaleW)
        default:
            return CGSize(width: 168 * scaleW, height: 200 * scaleW)
        }
    }
}
extension Type5Cell: Type3ItemCellDelegate{
    func didSelectViewImage(_ cell: Type3ItemCell) {
        let count = data.media.count
        var list: [MediaModel] = []
        if count == 1{
            list = []
        } else if count == 2{
            if cell.row == 0 {
                list.append(data.media[1])
            } else{
                list.append(data.media[0])
            }
        } else if count >= 3 {
            if cell.row == 0{
                list = Array(data.media[1...count-1])
            } else if cell.row == count-1 {
                list = Array(data.media[0...count - 2])
            } else{
                list = Array(data.media[cell.row+1...count-1] + data.media[0...cell.row-1])
            }
        }
        APIService.shared.getDetailVideo(privateKey: data.media[cell.row].privateID) { (data, error) in
            if let data = data as? MediaModel{
                self.delegate?.didSelectViewImage(data, list, self)
            }
        }
    }
    
    func didSelectViewBookmark(_ cell: Type3ItemCell) {
        
    }
    
    func didSelectViewShare(_ cell: Type3ItemCell) {
        self.delegate?.didSelectView2Share(cell)
    }
    
    
}
protocol Type5CellDelegate{
    func didSelectViewImage(_ data: MediaModel,_ list: [MediaModel],_ cell: Type5Cell)
    func didSelectView2Share(_ cell: Type3ItemCell)
    func didSelectViewMore(_ cell: Type5Cell)
}
