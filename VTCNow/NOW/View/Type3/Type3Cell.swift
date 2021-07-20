//
//  TinMoiCell.swift
//  VTCNow
//
//  Created by dovietduy on 1/25/21.
//

import UIKit
import AVFoundation

class Type3Cell: UICollectionViewCell {
    static let reuseIdentifier = "Type3Cell"
    @IBOutlet weak var collView: UICollectionView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var viewBanner: UIView!
    @IBOutlet weak var imgIcon: LazyImageView!
    @IBOutlet weak var viewLine: UIView!
    @IBOutlet weak var bottomLine: NSLayoutConstraint!
    fileprivate var player: AVPlayer? = nil
    fileprivate var isPlaying = false
    fileprivate var isSetPlayer = false
    var data = CategoryModel(){
        didSet{
            lblTitle.text = data.name
            if data.name != oldValue.name{
                collView.reloadData()
            }
        }
    }
    var delegate: Type3CellDelegate!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        collView.delegate = self
        collView.dataSource = self
        collView.register(UINib(nibName: Type3ItemCell.reuseIdentifier, bundle: nil), forCellWithReuseIdentifier: Type3ItemCell.reuseIdentifier)
        collView.register(UINib(nibName: BannerCell.reuseIdentifier, bundle: nil), forCellWithReuseIdentifier: BannerCell.reuseIdentifier)
        collView.register(UINib(nibName: ViewFullCell.reuseIdentifier, bundle: nil), forCellWithReuseIdentifier: ViewFullCell.reuseIdentifier)
        collView.register(UINib(nibName: VideoCell.reuseIdentifier, bundle: nil), forCellWithReuseIdentifier: VideoCell.reuseIdentifier)
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 25 * scaleW
        layout.sectionInset = UIEdgeInsets(top: 0, left: 20 * scaleW, bottom: 25 * scaleW, right: 20 * scaleW)
        collView.collectionViewLayout = layout
        APIService.shared.getPlaylist(privateKey: "7d20527f-5946-4b64-a42b-c33f9a5993aa") { (data, error) in
            if let data = data as? CategoryModel{
                if let url = URL(string: data.cdn.imageDomain + data.icon.replacingOccurrences(of: "\\", with: "/" )){
                    self.imgIcon.loadImage(fromURL: url)
                }
            }
        }
        //
        NotificationCenter.default.addObserver(self, selector: #selector(stopVOD5(_:)), name: NSNotification.Name("StopVOD5"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(playVOD5(_:)), name: NSNotification.Name("PlayVOD5"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(didScroll(_:)), name: NSNotification.Name("scrollViewDidScroll"), object: nil)
        
        //
        viewBanner.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didSelectBanner(_:))))
        if isOffClass == true{
            bottomLine.constant = 0
            viewLine.isHidden = true
            viewBanner.isHidden = true
        } else{
            
        }
        //
