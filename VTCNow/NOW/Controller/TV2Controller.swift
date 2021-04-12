//
//  TV2Controller.swift
//  NOW
//
//  Created by dovietduy on 4/8/21.
//

import UIKit
import AVFoundation
class TV2Controller: UIViewController {

    @IBOutlet weak var collView: UICollectionView!
    @IBOutlet weak var viewBack: UIView!
    var indexPath = IndexPath(row: 0, section: 0)
    var data = ChannelModel()
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        collView.delegate = self
        collView.dataSource = self
        collView.register(UINib(nibName: Video2Cell.className, bundle: nil), forCellWithReuseIdentifier: Video2Cell.className)
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 394 * scaleW, height: 350 * scaleW)
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        collView.collectionViewLayout = layout
        
        viewBack.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didSelectBtnBack(_:))))
    }
    @objc func didSelectBtnBack(_ sender: Any){
        self.navigationController?.popViewController(animated: true)
    }
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}
extension TV2Controller: UICollectionViewDelegate, UICollectionViewDataSource, UIScrollViewDelegate{
    
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
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Video2Cell.className, for: indexPath) as! Video2Cell
        cell.item = data
        cell.delegate = self
        if indexPath == self.indexPath{
            if let url = URL(string: data.url[0].link){
                
                cell.viewPlayer.player  = AVPlayer(url: url)
                cell.viewPlayer.player?.play()
                cell.setup()
                
            }
            cell.imgThumb.isHidden = true
            cell.viewShadow.isHidden = true
        } else{
            cell.viewPlayer.player?.pause()
            cell.imgThumb.isHidden = false
            cell.viewShadow.isHidden = false
        }
        return cell
    }
    
}
extension TV2Controller: Video2CellDelegate{
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
