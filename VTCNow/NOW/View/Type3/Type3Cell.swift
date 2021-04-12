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
    var delegate: Type3CellDelegate!
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
        case 0:
            return 6
        case 1:
            return 1
        default:
            return 18
        }
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 3
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.section {
        case 0:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Type3ItemCell.className, for: indexPath) as! Type3ItemCell
            let item = data.media[indexPath.row]
            cell.data = item
            cell.row = indexPath.row
            cell.delegate = self
            cell.lblTitle.text = item.name
            cell.lblTime.text = item.getTimePass()
            if let url = URL(string: root.cdn.imageDomain + item.thumnail.replacingOccurrences(of: "\\", with: "/" )){
                cell.thumbImage.loadImage(fromURL: url)
                cell.thumbImage.contentMode = .scaleAspectFill
            }
            return cell
        case 1:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ViewFullCell.className, for: indexPath) as! ViewFullCell
            cell.listData = Array(data.media.prefix(6))
            return cell
        default:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Type3ItemCell.className, for: indexPath) as! Type3ItemCell
            let item = data.media[indexPath.row + 6]
            cell.data = item
            cell.row = indexPath.row + 6
            cell.delegate = self
            cell.lblTitle.text = item.name
            cell.lblTime.text = item.getTimePass()
            if let url = URL(string: root.cdn.imageDomain + item.thumnail.replacingOccurrences(of: "\\", with: "/" )){
                cell.thumbImage.loadImage(fromURL: url)
                cell.thumbImage.contentMode = .scaleAspectFill
            }
            return cell
        }
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch indexPath.section {
        case 0:
            return CGSize(width: (414 - 30) / 2.001 * scaleW, height: 220 * scaleW)
        case 1:
            return CGSize(width: 414 * scaleW, height: 420 * scaleW)
        default:
            return CGSize(width: (414 - 30) / 2.001 * scaleW, height: 220 * scaleW)
        }
        
    }
}

extension Type3Cell: Type3ItemCellDelegate{
    func didSelectViewImage(_ cell: Type3ItemCell) {
        let temp = self.data.copy()
        let item = cell.data
        print(cell.row)
        temp.media.remove(at: cell.row)
        temp.media.insert(item, at: 0)
        news = temp
        delegate?.didSelectViewImage(cell)
    }
    
    func didSelectViewBookmark(_ cell: Type3ItemCell) {
        
    }
    
    func didSelectViewShare(_ cell: Type3ItemCell) {
        delegate?.didSelectViewShare(cell)
    }
    
    
}

protocol Type3CellDelegate{
    func didSelectViewShare(_ cell: Type3ItemCell)
    func didSelectViewImage(_ cell: Type3ItemCell)
}
