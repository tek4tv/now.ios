//
//  User2Controller.swift
//  NOW
//
//  Created by dovietduy on 4/23/21.
//

import UIKit
import AVFoundation
class User2Controller: UIViewController {

    @IBOutlet weak var collView: UICollectionView!
    @IBOutlet weak var viewBack: UIView!
    @IBOutlet weak var lblTitle: UILabel!
    var timer = Timer()
    var page = 0
    var indexPath = IndexPath(row: 1, section: 0)
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Initialization code
        collView.delegate = self
        collView.dataSource = self
        collView.register(UINib(nibName: VideoCell.className, bundle: nil), forCellWithReuseIdentifier: VideoCell.className)
        collView.register(UINib(nibName: NoCell.className, bundle: nil), forCellWithReuseIdentifier: NoCell.className)
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        collView.collectionViewLayout = layout
        
        viewBack.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didSelectBtnBack(_:))))
        //
        lblTitle.text = news.name
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if let cell = collView.cellForItem(at: indexPath) as? VideoCell{
            cell.viewPlayer.player?.pause()
        }
        NotificationCenter.default.post(name: NSNotification.Name("stopVOD"), object: nil)
    }
    @objc func didSelectBtnBack(_ sender: Any){
        self.navigationController?.popViewController(animated: false)
    }
    deinit {
        NotificationCenter.default.removeObserver(self)
        timer.invalidate()
    }
}

extension User2Controller: UICollectionViewDelegate, UICollectionViewDataSource, UIScrollViewDelegate, UICollectionViewDelegateFlowLayout{
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let count = collView.visibleCells.count
        if count == 2{
            let id0 = collView.indexPath(for: collView.visibleCells[0])!
            let id1 = collView.indexPath(for: collView.visibleCells[1])!
            if id0.row < id1.row {
                if self.indexPath != id0{
                    NotificationCenter.default.post(name: NSNotification.Name("stopVOD"), object: nil)
                    self.indexPath = id0
                    collView.reloadData()
                }
            }else{
                if self.indexPath != id1{
                    NotificationCenter.default.post(name: NSNotification.Name("stopVOD"), object: nil)
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
                NotificationCenter.default.post(name: NSNotification.Name("stopVOD"), object: nil)
                self.indexPath = list[1]
                collView.reloadData()
            }
        }
        if count == 4 {
            var list: [IndexPath] = []
            for cell in collView.visibleCells {
                let id = collView.indexPath(for: cell)
                list.append(id!)
            }
            list = list.sorted(by: { $0.row > $1.row })
            if self.indexPath != list[2]{
                NotificationCenter.default.post(name: NSNotification.Name("stopVOD"), object: nil)
                self.indexPath = list[2]
                collView.reloadData()
            }
        }
        
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch indexPath.row {
        case 0:
            return CGSize(width: 414 * scaleW, height: 1)
        case news.media.count + 1:
            return CGSize(width: 414 * scaleW, height: 320 * scaleW)
        default:
            return CGSize(width: 414 * scaleW, height: 320 * scaleW)
        }
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return news.media.count + 2
    }
//    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
//        if indexPath.row == news.media.count - 1 {
//            if news.name == "Đừng bỏ lỡ"{
//                return
//            }
//            APIService.shared.getMoreVideoPlaylist(privateKey: news.privateKey, page: page.description) { (data, error) in
//                if let data = data as? [MediaModel]{
//                    news.media += data
//                    self.page += 1
//                    self.collView.reloadData()
//                }
//            }
//        }
//    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.row {
        case 0:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NoCell.className, for: indexPath) as! NoCell
            return cell
        case news.media.count + 1:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NoCell.className, for: indexPath) as! NoCell
            return cell
        default:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: VideoCell.className, for: indexPath) as! VideoCell
            //cell.delegate = self
            
            let item = news.media[indexPath.row - 1]
            cell.item = item
            cell.indexPath = indexPath
            cell.lblTitle.text = item.name + item.episode

            
            cell.delegate = self
            if let url = URL(string: root.cdn.imageDomain + item.thumnail.replacingOccurrences(of: "\\", with: "/" )){
                cell.imgThumb.loadImage(fromURL: url)
            }
            if indexPath == self.indexPath{
                var link = ""
                if item.fileCode != "" {
                    link = item.fileCode
                }else{
                    link = item.path
                }
                if let url = URL(string: link){
                    
                    cell.viewPlayer.player = AVPlayer(url: url)
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
    
}
extension User2Controller: VideoCellDelegate{
    func didSelectViewShare(_ cell: VideoCell) {
        guard let url = URL(string: cell.item.path) else {
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
            vc.videoGravity = .resizeAspect
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
