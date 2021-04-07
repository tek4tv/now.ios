//
//  DanhMucCell.swift
//  VTCNow
//
//  Created by dovietduy on 1/26/21.
//

import UIKit

var news = CategoryModel()

class CategoryCell: UICollectionViewCell {

    @IBOutlet weak var collView: UICollectionView!
    var delegate: CategoryCellDelegate!
    var images: [String: UIImage] = [
        "Nổi bật": #imageLiteral(resourceName: "noibat"),
        "Đừng bỏ lỡ": #imageLiteral(resourceName: "tvshow"),
        "Tin mới": #imageLiteral(resourceName: "tinmoi"),
        "Tài liệu": #imageLiteral(resourceName: "tailieu"),
        "Ẩm thực": #imageLiteral(resourceName: "noibat"),
        "Sức khoẻ": #imageLiteral(resourceName: "noibat"),
        "TV Show": #imageLiteral(resourceName: "noibat"),
        "Âm nhạc": #imageLiteral(resourceName: "noibat"),
        "Phim": #imageLiteral(resourceName: "noibat"),
        "Sách hay": #imageLiteral(resourceName: "noibat"),
    ]
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        collView.delegate = self
        collView.dataSource = self
        collView.register(UINib(nibName: "CategoryItemCell", bundle: nil), forCellWithReuseIdentifier: "CategoryItemCell")
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 90 * scaleW, height: collView.bounds.height * scaleH)
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        collView.collectionViewLayout = layout
    }

}
extension CategoryCell: UICollectionViewDelegate, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categorys.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoryItemCell.className, for: indexPath) as! CategoryItemCell
        let item = categorys[indexPath.row]
        cell.lblTitle.text = item.name
        cell.thumbImage.image = images[item.name]
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cate = categorys[indexPath.row]
        delegate?.didSelectItem(cate)
    }
}
protocol CategoryCellDelegate {
    func didSelectItem(_ cate: CategoryModel)
}
