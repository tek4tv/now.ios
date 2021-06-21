//
//  TVCell.swift
//  NOW
//
//  Created by dovietduy on 4/8/21.
//

import UIKit
import AVFoundation
let ids: [String: String] = [
    "VTC1" : "62963352-3d13-4ac3-bb94-d05030baebf8",
    "VTC2" : "96d6862f-a844-40f4-a599-47390892b1ba",
    "VTC3" : "a2207660-a649-4a43-9cbf-21db1dfb44ef",
    "VTC4" : "72f4b9f3-bf60-4d1c-9e59-eafb7ed88446",
    "VTC5" : "f6be2dcf-4af8-4ab0-86cb-ae303e151ef3",
    "VTC6" : "a3337558-eeee-4d2e-b8e2-28147db7cf1c",
    "VTC7" : "4b9b2648-ef56-4519-a0f6-65aedc84e752",
    "VTC8" : "",
    "VTC9" : "40829b75-9b7b-41f1-b4fc-eb200e04d076",
    "VTC10" : "8031618f-4647-4f72-9d8a-d7e3b22b4eb8",
    "VTC11" : "899dbfe2-c4a9-40b6-871d-8e4fd7713989",
    "VTC12" : "5d2df72f-a69c-411e-ab7b-4175285b00ab",
    "VTC13" : "766b2687-b565-404a-a35e-1512a613ad5d",
    "VTC14" : "e993c44e-da25-46b2-8f7c-42831e90c833",
    "VTC16" : "fa839854-5dc8-4eb3-983f-9e57ec329f38"
]
class TVCell: UICollectionViewCell {

    @IBOutlet weak var imgThumb: LazyImageView!
    @IBOutlet weak var collView: UICollectionView!
    var indexPath = IndexPath(row: 1, section: 0)
    var data = ChannelModel()
    var isPlaying = false
    var delegate: TVCellDelegate!
    var listVideos: [MediaModel] = []
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        collView.delegate = self
        collView.dataSource = self
        collView.register(UINib(nibName: Video2Cell.className, bundle: nil), forCellWithReuseIdentifier: Video2Cell.className)
        collView.register(UINib(nibName: Video3Cell.className, bundle: nil), forCellWithReuseIdentifier: Video3Cell.className)
        collView.register(UINib(nibName: Video4Cell.className, bundle: nil), forCellWithReuseIdentifier: Video4Cell.className)
        collView.register(UINib(nibName: NoCell.className, bundle: nil), forCellWithReuseIdentifier: NoCell.className)
        let layout = UICollectionViewFlowLayout()
//        layout.itemSize = CGSize(width: collView.bounds.width * scaleW, height: 300 * scaleW)
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        collView.collectionViewLayout = layout
        
//        APIService.shared.getPlaylist(privateKey: "62963352-3d13-4ac3-bb94-d05030baebf8") {[self] (data, error) in
//            if let data = data as? CategoryModel {
//                listVideos = data.media
//                collView.reloadData()
//            }
//        }
    }
    func loadVideoByDate(date: Date){
        APIService.shared.getVideoByDate(privateId: ids[data.name] ?? "", date: date.getTimeString()) {[weak self] (data, error) in
            if let data = data as? [MediaModel]{
                self?.listVideos = data
                self?.collView.reloadData()
            }
        }
    }
    func setup(){
        APIService.shared.getPlaylist(privateKey: ids[data.name] ?? "") {[weak self] (data, error) in
            if let data = data as? CategoryModel {
                self?.listVideos = data.media
                self?.collView.reloadData()
            }
        }
    }
    func playLive(){
        collView.isScrollEnabled = true
        isPlaying = true
        collView.reloadData()
    }
    func stopLive(){
        collView.isScrollEnabled = false
        isPlaying = false
        collView.reloadData()
    }
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    override func prepareForReuse() {
        collView.scrollToItem(at: IndexPath(row: 0, section: 0), at: .top, animated: false)
        indexPath = IndexPath(row: 1, section: 0)
    }
}
extension TVCell: UICollectionViewDelegate, UICollectionViewDataSource, UIScrollViewDelegate, UICollectionViewDelegateFlowLayout{
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let count = collView.visibleCells.count
        
