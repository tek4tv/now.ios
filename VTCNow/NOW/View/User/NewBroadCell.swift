//
//  NewBroadCell.swift
//  NOW
//
//  Created by dovietduy on 4/22/21.
//

import UIKit

class NewBroadCell: UICollectionViewCell {
    static let reuseIdentifier = "NewBroadCell"
    @IBOutlet weak var collView: UICollectionView!
    @IBOutlet weak var imgAdd: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var icon: UIImageView!
    var delegate: NewBroadCellDelegate!
    var data: CategoryModel = CategoryModel(){
        didSet{
            if data.media.isEmpty{
                collView.isHidden = true
            } else {
                collView.isHidden = false
            }
            collView.reloadData()
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        collView.delegate = self
        collView.dataSource = self
        collView.register(UINib(nibName: Type3ItemCell.reuseIdentifier, bundle: nil), forCellWithReuseIdentifier: Type3ItemCell.reuseIdentifier)
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 160 * scaleW, height: 200 * scaleW)
        layout.minimumLineSpacing = 20 * scaleW
        layout.minimumInteritemSpacing = 0
        layout.sectionInset = UIEdgeInsets(top: 0, left: 20 * scaleW, bottom: 0, right: 20 * scaleW)
        collView.collectionViewLayout = layout
        icon.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didSelectLogo(_:))))
    }
    override func prepareForReuse() {
        imgAdd.image = #imageLiteral(resourceName: "icons8-add-100")
    }
    @objc func didSelectLogo(_ sender: Any){
        delegate?.didSelectIcon()
    }
}
extension NewBroadCell: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        data.media.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Type3ItemCell.reuseIdentifier, for: indexPath) as! Type3ItemCell
        let item = data.media[indexPath.row]
        cell.delegate = self
        cell.data = item
        cell.row = indexPath.row
        cell.lblTitle.text = item.name
        cell.lblTime.text = item.getTimePass()
        if let url = URL(string: root.cdn.imageDomain + item.thumnail320_180.replacingOccurrences(of: "\\", with: "/" )){
            cell.thumbImage.loadImage(fromURL: url)
            cell.thumbImage.contentMode = .scaleAspectFill
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    
}
protocol NewBroadCellDelegate: UserController {
    func didSelectItemAt(_ cell: NewBroadCell)
    func didSelectViewShare(_ cell: Type3ItemCell)
    func didSelectIcon()
}
extension NewBroadCell: Type3ItemCellDelegate {
    func didSelectViewImage(_ cell: Type3ItemCell) {
        let temp = self.data.copy()
        let item = cell.data
        temp.media.remove(at: cell.row)
        temp.media.insert(item, at: 0)
        news = temp
        delegate?.didSelectItemAt(self)
    }
    
    func didSelectViewBookmark(_ cell: Type3ItemCell) {
        
    }
    
    func didSelectViewShare(_ cell: Type3ItemCell) {
        delegate?.didSelectViewShare(cell)
    }
    
    
}
