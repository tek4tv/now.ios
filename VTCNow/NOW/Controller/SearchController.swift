//
//  SearchController.swift
//  NOW
//
//  Created by dovietduy on 2/24/21.
//

import UIKit

class SearchController: UIViewController {

    @IBOutlet weak var collView: UICollectionView!
    @IBOutlet weak var txfView: UITextField!
    @IBOutlet weak var viewBack: UIView!
    @IBOutlet weak var tblView: UITableView!
    @IBOutlet weak var lblNotFound: UILabel!
    @IBOutlet weak var viewSpeech: UIView!
    var indicator =  UIActivityIndicatorView()
    
    var listData : [MediaModel] = []
    var listString: [String] = []
    var filterListString: [String] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        viewSpeech.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didSelectViewSpeech(_:))))
        viewBack.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didSelectViewBack(_:))))
        txfView.addTarget(self, action: #selector(textFieldDidChange(_:)),
                          for: .editingChanged)
        txfView.addTarget(self, action: #selector(textFieldDidTouch(_:)),
                          for: .touchDown)
        collView.delegate = self
        collView.dataSource = self
        collView.register(UINib(nibName: "VideoCell", bundle: nil), forCellWithReuseIdentifier: "VideoCell")
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 414 * scaleW, height: 330 * scaleW)
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        collView.collectionViewLayout = layout
        txfView.delegate = self
        // Do any additional setup after loading the view.
        
        //
        tblView.delegate = self
        tblView.dataSource = self
        tblView.register(UINib(nibName: SearchCell.className, bundle: nil), forCellReuseIdentifier: SearchCell.className)
        APIService.shared.getSuggestion(keySearch: "") { (data, error) in
            if let data = data as? [String]{
                self.listString = data
                self.filterListString = data
            }
            self.tblView.reloadData()
        }
        lblNotFound.isHidden = true
    }
    @objc func didSelectViewSpeech(_ sender: Any){
        let vc = storyboard?.instantiateViewController(withIdentifier: SpeechToTextController.className) as! SpeechToTextController
        vc.modalPresentationStyle = .custom
        vc.modalTransitionStyle = .crossDissolve
        present(vc, animated: true, completion: nil)
        vc.onComplete = {[self] text in
            txfView.text = text
            tblView.isHidden = true
            indicator.startAnimating()
            lblNotFound.isHidden = true
            APIService.shared.searchAll(keySearch: text) { (data, error) in
                if let data = data as? [MediaModel]{
                    self.listData = data
                    self.collView.reloadData()
                    if self.listData.isEmpty {
                        self.lblNotFound.isHidden = false
                    }
                    self.indicator.stopAnimating()
                }
            }
        }
    }
    @objc func textFieldDidTouch(_ sender: Any){
        tblView.isHidden = false
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        
        if textField.text == "" {
           
            self.filterListString = listString
        } else {
            self.filterListString = []
//            APIService.shared.getSuggestion(keySearch: textField.text!) { (data, error) in
//                if let data = data as? [String]{
//                    for item in data {
//                        if item.lowercased().contains((textField.text!.lowercased())){
//                            self.filterListString.append(item)
//
//                        }
//                    }
//                }
//                self.tblView.reloadData()
//            }
            for item in listString{
                if item.lowercased().contains((textField.text!.lowercased())){
                    self.filterListString.append(item)
                }
            }
        }
        self.tblView.reloadData()
        tblView.isHidden = false
        
        
    }
    @objc func didSelectViewBack(_ sender: Any){
        self.navigationController?.popViewController(animated: true)
    }
}
extension SearchController: UICollectionViewDelegate, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        listData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: VideoCell.className, for: indexPath) as! VideoCell
        cell.delegate = self
        
        let item = listData[indexPath.row]
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
extension SearchController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool{
        txfView.endEditing(true)
        tblView.isHidden = true
        indicator.startAnimating()
        lblNotFound.isHidden = true
        APIService.shared.searchAll(keySearch: textField.text!) { (data, error) in
            if let data = data as? [MediaModel]{
                self.listData = data
                self.collView.reloadData()
                if self.listData.isEmpty {
                    self.lblNotFound.isHidden = false
                }
                self.indicator.stopAnimating()
            }
        }
        return true
    }
}
extension SearchController: VideoCellDelegate{
    func didSelect3Dot(_ cell: VideoCell) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "PopUpController") as! PopUpController
        vc.data = cell.item
        vc.modalPresentationStyle = .overFullScreen
        present(vc, animated: true, completion: nil)
    }
    
    func didSelectVideo(_ cell: VideoCell) {
        sharedItem = cell.item
        NotificationCenter.default.post(name: NSNotification.Name("openVideo"), object: nil)
    }
}

extension SearchController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filterListString.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SearchCell.className, for: indexPath) as! SearchCell
        cell.lblName.text = filterListString[indexPath.row]
        cell.delegate = self
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70 * scaleH
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        txfView.endEditing(true)
        txfView.text = filterListString[indexPath.row]
        tblView.isHidden = true
        indicator.hidesWhenStopped = true
        indicator.center = view.center
        view.addSubview(indicator)
        indicator.startAnimating()
        self.lblNotFound.isHidden = true
        APIService.shared.searchAll(keySearch: filterListString[indexPath.row]) { (data, error) in
            if let data = data as? [MediaModel]{
                self.listData = data
                self.collView.reloadData()
                self.indicator.stopAnimating()
                if self.listData.isEmpty {
                    self.lblNotFound.isHidden = false
                }
            }
        }
        
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        txfView.endEditing(true)
    }
}
extension SearchController: SearchCellDelegate{
    func didSelectViewFillText(_ text: String) {
        txfView.text = text
    }
    
    
}
