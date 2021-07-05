//
//  PopUp3Controller.swift
//  NOW
//
//  Created by dovietduy on 2/22/21.
//

import UIKit


class PopUp3Controller: UIViewController {
    var indexTick = 0
    @IBOutlet weak var collView: UICollectionView!
    @IBOutlet weak var heightCollView: NSLayoutConstraint!
    @IBOutlet weak var viewBack: UIView!
    @IBOutlet weak var viewCancel: UIView!
    var onComplete: (([StreamResolution]) -> Void)!
    var listResolution: [StreamResolution] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        collView.delegate = self
        collView.dataSource = self
        collView.register(UINib(nibName: PopUpItemCell.reuseIdentifier, bundle: nil), forCellWithReuseIdentifier: PopUpItemCell.reuseIdentifier)
        // Do any additional setup after loading the view.
        let layout = UICollectionViewFlowLayout()
        
        layout.itemSize = CGSize(width: collView.bounds.width, height: 60 * scaleH)
        layout.minimumLineSpacing = 0
        collView.collectionViewLayout = layout
        
        heightCollView.constant = CGFloat(listResolution.count * 60) * scaleH
        
        viewBack.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didSelectViewBack(_:))))
        viewCancel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didSelectViewBack(_:))))
    }
    @objc func didSelectViewBack(_ sender: Any){
        dismiss(animated: true, completion: nil)
        onComplete?(listResolution)
    }
    func setListResolution(_ list: [StreamResolution]){
        self.listResolution = list
    }
    
}
extension PopUp3Controller: UICollectionViewDelegate, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return listResolution.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PopUpItemCell.reuseIdentifier, for: indexPath) as! PopUpItemCell
        let item = listResolution[indexPath.row]
        cell.lblTitle.text = Int(item.resolution.height).description + "p"
        if indexPath.row == 0{
            cell.lblTitle.text = "Tự động " + Int(item.resolution.height).description + "p"
        }
        if item.isTicked {
            cell.imgTick.image = #imageLiteral(resourceName: "icons8-tick-box-52")
        } else{
            cell.imgTick.image = nil
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        for temp in listResolution{
            temp.isTicked = false
        }
        let item = listResolution[indexPath.row]
        item.isTicked = true
        collView.reloadData()
    }
}
