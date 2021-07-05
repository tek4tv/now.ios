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
    @IBOutlet weak var tblView: UITableView!
    @IBOutlet weak var viewBack: UIView!
    @IBOutlet weak var viewEdit: UIView!
    @IBOutlet weak var lblTitle: UILabel!
    var timer = Timer()
    var page = 1
    var indexPath = IndexPath(row: 1, section: 0)
    var onComplete: (() -> ())!
    var onDelete: (() -> ())!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Initialization code
        tblView.delegate = self
        tblView.dataSource = self
        tblView.register(UINib(nibName: CellVideo.reuseIdentifier, bundle: nil), forCellReuseIdentifier: CellVideo.reuseIdentifier)
        tblView.register(UINib(nibName: CellNo.reuseIdentifier, bundle: nil), forCellReuseIdentifier: CellNo.reuseIdentifier)
        tblView.estimatedRowHeight = 370 * scaleW
        tblView.rowHeight = UITableView.automaticDimension
        
        viewBack.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didSelectBtnBack(_:))))
        viewEdit.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didSelectViewEdit(_:))))
        //
        lblTitle.text = news.name
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if let cell = cellForRow(indexPath){
            cell.viewPlayer.player?.pause()
            cell.viewPlayer.player?.replaceCurrentItem(with: nil)
        }
        NotificationCenter.default.post(name: NSNotification.Name("stopVOD"), object: nil)
    }
    func cellForRow(_ indexPath: IndexPath) -> CellVideo? {
        guard let cell = tblView.cellForRow(at: indexPath) as? CellVideo else{
            return tblView.dequeueReusableCell(withIdentifier: CellVideo.reuseIdentifier, for: indexPath) as? CellVideo
        }
        return cell
    }
    @objc func didSelectBtnBack(_ sender: Any){
        self.navigationController?.popViewController(animated: false)
        onComplete?()
    }
    @objc func didSelectViewEdit(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(withIdentifier: PickUpController.className) as! PickUpController
        vc.idList = news.index
        let listSplit = news.name.split(separator: ",")
        var listString: [String] = []
        for text in listSplit {
            listString.append(String(text.trimmingCharacters(in: .whitespacesAndNewlines)))
        }
        vc.list5 = listString
        vc.isEditor = true
        navigationController?.pushViewController(vc, animated: false)
        vc.onComplete = {[self] (index) in
            let list = UserDefaults.standard.stringArray(forKey: "\(index)")!
            let cate = CategoryModel()
            if list.isEmpty {
                
            } else {
                cate.index = index
                var listName = ""
                for (index, text) in list.enumerated() {
                    if index == list.count - 1 {
                        listName += text
                    } else{
                        listName += text + ", "
                    }
                    APIService.shared.searchAll(keySearch: text) {[self] (data, error) in
                        if let data = data as? [MediaModel]{
                            cate.media += data
                            if index == list.count - 1 {
                                cate.name = listName
                                lblTitle.text = listName
                                news = cate
                                collView.reloadData()
                            }
                        }
                    }
                }
            }
        }
        vc.onDelete = {[self] in
            onDelete?()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: {
                navigationController?.popViewController(animated: false)
            }) 
        }
    }
    deinit {
        NotificationCenter.default.removeObserver(self)
        timer.invalidate()
    }
}
extension User2Controller: UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return news.media.count + 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: CellNo.reuseIdentifier, for: indexPath) as! CellNo
            return cell
        case news.media.count + 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: CellNo.reuseIdentifier, for: indexPath) as! CellNo
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: CellVideo.reuseIdentifier, for: indexPath) as! CellVideo
            
            let item = news.media[indexPath.row - 1]
            if news.name == "Đừng bỏ lỡ"{
                cell.lblTime.text = ""
            } else if item.episode != ""{
                cell.lblTime.text = "Tập " + item.episode + "/" + item.totalEpisode
            } else{
                cell.lblTime.text = item.timePass
            }
            cell.isOn = true
            cell.item = item
            cell.indexPath = indexPath
            cell.lblTitle.text = item.name
            cell.lblDescription.text = item.descripTion
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
                    if cell.isOn {
                        cell.monitor(item)
                        cell.viewPlayer.player?.play()
//                        cell.imgThumb.isHidden = true
                    } else {
                        cell.imgThumb.isHidden = false
                    }
                    cell.setup()
                }
