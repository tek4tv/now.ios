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
        collView.register(UINib(nibName: MovieItemCell.className, bundle: nil), forCellWithReuseIdentifier: MovieItemCell.className)
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 414 / 3.3 * scaleW, height: 240 * scaleW)
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.sectionInset = UIEdgeInsets(top: 0, left: 10 * scaleW, bottom: 0, right: 10 * scaleW)
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
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MovieItemCell.className, for: indexPath) as! MovieItemCell
        let item = data.media[indexPath.row]
        if let url = URL(string: root.cdn.imageDomain + item.portrait.replacingOccurrences(of: "\\", with: "/" )){
            cell.thumbImage.loadImage(fromURL: url)
        }
        cell.lblTitle.text = item.name
        cell.lblAuthor.text = item.author
        cell.lblTime.text =  item.country + " | " + item.minutes
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
