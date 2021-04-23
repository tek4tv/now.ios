//
//  ReadController.swift
//  NOW
//
//  Created by dovietduy on 3/2/21.
//

import UIKit

class ReadController: UIViewController {
    @IBOutlet weak var collView: UICollectionView!
    var page = 1
    override func viewDidLoad() {
        super.viewDidLoad()
        collView.delegate = self
        collView.dataSource = self
        collView.register(UINib(nibName: ReadCell.className, bundle: nil), forCellWithReuseIdentifier: ReadCell.className)
        // Do any additional setup after loading the view.
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 414 * scaleW, height: 414 * scaleW)
        collView.collectionViewLayout = layout
    }
    
}
extension ReadController: UICollectionViewDelegate, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        reads.count
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        if indexPath.row == reads.count - 5{
            page += 1
            APIService.shared.getRead (page: page.description) { (data, error) in
                if let data = data as? [ReadModel]{
                    reads += data
                    self.collView.reloadData()
                }
            }
        }
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ReadCell.className, for: indexPath) as! ReadCell
        let item = reads[indexPath.row]
        cell.delegate = self
        cell.lblTitle.text = item.title
        cell.lblDescription.text = item.description
        cell.lblTime.text = "· " + item.getTimePass()
        if let url = URL(string: item.image344_220){
            cell.imgThumb.loadImage(fromURL: url)
        }
        cell.item = item
        return cell
        
    }
    @objc func didSelectBtnSearch(_ sender: Any){
        let vc = storyboard?.instantiateViewController(withIdentifier: SearchController.className) as! SearchController
        self.navigationController?.pushViewController(vc, animated: false)
    }
}
extension ReadController: UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let vc = storyboard?.instantiateViewController(withIdentifier: ReadDetailWebviewController.className) as! ReadDetailWebviewController
        vc.url = reads[indexPath.row].detailUrl
        navigationController?.pushViewController(vc, animated: false)
        
    }
}
extension ReadController: ReadCellDelegate{
    func didSelectViewShare(_ cell: ReadCell) {
        guard let url = URL(string: cell.item.detailUrl) else {
            return
        }
        let itemsToShare = [url]
        let ac = UIActivityViewController(activityItems: itemsToShare, applicationActivities: nil)
        ac.popoverPresentationController?.sourceView = self.view
        self.present(ac, animated: false)
    }
    
    
}
