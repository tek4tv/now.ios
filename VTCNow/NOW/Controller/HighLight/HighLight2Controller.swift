//
//  HighLight2Controller.swift
//  NOW
//
//  Created by dovietduy on 2/17/21.
//

import UIKit
import AVFoundation
class HighLight2Controller: UIViewController {
//    @IBOutlet weak var collView: UICollectionView!
    @IBOutlet weak var tblView: UITableView!
    @IBOutlet weak var viewBack: UIView!
    @IBOutlet weak var txfView: UITextField!
    @IBOutlet weak var lblNotFound: UILabel!

    var listSearch: [MediaModel] = []
    var timer = Timer()
    var page = 1
    var indexPath = IndexPath(row: 1, section: 0)
    var isLoadMore = true
    var isSearching = false
    var isPushByHashTag = false
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Initialization code
        tblView.delegate = self
        tblView.dataSource = self
        tblView.register(UINib(nibName: CellVideo.className, bundle: nil), forCellReuseIdentifier: CellVideo.className)
        tblView.register(UINib(nibName: CellNo.className, bundle: nil), forCellReuseIdentifier: CellNo.className)
        tblView.estimatedRowHeight = 370 * scaleW
        tblView.rowHeight = UITableView.automaticDimension
        txfView.addTarget(self, action: #selector(textFieldDidChange(_:)),
                          for: .editingChanged)
        txfView.delegate = self
        viewBack.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didSelectBtnBack(_:))))

        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true, block: { (timer) in
            NotificationCenter.default.post(name: NSNotification.Name.init("countDownTimer2"), object: nil)
        })
        
        //
        if isPushByHashTag{
            txfView.isHidden = true
        }
        if news.media.count == 0 {
            lblNotFound.isHidden = false
        }
        listSearch = news.media
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.post(name: NSNotification.Name("stopVOD"), object: nil)
        if let cell = cellForRow(indexPath){
            cell.viewPlayer.player?.pause()
            cell.viewPlayer.player?.replaceCurrentItem(with: nil)
        }
        NotificationCenter.default.removeObserver(self)
        timer.invalidate()
    }
    func cellForRow(_ indexPath: IndexPath) -> CellVideo? {
        guard let cell = tblView.cellForRow(at: indexPath) as? CellVideo else{
            return tblView.dequeueReusableCell(withIdentifier: CellVideo.className, for: indexPath) as? CellVideo
        }
        return cell
    }
    @objc func didSelectBtnBack(_ sender: Any){
        self.navigationController?.popViewController(animated: false)
        isMessaging = false
    }
    deinit {
        NotificationCenter.default.removeObserver(self)
        timer.invalidate()
    }
    @objc func textFieldDidChange(_ textField: UITextField) {
        
        if textField.text == "" {
            
            self.listSearch = news.media
            isSearching = false
        } else {
            self.listSearch = []
            isSearching = true
            APIService.shared.searchByTag(privateKey: news.privateKey, keySearch: textField.text!) {[weak self] (data, error) in
                if let data = data as? [MediaModel]{
                    self?.listSearch = data
                    self?.tblView.reloadData()
                    self?.tblView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: false)
                }
            }
            
        }
        
    }
}
extension HighLight2Controller: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool{
        txfView.endEditing(true)
        return true
    }
}

extension HighLight2Controller: CellVideoDelegate{
    func didSelectViewCast() {
        
    }
    
