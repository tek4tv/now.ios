//
//  TVCell.swift
//  NOW
//
//  Created by dovietduy on 4/8/21.
//

import UIKit
import AVFoundation
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
        collView.register(UINib(nibName: NoCell.className, bundle: nil), forCellWithReuseIdentifier: NoCell.className)
        let layout = UICollectionViewFlowLayout()
//        layout.itemSize = CGSize(width: collView.bounds.width * scaleW, height: 300 * scaleW)
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        collView.collectionViewLayout = layout
        
        APIService.shared.getPlaylist(privateKey: "62963352-3d13-4ac3-bb94-d05030baebf8") {[self] (data, error) in
            if let data = data as? CategoryModel {
                listVideos = data.media
                collView.reloadData()
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
            return CGSize(width: collView.bounds.width * scaleW, height: 0)
        case listVideos.count + 2:
            return CGSize(width: collView.bounds.width * scaleW, height: 300 * scaleW)
        default:
            return CGSize(width: collView.bounds.width * scaleW, height: 300 * scaleW)
        }
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        1 + listVideos.count + 2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Video2Cell.className, for: indexPath) as! Video2Cell
        cell.delegate = self
        switch indexPath.row {
        case 0:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NoCell.className, for: indexPath) as! NoCell
            return cell
        case 1:
            cell.item = data
            cell.lblTitle.text = data.name
            cell.lblTime.text = "Đang phát trực tiếp"
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
                if isPlaying == true{
                    cell.viewPlayer.player?.play()
                    cell.btnPlay.setBackgroundImage(#imageLiteral(resourceName: "PAUSE"), for: .normal)
                }
            }
            cell.imgThumb.isHidden = true
        } else{
            cell.viewPlayer.player?.pause()
            cell.btnPlay.setBackgroundImage(#imageLiteral(resourceName: "PLAY"), for: .normal)
            cell.imgThumb.isHidden = false
        }
        return cell
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
protocol TVCellDelegate {
    func didSelectBookMark(_ cell: Video2Cell)
    func didSelectViewSetting(_ cell: Video2Cell)
    func didSelectViewFullScreen(_ cell: Video2Cell, _ newPlayer: AVPlayer)
    func didSelectViewCast()
}
