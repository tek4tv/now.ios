//
//  BookController.swift
//  NOW
//
//  Created by dovietduy on 2/26/21.
//

import UIKit

class BookController: UIViewController {
    @IBOutlet weak var collView: UICollectionView!
    @IBOutlet weak var viewBack: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        collView.delegate = self
        collView.dataSource = self
        collView.register(UINib(nibName: Type7Cell.className, bundle: nil), forCellWithReuseIdentifier: Type7Cell.className)
        collView.register(UINib(nibName: Book3Cell.className, bundle: nil), forCellWithReuseIdentifier: Book3Cell.className)
        let layout = UICollectionViewFlowLayout()
        //layout.itemSize = CGSize(width: 414 * scaleW, height: 270 * scaleW)
        collView.collectionViewLayout = layout
        viewBack.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didSelectViewBack(_:))))
    }
    @objc func didSelectViewBack(_ sender: Any){
        navigationController?.popViewController(animated: false)
    }
}
extension BookController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch indexPath.section {
        case 0:
            return CGSize(width: 414 * scaleW, height: (167 + 70) * scaleW)
        default:
            return CGSize(width: 414 * scaleW, height: 270 * scaleW)
        }
    }
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
            cell.data = news
            return cell
        default:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Type7Cell.className, for: indexPath) as! Type7Cell
            cell.delegate = self
            let item = news.components[indexPath.section - 1]
            cell.lblTitle.text = item.name
            cell.data = item.category
            return cell
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            let vc = storyboard?.instantiateViewController(withIdentifier: BookCategoryController.className) as! BookCategoryController
            vc.data = news
            self.navigationController?.pushViewController(vc, animated: false)
        default:
            let vc = storyboard?.instantiateViewController(withIdentifier: BookCategoryController.className) as! BookCategoryController
            vc.data = news.components[indexPath.section - 1].category
            self.navigationController?.pushViewController(vc, animated: false)
        }
        
    }
}
extension BookController: Type7CellDelegate, Book3CellDelegate{
    func didSelectItemAt(_ cell: Book3Cell, _ data: MediaModel) {
        
    }
    
    func didSelectItemAt(_ cell: Type7Cell, _ data: MediaModel) {
        let vc = storyboard?.instantiateViewController(withIdentifier: BookPlayerController.className) as! BookPlayerController
        vc.data = data
        self.navigationController?.pushViewController(vc, animated: false)
    }
    
    func didSelectItemAt(_ cell: Book3Cell) {
        let vc = storyboard?.instantiateViewController(withIdentifier: BookPlayerController.className) as! BookPlayerController
        self.navigationController?.pushViewController(vc, animated: false)
    }
    
    func didSelectViewMore(_ cell: Type7Cell){
        let vc = storyboard?.instantiateViewController(withIdentifier: BookCategoryController.className) as! BookCategoryController
        vc.data = cell.data
        self.navigationController?.pushViewController(vc, animated: false)
    }
}
