//
//  MovieController.swift
//  NOW
//
//  Created by dovietduy on 3/4/21.
//

import UIKit
extension MusicController{
    override var preferredStatusBarStyle: UIStatusBarStyle {
        if #available(iOS 13.0, *) {
            return .darkContent
        } else {
            // Fallback on earlier versions
            return .default
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
class MusicController: UIViewController {
    @IBOutlet weak var txfView: UITextField!
    @IBOutlet weak var collView: UICollectionView!
    @IBOutlet weak var collSearchView: UICollectionView!
    @IBOutlet weak var viewBack: UIView!
    var page = 1
    var listSearch: [MediaModel] = []
    override func viewDidLoad() {
        super.viewDidLoad()

        collView.delegate = self
        collView.dataSource = self
        collView.register(UINib(nibName: Type8ItemCell.reuseIdentifier, bundle: nil), forCellWithReuseIdentifier: Type8ItemCell.reuseIdentifier)
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.itemSize = CGSize(width: (414 - 60) / 2.001 * scaleW, height: 180 * scaleW)
        layout.sectionInset = UIEdgeInsets(top: 20 * scaleW, left: 20 * scaleW, bottom: 0, right: 20 * scaleW)
        collView.collectionViewLayout = layout
        viewBack.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didSelectViewBack(_:))))
        
        //
        txfView.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        txfView.delegate = self
        collSearchView.delegate = self
        collSearchView.dataSource = self
        collSearchView.register(UINib(nibName: Type8ItemCell.reuseIdentifier, bundle: nil), forCellWithReuseIdentifier: Type8ItemCell.reuseIdentifier)
        let layout2 = UICollectionViewFlowLayout()
        layout2.minimumLineSpacing = 0
        layout2.itemSize = CGSize(width: (414 - 60) / 2.001 * scaleW, height: 180 * scaleW)
        layout2.sectionInset = UIEdgeInsets(top: 20 * scaleW, left: 20 * scaleW, bottom: 0, right: 20 * scaleW)
        collSearchView.collectionViewLayout = layout2
        collSearchView.isHidden = true
    }
    @objc func didSelectViewBack(_ sender: Any){
        navigationController?.popViewController(animated: false)
    }
    @objc func textFieldDidChange(_ textField: UITextField) {
        
        if textField.text == "" {
           
            self.listSearch = []
            self.collSearchView.isHidden = true
        } else {
            self.listSearch = []
            self.collSearchView.isHidden = false
            APIService.shared.searchWithTag(privateKey: news.privateKey, keySearch: textField.text!) {[weak self] (data, error) in
                if let data = data as? [MediaModel]{
                    self?.listSearch = data
                    self?.collSearchView.reloadData()
                }
            }
            
        }
        
    }
}
extension MusicController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool{
        txfView.endEditing(true)
        return true
    }
}
extension MusicController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        switch collectionView {
        case collView:
            if indexPath.row == news.media.count - 1{
                APIService.shared.getMoreVideoPlaylist(privateKey: news.privateKey, page: page.description) { (data, error) in
                    if let data = data as? [MediaModel]{
                        news.media += data
                        self.page += 1
                        self.collView.reloadData()
                    }
                }
            }
        default:
            break
        }
        
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView {
        case collView:
            return news.media.count
        default:
            return listSearch.count
        }
        
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch collectionView {
        case collView:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Type8ItemCell.reuseIdentifier, for: indexPath) as! Type8ItemCell
            if indexPath.row < news.media.count{
                let item = news.media[indexPath.row]
                cell.lblTitle.text = item.name
                if let url = URL(string: root.cdn.imageDomain + item.thumnail.replacingOccurrences(of: "\\", with: "/" )){
                    cell.thumbImage.loadImage(fromURL: url)
                }
            }
            return cell
        default:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Type8ItemCell.reuseIdentifier, for: indexPath) as! Type8ItemCell
            if indexPath.row < listSearch.count {
                let item = listSearch[indexPath.row]
                cell.lblTitle.text = item.name
                if let url = URL(string: root.cdn.imageDomain + item.thumnail.replacingOccurrences(of: "\\", with: "/" )){
                    cell.thumbImage.loadImage(fromURL: url)
                }
            }
            return cell
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch collectionView {
        case collView:
            let count = news.media.count
            var list: [MediaModel] = []
            if count == 1{
                list = []
            } else if count == 2{
                if indexPath.row == 0 {
                    list.append(news.media[1])
                } else{
                    list.append(news.media[0])
                }
            } else if count >= 3 {
                if indexPath.row == 0{
                    list = Array(news.media[1...count-1])
                } else if indexPath.row == count-1 {
                    list = Array(news.media[0...count - 2])
                } else{
                    list = Array(news.media[indexPath.row+1...count-1] + news.media[0...indexPath.row-1])
                }
            }
            APIService.shared.getDetailVideo(privateKey: news.media[indexPath.row].privateID) { (data, error) in
                if let data = data as? MediaModel{
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: MusicPlayerController.className) as! MusicPlayerController
                    vc.item = data
                    vc.listData = list
                    self.navigationController?.pushViewController(vc, animated: false)
                }
            }
            
        default:
            let count = listSearch.count
            var list: [MediaModel] = []
            if count == 1{
                list = []
            } else if count == 2{
                if indexPath.row == 0 {
                    list.append(listSearch[1])
                } else{
                    list.append(listSearch[0])
                }
            } else if count >= 3 {
                if indexPath.row == 0{
                    list = Array(listSearch[1...count-1])
                } else if indexPath.row == count-1 {
                    list = Array(listSearch[0...count - 2])
                } else{
                    list = Array(listSearch[indexPath.row+1...count-1] + listSearch[0...indexPath.row-1])
                }
            }
            let vc = storyboard?.instantiateViewController(withIdentifier: MusicPlayerController.className) as! MusicPlayerController
            vc.item = listSearch[indexPath.row]
            vc.listData = list
            navigationController?.pushViewController(vc, animated: false)
        }
        
    }
    
}
