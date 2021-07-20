//
//  Type7Cell.swift
//  NOW
//
//  Created by dovietduy on 4/2/21.
//

import UIKit

class Type7Cell: UICollectionViewCell {
    static let reuseIdentifier = "Type7Cell"
    @IBOutlet weak var collView: UICollectionView!
    @IBOutlet weak var lblTitle: UILabel!
    var delegate: Type7CellDelegate!
    var data = CategoryModel(){
        didSet{
            lblTitle.text = data.name
            if data.name != oldValue.name{
                collView.reloadData()
            }
            if data.media.count >= 10 {
                length = 10
            } else {
                length = data.media.count
            }
        }
    }
    var row = 0
    fileprivate var length = 0
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        collView.delegate = self
        collView.dataSource = self
        collView.register(UINib(nibName: Type7ItemCell.reuseIdentifier, bundle: nil), forCellWithReuseIdentifier: Type7ItemCell.reuseIdentifier)
        collView.register(UINib(nibName: ViewMore3Cell.reuseIdentifier, bundle: nil), forCellWithReuseIdentifier: ViewMore3Cell.reuseIdentifier)
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.sectionInset = UIEdgeInsets(top: 0, left: 10 * scaleW, bottom: 0, right: 0 * scaleW)
        collView.collectionViewLayout = layout
    }
}
extension Type7Cell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if data.media.count < 10{
            APIService.shared.getMoreVideoPlaylist(privateKey: data.privateKey, page: "1") { (data, error) in
                if let data = data as? [MediaModel]{
                    self.data.media += data
                    if self.data.media.count >= 10 {
                        self.length = 10
                    }
                    self.collView.reloadData()
                }
            }
        }
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        if data.media.count >= 10{
//            return 10
//        }
//        return data.media.count
        return length
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch indexPath.row {
        case 0...length - 2:
            return CGSize(width: 150 * scaleW, height: 240 * scaleW)
        default:
            return CGSize(width: 158 * scaleW, height: 240 * scaleW)
        }
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        switch indexPath.row {
        case 0...length - 2:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Type7ItemCell.reuseIdentifier, for: indexPath) as! Type7ItemCell
            if indexPath.row < data.media.count{
                let item = data.media[indexPath.row]
                if let url = URL(string: root.cdn.imageDomain + item.square.replacingOccurrences(of: "\\", with: "/" )){
                    cell.imgThumb.loadImage(fromURL: url)
                }
                cell.lblTitle.text = item.name
                if item.episode != "" {
                    cell.viewEpisode.isHidden = false
                    cell.lblEpisode.text = item.episode
                    cell.lblTotalEpisode.text = item.totalEpisode
                }
                cell.lblAuthor.text = item.author
            }
            return cell
        default:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ViewMore3Cell.reuseIdentifier, for: indexPath) as! ViewMore3Cell
            if indexPath.row < data.media.count {
                let item = data.media[indexPath.row]
                if let url = URL(string: root.cdn.imageDomain + item.square.replacingOccurrences(of: "\\", with: "/" )){
                    cell.imgThumb.loadImage(fromURL: url)
                }
            }
            return cell
        }
        
        
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0...length - 2:
            if indexPath.row < data.media.count {
                let item = data.media[indexPath.row]
                if item.episode != "" {
                    delegate?.didSelectItemAt(self, item)
                } else{
                    delegate?.didSelectNovel(self, item, data.media)
                }
            }
        default:
            delegate?.didSelectViewMore(self)
        }
    }
}
protocol Type7CellDelegate: ListenController {
    func didSelectItemAt(_ cell: Type7Cell,_ data: MediaModel)
    func didSelectNovel(_ cell: Type7Cell, _ data: MediaModel, _ list: [MediaModel])
    func didSelectViewMore(_ cell: Type7Cell)
}
