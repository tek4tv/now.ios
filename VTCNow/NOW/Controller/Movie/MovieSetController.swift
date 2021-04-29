//
//  MovieSetController.swift
//  NOW
//
//  Created by dovietduy on 4/29/21.
//

import UIKit

class MovieSetController: UIViewController {

    @IBOutlet weak var viewBack: UIView!
    @IBOutlet weak var collView: UICollectionView!
    var page = 0
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        collView.delegate = self
        collView.dataSource = self
        collView.register(UINib(nibName: Type3ItemCell.className, bundle: nil), forCellWithReuseIdentifier: Type3ItemCell.className)
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: (414 - 60) / 2.01 * scaleW, height: 220 * scaleW)
        layout.minimumLineSpacing = 10 * scaleW
        layout.sectionInset = UIEdgeInsets(top: 10 * scaleW, left: 20 * scaleW, bottom: 0, right: 20 * scaleW)
        collView.collectionViewLayout = layout
        
        viewBack.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didSelectBtnBack(_:))))
    }
    @objc func didSelectBtnBack(_ sender: Any){
        self.navigationController?.popViewController(animated: false)
    }
}
extension MovieSetController: UICollectionViewDelegate, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.row == news.media.count - 1 {
            APIService.shared.getMoreVideoPlaylist(privateKey: news.privateKey, page: page.description) {[weak self] (data, error) in
                if let data = data as? [MediaModel]{
                    news.media += data
                    self?.page += 1
                    self?.collView.reloadData()
                }
            }
        }
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        news.media.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Type3ItemCell.className, for: indexPath) as! Type3ItemCell
        let item = news.media[indexPath.row]
        cell.data = item
        cell.row = indexPath.row
        cell.delegate = self
        cell.lblTitle.text = item.name
        cell.lblTime.text = item.getTimePass()
        if item.episode != "" {
            cell.viewEpisode.isHidden = false
            cell.lblEpisode.text = item.episode
            cell.lblTotalEpisode.text = item.totalEpisode
        }
        if let url = URL(string: root.cdn.imageDomain + item.thumnail.replacingOccurrences(of: "\\", with: "/" )){
            cell.thumbImage.loadImage(fromURL: url)
            cell.thumbImage.contentMode = .scaleAspectFill
        }
        return cell
    }
    
    
}
extension MovieSetController: Type3ItemCellDelegate{
    func didSelectViewImage(_ cell: Type3ItemCell) {
        let count = news.media.count
        var list: [MediaModel] = []
        if count == 1{
            list = []
        } else if count == 2{
            if cell.row == 0 {
                list.append(news.media[1])
            } else{
                list.append(news.media[0])
            }
        } else if count >= 3 {
            if cell.row == 0{
                list = Array(news.media[1...count-1])
            } else if cell.row == count-1 {
                list = Array(news.media[0...count - 2])
            } else{
                list = Array(news.media[cell.row+1...count-1] + news.media[0...cell.row-1])
            }
        }
        let vc = storyboard?.instantiateViewController(withIdentifier: VideoController.className) as! VideoController
        vc.item = cell.data
        vc.listData = list
        navigationController?.pushViewController(vc, animated: false)
    }
    
    func didSelectViewBookmark(_ cell: Type3ItemCell) {
        
    }
    
    func didSelectViewShare(_ cell: Type3ItemCell) {
        guard let url = URL(string: "https://now.vtc.vn/viewvod/a/\(cell.data.privateID).html") else {
            return
        }
        let itemsToShare = [url]
        let ac = UIActivityViewController(activityItems: itemsToShare, applicationActivities: nil)
        ac.popoverPresentationController?.sourceView = self.view
        self.present(ac, animated: true)
    }
    
    
}
