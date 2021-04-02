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
        collView.register(UINib(nibName: Type7ItemCell.className, bundle: nil), forCellWithReuseIdentifier: Type7ItemCell.className)
        collView.register(UINib(nibName: ViewMore3Cell.className, bundle: nil), forCellWithReuseIdentifier: ViewMore3Cell.className)
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 10 * scaleW
        layout.sectionInset = UIEdgeInsets(top: 0, left: 10 * scaleW, bottom: 0, right: 10 * scaleW)
        collView.collectionViewLayout = layout
    }
}
extension Type7Cell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if data.media.count >= 9{
            return 9
        }
        return data.media.count
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch indexPath.row {
        case 0...7:
            return CGSize(width: 110 * scaleW, height: 190 * scaleW)
        default:
            return CGSize(width: 118 * scaleW, height: 190 * scaleW)
        }
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let item = data.media[indexPath.row]
        switch indexPath.row {
        case 0...7:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Type7ItemCell.className, for: indexPath) as! Type7ItemCell
            
            if let url = URL(string: root.cdn.imageDomain + item.square.replacingOccurrences(of: "\\", with: "/" )){
                cell.imgThumb.loadImage(fromURL: url)
            }
            cell.lblTitle.text = item.name
            
            cell.lblAuthor.text = item.author
            return cell
        default:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ViewMore3Cell.className, for: indexPath) as! ViewMore3Cell
            
            if let url = URL(string: root.cdn.imageDomain + item.square.replacingOccurrences(of: "\\", with: "/" )){
                cell.imgThumb.loadImage(fromURL: url)
            }
            return cell
        }
        
        
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if data.name == "Sách hay"{
            APIService.shared.getDetailVideo(privateKey: data.media[indexPath.row].privateID) { (data, error) in
                if let data = data as? MediaModel{
                    sharedItem = data
                    sharedList = self.data.media
                    idBookPlaying = indexPath.row
                    NotificationCenter.default.post(name: NSNotification.Name("openBookPlayer"), object: nil)
                }
            }
        }else{
            APIService.shared.getDetailVideo(privateKey: data.media[indexPath.row].privateID) { (data, error) in
                if let data = data as? MediaModel{
                    sharedItem = data
                    sharedList = self.data.media
                    NotificationCenter.default.post(name: NSNotification.Name("openVideo"), object: nil)
                }
            }
        }
        
    }
}
