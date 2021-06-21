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
    var listCate: [CategoryModel] = []
    var images: [String: UIImage] = [
        "Tin mới": #imageLiteral(resourceName: "tinmoi"),
        "Món ngon": #imageLiteral(resourceName: "MON NGON"),
        "Sức khỏe": #imageLiteral(resourceName: "SUC KHOE"),
        "TV Show": #imageLiteral(resourceName: "TV SHOW"),
        "Âm nhạc": #imageLiteral(resourceName: "AM NHAC"),
        "Phim lẻ": #imageLiteral(resourceName: "PHIM LE"),
        "Phim bộ": #imageLiteral(resourceName: "PHIM BO"),
        "Sách hay": #imageLiteral(resourceName: "SACH HAY"),
    ]
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        collView.delegate = self
        collView.dataSource = self
        collView.register(UINib(nibName: "CategoryItemCell", bundle: nil), forCellWithReuseIdentifier: "CategoryItemCell")
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 93 * scaleW, height: 95 * scaleW)
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        collView.collectionViewLayout = layout
        
        //
        for cate in categorys {
            if cate.name != "Nổi bật" && cate.name != "Đừng bỏ lỡ" {
                listCate.append(cate)
            }
        }
        collView.reloadData()
    }

}
extension CategoryCell: UICollectionViewDelegate, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return listCate.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoryItemCell.className, for: indexPath) as! CategoryItemCell
        let item = listCate[indexPath.row]
        cell.lblTitle.text = item.name
        if let url = URL(string: root.cdn.imageDomain + item.icon.replacingOccurrences(of: "\\", with: "/" )){
            cell.thumbImage.loadImage(fromURL: url)
        }
        
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cate = listCate[indexPath.row]
        delegate?.didSelectItem(cate)
    }
}
protocol CategoryCellDelegate: class {
    func didSelectItem(_ cate: CategoryModel)
}
