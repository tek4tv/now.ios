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
    var page = 0
    var indexPath = IndexPath(row: 0, section: 0)
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Initialization code
        collView.delegate = self
        collView.dataSource = self
        collView.register(UINib(nibName: "VideoCell", bundle: nil), forCellWithReuseIdentifier: "VideoCell")
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 414 * scaleW, height: 330 * scaleW)
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.minimumLineSpacing = 20 * scaleW
        layout.minimumInteritemSpacing = 0
        collView.collectionViewLayout = layout
        
        //
        //sharedList = category.media
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if let cell = collView.cellForItem(at: indexPath) as? VideoCell{
            cell.viewPlayer.player?.pause()
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let cell = collView.cellForItem(at: indexPath) as? VideoCell{
            cell.viewPlayer.player?.play()
        }
    }
}

extension NewsController: UICollectionViewDelegate, UICollectionViewDataSource, UIScrollViewDelegate{
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let count = collView.visibleCells.count
        if count == 2{
            let id0 = collView.indexPath(for: collView.visibleCells[0])!
            let id1 = collView.indexPath(for: collView.visibleCells[1])!
            if id0.row < id1.row {
                if self.indexPath != id0{
                    if let cell = collView.visibleCells[1] as? VideoCell {
                        cell.viewPlayer.player?.pause()
                    }
                    self.indexPath = id0
                    collView.reloadData()
                }
            }else{
                if self.indexPath != id1{
                    if let cell = collView.visibleCells[0] as? VideoCell {
                        cell.viewPlayer.player?.pause()
                    }
                    self.indexPath = id1
                    collView.reloadData()
                }
            }
        }
        if count == 3{
            var list: [IndexPath] = []
            for cell in collView.visibleCells {
                let id = collView.indexPath(for: cell)
                list.append(id!)
            }
            list = list.sorted(by: { $0.row > $1.row })
            if self.indexPath != list[1]{
                if let cell = collView.visibleCells[0] as? VideoCell {
                    cell.viewPlayer.player?.pause()
                }
                if let cell = collView.visibleCells[2] as? VideoCell {
                    cell.viewPlayer.player?.pause()
                }
                self.indexPath = list[1]
                collView.reloadData()
            }
        }
        
    }

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
        
        let item = category.media[indexPath.row]
        cell.item = item
        cell.indexPath = indexPath
        cell.lblTitle.text = item.name
        cell.lblTime.text = item.timePass
        cell.delegate = self
        if let url = URL(string: root.cdn.imageDomain + item.thumnail.replacingOccurrences(of: "\\", with: "/" )){
            cell.imgThumb.loadImage(fromURL: url)
        }
        if indexPath == self.indexPath{
            if let url = URL(string: item.path){
                
                cell.viewPlayer.player  = AVPlayer(url: url)
                cell.viewPlayer.player?.play()
                cell.setup()
                
            }
            cell.imgThumb.isHidden = true
        } else{
            cell.viewPlayer.player?.pause()
            cell.imgThumb.isHidden = false
        }
        return cell
    }
}

extension NewsController: VideoCellDelegate{
    func didSelectViewShare(_ cell: VideoCell) {
        guard let url = URL(string: "https://now.vtc.vn/viewvod/a/\(cell.item.privateID).html") else {
            return
        }
        let itemsToShare = [url]
        let ac = UIActivityViewController(activityItems: itemsToShare, applicationActivities: nil)
        ac.popoverPresentationController?.sourceView = self.view
        self.present(ac, animated: true)
    }
    
    func didSelectViewBookmark(_ cell: VideoCell) {
        
    }
    

    
    func didSelectViewSetting(_ cell: VideoCell) {
        let vc = storyboard?.instantiateViewController(withIdentifier: PopUp2Controller.className) as! PopUp2Controller
        vc.modalPresentationStyle = .custom
        vc.modalTransitionStyle = .crossDissolve
        vc.listResolution = cell.listResolution
        vc.speed = cell.speed
        vc.onComplete = { list in
            cell.listResolution = list
            cell.setBitRate()
        }
        vc.onTickedSpeed = { value in
            cell.speed = value
            cell.setSpeed()
        }
        present(vc, animated: true, completion: nil)
                
    }
    
    func didSelectViewFullScreen(_ cell: VideoCell, _ newPlayer: AVPlayer) {
        if #available(iOS 13.0, *) {
            let vc = storyboard?.instantiateViewController(withIdentifier: FullScreenController.className) as! FullScreenController
            vc.player = newPlayer
            vc.listResolution = cell.listResolution
            vc.onDismiss = { () in
                cell.viewPlayer.player = vc.viewPlayer.player
                vc.player = nil
                cell.viewPlayer.player?.play()
                cell.isPlaying = true
                cell.btnPlay.setBackgroundImage(#imageLiteral(resourceName: "PAUSE"), for: .normal)
            }
            vc.modalPresentationStyle = .fullScreen
            present(vc, animated: true, completion: nil)
        } else {
            let vc = PlayerViewController()
            vc.player = newPlayer
            vc.onDismiss = { () in
                cell.viewPlayer.player = vc.player
                vc.player = nil
                cell.viewPlayer.player?.play()
                cell.isPlaying = true
                cell.btnPlay.setBackgroundImage(#imageLiteral(resourceName: "PAUSE"), for: .normal)
            }
            present(vc, animated: true) {
                vc.player?.play()
                vc.addObserver(self, forKeyPath: #keyPath(UIViewController.view.frame), options: [.old, .new], context: nil)
            }
        }
    }
    
    func didSelectViewCast() {
        
    }
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
    }
}

import XLPagerTabStrip
extension NewsController: IndicatorInfoProvider{
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: name)
    }
}
