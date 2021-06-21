//
//  Type7Cell.swift
//  NOW
//
//  Created by dovietduy on 4/2/21.
//

import UIKit

class Type7Cell: UICollectionViewCell {

    @IBOutlet weak var collView: UICollectionView!
    @IBOutlet weak var lblTitle: UILabel!
    var delegate: Type7CellDelegate!
    var data = CategoryModel(){
        didSet{
            lblTitle.text = data.name
            if data.name != oldValue.name{
                collView.reloadData()
            }
        }
    }
    var row = 0
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        collView.delegate = self
        collView.dataSource = self
        collView.register(UINib(nibName: Type7ItemCell.className, bundle: nil), forCellWithReuseIdentifier: Type7ItemCell.className)
        collView.register(UINib(nibName: ViewMore3Cell.className, bundle: nil), forCellWithReuseIdentifier: ViewMore3Cell.className)
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.sectionInset = UIEdgeInsets(top: 0, left: 10 * scaleW, bottom: 0, right: 0 * scaleW)
        collView.collectionViewLayout = layout
    }
}
extension Type7Cell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
//    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
//        if data.media.count < 9{
//            APIService.shared.getMoreVideoPlaylist(privateKey: data.privateKey, page: "0") { (data, error) in
//                if let data = data as? [MediaModel]{
//                    self.data.media += data
//                    self.collView.reloadData()
//                }
//            }
//        }
//    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 0:
            if data.media.count >= 8{
                return 8
            }
            return data.media.count
        default:
            return 1
        }
        
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        2
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch indexPath.section {
        case 0:
            return CGSize(width: 150 * scaleW, height: 240 * scaleW)
        default:
            return CGSize(width: 158 * scaleW, height: 240 * scaleW)
        }
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        switch indexPath.section {
        case 0:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Type7ItemCell.className, for: indexPath) as! Type7ItemCell
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
            return cell
        default:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ViewMore3Cell.className, for: indexPath) as! ViewMore3Cell
            let item = data.media[indexPath.row]
            if let url = URL(string: root.cdn.imageDomain + item.square.replacingOccurrences(of: "\\", with: "/" )){
                cell.imgThumb.loadImage(fromURL: url)
            }
            return cell
        }
        
        
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        row = indexPath.row
        switch indexPath.section {
        case 0:
            let item = data.media[indexPath.row]
            if item.episode != "" {
                delegate?.didSelectItemAt(self, item)
            } else{
                delegate?.didSelectNovel(self, item, data.media)
            }
            
            
        default:
            delegate?.didSelectViewMore(self)
        }
    }
}
protocol Type7CellDelegate: class {
    func didSelectItemAt(_ cell: Type7Cell,_ data: MediaModel)
    func didSelectNovel(_ cell: Type7Cell, _ data: MediaModel, _ list: [MediaModel])
    func didSelectViewMore(_ cell: Type7Cell)
}
