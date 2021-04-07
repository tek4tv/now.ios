//
//  ListenController.swift
//  NOW
//
//  Created by dovietduy on 3/1/21.
//

import UIKit
import AVFoundation
var count = 0

class ListenController: UIViewController {

    @IBOutlet weak var collView: UICollectionView!
    @IBOutlet weak var viewBack: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        collView.delegate = self
        collView.dataSource = self
        collView.register(UINib(nibName: Type7Cell.className, bundle: nil), forCellWithReuseIdentifier: Type7Cell.className)
        collView.register(UINib(nibName: Book3Cell.className, bundle: nil), forCellWithReuseIdentifier: Book3Cell.className)
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 414 * scaleW, height: 250 * scaleW)
        collView.collectionViewLayout = layout
        for item in bookCate.components{
            APIService.shared.getPlaylist(privateKey: item.privateKey) {[weak self] (data, error) in
                if let data = data as? CategoryModel{
                    item.category = data
                    count += 1
                    if count == bookCate.components.count {
                        news = bookCate
                        self?.collView.reloadData()
                    }
                }
            }
        }
    }
    @objc func didSelectViewBack(_ sender: Any){
        navigationController?.popViewController(animated: true)
    }
}
extension ListenController: UICollectionViewDelegate, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return news.components.count + 1
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.section {
        case 0:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Book3Cell.className, for: indexPath) as! Book3Cell
            cell.delegate = self
            cell.data = bookCate
            return cell
        default:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Type7Cell.className, for: indexPath) as! Type7Cell
            cell.delegate = self
            let item = news.components[indexPath.section - 1]
            cell.lblTitle.text = item.name + " >"
            cell.data = item.category
            return cell
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            let vc = storyboard?.instantiateViewController(withIdentifier: BookCategoryController.className) as! BookCategoryController
            vc.data = news
            self.navigationController?.pushViewController(vc, animated: true)
        default:
            let vc = storyboard?.instantiateViewController(withIdentifier: BookCategoryController.className) as! BookCategoryController
            vc.data = news.components[indexPath.section - 1].category
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
    }
}
extension ListenController: Type7CellDelegate, Book3CellDelegate{
    func didSelectItemAt(_ cell: Book3Cell) {
        let vc = storyboard?.instantiateViewController(withIdentifier: BookPlayerController.className) as! BookPlayerController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func didSelectItemAt(_ cell: Type7Cell) {
        let vc = storyboard?.instantiateViewController(withIdentifier: BookPlayerController.className) as! BookPlayerController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    func didSelectViewMore(_ cell: Type7Cell){
        let vc = storyboard?.instantiateViewController(withIdentifier: BookCategoryController.className) as! BookCategoryController
        vc.data = cell.data
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

