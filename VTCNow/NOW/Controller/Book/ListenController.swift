//
//  ListenController.swift
//  NOW
//
//  Created by dovietduy on 3/1/21.
//

import UIKit
import AVFoundation

extension ListenController{
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
class ListenController: UIViewController {
    @IBOutlet weak var txfView: UITextField!
    @IBOutlet weak var collView: UICollectionView!
    @IBOutlet weak var collSearchView: UICollectionView!
    var listSearch: [MediaModel] = []
    var tag = ""
    var count = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        txfView.addTarget(self, action: #selector(textFieldDidChange(_:)),
                          for: .editingChanged)
        txfView.delegate = self
        collView.delegate = self
        collView.dataSource = self
        collView.register(UINib(nibName: Type7Cell.reuseIdentifier, bundle: nil), forCellWithReuseIdentifier: Type7Cell.reuseIdentifier)
        collView.register(UINib(nibName: Book3Cell.reuseIdentifier, bundle: nil), forCellWithReuseIdentifier: Book3Cell.reuseIdentifier)
        let layout = UICollectionViewFlowLayout()
        collView.collectionViewLayout = layout
        
        collSearchView.delegate = self
        collSearchView.dataSource = self
        collSearchView.register(UINib(nibName: BookItemCell.reuseIdentifier, bundle: nil), forCellWithReuseIdentifier: BookItemCell.reuseIdentifier)
        
        let layout2 = UICollectionViewFlowLayout()
        //layout2.itemSize = CGSize(width: (414 - 80) / 3.01 * scaleW, height: 260 * scaleW)
        layout2.minimumLineSpacing = 20 * scaleW
        layout2.minimumInteritemSpacing = 0
        layout2.sectionInset = UIEdgeInsets(top: 10 * scaleW, left: 20 * scaleW, bottom: 0, right: 20 * scaleW)
        collSearchView.collectionViewLayout = layout2
        collSearchView.isHidden = true
        
        for item in bookCate.components{
            APIService.shared.getPlaylist(privateKey: item.privateKey) {[weak self] (data, error) in
                if let data = data as? CategoryModel{
                    item.category = data
                    self?.count += 1
                    if self!.count == bookCate.components.count {
                        self?.collView.reloadData()
                    }
                }
            }
        }
        tag = bookCate.privateKey
        for item in bookCate.components{
            tag += " | " + item.privateKey
        }
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
            APIService.shared.searchByTag(privateKey: tag, keySearch: textField.text!) {[weak self] (data, error) in
                if let data = data as? [MediaModel]{
                    self?.listSearch = data
                    self?.collSearchView.reloadData()
                    self?.collSearchView.layoutIfNeeded()
                }
            }
            
        }
        
    }
}
extension ListenController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool{
        txfView.endEditing(true)
        return true
    }
}
extension ListenController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch collectionView {
        case collView:
            switch indexPath.row {
            case 0:
                return CGSize(width: 414 * scaleW, height: (175 + 70) * scaleW)
            default:
                return CGSize(width: 414 * scaleW, height: 310 * scaleW)
            }
        default:
            return CGSize(width: (414 - 80) / 3.01 * scaleW, height: 260 * scaleW)
        }
        
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView {
        case collView:
            return bookCate.components.count + 1
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
            switch indexPath.row {
            case 0:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Book3Cell.reuseIdentifier, for: indexPath) as! Book3Cell
                cell.delegate = self
                cell.data = bookCate
                return cell
            default:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Type7Cell.reuseIdentifier, for: indexPath) as! Type7Cell
                cell.delegate = self
                if indexPath.row - 1 < bookCate.components.count {
                    let item = bookCate.components[indexPath.row - 1]
                    cell.lblTitle.text = item.name
                    cell.data = item.category
                }
                return cell
            }
        default:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BookItemCell.reuseIdentifier, for: indexPath) as! BookItemCell
            if indexPath.row < listSearch.count {
                let item = listSearch[indexPath.row]
                if let url = URL(string: root.cdn.imageDomain + item.portrait.replacingOccurrences(of: "\\", with: "/" )){
                    cell.thumbImage.loadImage(fromURL: url)
                }
                cell.lblTitle.text = item.name
                if item.episode != "" {
                    cell.viewEpisode.isHidden = false
                    cell.lblEpisode.text = item.episode
                    cell.lblTotalEpisode.text = item.totalEpisode
                }
                cell.lblAuthor.text = item.author
            }
            return cell
        }
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch collectionView {
        case collView:
            switch indexPath.row {
            case 0:
                let vc = storyboard?.instantiateViewController(withIdentifier: BookCategoryController.className) as! BookCategoryController
                vc.data = bookCate
                self.navigationController?.pushViewController(vc, animated: false)
            default:
                let vc = storyboard?.instantiateViewController(withIdentifier: BookCategoryController.className) as! BookCategoryController
                if indexPath.row - 1 < bookCate.components.count{
                    vc.data = bookCate.components[indexPath.row - 1].category
                }
                self.navigationController?.pushViewController(vc, animated: false)
            }
        default:
            APIService.shared.getDetailVideo(privateKey: listSearch[indexPath.row].privateID) { (data, error) in
                if let data = data as? MediaModel {
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: BookPlayerController.className) as! BookPlayerController
                    let item = data
                    if item.episode != "" {
                        vc.isNovel = false
                        vc.data = item
                    } else{
                        vc.isNovel = true
                        vc.data = item
                        vc.listData = self.listSearch
                        vc.idPlaying = indexPath.row
                    }
                    
                    self.navigationController?.pushViewController(vc, animated: false)
                }
            }
            
        }
        
        
    }
    
}
extension ListenController: Type7CellDelegate, Book3CellDelegate{
    func didSelectViewMore(_ cell: Book3Cell) {
        let vc = storyboard?.instantiateViewController(withIdentifier: BookCategoryController.className) as! BookCategoryController
        vc.data = cell.data
        self.navigationController?.pushViewController(vc, animated: false)
    }
    func didSelectNovel(_ cell: Book3Cell, _ data: MediaModel, _ list: [MediaModel]) {
        APIService.shared.getDetailVideo(privateKey: data.privateID) { (data, error) in
            if let data = data as? MediaModel {
                let vc = self.storyboard?.instantiateViewController(withIdentifier: BookPlayerController.className) as! BookPlayerController
                vc.data = data
                vc.listData = list
                vc.isNovel = true
                vc.idPlaying = cell.row
                self.navigationController?.pushViewController(vc, animated: false)
            }
        }
        
    }
    
