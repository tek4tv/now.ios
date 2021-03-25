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
        collView.register(UINib(nibName: BookCell.className, bundle: nil), forCellWithReuseIdentifier: BookCell.className)
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 414 * scaleW, height: 320 * scaleW)
        layout.minimumLineSpacing = 0
        collView.collectionViewLayout = layout
        viewBack.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didSelectViewBack(_:))))
    }
    @objc func didSelectViewBack(_ sender: Any){
        navigationController?.popViewController(animated: true)
    }
}
extension BookController: UICollectionViewDelegate, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return news.components.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BookCell.className, for: indexPath) as! BookCell
        cell.delegate = self
        let item = news.components[indexPath.section]
        cell.lblTitle.text = item.name + " >"
        cell.data = item.category
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = storyboard?.instantiateViewController(withIdentifier: BookCategoryController.className) as! BookCategoryController
        vc.data = news.components[indexPath.section].category
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
extension BookController: BookCellDelegate{
    func didSelectItemAt() {
        let vc = storyboard?.instantiateViewController(withIdentifier: BookPlayerController.className) as! BookPlayerController
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
