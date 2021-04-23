//
//  BookCategoryController.swift
//  NOW
//
//  Created by dovietduy on 2/26/21.
//

import UIKit

class BookCategoryController: UIViewController {
    @IBOutlet weak var collView: UICollectionView!
    @IBOutlet weak var viewBack: UIView!
    var data = CategoryModel()
    var page = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        collView.delegate = self
        collView.dataSource = self
        collView.register(UINib(nibName: BookItemCell.className, bundle: nil), forCellWithReuseIdentifier: BookItemCell.className)
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: (414 - 80) / 3.01 * scaleW, height: 260 * scaleW)
        layout.minimumLineSpacing = 20 * scaleW
        layout.minimumInteritemSpacing = 0
        layout.sectionInset = UIEdgeInsets(top: 10 * scaleW, left: 20 * scaleW, bottom: 0, right: 20 * scaleW)
        collView.collectionViewLayout = layout
        
        // Do any additional setup after loading the view.
        viewBack.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didSelectViewBack(_:))))
    }
    @objc func didSelectViewBack(_ sender: Any){
        navigationController?.popViewController(animated: false)
    }
}
extension BookCategoryController: UICollectionViewDelegate, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.media.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BookItemCell.className, for: indexPath) as! BookItemCell
        let item = data.media[indexPath.row]
        if let url = URL(string: root.cdn.imageDomain + item.portrait.replacingOccurrences(of: "\\", with: "/" )){
            cell.thumbImage.loadImage(fromURL: url)
        }
        cell.lblTitle.text = item.name
        if item.episode != "" {
            cell.viewEpisode.isHidden = false
            cell.lblEpisode.text = item.episode
            cell.lblTotalEpisode.text = item.totalEpisode
        }
        cell.lblAuthor.text = item.author
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = storyboard?.instantiateViewController(withIdentifier: BookPlayerController.className) as! BookPlayerController
        vc.data = data.media[indexPath.row]
        self.navigationController?.pushViewController(vc, animated: false)
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
