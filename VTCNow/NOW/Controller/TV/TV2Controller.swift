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
    var indexPath = IndexPath(row: 1, section: 0)
    var data = ChannelModel()
    var listVideos: [MediaModel] = []
    var datePicker: Date = Date()
    var isPickDate = false
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        collView.delegate = self
        collView.dataSource = self
        collView.register(UINib(nibName: Video2Cell.className, bundle: nil), forCellWithReuseIdentifier: Video2Cell.className)
        collView.register(UINib(nibName: Video3Cell.className, bundle: nil), forCellWithReuseIdentifier: Video3Cell.className)
        collView.register(UINib(nibName: Video4Cell.className, bundle: nil), forCellWithReuseIdentifier: Video4Cell.className)
        collView.register(UINib(nibName: NoCell.className, bundle: nil), forCellWithReuseIdentifier: NoCell.className)
        let layout = UICollectionViewFlowLayout()
        //layout.itemSize = CGSize(width: (414 - 40) * scaleW, height: 340 * scaleW)
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        collView.collectionViewLayout = layout
        
        viewBack.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didSelectBtnBack(_:))))
        //
        APIService.shared.getPlaylist(privateKey: ids[data.name] ?? "") {[self] (data, error) in
            if let data = data as? CategoryModel {
                listVideos = data.media
                collView.reloadData()
            }
        }
    }
    @objc func didSelectBtnBack(_ sender: Any){
        self.navigationController?.popViewController(animated: false)
    }
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.post(name: NSNotification.Name("stopLive"), object: nil)
    }
}
extension TV2Controller: UICollectionViewDelegate, UICollectionViewDataSource, UIScrollViewDelegate, UICollectionViewDelegateFlowLayout{
    
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
        }
        if count == 3{
            var list: [IndexPath] = []
            for cell in collView.visibleCells {
                let id = collView.indexPath(for: cell)
                list.append(id!)
            }
            list = list.sorted(by: { $0.row > $1.row })
            if self.indexPath != list[1]{
                NotificationCenter.default.post(name: NSNotification.Name("stopLive"), object: nil)
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
                NotificationCenter.default.post(name: NSNotification.Name("stopLive"), object: nil)
                self.indexPath = list[2]
                collView.reloadData()
            }
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch indexPath.row {
        case 0:
            return CGSize(width: collView.bounds.width * scaleW, height: 0)
        case listVideos.count + 2:
            return CGSize(width: 414 * scaleW, height: 350 * scaleW)
        default:
            return CGSize(width: 414 * scaleW, height: 350 * scaleW)
        }
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1 + listVideos.count + 2
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Video2Cell.className, for: indexPath) as! Video2Cell
        cell.delegate = self
        switch indexPath.row {
        case 0:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NoCell.className, for: indexPath) as! NoCell
            return cell
        case 1:
            if data.name == "VTC1" || data.name == "VTC14"{
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Video3Cell.className, for: indexPath) as! Video3Cell
                cell.delegate = self
                cell.item = data
                cell.lblTitle.text = ""
                if indexPath == self.indexPath{
                    var link = ""
                    if cell.item is ChannelModel {
                        link = data.url[0].link
                    } else {
                        link = listVideos[indexPath.row - 2].path
                    }
                    if let url = URL(string: link){
                        
                        cell.viewPlayer.player  = AVPlayer(url: url)
                        cell.setup()
                        cell.viewPlayer.player?.play()

                    }
                    cell.imgThumb.isHidden = true
                } else{
                    cell.viewPlayer.player?.pause()
                    cell.imgThumb.isHidden = false
                }
                return cell
            } else{
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Video4Cell.className, for: indexPath) as! Video4Cell
                cell.delegate = self
                cell.item = data
                cell.lblTitle.text = ""
                if indexPath == self.indexPath{
                    var link = ""
                    if cell.item is ChannelModel {
                        link = data.url[0].link
                    } else {
                        link = listVideos[indexPath.row - 2].path
                    }
                    if let url = URL(string: link){
                        
                        cell.viewPlayer.player  = AVPlayer(url: url)
                        cell.setup()
                        cell.viewPlayer.player?.play()

                    }
                    cell.imgThumb.isHidden = true
                } else{
                    cell.viewPlayer.player?.pause()
                    cell.imgThumb.isHidden = false
                }
                return cell
            }
            
        case listVideos.count + 2:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NoCell.className, for: indexPath) as! NoCell
            return cell
        default:
            let item = listVideos[indexPath.row - 2]
            cell.item = item
            cell.lblTitle.text = item.name
            cell.lblTime.text = item.getTimePass()
            if let url = URL(string: root.cdn.imageDomain + item.thumnail.replacingOccurrences(of: "\\", with: "/" )){
                cell.imgThumb.loadImage(fromURL: url)
            }
        }
        if indexPath == self.indexPath{
            var link = ""
            if cell.item is ChannelModel {
                link = data.url[0].link
            } else {
                link = listVideos[indexPath.row - 2].path
            }
            if let url = URL(string: link){
                
                cell.viewPlayer.player  = AVPlayer(url: url)
                cell.setup()
                cell.viewPlayer.player?.play()

            }
            cell.imgThumb.isHidden = true
        } else{
            cell.viewPlayer.player?.pause()
            cell.imgThumb.isHidden = false
        }
        return cell
    }
}
extension TV2Controller: Video2CellDelegate{
    func scrollToTop(_ cell: Video2Cell) {
        collView.scrollToItem(at: cell.indexPath, at: .top, animated: true)
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
extension TV2Controller: Video3CellDelegate{
    func didSelectBookMark(_ cell: Video3Cell) {
        //self.delegate?.didSelectBookMark(cell)
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
            APIService.shared.getVideoByDate(privateId: ids[(self?.data.name)!] ?? "", date: date.getTimeString()) {[weak self] (data, error) in
                if let data = data as? [MediaModel]{
                    self?.listVideos = data
                    self?.collView.reloadData()
                }
            }
        }
    }
    
    
}
extension TV2Controller: Video4CellDelegate{
    func didSelectBookMark(_ cell: Video4Cell) {
        
    }
    
    
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

    
    
}
