//
//  BookCategoryController.swift
//  NOW
//
//  Created by dovietduy on 2/26/21.
//

import UIKit

class MovieCategoryController: UIViewController {
    @IBOutlet weak var collView: UICollectionView!
    @IBOutlet weak var viewBack: UIView!
    var data = CategoryModel()
    var page = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        collView.delegate = self
        collView.dataSource = self
        collView.register(UINib(nibName: MovieItem2Cell.className, bundle: nil), forCellWithReuseIdentifier: MovieItem2Cell.className)
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 374 / 3.01 * scaleW, height: 280 * scaleW)
        layout.minimumLineSpacing = 10 * scaleW
        layout.minimumInteritemSpacing = 10 * scaleW
        layout.sectionInset = UIEdgeInsets(top: 10 * scaleW, left: 10 * scaleW, bottom: 0, right: 10 * scaleW)
        collView.collectionViewLayout = layout
        
        // Do any additional setup after loading the view.
        viewBack.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didSelectViewBack(_:))))
    }
    @objc func didSelectViewBack(_ sender: Any){
        navigationController?.popViewController(animated: true)
    }
}
extension MovieCategoryController: UICollectionViewDelegate, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.media.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MovieItem2Cell.className, for: indexPath) as! MovieItem2Cell
        let item = data.media[indexPath.row]
        if let url = URL(string: root.cdn.imageDomain + item.portrait.replacingOccurrences(of: "\\", with: "/" )){
            cell.imgThumb.loadImage(fromURL: url)
        }
        cell.lblTitle.text = item.name
        cell.lblCountry.text = item.country
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
        APIService.shared.getDetailVideo(privateKey: data.media[indexPath.row].privateID) {[self] (data, error) in
            if let data = data as? MediaModel{
                let vc = storyboard?.instantiateViewController(withIdentifier: VideoController.className) as! VideoController
                vc.item = data
                vc.listData = list
                navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.row == data.media.count - 1{
            APIService.shared.getMoreVideoPlaylist(privateKey: data.privateKey, page: page.description) { (data, error) in
                if let data = data as? [MediaModel]{
                    self.data.media += data
                    self.page += 1
                    self.collView.reloadData()
                }
            }
        }
    }
}