//                cell.imgThumb.isHidden = true
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
        case news.media.count + 1:
            return 370 * scaleW
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
//extension User2Controller: UICollectionViewDelegate, UICollectionViewDataSource, UIScrollViewDelegate, UICollectionViewDelegateFlowLayout{
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
//        case news.media.count + 1:
//            return CGSize(width: 414 * scaleW, height: 320 * scaleW)
//        default:
//            return CGSize(width: 414 * scaleW, height: 320 * scaleW)
//        }
//    }
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return news.media.count + 2
//    }
////    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
////        if indexPath.row == news.media.count - 1 {
////            if news.name == "Đừng bỏ lỡ"{
////                return
////            }
////            APIService.shared.getMoreVideoPlaylist(privateKey: news.privateKey, page: page.description) { (data, error) in
////                if let data = data as? [MediaModel]{
////                    news.media += data
////                    self.page += 1
////                    self.collView.reloadData()
////                }
////            }
////        }
////    }
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        switch indexPath.row {
//        case 0:
//            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NoCell.className, for: indexPath) as! NoCell
//            return cell
//        case news.media.count + 1:
//            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NoCell.className, for: indexPath) as! NoCell
//            return cell
//        default:
//            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: VideoCell.className, for: indexPath) as! VideoCell
//            //cell.delegate = self
//            
//            let item = news.media[indexPath.row - 1]
//            cell.item = item
//            cell.indexPath = indexPath
//            cell.lblTitle.text = item.name + item.episode
//            cell.lblTime.text = item.getTimePass()
//            
//            cell.delegate = self
//            if let url = URL(string: root.cdn.imageDomain + item.thumnail.replacingOccurrences(of: "\\", with: "/" )){
//                cell.imgThumb.loadImage(fromURL: url)
//            }
//            if indexPath == self.indexPath{
//                var link = ""
//                if item.fileCode != "" {
//                    link = item.fileCode
//                }else{
//                    link = item.path
//                }
//                if let url = URL(string: link){
//                    
//                    cell.viewPlayer.player = AVPlayer(url: url)
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
extension User2Controller: CellVideoDelegate{
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
            vc.item = cell.item
            vc.listResolution = cell.listResolution
            vc.onDismiss = { () in
                cell.viewPlayer.player = vc.viewPlayer.player
                vc.player = nil
                cell.monitor(cell.item)
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
//extension User2Controller: VideoCellDelegate{
//    func scrollToTop(_ cell: VideoCell) {
//        collView.scrollToItem(at: cell.indexPath, at: .top, animated: true)
//    }
//    func didFinish() {
//
//    }
//
//    func didSelectViewShare(_ cell: VideoCell) {
//        guard let url = URL(string: "https://now.vtc.vn/viewvod/a/\(cell.item.privateID).html") else {
//            return
//        }
//        let itemsToShare = [url]
//        let ac = UIActivityViewController(activityItems: itemsToShare, applicationActivities: nil)
//        ac.popoverPresentationController?.sourceView = self.view
//        self.present(ac, animated: true)
//    }
//
//    func didSelectViewBookmark(_ cell: VideoCell) {
//
//    }
//
//
//    func didSelectViewSetting(_ cell: VideoCell) {
//        let vc = storyboard?.instantiateViewController(withIdentifier: PopUp2Controller.className) as! PopUp2Controller
//        vc.modalPresentationStyle = .custom
//        vc.modalTransitionStyle = .crossDissolve
//        vc.listResolution = cell.listResolution
//        vc.speed = cell.speed
//        vc.onComplete = { list in
//            cell.listResolution = list
//            cell.setBitRate()
//        }
//        vc.onTickedSpeed = { value in
//            cell.speed = value
//            cell.setSpeed()
//        }
//        present(vc, animated: true, completion: nil)
//
//    }
//
//    func didSelectViewFullScreen(_ cell: VideoCell, _ newPlayer: AVPlayer) {
//        if #available(iOS 13.0, *) {
//            let vc = storyboard?.instantiateViewController(withIdentifier: FullScreenController.className) as! FullScreenController
//            vc.player = newPlayer
//            vc.item = cell.item
//            vc.listResolution = cell.listResolution
//            vc.onDismiss = { () in
//                cell.viewPlayer.player = vc.viewPlayer.player
//                vc.player = nil
//                cell.viewPlayer.player?.play()
//                cell.isPlaying = true
//                cell.btnPlay.setBackgroundImage(#imageLiteral(resourceName: "PAUSE"), for: .normal)
//            }
//            vc.modalPresentationStyle = .fullScreen
//            present(vc, animated: true, completion: nil)
//        } else {
//            let vc = PlayerViewController()
//            vc.player = newPlayer
//            vc.videoGravity = .resizeAspect
//            vc.onDismiss = { () in
//                cell.viewPlayer.player = vc.player
//                vc.player = nil
//                cell.viewPlayer.player?.play()
//                cell.isPlaying = true
//                cell.btnPlay.setBackgroundImage(#imageLiteral(resourceName: "PAUSE"), for: .normal)
//            }
//            present(vc, animated: true) {
//                vc.player?.play()
//                vc.addObserver(self, forKeyPath: #keyPath(UIViewController.view.frame), options: [.old, .new], context: nil)
//            }
//        }
//    }
//
//    func didSelectViewCast() {
//
//    }
//    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
//
//    }
//}
