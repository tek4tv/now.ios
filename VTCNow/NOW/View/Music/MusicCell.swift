//
//  PhimCell.swift
//  VTCNow
//
//  Created by dovietduy on 1/27/21.
//

import UIKit
class MusicCell: UICollectionViewCell {

    @IBOutlet weak var collView: UICollectionView!
    @IBOutlet weak var lblTitle: UILabel!
    var delegate: MusicCellDelegate!
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
        collView.register(UINib(nibName: MusicItemCell.className, bundle: nil), forCellWithReuseIdentifier: MusicItemCell.className)
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 170 * scaleW, height: 220 * scaleW)
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        layout.sectionInset = UIEdgeInsets(top: 0, left: 2 * scaleW, bottom: 0, right: 0)
        collView.collectionViewLayout = layout
    }
    override func prepareForReuse() {
        lblTitle.text = ""
    }
}
extension MusicCell: UICollectionViewDelegate, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.media.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MusicItemCell.className, for: indexPath) as! MusicItemCell
        let item = data.media[indexPath.row]
        if let url = URL(string: root.cdn.imageDomain + item.image[0].url.replacingOccurrences(of: "\\", with: "/" )){
            print()
            cell.thumbImage.loadImage(fromURL: url)
        }
        cell.lblAuthor.text = item.cast
        print("Cast" + item.cast)
        cell.lblTitle.text = item.name
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let count = data.media.count
        
        var list: [MediaModel] = []
        if count == 1{
            list = []
        } else if count == 2{
            if indexPath.row == 0 {
                list.append(data.media[1])
            } else{
                list.append(data.media[0])
            }
        } else if count >= 3 {
            if indexPath.row == 0{
                list = Array(data.media[1...count-1])
            } else if indexPath.row == count-1 {
                list = Array(data.media[0...count - 2])
            } else{
                list = Array(data.media[indexPath.row+1...count-1] + data.media[0...indexPath.row-1])
            }
        }
        APIService.shared.getDetailVideo(privateKey: data.media[indexPath.row].privateID) { (data, error) in
            if let data = data as? MediaModel{
                self.delegate?.didSelectItemAt(data, list)
            }
        }
    }
}

protocol MusicCellDelegate{
    func didSelectItemAt(_ data: MediaModel, _ list: [MediaModel])
    
}