    func didSelectNovel(_ cell: Type7Cell, _ data: MediaModel, _ list: [MediaModel]) {
        APIService.shared.getDetailVideo(privateKey: data.privateID) { (data, error) in
            if let data = data as? MediaModel {
                let vc = self.storyboard?.instantiateViewController(withIdentifier: BookPlayerController.className) as! BookPlayerController
                vc.data = data
                vc.listData = list
                vc.isNovel = true
                vc.idPlaying = cell.row
                self.navigationController?.pushViewController(vc, animated: false)
            }
        }
    }
    
    func didSelectItemAt(_ cell: Book3Cell, _ data: MediaModel) {
        APIService.shared.getDetailVideo(privateKey: data.privateID) { (data, error) in
            if let data = data as? MediaModel {
                let vc = self.storyboard?.instantiateViewController(withIdentifier: BookPlayerController.className) as! BookPlayerController
                vc.data = data
                self.navigationController?.pushViewController(vc, animated: false)
            }
        }
    }
    
    func didSelectItemAt(_ cell: Type7Cell, _ data: MediaModel) {
        APIService.shared.getDetailVideo(privateKey: data.privateID) { (data, error) in
            if let data = data as? MediaModel {
                let vc = self.storyboard?.instantiateViewController(withIdentifier: BookPlayerController.className) as! BookPlayerController
                vc.data = data
                self.navigationController?.pushViewController(vc, animated: false)
            }
        }
    }
    
    func didSelectItemAt(_ cell: Type7Cell) {
        let vc = storyboard?.instantiateViewController(withIdentifier: BookPlayerController.className) as! BookPlayerController
        self.navigationController?.pushViewController(vc, animated: false)
    }
    func didSelectViewMore(_ cell: Type7Cell){
        let vc = storyboard?.instantiateViewController(withIdentifier: BookCategoryController.className) as! BookCategoryController
        vc.data = cell.data
        self.navigationController?.pushViewController(vc, animated: false)
    }
}

