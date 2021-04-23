//
//  MovieController.swift
//  NOW
//
//  Created by dovietduy on 3/4/21.
//

import UIKit

class MovieController: UIViewController {
    @IBOutlet weak var collView: UICollectionView!
    @IBOutlet weak var viewBack: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        collView.delegate = self
        collView.dataSource = self
        collView.register(UINib(nibName: MovieCell.className, bundle: nil), forCellWithReuseIdentifier: MovieCell.className)
        collView.register(UINib(nibName: Movie2Cell.className, bundle: nil), forCellWithReuseIdentifier: Movie2Cell.className)
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        collView.collectionViewLayout = layout
        viewBack.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didSelectViewBack(_:))))
    }
    @objc func didSelectViewBack(_ sender: Any){
        navigationController?.popViewController(animated: false)
    }
}
extension MovieController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return news.components.count + 1
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch indexPath.section {
        case 0:
            return CGSize(width: 414 * scaleW, height: 230 * scaleW)
        default:
            return CGSize(width: 414 * scaleW, height: 290 * scaleW)
        }
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.section {
        case 0:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Movie2Cell.className, for: indexPath) as! Movie2Cell
            cell.delegate = self
            cell.data = news
            return cell
        default:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MovieCell.className, for: indexPath) as! MovieCell
            cell.delegate = self
            let item = news.components[indexPath.section - 1]
            cell.lblTitle.text = item.name
            cell.data = item.category
            return cell
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = storyboard?.instantiateViewController(withIdentifier: MovieCategoryController.className) as! MovieCategoryController
        vc.data = news.components[indexPath.section - 1].category
        self.navigationController?.pushViewController(vc, animated: false)
    }
    
}
extension MovieController: MovieCellDelegate{
    func didSelectItemAt(_ data: MediaModel, _ list: [MediaModel]) {
        let vc = storyboard?.instantiateViewController(withIdentifier: VideoController.className) as! VideoController
        vc.item = data
        vc.listData = list
        navigationController?.pushViewController(vc, animated: false)
    }
    
}
extension MovieController: Movie2CellDelegate{
    func didSelectItemAt(_ data: MediaModel, _ list: [MediaModel], _ cell: Movie2Cell) {
        let vc = storyboard?.instantiateViewController(withIdentifier: VideoController.className) as! VideoController
        vc.item = data
        vc.listData = list
        navigationController?.pushViewController(vc, animated: false)
    }
    
    
}
