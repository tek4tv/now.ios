//
//  HighLight2Controller.swift
//  NOW
//
//  Created by dovietduy on 2/17/21.
//

import UIKit
import AVFoundation
class HighLight2Controller: UIViewController {
    @IBOutlet weak var collView: UICollectionView!
    @IBOutlet weak var viewBack: UIView!
    var timer = Timer()
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
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        collView.collectionViewLayout = layout
        
        viewBack.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didSelectBtnBack(_:))))
        if news.name == "Đừng bỏ lỡ"{
            timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true, block: {(timer) in
                NotificationCenter.default.post(name: NSNotification.Name.init("countDownTimer2"), object: nil)
            })
        }else{
            timer.invalidate()
        }
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if let cell = collView.cellForItem(at: indexPath) as? VideoCell{
            cell.viewPlayer.player?.pause()
        }
    }
    @objc func didSelectBtnBack(_ sender: Any){
        self.navigationController?.popViewController(animated: true)
    }
    deinit {
        NotificationCenter.default.removeObserver(self)
        timer.invalidate()
    }
}

extension HighLight2Controller: UICollectionViewDelegate, UICollectionViewDataSource, UIScrollViewDelegate{
    
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
        return news.media.count
    }
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.row == news.media.count - 1 {
            if news.name == "Đừng bỏ lỡ"{
                return
            }
            APIService.shared.getMoreVideoPlaylist(privateKey: news.privateKey, page: page.description) { (data, error) in
                if let data = data as? [MediaModel]{
                    news.media += data
                    self.page += 1
                    self.collView.reloadData()
                }
            }
        }
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: VideoCell.className, for: indexPath) as! VideoCell
        //cell.delegate = self
        
        let item = news.media[indexPath.row]
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
extension HighLight2Controller: VideoCellDelegate{
    func didSelectBookMark(_ cell: VideoCell) {
        
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
        let vc = PlayerViewController()
        vc.player = newPlayer
        vc.onDismiss = { () in
            cell.viewPlayer.player = vc.player
            vc.player = nil
            cell.viewPlayer.player?.play()
            cell.isPlaying = true
            cell.btnPlay.setBackgroundImage(#imageLiteral(resourceName: "icons8-pause-49"), for: .normal)
        }
        present(vc, animated: true) {
            vc.player?.play()
            vc.addObserver(self, forKeyPath: #keyPath(UIViewController.view.frame), options: [.old, .new], context: nil)
        }
    }
    
    func didSelectViewCast() {
        
    }
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
    }
}
