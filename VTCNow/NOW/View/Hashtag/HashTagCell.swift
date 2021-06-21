//
//  HashTagCell.swift
//  NOW
//
//  Created by dovietduy on 3/31/21.
//

import UIKit

class HashTagCell: UICollectionViewCell {

    @IBOutlet weak var collView: UICollectionView!
    var listData: [KeyWordModel] = []
    var delegate: HashTagCellDelegate!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        collView.delegate = self
        collView.dataSource = self
        collView.register(UINib(nibName: HashTagItemCell.className, bundle: nil), forCellWithReuseIdentifier: HashTagItemCell.className)
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 20 * scaleW
        layout.sectionInset = UIEdgeInsets(top: 0, left: 20 * scaleW, bottom: 0, right: 20 * scaleW)
        collView.collectionViewLayout = layout
        
        APIService.shared.getKeyWord {[weak self] (data, error) in
            if let data = data as? [KeyWordModel] {
                self?.listData = data
                self?.collView.reloadData()
            }
        }
    }

}
extension HashTagCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        listData.count
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let label = UILabel(frame: .zero)
        label.text = listData[indexPath.row].keyWord
        label.font = UIFont(name: "Roboto-Medium", size: 18 * scaleW)
        label.sizeToFit()
        return CGSize(width: label.frame.width + 10 * scaleW, height: 35 * scaleW)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HashTagItemCell.className, for: indexPath) as! HashTagItemCell
        cell.lblTitle.text = listData[indexPath.row].keyWord
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.delegate?.didSelectItemAt(listData[indexPath.row].privateKey)
    }
    
}
protocol HashTagCellDelegate: class {
    func didSelectItemAt(_ word: String)
}
