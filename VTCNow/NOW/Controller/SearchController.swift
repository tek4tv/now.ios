//
//  SearchController.swift
//  NOW
//
//  Created by dovietduy on 2/24/21.
//

import UIKit
import AVFoundation
class SearchController: UIViewController {

    @IBOutlet weak var collView: UICollectionView!
    @IBOutlet weak var txfView: UITextField!
    @IBOutlet weak var viewBack: UIView!
    @IBOutlet weak var tblView: UITableView!
    @IBOutlet weak var lblNotFound: UILabel!
    @IBOutlet weak var viewSpeech: UIView!
    @IBOutlet weak var collWordView: UICollectionView!
    var indicator =  UIActivityIndicatorView()
    var listWord = ["Sơn Tùng MTP", "Covid 19", "Cuộc sống 24h", "Hà nội", "Phải chăng em đã yêu?", "Yêu"]
    var listData : [MediaModel] = []
    var listString: [String] = []
    var filterListString: [String] = []
    var indexPath = IndexPath(row: 0, section: 0)
    var isPushByHashTag = false
    override func viewDidLoad() {
        super.viewDidLoad()
        viewSpeech.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didSelectViewSpeech(_:))))
        viewBack.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didSelectViewBack(_:))))
        txfView.addTarget(self, action: #selector(textFieldDidChange(_:)),
                          for: .editingChanged)
        txfView.addTarget(self, action: #selector(textFieldDidTouch(_:)),
                          for: .touchDown)
        collView.tag = 0
        collView.delegate = self
        collView.dataSource = self
        collView.register(UINib(nibName: "VideoCell", bundle: nil), forCellWithReuseIdentifier: "VideoCell")
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 414 * scaleW, height: 330 * scaleW)
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        collView.collectionViewLayout = layout
        txfView.delegate = self
        // Do any additional setup after loading the view.
        collWordView.tag = 1
        collWordView.delegate = self
        collWordView.dataSource = self
        collWordView.register(UINib(nibName: WordCell.className, bundle: nil), forCellWithReuseIdentifier: WordCell.className)
        let layout2 = LeftAlignedCellsCustomFlowLayout()
        layout2.estimatedItemSize = CGSize(width: 1, height: 40 * scaleH)
        layout2.minimumLineSpacing = 5
        layout2.minimumInteritemSpacing = 5
        collWordView.collectionViewLayout = layout2
        //
        tblView.delegate = self
        tblView.dataSource = self
        tblView.register(UINib(nibName: SearchCell.className, bundle: nil), forCellReuseIdentifier: SearchCell.className)
        APIService.shared.getSuggestion(keySearch: "") { (data, error) in
            if let data = data as? [String]{
                self.listString = data
                self.filterListString = data
            }
            self.tblView.reloadData()
        }
        lblNotFound.isHidden = true
        self.collView.isHidden = true
        
        //
        if isPushByHashTag{
            collView.isHidden = false
        }
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if let cell = collView.cellForItem(at: indexPath) as? VideoCell{
            cell.viewPlayer.player?.pause()
        }
    }
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    @objc func didSelectViewSpeech(_ sender: Any){
        let vc = storyboard?.instantiateViewController(withIdentifier: SpeechToTextController.className) as! SpeechToTextController
        vc.modalPresentationStyle = .custom
        vc.modalTransitionStyle = .crossDissolve
        present(vc, animated: true, completion: nil)
        vc.onComplete = {[self] text in
            txfView.text = text
            tblView.isHidden = true
            indicator.startAnimating()
            lblNotFound.isHidden = true
            APIService.shared.searchAll(keySearch: text) { (data, error) in
                if let data = data as? [MediaModel]{
                    self.listData = data
                    self.collView.reloadData()
                    if self.listData.isEmpty {
                        self.lblNotFound.isHidden = false
                    }
                    self.indicator.stopAnimating()
                }
            }
        }
    }
    @objc func textFieldDidTouch(_ sender: Any){
        tblView.isHidden = false
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        
        if textField.text == "" {
           
            self.filterListString = listString
        } else {
            self.filterListString = []
//            APIService.shared.getSuggestion(keySearch: textField.text!) { (data, error) in
//                if let data = data as? [String]{
//                    for item in data {
//                        if item.lowercased().contains((textField.text!.lowercased())){
//                            self.filterListString.append(item)
//
//                        }
//                    }
//                }
//                self.tblView.reloadData()
//            }
            for item in listString{
                if item.lowercased().contains((textField.text!.lowercased())){
                    self.filterListString.append(item)
                }
            }
        }
        self.tblView.reloadData()
        tblView.isHidden = false
        
        
    }
    @objc func didSelectViewBack(_ sender: Any){
        self.navigationController?.popViewController(animated: true)
    }
}
extension SearchController: UICollectionViewDelegate, UICollectionViewDataSource, UIScrollViewDelegate{
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        txfView.endEditing(true)
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
        switch collectionView.tag {
        case 0:
            return listData.count
        default:
            return listWord.count
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch collectionView.tag{
        case 0:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: VideoCell.className, for: indexPath) as! VideoCell
            cell.delegate = self
            
            let item = listData[indexPath.row]
            cell.item = item
            cell.indexPath = indexPath
            cell.lblTitle.text = item.name
            cell.lblTime.text = item.timePass
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
                cell.viewShadow.isHidden = true
            } else{
                cell.viewPlayer.player?.pause()
                cell.imgThumb.isHidden = false
                cell.viewShadow.isHidden = false
            }
            return cell
        default:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: WordCell.className, for: indexPath) as! WordCell
            cell.lblTitle.text = "#" + listWord[indexPath.row]
            return cell
        }
        
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch collectionView.tag {
        case 0:
            break
        default:
            //txfView.endEditing(true)
            txfView.text = listWord[indexPath.row]
            collView.isHidden = false
            indicator.hidesWhenStopped = true
            indicator.center = view.center
            view.addSubview(indicator)
            indicator.startAnimating()
            self.lblNotFound.isHidden = true
            APIService.shared.searchAll(keySearch: listWord[indexPath.row]) { (data, error) in
                if let data = data as? [MediaModel]{
                    self.listData = data
                    self.collView.reloadData()
                    self.indicator.stopAnimating()
                    if self.listData.isEmpty {
                        self.lblNotFound.isHidden = false
                        self.collView.isHidden = true
                    }
                }
            }
        }
    }
    
}
extension SearchController: VideoCellDelegate{
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
                cell.btnPlay.setBackgroundImage(#imageLiteral(resourceName: "icons8-pause-49"), for: .normal)
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
                cell.btnPlay.setBackgroundImage(#imageLiteral(resourceName: "icons8-pause-49"), for: .normal)
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
extension SearchController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool{
        txfView.endEditing(true)
        tblView.isHidden = true
        indicator.startAnimating()
        lblNotFound.isHidden = true
        collView.isHidden = false
        APIService.shared.searchAll(keySearch: textField.text!) { (data, error) in
            if let data = data as? [MediaModel]{
                self.listData = data
                self.collView.reloadData()
                if self.listData.isEmpty {
                    self.lblNotFound.isHidden = false
                    self.collView.isHidden = true
                }
                self.indicator.stopAnimating()
            }
        }
        return true
    }
}

extension SearchController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filterListString.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SearchCell.className, for: indexPath) as! SearchCell
        cell.lblName.text = filterListString[indexPath.row]
        cell.delegate = self
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70 * scaleH
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        txfView.endEditing(true)
        txfView.text = filterListString[indexPath.row]
        tblView.isHidden = true
        collView.isHidden = false
        indicator.hidesWhenStopped = true
        indicator.center = view.center
        view.addSubview(indicator)
        indicator.startAnimating()
        self.lblNotFound.isHidden = true
        APIService.shared.searchAll(keySearch: filterListString[indexPath.row]) { (data, error) in
            if let data = data as? [MediaModel]{
                self.listData = data
                self.collView.reloadData()
                self.indicator.stopAnimating()
                if self.listData.isEmpty {
                    self.lblNotFound.isHidden = false
                    self.collView.isHidden = true
                }
            }
        }
        
    }

}
extension SearchController: SearchCellDelegate{
    func didSelectViewFillText(_ text: String) {
        txfView.text = text
    }
    
    
}
