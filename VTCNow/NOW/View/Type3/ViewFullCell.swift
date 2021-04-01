//
//  ViewFullCell.swift
//  NOW
//
//  Created by dovietduy on 4/1/21.
//

import UIKit

class ViewFullCell: UICollectionViewCell {

    @IBOutlet weak var collView: UICollectionView!
    @IBOutlet weak var collDotView: UICollectionView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        collView.tag = 0
        collView.delegate = self
        collView.dataSource = self
        collView.register(UINib(nibName: ViewFullItemCell.className, bundle: nil), forCellWithReuseIdentifier: ViewFullItemCell.className)
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: collView.bounds.width * scaleW, height: collView.bounds.height * scaleW)
        collView.collectionViewLayout = layout
        collView.isPagingEnabled = true
        
        collDotView.tag = 1
        collDotView.delegate = self
        collDotView.dataSource = self
        collDotView.register(UINib(nibName: LongDotCell.className, bundle: nil), forCellWithReuseIdentifier: LongDotCell.className)
        let layout2 = UICollectionViewFlowLayout()
        layout2.itemSize = CGSize(width: (collDotView.bounds.width - 50) / 6.5, height: 2 * scaleW)
        collDotView.collectionViewLayout = layout2
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
            return cell
        default:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: LongDotCell.className, for: indexPath) as! LongDotCell
            return cell
        }
    }
    
    
}
