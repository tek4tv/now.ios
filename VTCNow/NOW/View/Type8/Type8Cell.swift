//
//  Type4Cell.swift
//  VTCNow
//
//  Created by dovietduy on 1/27/21.
//

import UIKit

class Type8Cell: UICollectionViewCell {
    static let reuseIdentifier = "Type8Cell"
    @IBOutlet weak var collView: UICollectionView!
    @IBOutlet weak var lblTitle: UILabel!
    
    var delegate: Type8CellDelegate!
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
        collView.register(UINib(nibName: "Type8ItemCell", bundle: nil), forCellWithReuseIdentifier: "Type8ItemCell")
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: (414 - 60) / 2.001 * scaleW, height: 180 * scaleW)
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.sectionInset = UIEdgeInsets(top: 0, left: 20 * scaleW, bottom: 0, right: 20 * scaleW)
        collView.collectionViewLayout = layout
    }

}
extension Type8Cell: UICollectionViewDelegate, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Type8ItemCell.reuseIdentifier, for: indexPath) as! Type8ItemCell
        let item = data.media[indexPath.row]
        if let url = URL(string: root.cdn.imageDomain + item.thumnail320_180.replacingOccurrences(of: "\\", with: "/" )){
            cell.thumbImage.loadImage(fromURL: url)
        }
        cell.lblTitle.text = item.name + item.episode
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
                self.delegate?.didSelectItemAt(data, list, self)
            }
        }
    }
}
protocol Type8CellDelegate: HighLightController{
    func didSelectItemAt(_ data: MediaModel, _ listData: [MediaModel], _ cell: Type8Cell)
}
