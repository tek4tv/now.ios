//
//  HighLight2Controller.swift
//  NOW
//
//  Created by dovietduy on 2/17/21.
//

import UIKit

class HighLight2Controller: UIViewController {
    @IBOutlet weak var collView: UICollectionView!
    @IBOutlet weak var viewBack: UIView!
    var timer = Timer()
    var page = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Initialization code
        collView.delegate = self
        collView.dataSource = self
        collView.register(UINib(nibName: "VideoCell", bundle: nil), forCellWithReuseIdentifier: "VideoCell")
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 414 * scaleW, height: 330 * scaleW)
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        collView.collectionViewLayout = layout
        
        viewBack.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didSelectBtnBack(_:))))
        if news.name == "Đừng bỏ lỡ"{
            timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true, block: {(timer) in
                NotificationCenter.default.post(name: NSNotification.Name.init("countDownTimer2"), object: nil)
            })
        }else{
            timer.invalidate()
        }
    }
    @objc func didSelectBtnBack(_ sender: Any){
        self.navigationController?.popViewController(animated: true)
    }
    deinit {
        NotificationCenter.default.removeObserver(self)
        timer.invalidate()
    }
}

extension HighLight2Controller: UICollectionViewDelegate, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return news.media.count
    }
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.row == news.media.count - 1 {
            if news.name == "Đừng bỏ lỡ"{
                return
            }
            APIService.shared.getMoreVideoPlaylist(privateKey: news.privateKey, page: page.description) { (data, error) in
                if let data = data as? [MediaModel]{
                    news.media += data
                    self.page += 1
                    self.collView.reloadData()
                }
            }
        }
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: VideoCell.className, for: indexPath) as! VideoCell
        cell.delegate = self
        
        let item = news.media[indexPath.row]
        cell.item = item
        cell.indexPath = indexPath
        cell.lblTitle.text = item.name
        cell.lblTime.text = item.timePass
        if let url = URL(string: root.cdn.imageDomain + item.thumnail.replacingOccurrences(of: "\\", with: "/" )){
            cell.thumbImage.loadImage(fromURL: url)
        }
        return cell
    }
    
}
extension HighLight2Controller: VideoCellDelegate{
    func didSelectVideo(_ cell: VideoCell) {
//        sharedItem = cell.item
//        sharedList = news.media
//        NotificationCenter.default.post(name: NSNotification.Name("openVideo"), object: nil)
        APIService.shared.getDetailVideo(privateKey: cell.item.privateID) { (data, error) in
            if let data = data as? MediaModel{
                sharedItem = data
                sharedList = news.media
                NotificationCenter.default.post(name: NSNotification.Name("openVideo"), object: nil)
            }
        }
    }
    func didSelect3Dot(_ cell: VideoCell) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "PopUpController") as! PopUpController
        vc.data = cell.item
        vc.modalPresentationStyle = .overFullScreen
        vc.modalTransitionStyle = .crossDissolve
        present(vc, animated: true, completion: nil)
    }
}
