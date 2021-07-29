//
//  SearchController.swift
//  NOW
//
//  Created by dovietduy on 2/24/21.
//

import UIKit
import AVFoundation
extension SearchController{
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
class SearchController: UIViewController {

    //@IBOutlet weak var collView: UICollectionView!
    @IBOutlet weak var txfView: UITextField!
    @IBOutlet weak var viewBack: UIView!
    @IBOutlet weak var tblView: UITableView!
    @IBOutlet weak var lblNotFound: UILabel!
    @IBOutlet weak var viewSpeech: UIView!
    @IBOutlet weak var collWordView: UICollectionView!
    var indicator =  UIActivityIndicatorView()
    var listWord: [KeyWordModel] = []
    var listData : [MediaModel] = []
    var filterListString: [KeySearchModel] = []
    var indexPath = IndexPath(row: 1, section: 0)

    override func viewDidLoad() {
        super.viewDidLoad()
        viewSpeech.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didSelectViewSpeech(_:))))
        viewBack.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didSelectViewBack(_:))))
        txfView.addTarget(self, action: #selector(textFieldDidChange(_:)),
                          for: .editingChanged)
        txfView.addTarget(self, action: #selector(textFieldDidTouch(_:)),
                          for: .touchDown)
        txfView.delegate = self
        // Do any additional setup after loading the view.
        collWordView.delegate = self
        collWordView.dataSource = self
        collWordView.register(UINib(nibName: HashTagItemCell.reuseIdentifier, bundle: nil), forCellWithReuseIdentifier: HashTagItemCell.reuseIdentifier)
        let layout2 = LeftAlignedCellsCustomFlowLayout()
        layout2.estimatedItemSize = CGSize(width: 1, height: 40 * scaleW)
        layout2.minimumLineSpacing = 5
        layout2.minimumInteritemSpacing = 5
        collWordView.collectionViewLayout = layout2
        //
        tblView.delegate = self
        tblView.dataSource = self
        tblView.register(UINib(nibName: SearchCell.reuseIdentifier, bundle: nil), forCellReuseIdentifier: SearchCell.reuseIdentifier)
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
            
        } else {
            
        }

        APIService.shared.getKeySearch {[weak self] (data, error) in
            if let data = data as? [KeyWordModel] {
                self?.listWord = data
                self?.collWordView.reloadData()
            }
        }

    }
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    @objc func didSelectViewSpeech(_ sender: Any){
        let vc = SpeechToTextVC(nibName: SpeechToTextVC.className, bundle: nil)
        vc.modalPresentationStyle = .overFullScreen
        present(vc, animated: false, completion: nil)
        vc.onComplete = {[self] text in
            txfView.text = text
            tblView.isHidden = true
            indicator.startAnimating()
            lblNotFound.isHidden = true
            APIService.shared.searchAll(keySearch: text) { (data, error) in
                if let data = data as? [MediaModel]{
                    self.listData = data
                    news = CategoryModel()
                    news.media = data
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: HighLight2Controller.className) as! HighLight2Controller
                    self.navigationController?.pushViewController(vc, animated: false)
                }
            }
        }
    }
    @objc func textFieldDidTouch(_ sender: Any){
        tblView.isHidden = false
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        
        if textField.text == "" {
           
            self.filterListString = []
            self.tblView.isHidden = true
        } else {
            self.filterListString = []
            APIService.shared.getSuggestion(keySearch: textField.text!) { (data, error) in
                if let data = data as? [KeySearchModel]{
                    self.filterListString = data
                }
                self.tblView.reloadData()
                self.tblView.isHidden = false
            }

//            for item in listString{
//                if item.lowercased().contains((textField.text!.lowercased())){
//                    self.filterListString.append(item)
//                }
//            }
        }
        //self.tblView.reloadData()
        
    }
    
    @objc func didSelectViewBack(_ sender: Any){
        self.navigationController?.popViewController(animated: false)
    }
}
extension SearchController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 1, height: 40 * scaleW)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return listWord.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HashTagItemCell.reuseIdentifier, for: indexPath) as! HashTagItemCell
        if indexPath.row < listWord.count {
            cell.lblTitle.text = listWord[indexPath.row].name
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        APIService.shared.searchByTag(privateKey: "", keySearch: listWord[indexPath.row].keyWord) { (data, error) in
            if let data = data as? [MediaModel]{
                self.listData = data
                news = CategoryModel()
                news.media = data
                let vc = self.storyboard?.instantiateViewController(withIdentifier: HighLight2Controller.className) as! HighLight2Controller
                self.navigationController?.pushViewController(vc, animated: false)
                
            }
        }
    }
}

extension SearchController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool{
        txfView.endEditing(true)
        tblView.isHidden = true
        print(textField.text!)
        APIService.shared.searchAll(keySearch: textField.text!) { (data, error) in
            if let data = data as? [MediaModel]{
                self.listData = data
                news = CategoryModel()
                news.media = data
                let vc = self.storyboard?.instantiateViewController(withIdentifier: HighLight2Controller.className) as! HighLight2Controller
                vc.isPushByHashTag = true
                self.navigationController?.pushViewController(vc, animated: false)
            }
        }
        return true
    }
}

extension SearchController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filterListString.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SearchCell.reuseIdentifier, for: indexPath) as! SearchCell
        cell.lblName.text = filterListString[indexPath.row].string
        cell.delegate = self
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70 * scaleH
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        txfView.endEditing(true)
        txfView.text = filterListString[indexPath.row].string
        tblView.isHidden = true
        APIService.shared.getDetailVideo(privateKey: filterListString[indexPath.row].privateKey) { data, error in
            if let data = data as? MediaModel {
                let vc = self.storyboard?.instantiateViewController(withIdentifier: VideoController.className) as! VideoController
                vc.item = data
//                vc.listData = 
                self.navigationController?.pushViewController(vc, animated: false)
            }
        }
//        APIService.shared.searchAll(keySearch: filterListString[indexPath.row]) { (data, error) in
//            if let data = data as? [MediaModel]{
//                self.listData = data
//                news = CategoryModel()
//                news.media = data
//                let vc = self.storyboard?.instantiateViewController(withIdentifier: HighLight2Controller.className) as! HighLight2Controller
//                self.navigationController?.pushViewController(vc, animated: false)
//            }
//        }
        
    }

}
extension SearchController: SearchCellDelegate{
    func didSelectViewFillText(_ text: String) {
        txfView.text = text
    }

}
