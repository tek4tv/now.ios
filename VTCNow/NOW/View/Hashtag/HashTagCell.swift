//
//  HashTagCell.swift
//  NOW
//
//  Created by dovietduy on 3/31/21.
//

import UIKit

class HashTagCell: UICollectionViewCell {

    @IBOutlet weak var collView: UICollectionView!
    let listData = ["Võ Hoàng Yến", "Chính biến Myanmar", "Vắc xin AstraZeneca", "Sơn Tùng MTP", "Covid 19"]
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        collView.delegate = self
        collView.dataSource = self
        collView.register(UINib(nibName: HashTagItemCell.className, bundle: nil), forCellWithReuseIdentifier: HashTagItemCell.className)
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        collView.collectionViewLayout = layout
    }

}
extension HashTagCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        listData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HashTagItemCell.className, for: indexPath) as! HashTagItemCell
        cell.lblTitle.text = "# " + listData[indexPath.row]
        return cell
    }
    
    
}
