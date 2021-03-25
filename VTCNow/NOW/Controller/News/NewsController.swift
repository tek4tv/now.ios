//
//  NewFeedController.swift
//  VTCNow
//
//  Created by dovietduy on 1/28/21.
//

import UIKit
import AVFoundation

class NewsController: UIViewController {
    @IBOutlet weak var collView: UICollectionView!
    var name = ""
    var category = CategoryModel()
    var isPlaying = false
    var isEnded = false
    var page = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Initialization code
        collView.delegate = self
        collView.dataSource = self
        collView.register(UINib(nibName: "VideoCell", bundle: nil), forCellWithReuseIdentifier: "VideoCell")
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 414 * scaleW, height: 330 * scaleW)
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        collView.collectionViewLayout = layout
        
        //
        sharedList = category.media
    }

}

extension NewsController: UICollectionViewDelegate, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return category.media.count
    }
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.row == category.media.count - 1{
            APIService.shared.getMoreVideoPlaylist(privateKey: category.privateKey, page: page.description) { [self] (data, error) in
                if let data = data as? [MediaModel]{
                    self.category.media += data
                    self.page += 1
                    self.collView.reloadData()
                }
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: VideoCell.className, for: indexPath) as! VideoCell
        cell.delegate = self
        
        let item = category.media[indexPath.row]
        cell.item = item
        cell.indexPath = indexPath
        cell.lblTitle.text = item.name
        cell.lblTime.text = item.timePass
        if let url = URL(string: root.cdn.imageDomain + item.thumnail.replacingOccurrences(of: "\\", with: "/" )){
            cell.thumbImage.loadImage(fromURL: url)
        }
        return cell
    }
    
}
extension NewsController: VideoCellDelegate{
    func didSelectVideo(_ cell: VideoCell) {
//        sharedItem = cell.item
//        NotificationCenter.default.post(name: NSNotification.Name("openVideo"), object: nil)
        APIService.shared.getDetailVideo(privateKey: cell.item.privateID) { (data, error) in
            if let data = data as? MediaModel{
                sharedItem = data
                NotificationCenter.default.post(name: NSNotification.Name("openVideo"), object: nil)
            }
        }
    }
    func didSelect3Dot(_ cell: VideoCell) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "PopUpController") as! PopUpController
        vc.data = cell.item
        vc.modalPresentationStyle = .overFullScreen
        present(vc, animated: true, completion: nil)
    }
}


import XLPagerTabStrip
extension NewsController: IndicatorInfoProvider{
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: name)
    }
}
