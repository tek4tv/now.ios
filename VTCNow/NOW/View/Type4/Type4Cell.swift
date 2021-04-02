//
//  Type4Cell.swift
//  VTCNow
//
//  Created by dovietduy on 1/27/21.
//

import UIKit

class Type4Cell: UICollectionViewCell {

    @IBOutlet weak var collView: UICollectionView!
    @IBOutlet weak var lblTitle: UILabel!
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
        collView.register(UINib(nibName: "Type4ItemCell", bundle: nil), forCellWithReuseIdentifier: "Type4ItemCell")
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 190 * scaleW, height: 170 * scaleW)
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.sectionInset = UIEdgeInsets(top: 0, left: 10 * scaleW, bottom: 0, right: 10 * scaleW)
        collView.collectionViewLayout = layout
    }

}
extension Type4Cell: UICollectionViewDelegate, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Type4ItemCell.className, for: indexPath) as! Type4ItemCell
        let item = data.media[indexPath.row]
        if let url = URL(string: root.cdn.imageDomain + item.thumnail.replacingOccurrences(of: "\\", with: "/" )){
            cell.thumbImage.loadImage(fromURL: url)
        }
        cell.lblTitle.text = item.name + item.episode
        if item.path.contains(".mp3"){
            cell.imgOverlay.isHidden = true
        }
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        sharedItem = data.media[indexPath.row]
//        sharedList = data.media
//        NotificationCenter.default.post(name: NSNotification.Name("openVideo"), object: nil)
        APIService.shared.getDetailVideo(privateKey: data.media[indexPath.row].privateID) { (data, error) in
            if let data = data as? MediaModel{
                sharedItem = data
                sharedList = self.data.media
                NotificationCenter.default.post(name: NSNotification.Name("openVideo"), object: nil)
            }
        }
    }
}
