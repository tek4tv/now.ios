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
    var indexPath = IndexPath(row: 0, section: 0)
    var data = ChannelModel()
    var isPlaying = false
    var delegate: TVCellDelegate!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        collView.delegate = self
        collView.dataSource = self
        collView.register(UINib(nibName: Video2Cell.className, bundle: nil), forCellWithReuseIdentifier: Video2Cell.className)
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: collView.bounds.width * scaleW, height: 280 * scaleW)
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        collView.collectionViewLayout = layout
        
        
    }
    func playLive(){
        isPlaying = true
        collView.reloadData()
    }
    func stopLive(){
        isPlaying = false
        collView.reloadData()
    }
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}
extension TVCell: UICollectionViewDelegate, UICollectionViewDataSource, UIScrollViewDelegate{
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let count = collView.visibleCells.count

        if count == 2{
            let id0 = collView.indexPath(for: collView.visibleCells[0])!
            let id1 = collView.indexPath(for: collView.visibleCells[1])!
            if id0.row < id1.row {
                if self.indexPath != id0{
                    if let cell = collView.visibleCells[1] as? VideoCell {
                        cell.viewPlayer.player?.pause()
                        cell.btnPlay.setBackgroundImage(#imageLiteral(resourceName: "ic_pause-1"), for: .normal)
                    }
                    self.indexPath = id0
                    collView.reloadData()
                }
            }else{
                if self.indexPath != id1{
                    if let cell = collView.visibleCells[0] as? VideoCell {
                        cell.viewPlayer.player?.pause()
                        cell.btnPlay.setBackgroundImage(#imageLiteral(resourceName: "ic_pause-1"), for: .normal)
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
            list = list.sorted(by: { $0.row < $1.row })
            
            if self.indexPath != list[1]{
                if let cell = collView.visibleCells[0] as? VideoCell {
                    cell.viewPlayer.player?.pause()
                    cell.btnPlay.setBackgroundImage(#imageLiteral(resourceName: "ic_pause-1"), for: .normal)
                }
                if let cell = collView.visibleCells[2] as? VideoCell {
                    cell.viewPlayer.player?.pause()
                    cell.btnPlay.setBackgroundImage(#imageLiteral(resourceName: "ic_pause-1"), for: .normal)
                }
                self.indexPath = list[1]
                collView.reloadData()
            }
        }
        
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Video2Cell.className, for: indexPath) as! Video2Cell
        cell.item = data
        cell.delegate = self
        if indexPath == self.indexPath{
            if let url = URL(string: data.url[0].link){
                
                cell.viewPlayer.player  = AVPlayer(url: url)
                cell.setup()
                if isPlaying == true{
                    cell.viewPlayer.player?.play()
                    cell.btnPlay.setBackgroundImage(#imageLiteral(resourceName: "ic_playing"), for: .normal)
                }
            }
            cell.imgThumb.isHidden = true
            cell.viewShadow.isHidden = true
        } else{
            cell.viewPlayer.player?.pause()
            cell.btnPlay.setBackgroundImage(#imageLiteral(resourceName: "ic_pause-1"), for: .normal)
            cell.imgThumb.isHidden = false
            cell.viewShadow.isHidden = false
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
