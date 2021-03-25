//
//  PhimCell.swift
//  VTCNow
//
//  Created by dovietduy on 1/27/21.
//

import UIKit
class MovieCell: UICollectionViewCell {

    @IBOutlet weak var collView: UICollectionView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var viewLine: UIView!
    var delegate: MovieCellDelegate!
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
        collView.register(UINib(nibName: MovieItemCell.className, bundle: nil), forCellWithReuseIdentifier: MovieItemCell.className)
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 150 * scaleW, height: 260 * scaleW)
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.sectionInset = UIEdgeInsets(top: 0, left: 5 * scaleW, bottom: 0, right: 0)
        collView.collectionViewLayout = layout
    }
    override func prepareForReuse() {
        lblTitle.text = ""
    }
}
extension MovieCell: UICollectionViewDelegate, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.media.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MovieItemCell.className, for: indexPath) as! MovieItemCell
        let item = data.media[indexPath.row]
        if let url = URL(string: root.cdn.imageDomain + item.portrait.replacingOccurrences(of: "\\", with: "/" )){
            cell.thumbImage.loadImage(fromURL: url)
        }
        cell.lblTitle.text = item.name
        cell.lblTime.text =  item.country + " | " + item.minutes
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        sharedItem = data.media[indexPath.row]
//        sharedList = data.media
//        NotificationCenter.default.post(name: NSNotification.Name("openVideo"), object: nil)
//        delegate?.didSelectItemAt()
        APIService.shared.getDetailVideo(privateKey: data.media[indexPath.row].privateID) { (data, error) in
            if let data = data as? MediaModel{
                sharedItem = data
                sharedList = self.data.media
                NotificationCenter.default.post(name: NSNotification.Name("openVideo"), object: nil)
                self.delegate?.didSelectItemAt()
            }
        }
    }
}

protocol MovieCellDelegate{
    func didSelectItemAt()
}
