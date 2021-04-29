//
//  Book3Cell.swift
//  NOW
//
//  Created by dovietduy on 4/5/21.
//

import UIKit

class Book3Cell: UICollectionViewCell {
    @IBOutlet weak var collView: UICollectionView!
    var data = CategoryModel()
    var delegate: Book3CellDelegate!
    var row = 0
    override func awakeFromNib() {
        super.awakeFromNib()
        collView.delegate = self
        collView.dataSource = self
        collView.register(UINib(nibName: Book3ItemCell.className, bundle: nil), forCellWithReuseIdentifier: Book3ItemCell.className)
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 334 * scaleW, height: 167 * scaleW)
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 20 * scaleW
        layout.sectionInset = UIEdgeInsets(top: 0, left: 20 * scaleW, bottom: 0, right: 20 * scaleW)
        collView.collectionViewLayout = layout
        // Initialization code
    }

}
extension Book3Cell: UICollectionViewDelegate, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.media.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Book3ItemCell.className, for: indexPath) as! Book3ItemCell
        let item = data.media[indexPath.row]
        if let url = URL(string: root.cdn.imageDomain + item.thumnail.replacingOccurrences(of: "\\", with: "/" )){
            cell.imgThumb.loadImage(fromURL: url)
        }
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        row = indexPath.row
        let item = self.data.media[indexPath.row]
        if item.episode != ""{
            self.delegate?.didSelectItemAt(self, item)
        } else{
            self.delegate?.didSelectNovel(self, item, data.media)
        }
        
    }
    
}
protocol Book3CellDelegate {
    func didSelectItemAt(_ cell: Book3Cell,_ data: MediaModel)
    func didSelectNovel(_ cell: Book3Cell,_ data: MediaModel, _ list: [MediaModel])
}
