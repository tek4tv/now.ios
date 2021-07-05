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
    @IBOutlet weak var txfView: UITextField!
    var listSearch: [MediaModel] = []
    var page = 1
    var isPushByTVShow = false
    var isSearching = false
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        collView.delegate = self
        collView.dataSource = self
        collView.register(UINib(nibName: Type3ItemCell.reuseIdentifier, bundle: nil), forCellWithReuseIdentifier: Type3ItemCell.reuseIdentifier)
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: (414 - 60) / 2.01 * scaleW, height: 180 * scaleW)
        layout.minimumLineSpacing = 20 * scaleW
        layout.sectionInset = UIEdgeInsets(top: 20 * scaleW, left: 20 * scaleW, bottom: 0, right: 20 * scaleW)
        collView.collectionViewLayout = layout
        
        viewBack.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didSelectBtnBack(_:))))
        txfView.addTarget(self, action: #selector(textFieldDidChange(_:)),
                          for: .editingChanged)
        txfView.delegate = self
        listSearch = news.media
    }
    @objc func didSelectBtnBack(_ sender: Any){
        self.navigationController?.popViewController(animated: false)
    }
    @objc func textFieldDidChange(_ textField: UITextField) {
        
        if textField.text == "" {
           isSearching = false
            self.listSearch = news.media
            self.collView.reloadData()
        } else {
            self.listSearch = []
            isSearching = true
            APIService.shared.searchByTag(privateKey: news.privateKey, keySearch: textField.text!) {[weak self] (data, error) in
                if let data = data as? [MediaModel]{
                    self?.listSearch = data
                    self?.collView.reloadData()
                }
            }
            
        }
        
    }
}
extension MovieSetController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool{
        txfView.endEditing(true)
        return true
    }
}
extension MovieSetController: UICollectionViewDelegate, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.row == news.media.count - 1 {
            APIService.shared.getMoreVideoPlaylist(privateKey: news.privateKey, page: page.description) {[weak self] (data, error) in
                if let data = data as? [MediaModel]{
                    news.media += data
                    if self?.isSearching == false{
                        self?.listSearch = news.media
                    }
                    self?.page += 1
                    self?.collView.reloadData()
                }
            }
        }
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        listSearch.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Type3ItemCell.reuseIdentifier, for: indexPath) as! Type3ItemCell
        let item = listSearch[indexPath.row]
        cell.data = item
        cell.row = indexPath.row
        cell.delegate = self
        cell.lblTitle.text = item.name
        if item.country != "" {
            cell.lblTime.text = item.country
        } else {
            cell.lblTime.text = item.getTimePass()
        }
        if isPushByTVShow {
            cell.lblTime.isHidden = true
            cell.viewShare.isHidden = true
        }
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
        let count = listSearch.count
        var list: [MediaModel] = []
        if count == 1{
            list = []
        } else if count == 2{
            if cell.row == 0 {
                list.append(listSearch[1])
            } else{
                list.append(listSearch[0])
            }
        } else if count >= 3 {
            if cell.row == 0{
                list = Array(listSearch[1...count-1])
            } else if cell.row == count-1 {
                list = Array(listSearch[0...count - 2])
            } else{
                list = Array(listSearch[cell.row+1...count-1] + listSearch[0...cell.row-1])
            }
        }
        if cell.data.endTimecode != ""{
            APIService.shared.getRelatedEpisode(code: cell.data.endTimecode) {[weak self] (list1, error) in
                if let list1 = list1 as? [MediaModel] {
                    if list1.isEmpty{
                        let vc = self?.storyboard?.instantiateViewController(withIdentifier: VideoController.className) as! VideoController
                        vc.item = cell.data
                        vc.listData = list
                        self?.navigationController?.pushViewController(vc, animated: false)
                    } else{
                        let vc = self?.storyboard?.instantiateViewController(withIdentifier: VideoController.className) as! VideoController
                        vc.item = cell.data
                        vc.listData = list1
                        self?.navigationController?.pushViewController(vc, animated: false)
                    }
                }
            }
        } else{
            let vc = storyboard?.instantiateViewController(withIdentifier: VideoController.className) as! VideoController
            vc.item = cell.data
            vc.listData = list
            navigationController?.pushViewController(vc, animated: false)
        }
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