//        if videoHot.media.count >= 1 {
//            let item = videoHot.media[0]
//            if let url = URL(string: item.path.replacingOccurrences(of: "\\", with: "/")){
//                player = AVPlayer(url: url)
//            }
//        }
        
    }
    @objc func didSelectBanner(_ sender: Any){
        delegate?.didSelectBannerClass()
    }
    func refresh(){
        collView.reloadData()
    }
    @objc func stopVOD5(_ notification: Notification){
        if let cell = collView.cellForItem(at: IndexPath(row: 0, section: 5)) as? VideoCell{
            cell.viewPlayer.player?.pause()
            cell.isPlaying = false
            cell.btnPlay.isHidden = true
            cell.btnPlay.setBackgroundImage(#imageLiteral(resourceName: "PLAY"), for: .normal)
        }
    }
    @objc func playVOD5(_ notification: Notification){
        
            if let cell = collView.cellForItem(at: IndexPath(row: 0, section: 5)) as? VideoCell{
                NotificationCenter.default.post(name: NSNotification.Name("cell.loadVideo"), object: nil)
                if isPlaying == true {
                    cell.viewPlayer.player?.play()
                    cell.isPlaying = true
                    cell.btnPlay.isHidden = true
                    cell.btnPlay.setBackgroundImage(#imageLiteral(resourceName: "PAUSE"), for: .normal)
                }
                
            }
        
        
    }
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}
extension Type3Cell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // 6 1 6 1 6 1 6
        switch section {
        case 0:
            return 6
        case 1:
            return 1
        case 2:
            return 6
        case 3:
            return 1
        case 4:
            return 6
        case 5:
            return 1
        default:
            return 6
        }
//        24
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 7
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.section {
        case 0:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Type3ItemCell.reuseIdentifier, for: indexPath) as! Type3ItemCell
            let item = data.media[indexPath.row]
            cell.data = item
            cell.row = indexPath.row
            cell.delegate = self
            cell.lblTitle.text = item.name
            cell.lblTime.text = item.getTimePass()
            if let url = URL(string: root.cdn.imageDomain + item.thumnail.replacingOccurrences(of: "\\", with: "/" )){
                cell.thumbImage.loadImage(fromURL: url)
                cell.thumbImage.contentMode = .scaleAspectFill
            }
            return cell
        case 1:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ViewFullCell.reuseIdentifier, for: indexPath) as! ViewFullCell
            
            cell.delegate = self
            return cell
        case 2:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Type3ItemCell.reuseIdentifier, for: indexPath) as! Type3ItemCell
            let item = data.media[indexPath.row + 6]
            cell.data = item
            cell.row = indexPath.row + 6
            cell.delegate = self
            cell.lblTitle.text = item.name
            cell.lblTime.text = item.getTimePass()
            if let url = URL(string: root.cdn.imageDomain + item.thumnail.replacingOccurrences(of: "\\", with: "/" )){
                cell.thumbImage.loadImage(fromURL: url)
                cell.thumbImage.contentMode = .scaleAspectFill
            }
            return cell
        case 3:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BannerCell.reuseIdentifier, for: indexPath) as! BannerCell
            cell.delegate = self
            if let url = URL(string: banner.icon.replacingOccurrences(of: "\\", with: "/" )){
                cell.imgThumb.loadImage(fromURL: url)
            }
            
            return cell
            
        case 4:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Type3ItemCell.reuseIdentifier, for: indexPath) as! Type3ItemCell
            let item = data.media[indexPath.row + 12]
            cell.data = item
            cell.row = indexPath.row + 12
            cell.delegate = self
            cell.lblTitle.text = item.name
            cell.lblTime.text = item.getTimePass()
            if let url = URL(string: root.cdn.imageDomain + item.thumnail.replacingOccurrences(of: "\\", with: "/" )){
                cell.thumbImage.loadImage(fromURL: url)
                cell.thumbImage.contentMode = .scaleAspectFill
            }
            return cell
        case 5:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: VideoCell.reuseIdentifier, for: indexPath) as! VideoCell
            cell.lblTitle.font = UIFont(name: "Roboto-Regular", size: 17 * scaleW)
            cell.lblTime.font = UIFont(name: "Roboto-Regular", size: 14 * scaleW)
            NotificationCenter.default.post(name: NSNotification.Name("cell.loadVideo"), object: nil)
            if videoHot.media.count >= 1 {
                let item = videoHot.media[0]
                //cell.item = item
                cell.delegate = self
                cell.lblTitle.text = item.name
                cell.lblTime.text = item.timePass
                if let url = URL(string: root.cdn.imageDomain + item.thumnail.replacingOccurrences(of: "\\", with: "/" )){
                    cell.imgThumb.loadImage(fromURL: url)
                }
                
            }else{
                cell.lblTime.text = ""
                cell.lblTitle.text = ""
            }
            
            
            return cell
        default:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Type3ItemCell.reuseIdentifier, for: indexPath) as! Type3ItemCell
            let item = data.media[indexPath.row + 18]
            cell.data = item
            cell.row = indexPath.row + 18
            cell.delegate = self
            cell.lblTitle.text = item.name
            cell.lblTime.text = item.getTimePass()
            if let url = URL(string: root.cdn.imageDomain + item.thumnail.replacingOccurrences(of: "\\", with: "/" )){
                cell.thumbImage.loadImage(fromURL: url)
                cell.thumbImage.contentMode = .scaleAspectFill
            }
            return cell
        }
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    @objc func didScroll(_ notification: Notification){
        if let cell = collView.cellForItem(at: IndexPath(row: 0, section: 5)) as? VideoCell {
            if cell.isVisibleToUser {
                NotificationCenter.default.post(name: NSNotification.Name("cell.playVideo"), object: nil)
                isPlaying = true
//                cell.viewPlayer.player?.play()
//                cell.isPlaying = true
//                cell.btnPlay.setBackgroundImage(#imageLiteral(resourceName: "PAUSE"), for: .normal)
            } else{
                NotificationCenter.default.post(name: NSNotification.Name("cell.pauseVideo"), object: nil)
                isPlaying = false
//                cell.viewPlayer.player?.pause()
//                cell.isPlaying = false
//                cell.btnPlay.setBackgroundImage(#imageLiteral(resourceName: "PLAY"), for: .normal)
            }
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch indexPath.section {
        case 0:
            return CGSize(width: (414 - 60) / 2.01 * scaleW, height: 220 * scaleW)
        case 1:
            return CGSize(width: 414 * scaleW, height: 385 * scaleW)
        case 2:
            return CGSize(width: (414 - 60) / 2.01 * scaleW, height: 220 * scaleW)
        case 3:
            return CGSize(width: (414 - 40) * scaleW, height: 210 * scaleW)
        case 4:
            return CGSize(width: (414 - 60) / 2.01 * scaleW, height: 220 * scaleW)
        case 5:
            return CGSize(width: 414 * scaleW, height: 320 * scaleW)
        default:
            return CGSize(width: (414 - 60) / 2.01 * scaleW, height: 220 * scaleW)
        }
        
    }
}