        if count == 2 {
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
            list = list.sorted(by: { $0.row < $1.row })
            
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
            return CGSize(width: 300 * scaleW, height: 0)
        case 1 :
            return CGSize(width: 300 * scaleW, height: 270 * scaleW)
        case listVideos.count + 2:
            return CGSize(width: 300 * scaleW, height: 300 * scaleW)
        default:
            return CGSize(width: 300 * scaleW, height: 300 * scaleW)
        }
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        1 + listVideos.count + 2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
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
                    if isPlaying == true{
                        cell.setup()
                    }
                    cell.imgThumb.isHidden = true
                } else{
                    cell.imgThumb.isHidden = false
                }
                return cell
            } else{
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Video4Cell.className, for: indexPath) as! Video4Cell
                cell.delegate = self
                cell.item = data
                cell.lblTitle.text = " "
                if indexPath == self.indexPath{
                    if isPlaying == true{
                        cell.setup()
                    }
                    cell.imgThumb.isHidden = true
                } else{
                    cell.imgThumb.isHidden = false
                }
                return cell
            }
            
        case listVideos.count + 2:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NoCell.className, for: indexPath) as! NoCell
            return cell
        default:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Video2Cell.className, for: indexPath) as! Video2Cell
            cell.delegate = self
            let item = listVideos[indexPath.row - 2]
            cell.item = item
            cell.lblTitle.text = item.name
            cell.lblTime.text = item.getTimePass()
            if let url = URL(string: root.cdn.imageDomain + item.thumnail.replacingOccurrences(of: "\\", with: "/" )){
                cell.imgThumb.loadImage(fromURL: url)
            }
            if indexPath == self.indexPath{
                if isPlaying == true{
                    cell.setup()
                }
                cell.imgThumb.isHidden = true
            } else{
                cell.imgThumb.isHidden = false
            }
            return cell
        }
        
    }
}
extension TVCell: Video2CellDelegate{
    func didSelectBookMark(_ cell: Video2Cell) {
        self.delegate?.didSelectBookMark(cell)
    }
    
    func didSelectViewSetting(_ cell: Video2Cell) {
        self.delegate?.didSelectViewSetting(cell)
    }
    
    func didSelectViewFullScreen(_ cell: Video2Cell, _ newPlayer: AVPlayer) {
        self.delegate?.didSelectViewFullScreen(cell, newPlayer)
    }
    
    func didSelectViewCast() {
        self.delegate?.didSelectViewCast()
    }
    
    
}
extension TVCell: Video3CellDelegate{
    func didSelectBookMark(_ cell: Video3Cell) {
        //self.delegate?.didSelectBookMark(cell)
    }
    
    func didSelectViewSetting(_ cell: Video3Cell) {
        self.delegate?.didSelectViewSetting(cell)
    }
    
    func didSelectViewFullScreen(_ cell: Video3Cell, _ newPlayer: AVPlayer) {
        self.delegate.didSelectViewFullScreen(cell, newPlayer)
    }
    
    func didSelectDatePicker() {
        delegate?.didSelectDatePicker()
    }
    
    
}
extension TVCell: Video4CellDelegate{
    func didSelectBookMark(_ cell: Video4Cell) {
        //self.delegate?.didSelectBookMark(cell)
    }
    
    func didSelectViewSetting(_ cell: Video4Cell) {
        self.delegate?.didSelectViewSetting(cell)
    }
    
    func didSelectViewFullScreen(_ cell: Video4Cell, _ newPlayer: AVPlayer) {
        self.delegate.didSelectViewFullScreen(cell, newPlayer)
    }
    
}
protocol TVCellDelegate: class {
    func didSelectBookMark(_ cell: Video2Cell)
    func didSelectViewSetting(_ cell: Video2Cell)
    func didSelectViewFullScreen(_ cell: Video2Cell, _ newPlayer: AVPlayer)
    func didSelectViewSetting(_ cell: Video3Cell)
    func didSelectViewFullScreen(_ cell: Video3Cell, _ newPlayer: AVPlayer)
    func didSelectViewSetting(_ cell: Video4Cell)
    func didSelectViewFullScreen(_ cell: Video4Cell, _ newPlayer: AVPlayer)
    func didSelectViewCast()
    func didSelectDatePicker()
}
