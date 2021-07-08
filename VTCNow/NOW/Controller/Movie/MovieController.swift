//
//  MovieController.swift
//  NOW
//
//  Created by dovietduy on 3/4/21.
//

import UIKit
extension MovieController{
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
class MovieController: UIViewController {
    @IBOutlet weak var collView: UICollectionView!
    @IBOutlet weak var viewBack: UIView!
    @IBOutlet weak var collSearchView: UICollectionView!
    @IBOutlet weak var txfView: UITextField!
    var tag = ""
    var listSearch: [MediaModel] = []
    override func viewDidLoad() {
        super.viewDidLoad()

        collView.delegate = self
        collView.dataSource = self
        collView.register(UINib(nibName: Movie3Cell.reuseIdentifier, bundle: nil), forCellWithReuseIdentifier: Movie3Cell.reuseIdentifier)
        collView.register(UINib(nibName: Movie2Cell.reuseIdentifier, bundle: nil), forCellWithReuseIdentifier: Movie2Cell.reuseIdentifier)
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        collView.collectionViewLayout = layout
        layout.sectionInset = UIEdgeInsets(top: 20 * scaleW, left: 0, bottom: 0, right: 0)
        //
        collSearchView.delegate = self
        collSearchView.dataSource = self
        collSearchView.register(UINib(nibName: MovieItem2Cell.reuseIdentifier, bundle: nil), forCellWithReuseIdentifier: MovieItem2Cell.reuseIdentifier)
        
        let layout2 = UICollectionViewFlowLayout()
        layout2.itemSize = CGSize(width: (414 - 80) / 3.01 * scaleW, height: 250 * scaleW)
        layout2.minimumLineSpacing = 20 * scaleW
        layout2.minimumInteritemSpacing = 20 * scaleW
        layout2.sectionInset = UIEdgeInsets(top: 20 * scaleW, left: 20 * scaleW, bottom: 0, right: 20 * scaleW)
        collSearchView.collectionViewLayout = layout2
        collSearchView.isHidden = true
        //
        txfView.addTarget(self, action: #selector(textFieldDidChange(_:)),
                          for: .editingChanged)
        txfView.delegate = self
        //
        viewBack.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didSelectViewBack(_:))))
        //
        tag = news.privateKey
        for item in news.components{
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
                }
            }
            
        }
        
    }
}
extension MovieController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool{
        txfView.endEditing(true)
        return true
    }
}
extension MovieController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView {
        case collView:
            return 1
        default:
            return listSearch.count
        }
        
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        switch collectionView {
        case collView:
            return news.components.count + 1
        default:
            return 1
        }
        
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch collectionView {
        case collView:
            switch indexPath.section {
            case 0:
                return CGSize(width: 414 * scaleW, height: 260 * scaleW)
            default:
                return CGSize(width: 414 * scaleW, height: 370 * scaleW)
            }
        default:
            return CGSize(width: (414 - 80) / 3.01 * scaleW, height: 250 * scaleW)
        }
        
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch collectionView {
        case collView:
            switch indexPath.section {
            case 0:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Movie2Cell.reuseIdentifier, for: indexPath) as! Movie2Cell
                cell.delegate = self
                cell.data = news
                return cell
            default:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Movie3Cell.reuseIdentifier, for: indexPath) as! Movie3Cell
                cell.delegate = self
                let item = news.components[indexPath.section - 1]
                cell.lblTitle.text = item.name
                cell.data = item.category
                return cell
            }
        default:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MovieItem2Cell.reuseIdentifier, for: indexPath) as! MovieItem2Cell
            let item = listSearch[indexPath.row]
            if let url = URL(string: root.cdn.imageDomain + item.portrait.replacingOccurrences(of: "\\", with: "/" )){
                cell.imgThumb.loadImage(fromURL: url)
            }
            cell.lblTitle.text = item.name
            cell.lblCountry.text = item.country
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch collectionView {
        case collView:
            let vc = storyboard?.instantiateViewController(withIdentifier: MovieCategoryController.className) as! MovieCategoryController
            vc.data = news.components[indexPath.section - 1].category
            self.navigationController?.pushViewController(vc, animated: false)
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
            APIService.shared.getDetailVideo(privateKey: listSearch[indexPath.row].privateID) {[self] (data, error) in
                if let data = data as? MediaModel{
                    let vc = storyboard?.instantiateViewController(withIdentifier: VideoController.className) as! VideoController
                    vc.item = data
                    vc.listData = list
                    navigationController?.pushViewController(vc, animated: false)
                }
            }
        }
        
    }
    
}
extension MovieController: Movie3CellDelegate{
    func didSelectItemAt(_ data: MediaModel, _ list: [MediaModel]) {
        let vc = storyboard?.instantiateViewController(withIdentifier: VideoController.className) as! VideoController
        vc.item = data
        vc.listData = list
        navigationController?.pushViewController(vc, animated: false)
    }
    
}
extension MovieController: Movie2CellDelegate{
    func didSelectItemAt(_ data: MediaModel, _ list: [MediaModel], _ cell: Movie2Cell) {
        let vc = storyboard?.instantiateViewController(withIdentifier: VideoController.className) as! VideoController
        vc.item = data
        vc.listData = list
        navigationController?.pushViewController(vc, animated: false)
    }
    
    
}