extension Type3Cell: Type3ItemCellDelegate{
    func didSelectViewImage(_ cell: Type3ItemCell) {
        let temp = self.data.copy()
        let item = cell.data
//        print(cell.row)
        temp.media.remove(at: cell.row)
        temp.media.insert(item, at: 0)
        news = temp
        delegate?.didSelectViewImage(cell)
    }
    
    func didSelectViewBookmark(_ cell: Type3ItemCell) {
        
    }
    
    func didSelectViewShare(_ cell: Type3ItemCell) {
        delegate?.didSelectViewShare(cell)
    }
    
    
}
extension Type3Cell: BannerCellDelegate{
    func didSelectImage() {
        APIService.shared.getPlaylist(privateKey: banner.privateKey) {[weak self] (data, error) in
            if let data = data as? CategoryModel{
                news = data
                self?.delegate?.didSelectBanner()
            }
        }
        
    }

}
extension Type3Cell: ViewFullCellDelegate{
    func didSelectXemToanCanh() {
        delegate?.didSelectOverViewLabel()
    }
    
    func didSelectItemAt() {
        delegate?.didSelectOverView()
    }
    
    
}
extension Type3Cell: VideoCellDelegate{
    func scrollToTop(_ cell: VideoCell) {
        
    }
    func didFinish() {
        
    }
    
    func didSelectViewShare(_ cell: VideoCell) {
//        guard let url = URL(string: "https://now.vtc.vn/viewvod/a/\(cell.item.privateID).html") else {
//            return
//        }
//        let itemsToShare = [url]
//        let ac = UIActivityViewController(activityItems: itemsToShare, applicationActivities: nil)
//        ac.popoverPresentationController?.sourceView = self.view
//        self.present(ac, animated: true)
        
        delegate?.didSelectViewShare(cell)
    }
    
    func didSelectViewBookmark(_ cell: VideoCell) {
        
    }
    
    
    func didSelectViewSetting(_ cell: VideoCell) {
        delegate?.didSelectViewSetting(cell)
    }
    
    func didSelectViewFullScreen(_ cell: VideoCell, _ newPlayer: AVPlayer) {
        delegate?.didSelectViewFullScreen(cell, newPlayer)
    }
    
    func didSelectViewCast() {
        
    }
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
    }
}

protocol Type3CellDelegate: HighLightController{
    func didSelectViewShare(_ cell: Type3ItemCell)
    func didSelectViewImage(_ cell: Type3ItemCell)
    func didSelectViewShare(_ cell: VideoCell)
    func didSelectViewSetting(_ cell: VideoCell)
    func didSelectViewFullScreen(_ cell: VideoCell, _ newPlayer: AVPlayer)
    func didSelectBanner()
    func didSelectBannerClass()
    func didSelectOverView()
    func didSelectOverViewLabel()
}
extension UIView {
    var isVisibleToUser: Bool {

        if isHidden || alpha == 0 || superview == nil {
            return false
        }

        guard let rootViewController = UIApplication.shared.keyWindow?.rootViewController else {
            return false
        }

        let viewFrame = convert(bounds, to: rootViewController.view)

        let topSafeArea: CGFloat
        let bottomSafeArea: CGFloat

        if #available(iOS 11.0, *) {
            topSafeArea = rootViewController.view.safeAreaInsets.top
            bottomSafeArea = rootViewController.view.safeAreaInsets.bottom
        } else {
            topSafeArea = rootViewController.topLayoutGuide.length
            bottomSafeArea = rootViewController.bottomLayoutGuide.length
        }

        return viewFrame.minX >= 0 &&
            viewFrame.maxX <= rootViewController.view.bounds.width &&
            viewFrame.minY >= topSafeArea &&
            viewFrame.maxY <= rootViewController.view.bounds.height - bottomSafeArea

    }
}