    func didSelectViewSetting(_ cell: CellVideo) {
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
    
    func didSelectViewFullScreen(_ cell: CellVideo, _ newPlayer: AVPlayer) {
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
    
    func didSelectViewShare(_ cell: CellVideo) {
        guard let url = URL(string: "https://now.vtc.vn/viewvod/a/\(cell.item.privateID).html") else {
            return
        }
        let itemsToShare = [url]
        let ac = UIActivityViewController(activityItems: itemsToShare, applicationActivities: nil)
        ac.popoverPresentationController?.sourceView = self.view
        self.present(ac, animated: true)
    }
    
    func didSelectViewBookmark(_ cell: CellVideo) {
        
    }
    
    func didFinish() {
        if self.indexPath.row < news.media.count - 1 {
            tblView.scrollToRow(at: IndexPath(row: self.indexPath.row + 1, section: 0), at: .top, animated: true)
        }
        
    }
    
    func scrollToTop(_ cell: CellVideo) {
        tblView.scrollToRow(at: cell.indexPath, at: .top, animated: true)
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
    }
    
}
extension HighLight2Controller: UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listSearch.count + 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: CellNo.className, for: indexPath) as! CellNo
            return cell
        case listSearch.count + 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: CellNo.className, for: indexPath) as! CellNo
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: CellVideo.className, for: indexPath) as! CellVideo
            
            let item = listSearch[indexPath.row - 1]
            cell.item = item
            cell.indexPath = indexPath
            cell.lblTitle.text = item.name
            cell.lblDescription.text = item.descripTion
            if news.name == "Đừng bỏ lỡ"{
                cell.lblTime.text = ""
            } else if item.episode != ""{
                cell.lblTime.text = "Tập " + item.episode + "/" + item.totalEpisode
            } else{
                cell.lblTime.text = item.timePass
            }
            
            cell.delegate = self
            if let url = URL(string: root.cdn.imageDomain + item.thumnail.replacingOccurrences(of: "\\", with: "/" )){
                cell.imgThumb.loadImage(fromURL: url)
            }
            if indexPath == self.indexPath{
                var link = ""
                if item.path != "" {
                    link = item.path
                    if Array(link)[link.count - 1] == "/" {
                        link = item.fileCode
                    }
                }else{
                    link = item.fileCode
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
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row {
        case 0:
            return 0
        case listSearch.count + 1:
            return 370 * scaleW
        default:
            return UITableView.automaticDimension
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == news.media.count - 1 && isLoadMore == true{
            if news.name == "Đừng bỏ lỡ"{
                return
            }
            APIService.shared.getMoreVideoPlaylist(privateKey: news.privateKey, page: page.description) {[weak self] (data, error) in
                if let data = data as? [MediaModel]{
                    news.media += data
                    if self?.isSearching == true {
                        self?.listSearch = news.media
                    }
                    self?.page += 1
                    self?.tblView.reloadData()
                }
            }
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let count = tblView.visibleCells.count
        if count == 2{
            let id0 = tblView.indexPath(for: tblView.visibleCells[0])!
            let id1 = tblView.indexPath(for: tblView.visibleCells[1])!
            if id0.row < id1.row {
                if self.indexPath != id0{
                    NotificationCenter.default.post(name: NSNotification.Name("stopVOD"), object: nil)
                    self.indexPath = id0
                    tblView.reloadData()
                }
            }else{
                if self.indexPath != id1{
                    NotificationCenter.default.post(name: NSNotification.Name("stopVOD"), object: nil)
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
                NotificationCenter.default.post(name: NSNotification.Name("stopVOD"), object: nil)
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
                NotificationCenter.default.post(name: NSNotification.Name("stopVOD"), object: nil)
                self.indexPath = list[2]
                tblView.reloadData()
            }
        }
        
    }
}

//extension HighLight2Controller: UICollectionViewDelegate, UICollectionViewDataSource, UIScrollViewDelegate, UICollectionViewDelegateFlowLayout{
//
//    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        let count = collView.visibleCells.count
//        if count == 2{
//            let id0 = collView.indexPath(for: collView.visibleCells[0])!
//            let id1 = collView.indexPath(for: collView.visibleCells[1])!
//            if id0.row < id1.row {
//                if self.indexPath != id0{
//                    NotificationCenter.default.post(name: NSNotification.Name("stopVOD"), object: nil)
//                    self.indexPath = id0
//                    collView.reloadData()
//                }
//            }else{
//                if self.indexPath != id1{
//                    NotificationCenter.default.post(name: NSNotification.Name("stopVOD"), object: nil)
//                    self.indexPath = id1
//                    collView.reloadData()
//                }
//            }
//        }
//        if count == 3{
//            var list: [IndexPath] = []
//            for cell in collView.visibleCells {
//                let id = collView.indexPath(for: cell)
//                list.append(id!)
//            }
//            list = list.sorted(by: { $0.row > $1.row })
//            if self.indexPath != list[1]{
//                NotificationCenter.default.post(name: NSNotification.Name("stopVOD"), object: nil)
//                self.indexPath = list[1]
//                collView.reloadData()
//            }
//        }
//        if count == 4 {
//            var list: [IndexPath] = []
//            for cell in collView.visibleCells {
//                let id = collView.indexPath(for: cell)
//                list.append(id!)
//            }
//            list = list.sorted(by: { $0.row > $1.row })
//            if self.indexPath != list[2]{
//                NotificationCenter.default.post(name: NSNotification.Name("stopVOD"), object: nil)
//                self.indexPath = list[2]
//                collView.reloadData()
//            }
//        }
//
//    }
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        switch indexPath.row {
//        case 0:
//            return CGSize(width: 414 * scaleW, height: 1)
//        case listSearch.count + 1:
//            return CGSize(width: 414 * scaleW, height: 350 * scaleW)
//        default:
//            return CGSize(width: 414 * scaleW, height: 350 * scaleW)
//        }
//    }
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return listSearch.count + 2
//    }
//    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
//
//        if indexPath.row == news.media.count - 1 && isLoadMore == true{
//            if news.name == "Đừng bỏ lỡ"{
//                return
//            }
//            APIService.shared.getMoreVideoPlaylist(privateKey: news.privateKey, page: page.description) {[weak self] (data, error) in
//                if let data = data as? [MediaModel]{
//                    news.media += data
//                    self?.page += 1
//                    self?.collView.reloadData()
//                }
//            }
//        }
//    }
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        switch indexPath.row {
//        case 0:
//            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NoCell.className, for: indexPath) as! NoCell
//            return cell
//        case listSearch.count + 1:
//            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NoCell.className, for: indexPath) as! NoCell
//            return cell
//        default:
//            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: VideoCell.className, for: indexPath) as! VideoCell
//            //cell.delegate = self
//
//            let item = listSearch[indexPath.row - 1]
//            cell.item = item
//            cell.indexPath = indexPath
//            cell.lblTitle.text = item.name
//            if news.name == "Đừng bỏ lỡ"{
//                cell.lblTime.text = ""
//            } else if item.episode != ""{
//                cell.lblTime.text = "Tập " + item.episode + "/" + item.totalEpisode
//            } else{
//                cell.lblTime.text = item.timePass
//            }
//
//            cell.delegate = self
//            if let url = URL(string: root.cdn.imageDomain + item.thumnail.replacingOccurrences(of: "\\", with: "/" )){
//                cell.imgThumb.loadImage(fromURL: url)
//            }
//            if indexPath == self.indexPath{
//                var link = ""
//                if item.path != "" {
//                    link = item.path
//                    if Array(link)[link.count - 1] == "/" {
//                        link = item.fileCode
//                    }
//                }else{
//                    link = item.fileCode
//                }
//                if let url = URL(string: link){
//
//                    cell.viewPlayer.player = AVPlayer(url: url)
////                    cell.viewPlayer.player?.automaticallyWaitsToMinimizeStalling = false
////                    cell.viewPlayer.player?.playImmediately(atRate: 1.0)
//                    cell.viewPlayer.player?.play()
//                    cell.setup()
//                }
//                cell.imgThumb.isHidden = true
//            } else{
//                cell.viewPlayer.player?.pause()
//                cell.imgThumb.isHidden = false
//            }
//            return cell
//        }
//
//    }
//
//}
