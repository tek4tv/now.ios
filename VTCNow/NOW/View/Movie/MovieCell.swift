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
            lblTitle.text = data.name
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
        layout.itemSize = CGSize(width: 110 * scaleW, height: 230 * scaleW)
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 20 * scaleW
        layout.minimumInteritemSpacing = 0
        layout.sectionInset = UIEdgeInsets(top: 0, left: 20 * scaleW, bottom: 0, right: 20 * scaleW)
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

protocol MovieCellDelegate: class{
    func didSelectItemAt(_ data: MediaModel,_ list: [MediaModel])
}
