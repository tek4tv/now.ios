//
//  LiveController.swift
//  NOW
//
//  Created by Apple on 20/07/2021.
//

import UIKit
import AVFoundation
var channels: [ComponentModel] = []
var players: [AVPlayer] = []
class LiveController: UIViewController {
    fileprivate var countToStart = 0
    @IBOutlet weak var icon: LazyImageView!
    @IBOutlet weak var tblView: UITableView!
    
    var indexPath = IndexPath(row: 1, section: 0)
    let activityIndicatorView1: UIActivityIndicatorView = {
        let aiv = UIActivityIndicatorView(style: .whiteLarge)
        aiv.translatesAutoresizingMaskIntoConstraints = false
        aiv.color = #colorLiteral(red: 0.5225926042, green: 0.0004706631007, blue: 0.2674992383, alpha: 1)
        aiv.startAnimating()
        return aiv
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        tblView.delegate = self
        tblView.dataSource = self
        tblView.register(UINib(nibName: CellLive.reuseIdentifier, bundle: nil), forCellReuseIdentifier: CellLive.reuseIdentifier)
        tblView.register(UINib(nibName: CellNo.reuseIdentifier, bundle: nil), forCellReuseIdentifier: CellNo.reuseIdentifier)
        tblView.estimatedRowHeight = 330 * scaleW
        tblView.rowHeight = UITableView.automaticDimension
        tblView.isHidden = true
        view.addSubview(activityIndicatorView1)
        activityIndicatorView1.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        activityIndicatorView1.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        APIService.shared.getLive { (data, error) in
            if let data = data as? CategoryModel{
                channels = data.components
//                for item in channels{
//                    if let url = URL(string: item.domain.replacingOccurrences(of: "\\", with: "/")){
//                        let playerItem = AVPlayerItem(url: url)
//                        playerItem.preferredForwardBufferDuration = TimeInterval(2.0)
//                        playerItem.preferredPeakBitRate = 1
//                        let player = AVPlayer(playerItem: playerItem)
//                        //player.currentItem?.preferredPeakBitRate = 0
//                        //player.currentItem?.preferredForwardBufferDuration = TimeInterval(2.0)
//                        player.automaticallyWaitsToMinimizeStalling = true
//                        player.currentItem?.addObserver(self, forKeyPath: #keyPath(AVPlayerItem.status), options: .new, context: nil)
//                        players.append(player)
//                    }
//                }

                    if let url = URL(string: channels[0].domain.replacingOccurrences(of: "\\", with: "/")){
                        let playerItem = AVPlayerItem(url: url)
                        playerItem.preferredForwardBufferDuration = TimeInterval(2.0)
                        playerItem.preferredPeakBitRate = 1
                        let player = AVPlayer(playerItem: playerItem)
                        //player.currentItem?.preferredPeakBitRate = 0
                        //player.currentItem?.preferredForwardBufferDuration = TimeInterval(2.0)
                        player.automaticallyWaitsToMinimizeStalling = true
                        player.currentItem?.addObserver(self, forKeyPath: #keyPath(AVPlayerItem.status), options: .new, context: nil)
                        players.append(player)
                    }
                
                self.activityIndicatorView1.stopAnimating()
                self.tblView.reloadData()
                self.tblView.isHidden = false
            }
        }
    }
    func cellForRow(_ indexPath: IndexPath) -> CellLive? {
        guard let cell = tblView.cellForRow(at: indexPath) as? CellLive else{
            return tblView.dequeueReusableCell(withIdentifier: CellLive.reuseIdentifier, for: indexPath) as? CellLive
        }
        return cell
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        NotificationCenter.default.post(name: NSNotification.Name("live.video.stop"), object: nil)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tblView.reloadData()
    }
    var player : AVPlayer? = nil
}
extension LiveController: UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return channels.count + 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: CellNo.reuseIdentifier, for: indexPath) as! CellNo
            return cell
        case channels.count + 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: CellNo.reuseIdentifier, for: indexPath) as! CellNo
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: CellLive.reuseIdentifier, for: indexPath) as! CellLive
            if indexPath.row - 1 < channels.count {
                let item = channels[indexPath.row - 1]
                cell.item = item
                cell.indexPath = indexPath
                cell.lblTitle.text = item.descripTion
                cell.delegate = self
                
                if indexPath == self.indexPath{
                    if let url = URL(string: item.icon.replacingOccurrences(of: "\\", with: "/")){
                        self.icon.loadImage(fromURL: url)
                    }
                    if indexPath.row == 1 {
                        cell.setup(players[0])
                    }
//                    cell.setup(players[indexPath.row - 1])
                    //let link = item.domain
                    
                    
                    //avplayeritem = players[indexPath.row - 1]
                    //cell.viewPlayer.player?.replaceCurrentItem(with: nil)
//                    cell.viewPlayer.player = player
                    
//                    cell.viewPlayer.player?.rate = 1.0
//                    cell.viewPlayer.player?.currentItem?.preferredPeakBitRate = 0
//                    cell.viewPlayer.player?.currentItem?.preferredForwardBufferDuration = 0
//                    cell.viewPlayer.player?.automaticallyWaitsToMinimizeStalling = true
//                    let itemA = players[indexPath.row - 1].currentItem
//                    player = nil
//                    player = AVPlayer()
//                    player?.replaceCurrentItem(with: itemA)
                    
                    
//                    cell.viewPlayer.player?.playImmediately(atRate: 1.0)
//                    print(cell.viewPlayer.player?.timeControlStatus.rawValue)
                    
//                    if let url = URL(string: link.replacingOccurrences(of: "\\", with: "/")){
//                        print(url)
//                        //cell.viewPlayer.player = AVPlayer(url: url)
////                        if cell.isOn {
//                            
//                            
////                            cell.viewPlayer.player?.play()
//    //                        cell.imgThumb.isHidden = true
////                        } else {
////
////                            cell.imgThumb.isHidden = false
////                        }
//                        
//                    }
    //                cell.imgThumb.isHidden = true
                } else{
                    cell.activityIndicatorView.stopAnimating()
//                    cell.viewPlayer.player?.pause()
                    cell.imgThumb.isHidden = false
                }
                if let url = URL(string: root.cdn.imageDomain + item.logo.replacingOccurrences(of: "\\", with: "/" )){
                    cell.imgThumb.loadImage(fromURL: url)
                }
                
            }
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row {
        case 0:
            return 0
        case channels.count + 1:
            return 100 * scaleW
        default:
            return UITableView.automaticDimension
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let count = tblView.visibleCells.count
        if count == 2{
            let id0 = tblView.indexPath(for: tblView.visibleCells[0])!
            let id1 = tblView.indexPath(for: tblView.visibleCells[1])!
            if id0.row < id1.row {
                if self.indexPath != id0{
                    NotificationCenter.default.post(name: NSNotification.Name("live.video.stop"), object: nil)
                    self.indexPath = id0
                    tblView.reloadData()
                }
            }else{
                if self.indexPath != id1{
                    NotificationCenter.default.post(name: NSNotification.Name("live.video.stop"), object: nil)
                    self.indexPath = id1
                    tblView.reloadData()
                }
            }
        }
        if count == 3{
            var list: [IndexPath] = []
            for cell in tblView.visibleCells {
                let id = tblView.indexPath(for: cell)
                list.append(id!)
            }
            list = list.sorted(by: { $0.row > $1.row })
            if self.indexPath != list[1]{
                NotificationCenter.default.post(name: NSNotification.Name("live.video.stop"), object: nil)
                self.indexPath = list[1]
                tblView.reloadData()
            }
        }
        if count == 4 {
            var list: [IndexPath] = []
            for cell in tblView.visibleCells {
                let id = tblView.indexPath(for: cell)
                list.append(id!)
            }
            list = list.sorted(by: { $0.row > $1.row })
            if self.indexPath != list[2]{
                NotificationCenter.default.post(name: NSNotification.Name("live.video.stop"), object: nil)
                self.indexPath = list[2]
                tblView.reloadData()
            }
        }
        
    }
}
extension LiveController: CellLiveDelegate{
    func didSelectViewSetting(_ cell: CellLive) {
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
    
    func didSelectViewFullScreen(_ cell: CellLive, _ newPlayer: AVPlayer) {
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
    
    func didSelectViewShare(_ cell: CellLive) {
        
    }
    
    func didSelectViewBookmark(_ cell: CellLive) {
        
    }
    
    func didFinish() {
        
    }
    
    func scrollToTop(_ cell: CellLive) {
        tblView.scrollToRow(at: cell.indexPath, at: .top, animated: true)
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == #keyPath(AVPlayerItem.status){
            var status: AVPlayerItem.Status = .unknown
            if let statusNumber = change?[.newKey] as? NSNumber, let newStatus = AVPlayerItem.Status(rawValue: statusNumber.intValue){
                status = newStatus
            }
            switch status {
            case .readyToPlay:
                print("Ready")
            case .failed:
                print("Failed")
            default:
                break
            }
        }
    }
}

