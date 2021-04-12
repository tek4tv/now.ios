//
//  TVController.swift
//  NOW
//
//  Created by dovietduy on 4/8/21.
//

import UIKit
import AVFoundation
import UPCarouselFlowLayout
class TVController: UIViewController {

    @IBOutlet weak var collView: UICollectionView!
    var indexPath = IndexPath(row: 0, section: 0)
    override func viewDidLoad() {
        super.viewDidLoad()
        collView.delegate = self
        collView.dataSource = self
        collView.register(UINib(nibName: TVCell.className, bundle: nil), forCellWithReuseIdentifier: TVCell.className)
        let layout = UPCarouselFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 300 * scaleW, height: 800 * scaleH)
        layout.spacingMode = .fixed(spacing: 10.0)
        layout.sideItemScale = 0.95
        layout.sideItemAlpha = 1.0
        collView.collectionViewLayout = layout
        //
        news = CategoryModel()
        //
        let tap = UITapGestureRecognizer(target: self, action: #selector(didTapTwoTime(_:)))
        tap.numberOfTapsRequired = 2
        collView.addGestureRecognizer(tap)
    }
    
    @objc func didTapTwoTime(_ sender: Any){
        let vc = storyboard?.instantiateViewController(withIdentifier: TV2Controller.className) as! TV2Controller
        vc.data = lives[indexPath.row]
        navigationController?.pushViewController(vc, animated: true)
        if let cell = collView.cellForItem(at: indexPath) as? TVCell{
            cell.stopLive()
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let cell = collView.cellForItem(at: indexPath) as? TVCell{
            cell.playLive()
        }
    }
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if let cell = collView.cellForItem(at: indexPath) as? TVCell{
            cell.stopLive()
        }
    }
}
extension TVController: UICollectionViewDelegate, UICollectionViewDataSource, UIScrollViewDelegate{
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let count = collView.visibleCells.count

        if count == 2{
            let id0 = collView.indexPath(for: collView.visibleCells[0])!
            let id1 = collView.indexPath(for: collView.visibleCells[1])!
            if id0.row < id1.row {
                if self.indexPath != id0{
                    if let cell = collView.visibleCells[1] as? TVCell {
                        cell.stopLive()
                    }
                    self.indexPath = id0
                    collView.reloadData()
                }
            }else{
                if self.indexPath != id1{
                    if let cell = collView.visibleCells[0] as? TVCell {
                        cell.stopLive()
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
            list = list.sorted(by: { $0.row < $1.row })
            
            if self.indexPath != list[1]{
                if let cell = collView.visibleCells[0] as? TVCell {
                    cell.stopLive()
                }
                if let cell = collView.visibleCells[2] as? TVCell {
                    cell.stopLive()
                }
                self.indexPath = list[1]
                collView.reloadData()
            }
        }
        
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        lives.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TVCell.className, for: indexPath) as! TVCell
        let item = lives[indexPath.row]
        cell.data = item
        cell.collView.reloadData()
        cell.delegate = self
        if let url = URL(string: root.cdn.imageDomain + item.image[0].url.replacingOccurrences(of: "\\", with: "/" )){
            cell.imgThumb.loadImage(fromURL: url)
        }
        if indexPath == self.indexPath {
            cell.playLive()
        } else{
            cell.stopLive()
        }
        return cell
    }
}
extension TVController: TVCellDelegate{
    func didSelectBookMark(_ cell: Video2Cell) {
        
    }
    
    func didSelectViewSetting(_ cell: Video2Cell) {
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
    
    func didSelectViewFullScreen(_ cell: Video2Cell, _ newPlayer: AVPlayer) {
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
