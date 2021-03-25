//
//  PhimCell.swift
//  VTCNow
//
//  Created by dovietduy on 1/27/21.
//

import UIKit
class BookCell: UICollectionViewCell {

    @IBOutlet weak var collView: UICollectionView!
    @IBOutlet weak var lblTitle: UILabel!
    var delegate: BookCellDelegate!
    var data = CategoryModel(){
        didSet{
            lblTitle.text = data.name + " >"
            if data.name != oldValue.name{
                collView.reloadData()
            }
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        collView.delegate = self
        collView.dataSource = self
        collView.register(UINib(nibName: BookItemCell.className, bundle: nil), forCellWithReuseIdentifier: BookItemCell.className)
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 150 * scaleW, height: 260 * scaleW)
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 5
        layout.sectionInset = UIEdgeInsets(top: 0, left: 5 * scaleW, bottom: 0, right: 5 * scaleW)
        collView.collectionViewLayout = layout
    }
    override func prepareForReuse() {
        lblTitle.text = ""
    }
}
extension BookCell: UICollectionViewDelegate, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.media.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BookItemCell.className, for: indexPath) as! BookItemCell
        let item = data.media[indexPath.row]
        if let url = URL(string: root.cdn.imageDomain + item.image[0].url.replacingOccurrences(of: "\\", with: "/" )){
            cell.thumbImage.loadImage(fromURL: url)
        }
        cell.lblTitle.text = item.name + item.episode
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        sharedItem = data.media[indexPath.row]
//        sharedList = data.media
//        idBookPlaying = indexPath.row
//        delegate?.didSelectItemAt()
        APIService.shared.getDetailVideo(privateKey: data.media[indexPath.row].privateID) { (data, error) in
            if let data = data as? MediaModel{
                sharedItem = data
                sharedList = self.data.media
                idBookPlaying = indexPath.row
                self.delegate?.didSelectItemAt()
            }
        }
    }
}

protocol BookCellDelegate{
    func didSelectItemAt()
}
