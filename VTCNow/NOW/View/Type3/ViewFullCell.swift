//
//  ViewFullCell.swift
//  NOW
//
//  Created by dovietduy on 4/1/21.
//

import UIKit

class ViewFullCell: UICollectionViewCell {

    @IBOutlet weak var viewContainer: UIView!
    @IBOutlet weak var collView: UICollectionView!
    @IBOutlet weak var collDotView: UICollectionView!
    var listData: [MediaModel] = []
    
    var timer = Timer()
    var indexPath = IndexPath(row: 0, section: 0)
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        collView.tag = 0
        collView.delegate = self
        collView.dataSource = self
        collView.register(UINib(nibName: ViewFullItemCell.className, bundle: nil), forCellWithReuseIdentifier: ViewFullItemCell.className)
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: collView.bounds.width * scaleW, height: collView.bounds.height * scaleW)
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        collView.collectionViewLayout = layout
        collView.isPagingEnabled = true
        
        collDotView.tag = 1
        collDotView.delegate = self
        collDotView.dataSource = self
        collDotView.register(UINib(nibName: LongDotCell.className, bundle: nil), forCellWithReuseIdentifier: LongDotCell.className)
        let layout2 = UICollectionViewFlowLayout()
        layout2.itemSize = CGSize(width: (collDotView.bounds.width - 50) / 6.5, height: 2 * scaleW)
        collDotView.collectionViewLayout = layout2
        
        viewContainer.dropShadow()
        timer = Timer.scheduledTimer(withTimeInterval: 6.0, repeats: true, block: {[self] (timer) in
            if indexPath.row < listData.count{
                indexPath.row += 1
            } else{
                indexPath.row = 0
            }
            collView.isPagingEnabled = false
            collView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
            collView.isPagingEnabled = true
        })
        
    }

}
extension ViewFullCell: UICollectionViewDelegate, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 6
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch collectionView.tag {
        case 0:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ViewFullItemCell.className, for: indexPath) as! ViewFullItemCell
            let item = listData[indexPath.row]
            cell.lblTitle.text = item.name
            cell.lblTime.text = item.timePass
            cell.lblDescription.text = item.descripTion
            cell.lblDescription.isHidden = true
            if let url = URL(string: root.cdn.imageDomain + item.thumnail.replacingOccurrences(of: "\\", with: "/" )){
                cell.imgThumb.loadImage(fromURL: url)
            }
            return cell
        default:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: LongDotCell.className, for: indexPath) as! LongDotCell
            if indexPath == self.indexPath{
                cell.viewDot.backgroundColor = #colorLiteral(red: 0.5019607843, green: 0.01176470588, blue: 0.2588235294, alpha: 1)
            }else{
                cell.viewDot.backgroundColor = .lightGray
            }
            return cell
        }
    }

    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        switch collectionView.tag {
        case 0:
            self.indexPath = indexPath
            collDotView.reloadData()
            
        default:
            break
        }
        
    }
    
}
