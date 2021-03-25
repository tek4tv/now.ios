//
//  PopUp7Controller.swift
//  NOW
//
//  Created by dovietduy on 3/10/21.
//

import UIKit

class PopUp7Controller: UIViewController {

    @IBOutlet weak var collView: UICollectionView!
    @IBOutlet weak var viewBack: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        collView.delegate = self
        collView.dataSource = self
        collView.register(UINib(nibName: DailyCell.className, bundle: nil), forCellWithReuseIdentifier: DailyCell.className)
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: (369 * scaleW) / 6.0, height: 100 * scaleH)
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 5 * scaleW
        layout.sectionInset = UIEdgeInsets(top: 0, left: 10 * scaleW, bottom: 0, right: 10 * scaleW)
        collView.collectionViewLayout = layout
        viewBack.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didSelectViewBack(_:))))
    }
    @objc func didSelectViewBack(_ sender: Any){
        dismiss(animated: true, completion: nil)
    }
}
extension PopUp7Controller: UICollectionViewDelegate, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 6
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DailyCell.className, for: indexPath) as! DailyCell
        return cell
    }
    
    
}
