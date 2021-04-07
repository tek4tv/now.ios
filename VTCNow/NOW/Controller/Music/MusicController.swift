//
//  MovieController.swift
//  NOW
//
//  Created by dovietduy on 3/4/21.
//

import UIKit

class MusicController: UIViewController {
    @IBOutlet weak var collView: UICollectionView!
    @IBOutlet weak var viewBack: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        collView.delegate = self
        collView.dataSource = self
        collView.register(UINib(nibName: MusicCell.className, bundle: nil), forCellWithReuseIdentifier: MusicCell.className)
        collView.register(UINib(nibName: Music2Cell.className, bundle: nil), forCellWithReuseIdentifier: Music2Cell.className)
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        collView.collectionViewLayout = layout
        viewBack.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didSelectViewBack(_:))))
    }
    @objc func didSelectViewBack(_ sender: Any){
        navigationController?.popViewController(animated: true)
    }
}
extension MusicController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return news.components.count
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch indexPath.section {
        case 0:
            return CGSize(width: 414 * scaleW, height: 280 * scaleW)
        default:
            return CGSize(width: 414 * scaleW, height: 300 * scaleW)
        }
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.section {
        case 0:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Music2Cell.className, for: indexPath) as! Music2Cell
            cell.delegate = self
            let item = news.components[indexPath.section]
            cell.lblTitle.text = item.name
            cell.data = item.category
            return cell
        default:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MusicCell.className, for: indexPath) as! MusicCell
            cell.delegate = self
            let item = news.components[indexPath.section]
            cell.lblTitle.text = item.name
            cell.data = item.category
            return cell
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = storyboard?.instantiateViewController(withIdentifier: MusicCategoryController.className) as! MusicCategoryController
        vc.data = news.components[indexPath.section].category
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}
extension MusicController: MusicCellDelegate{
    func didSelectItemAt(_ data: MediaModel, _ list: [MediaModel]) {
        let vc = storyboard?.instantiateViewController(withIdentifier: MusicPlayerController.className) as! MusicPlayerController
        vc.item = data
        vc.listData = list
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension MusicController: Music2CellDelegate{
    func didSelect2ItemAt(_ data: MediaModel, _ list: [MediaModel]) {
        let vc = storyboard?.instantiateViewController(withIdentifier: MusicPlayerController.className) as! MusicPlayerController
        vc.item = data
        vc.listData = list
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
}
