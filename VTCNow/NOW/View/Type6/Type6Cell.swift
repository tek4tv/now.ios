//
//  PhimCell.swift
//  VTCNow
//
//  Created by dovietduy on 1/27/21.
//

import UIKit
class Type6Cell: UICollectionViewCell {

    @IBOutlet weak var collView: UICollectionView!
    @IBOutlet weak var lblTitle: UILabel!
    var delegate: Type6CellDelegate!
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
        collView.register(UINib(nibName: Type6ItemCell.className, bundle: nil), forCellWithReuseIdentifier: Type6ItemCell.className)
        collView.register(UINib(nibName: ViewMore2Cell.className, bundle: nil), forCellWithReuseIdentifier: ViewMore2Cell.className)
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 10 * scaleW
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 10 * scaleW, right: 10 * scaleW)
        collView.collectionViewLayout = layout
    }
}
extension Type6Cell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if data.media.count >= 9{
            return 9
        }
        return data.media.count
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch indexPath.row {
        case 0...7:
            return CGSize(width: 120 * scaleW, height: 260 * scaleW)
        default:
            return CGSize(width: 128 * scaleW, height: 260 * scaleW)
        }
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let item = data.media[indexPath.row]
        switch indexPath.row {
        case 0...7:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Type6ItemCell.className, for: indexPath) as! Type6ItemCell
            
            if let url = URL(string: root.cdn.imageDomain + item.portrait.replacingOccurrences(of: "\\", with: "/" )){
                cell.thumbImage.loadImage(fromURL: url)
            }
            cell.lblTitle.text = item.name
            
            cell.lblCountry.text = item.country
            return cell
        default:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ViewMore2Cell.className, for: indexPath) as! ViewMore2Cell
            
            if let url = URL(string: root.cdn.imageDomain + item.portrait.replacingOccurrences(of: "\\", with: "/" )){
                cell.imgThumb.loadImage(fromURL: url)
            }
            return cell
        }
        
        
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0...7:
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
        default:
            self.delegate.didSelectViewMore(self)
        }
        
    }
}
protocol Type6CellDelegate{
    func didSelectItemAt(_ data: MediaModel, _ list: [MediaModel] , _ cell: Type6Cell)
    func didSelectViewMore(_ cell: Type6Cell)
}
