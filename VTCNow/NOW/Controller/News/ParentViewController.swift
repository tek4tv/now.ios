//
//  MyPagerTabStripName.swift
//  VTCNow
//
//  Created by dovietduy on 1/28/21.
//

import Foundation
import XLPagerTabStrip
import AVFoundation
import AVKit

class ParentViewController: ButtonBarPagerTabStripViewController {
    @IBOutlet weak var viewBack: UIView!
    @IBOutlet weak var txfView: UITextField!
    @IBOutlet weak var tblSearchView: UITableView!
    var listSearch: [MediaModel] = []
    var indexPath = IndexPath(row: 1, section: 0)
    override func viewDidLoad() {
        
        
        //NotificationCenter.default.addObserver(self, selector: #selector(didOpenVideo(_:)), name: NSNotification.Name("openVideo"), object: nil)
        // change selected bar color
        settings.style.buttonBarBackgroundColor = .white
        settings.style.buttonBarItemBackgroundColor = .white
        settings.style.selectedBarBackgroundColor = #colorLiteral(red: 0.5225926042, green: 0.0004706631007, blue: 0.2674992383, alpha: 1)
        settings.style.buttonBarItemFont = .systemFont(ofSize: 14 * scaleW)
        settings.style.selectedBarHeight = 2.0
        settings.style.buttonBarMinimumLineSpacing = 15 * scaleW
        settings.style.buttonBarItemTitleColor = .black
        settings.style.buttonBarLeftContentInset = 20 * scaleW
        settings.style.buttonBarRightContentInset = 0
        changeCurrentIndexProgressive = {(oldCell: ButtonBarViewCell?, newCell: ButtonBarViewCell?, progressPercentage: CGFloat, changeCurrentIndex: Bool, animated: Bool) -> Void in
            guard changeCurrentIndex == true else { return }
            oldCell?.label.textColor = .gray
            newCell?.label.textColor = #colorLiteral(red: 0.5225926042, green: 0.0004706631007, blue: 0.2674992383, alpha: 1)
        }
        super.viewDidLoad()
        viewBack.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didSelectViewBack(_:))))
        //
        tblSearchView.delegate = self
        tblSearchView.dataSource = self
        tblSearchView.register(UINib(nibName: CellVideo.className, bundle: nil), forCellReuseIdentifier: CellVideo.className)
        tblSearchView.register(UINib(nibName: CellNo.className, bundle: nil), forCellReuseIdentifier: CellNo.className)
        tblSearchView.estimatedRowHeight = 350 * scaleW
        tblSearchView.rowHeight = UITableView.automaticDimension
        txfView.addTarget(self, action: #selector(textFieldDidChange(_:)),
                          for: .editingChanged)
        txfView.delegate = self
    }
    
    @objc func didSelectViewBack(_ sender: Any){
        self.navigationController?.popViewController(animated: false)
    }
    override func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
        var child :[UIViewController] = []
        let child0 = storyboard?.instantiateViewController(withIdentifier: NewsController.className) as! NewsController
        child0.name = "Mới nhất"
        child0.category = news
        child.append(child0)
        for item in news.components{
            let childAdd = storyboard?.instantiateViewController(withIdentifier: NewsController.className) as! NewsController
            childAdd.name = item.name
            childAdd.category = item.category
            child.append(childAdd)
        }
        return child
    }
    @objc func textFieldDidChange(_ textField: UITextField) {
        NotificationCenter.default.post(name: NSNotification.Name("video.stop.now"), object: nil)
        if textField.text == "" {
            if let cell = cellForRow(indexPath){
                cell.viewPlayer.player?.pause()
                cell.viewPlayer.player?.replaceCurrentItem(with: nil)
            }
            self.listSearch = []
            self.tblSearchView.isHidden = true
            self.tblSearchView.reloadData()
        } else {
            if let cell = cellForRow(indexPath){
                cell.viewPlayer.player?.pause()
                cell.viewPlayer.player?.replaceCurrentItem(with: nil)
            }
            self.listSearch = []
            self.listSearch = []
            self.tblSearchView.isHidden = false
            self.indexPath = IndexPath(row: 1, section: 0)
            APIService.shared.searchByTag(privateKey: news.privateKey, keySearch: textField.text!) {[weak self] (data, error) in
                if let data = data as? [MediaModel]{
                    self?.listSearch = data
                    self?.tblSearchView.reloadData()
                }
            }
            
        }
        
    }
    func cellForRow(_ indexPath: IndexPath) -> CellVideo?{
        guard let cell = tblSearchView.cellForRow(at: indexPath) as? CellVideo else {
            return tblSearchView.dequeueReusableCell(withIdentifier: CellVideo.className, for: indexPath) as? CellVideo
        }
        return cell
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.post(name: NSNotification.Name("stopVOD"), object: nil)
        if let cell = cellForRow(indexPath){
            cell.viewPlayer.player?.pause()
            cell.viewPlayer.player?.replaceCurrentItem(with: nil)
        }
    }
    override func scroll() {
        let count = tblSearchView.visibleCells.count
        if count == 2{
            let id0 = tblSearchView.indexPath(for: tblSearchView.visibleCells[0])!
            let id1 = tblSearchView.indexPath(for: tblSearchView.visibleCells[1])!
            if id0.row < id1.row {
                if self.indexPath != id0{
                    NotificationCenter.default.post(name: NSNotification.Name("stopVOD"), object: nil)
                    self.indexPath = id0
                    tblSearchView.reloadData()
                }
            }else{
                if self.indexPath != id1{
                    NotificationCenter.default.post(name: NSNotification.Name("stopVOD"), object: nil)
                    self.indexPath = id1
                    tblSearchView.reloadData()
                }
            }
        }
        if count == 3{
            var list: [IndexPath] = []
            for cell in tblSearchView.visibleCells {
                let id = tblSearchView.indexPath(for: cell)
                list.append(id!)
            }
            list = list.sorted(by: { $0.row > $1.row })
            if self.indexPath != list[1]{
                NotificationCenter.default.post(name: NSNotification.Name("stopVOD"), object: nil)
                self.indexPath = list[1]
                tblSearchView.reloadData()
            }
        }
        if count == 4 {
            var list: [IndexPath] = []
            for cell in tblSearchView.visibleCells {
                let id = tblSearchView.indexPath(for: cell)
                list.append(id!)
            }
            list = list.sorted(by: { $0.row > $1.row })
            if self.indexPath != list[2]{
                NotificationCenter.default.post(name: NSNotification.Name("stopVOD"), object: nil)
                self.indexPath = list[2]
                tblSearchView.reloadData()
            }
        }

    }
}
extension ParentViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool{
        txfView.endEditing(true)
        return true
    }
}
extension ParentViewController: UITableViewDelegate, UITableViewDataSource{
    
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
//                    cell.viewPlayer.player?.automaticallyWaitsToMinimizeStalling = false
//                    cell.viewPlayer.player?.playImmediately(atRate: 1.0)
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
            return UITableView.automaticDimension
        default:
            return UITableView.automaticDimension
        }
    }
}

    

extension ParentViewController: CellVideoDelegate{
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
    
    func didSelectViewCast() {
        
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
            tblSearchView.scrollToRow(at: IndexPath(row: self.indexPath.row + 1, section: 0), at: .top, animated: true)
        }
    }
    
    func scrollToTop(_ cell: CellVideo) {
        tblSearchView.scrollToRow(at: cell.indexPath, at: .top, animated: true)
    }

}
