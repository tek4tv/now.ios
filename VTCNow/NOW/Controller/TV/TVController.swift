//
//  TVController.swift
//  NOW
//
//  Created by dovietduy on 4/8/21.
//

import UIKit
import AVFoundation
import UPCarouselFlowLayout
extension TVController{
    override var preferredStatusBarStyle: UIStatusBarStyle {
        if #available(iOS 13.0, *) {
            return .darkContent
        } else {
            // Fallback on earlier versions
            return .default
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
class TVController: UIViewController {

    @IBOutlet weak var collView: UICollectionView!
    var indexPath = IndexPath(row: 0, section: 0)
    var datePicker: Date = Date()
    var images: [String: UIImage] = [
        "VTC1": UIImage(named: "VTC 1")!,
        "VTC2": UIImage(named: "VTC 2")!,
        "VTC3": UIImage(named: "VTC 3")!,
        "VTC4": UIImage(named: "VTC 4")!,
        "VTC5": UIImage(named: "VTC 5")!,
        "VTC6": UIImage(named: "VTC 6")!,
        "VTC7": UIImage(named: "VTC 7")!,
        "VTC8": UIImage(named: "VTC 8")!,
        "VTC9": UIImage(named: "VTC 9")!,
        "VTC10": UIImage(named: "VTC 10")!,
        "VTC11": UIImage(named: "VTC 11")!,
        "VTC12": UIImage(named: "VTC 12")!,
        "VTC13": UIImage(named: "VTC 13")!,
        "VTC14": UIImage(named: "VTC 14")!,
        "VTC16": UIImage(named: "VTC 16")!,
    ]
    var isPickDate = false
    override func viewDidLoad() {
        super.viewDidLoad()
        collView.delegate = self
        collView.dataSource = self
        collView.register(UINib(nibName: TVCell.reuseIdentifier, bundle: nil), forCellWithReuseIdentifier: TVCell.reuseIdentifier)
        collView.register(UINib(nibName: NoCell.reuseIdentifier, bundle: nil), forCellWithReuseIdentifier: NoCell.reuseIdentifier)
        let layout = UPCarouselFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 330 * scaleW, height: 800 * scaleH)
        layout.spacingMode = .fixed(spacing: 20.0)
        layout.sideItemScale = 0.8
        layout.sideItemAlpha = 1.0
        collView.collectionViewLayout = layout
        //
        news = CategoryModel()
        //
        let tap = UITapGestureRecognizer(target: self, action: #selector(didTapTwoTime(_:)))
        tap.numberOfTapsRequired = 2
        tap.delaysTouchesBegan = true
        collView.addGestureRecognizer(tap)
    }
    
    @objc func didTapTwoTime(_ sender: Any){
        NotificationCenter.default.post(name: NSNotification.Name("TVController.cell.pauseVideo"), object: nil)
        let vc = storyboard?.instantiateViewController(withIdentifier: TV2Controller.className) as! TV2Controller
        vc.data = lives[indexPath.row]
        navigationController?.pushViewController(vc, animated: false)
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

                    NotificationCenter.default.post(name: NSNotification.Name("stopLive"), object: nil)
                    self.indexPath = id0
                    collView.reloadData()
                }
            }else{
                if self.indexPath != id1{
                    NotificationCenter.default.post(name: NSNotification.Name("stopLive"), object: nil)
                    self.indexPath = id1
                    collView.reloadData()
                }
            }
            if id0.row == lives.count || id1.row == lives.count {
                collView.scrollToItem(at: IndexPath(row: 0, section: 0), at: .centeredHorizontally, animated: true)
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
//                if let cell = collView.visibleCells[0] as? TVCell {
//                    cell.stopLive()
//                }
//                if let cell = collView.visibleCells[2] as? TVCell {
//                    cell.stopLive()
//                }
                NotificationCenter.default.post(name: NSNotification.Name("stopLive"), object: nil)
                self.indexPath = list[1]
                collView.reloadData()
            }
        }
        
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        lives.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.row {
        case lives.count:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NoCell.reuseIdentifier, for: indexPath) as! NoCell
            return cell
        default:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TVCell.reuseIdentifier, for: indexPath) as! TVCell
            let item = lives[indexPath.row]
            cell.data = item
            cell.collView.reloadData()
            cell.delegate = self
//            if let url = URL(string: root.cdn.imageDomain + item.image[0].url.replacingOccurrences(of: "\\", with: "/" )){
//                cell.imgThumb.loadImage(fromURL: url)
//            }
            cell.imgThumb.image = images[item.name]
            if indexPath == self.indexPath {
                cell.playLive()
                if isPickDate == true{
                    cell.loadVideoByDate(date: datePicker)
                    isPickDate = false
                } else{
                    cell.setup()
                }
            } else{
                cell.stopLive()
            }
            return cell
        }
        
    }
}
extension TVController: TVCellDelegate{
    func didSelectViewSetting(_ cell: Video4Cell) {
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
    
    func didSelectViewFullScreen(_ cell: Video4Cell, _ newPlayer: AVPlayer) {
        if #available(iOS 13.0, *) {
            let vc = storyboard?.instantiateViewController(withIdentifier: FullScreenController.className) as! FullScreenController
            vc.player = newPlayer
            vc.item1 = cell.item
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
    
    func didSelectViewSetting(_ cell: Video3Cell) {
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
    
    func didSelectViewFullScreen(_ cell: Video3Cell, _ newPlayer: AVPlayer) {
        if #available(iOS 13.0, *) {
            let vc = storyboard?.instantiateViewController(withIdentifier: FullScreenController.className) as! FullScreenController
            vc.player = newPlayer
            vc.item1 = cell.item
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
    

    func didSelectDatePicker() {
        let vc = storyboard?.instantiateViewController(withIdentifier: DatePickerController.className) as! DatePickerController
        vc.modalPresentationStyle = .overFullScreen
        present(vc, animated: false, completion: nil)
        vc.onComplete = {[weak self] (date) in
//            print(date)
            self?.isPickDate = true
            self?.datePicker = date
            self?.collView.reloadData()
        }
    }
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
        if #available(iOS 13.0, *) {
            let vc = storyboard?.instantiateViewController(withIdentifier: FullScreenController.className) as! FullScreenController
            vc.player = newPlayer
            vc.item = cell.item
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
