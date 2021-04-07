//
//  BookCategoryController.swift
//  NOW
//
//  Created by dovietduy on 2/26/21.
//

import UIKit

class MusicCategoryController: UIViewController {
    @IBOutlet weak var collView: UICollectionView!
    @IBOutlet weak var viewBack: UIView!
    var data : CategoryModel = CategoryModel()
    var page = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        collView.delegate = self
        collView.dataSource = self
        collView.register(UINib(nibName: Music3Cell.className, bundle: nil), forCellWithReuseIdentifier: Music3Cell.className)
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 414 * scaleW, height: 130 * scaleW)
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        collView.collectionViewLayout = layout
        
        // Do any additional setup after loading the view.
        viewBack.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didSelectViewBack(_:))))
    }
    @objc func didSelectViewBack(_ sender: Any){
        navigationController?.popViewController(animated: true)
    }
}
extension MusicCategoryController: UICollectionViewDelegate, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.media.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Music3Cell.className, for: indexPath) as! Music3Cell
        let item = data.media[indexPath.row]
        if let url = URL(string: root.cdn.imageDomain + item.thumnail.replacingOccurrences(of: "\\", with: "/" )){
            cell.imgThumb.loadImage(fromURL: url)
        }
        cell.lblTitle.text = item.name
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        sharedItem = data.media[indexPath.row]
//        sharedList = data.media
//        if sharedItem.path.contains("mp3"){
//            let vc = storyboard?.instantiateViewController(withIdentifier: BookPlayerController.className) as! BookPlayerController
//            navigationController?.pushViewController(vc, animated: true)
//        }else{
//            NotificationCenter.default.post(name: NSNotification.Name("openVideo"), object: nil)
//        }
        //
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
        //
        
        APIService.shared.getDetailVideo(privateKey: data.media[indexPath.row].privateID) {[self] (data, error) in
            if let data = data as? MediaModel{
//                sharedItem = data
//                sharedList = self.data.media
//                if sharedItem.path.contains("mp3"){
//                    let vc = storyboard?.instantiateViewController(withIdentifier: BookPlayerController.className) as! BookPlayerController
//                    navigationController?.pushViewController(vc, animated: true)
//                }else{
//                    NotificationCenter.default.post(name: NSNotification.Name("openVideo"), object: nil)
//                }
                let vc = storyboard?.instantiateViewController(withIdentifier: MusicPlayerController.className) as! MusicPlayerController
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
