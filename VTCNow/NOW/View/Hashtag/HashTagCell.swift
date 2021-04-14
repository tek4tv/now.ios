//
//  HashTagCell.swift
//  NOW
//
//  Created by dovietduy on 3/31/21.
//

import UIKit

class HashTagCell: UICollectionViewCell {

    @IBOutlet weak var collView: UICollectionView!
    let listData = ["Võ Hoàng Yên", "Chính biến Myanmar", "Vắc xin AstraZeneca", "Sơn Tùng MTP", "Covid 19"]
    var delegate: HashTagCellDelegate!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        collView.delegate = self
        collView.dataSource = self
        collView.register(UINib(nibName: HashTagItemCell.className, bundle: nil), forCellWithReuseIdentifier: HashTagItemCell.className)
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 10 * scaleW
        layout.sectionInset = UIEdgeInsets(top: 0, left: 10 * scaleW, bottom: 0, right: 10 * scaleW)
        collView.collectionViewLayout = layout
    }

}
extension HashTagCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        listData.count
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let label = UILabel(frame: .zero)
        label.text = "# " + listData[indexPath.row]
        label.font = UIFont(name: "Roboto-Medium", size: 13 * scaleW)
        label.sizeToFit()
        return CGSize(width: label.frame.width + 10 * scaleW, height: 40 * scaleH)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HashTagItemCell.className, for: indexPath) as! HashTagItemCell
        cell.lblTitle.text = "# " + listData[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.delegate?.didSelectItemAt(listData[indexPath.row])
    }
    
}
protocol HashTagCellDelegate {
    func didSelectItemAt(_ word: String)
}
