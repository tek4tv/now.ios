//
//  UserController.swift
//  NOW
//
//  Created by dovietduy on 3/9/21.
//

import UIKit

extension UserController{
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
class UserController: UIViewController {
    @IBOutlet weak var collView: UICollectionView!
//    var listName = "Chọn theo nhiều chủ đề"
//    var listData: [MediaModel] = []
    var listCate: [CategoryModel] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        collView.delegate = self
        collView.dataSource = self
        collView.register(UINib(nibName: WeatherCell.reuseIdentifier, bundle: nil), forCellWithReuseIdentifier: WeatherCell.reuseIdentifier)
        collView.register(UINib(nibName: NewBroadCell.reuseIdentifier, bundle: nil), forCellWithReuseIdentifier: NewBroadCell.reuseIdentifier)
        let layout = UICollectionViewFlowLayout()
        //layout.itemSize = CGSize(width: 414 * scaleW, height: 250 * scaleW)
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.sectionInset = UIEdgeInsets(top: 10 * scaleW, left: 0, bottom: 10 * scaleW, right: 0)
        collView.collectionViewLayout = layout
        let count = UserDefaults.standard.integer(forKey: "NumberOfList")
        for index in 0..<count{
            let cate = CategoryModel()
            let list = UserDefaults.standard.stringArray(forKey: "\(index)")!
            if list.isEmpty {
                
            } else {
                cate.index = index
                var listName = ""
                for (index, text) in list.enumerated() {
                    if index == list.count - 1 {
                        listName += text
                    } else{
                        listName += text + ", "
                    }
                    APIService.shared.searchAll(keySearch: text) {[self] (data, error) in
                        if let data = data as? [MediaModel]{
                            cate.media += data
                            if index == list.count - 1 {
                                
                                cate.name = listName
                                listCate.append(cate)
                                collView.reloadData()
                            }
                        }
                    }
                }
            }
        }
//        let list = UserDefaults.standard.stringArray(forKey: "List0")!
//        if list.isEmpty {
//
//        } else {
//            listName = ""
//            for (index, text) in list.enumerated() {
//                if index == list.count - 1 {
//                    listName += text
//                } else{
//                    listName += text + ", "
//                }
//                APIService.shared.searchAll(keySearch: text) {[self] (data, error) in
//                    if let data = data as? [MediaModel]{
//                        listData += data
//                        collView.reloadData()
//                    }
//                }
//            }
//        }
       
    }
    @objc func didSelectBtnSearch(_ sender: Any){
        let vc = storyboard?.instantiateViewController(withIdentifier: SearchController.className) as! SearchController
        self.navigationController?.pushViewController(vc, animated: false)
    }
}
extension UserController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        default:
            return listCate.count + 1
        }
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch indexPath.section {
        case 0:
            return CGSize(width: 414 * scaleW, height: 70 * scaleW)
        default:
            return CGSize(width: 414 * scaleW, height: 270 * scaleW)
        }
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.section {
        case 0:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: WeatherCell.reuseIdentifier, for: indexPath) as! WeatherCell
            cell.delegate = self
            cell.viewSearch.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didSelectBtnSearch(_:))))
            return cell
        default:
            switch indexPath.row {
            case 0..<listCate.count:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NewBroadCell.reuseIdentifier, for: indexPath) as! NewBroadCell
                if indexPath.row < listCate.count{
                    let item = listCate[indexPath.row]
                    cell.delegate = self
                    cell.lblTitle.text = item.name
                    cell.imgAdd.image = #imageLiteral(resourceName: "NEXT")
                    cell.data = item
                    cell.collView.backgroundColor = .white
                }
                return cell
            default:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NewBroadCell.reuseIdentifier, for: indexPath) as! NewBroadCell
                cell.delegate = self
                cell.imgAdd.image = #imageLiteral(resourceName: "icons8-add-100")
                cell.lblTitle.text = "Chọn nhiều chủ đề"
                cell.data = CategoryModel()
                cell.collView.backgroundColor = .clear
                return cell
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            break
        default:
            switch indexPath.row {
            case 0..<listCate.count:
                
                news = listCate[indexPath.row]
                let vc = storyboard?.instantiateViewController(withIdentifier: User2Controller.className) as! User2Controller
                navigationController?.pushViewController(vc, animated: false)
                vc.onComplete = {[self] in
                    refresh()
                }
                vc.onDelete = {[self] in
                    refresh()
                }
            default:
                let vc = storyboard?.instantiateViewController(withIdentifier: PickUpController.className) as! PickUpController
                navigationController?.pushViewController(vc, animated: false)
                vc.onComplete = {[self] (index) in
                    
                    let list = UserDefaults.standard.stringArray(forKey: "\(index)")!
                    let cate = CategoryModel()
                    if list.isEmpty {
                        
                    } else {
                        cate.index = index
                        var listName = ""
                        for (index, text) in list.enumerated() {
                            if index == list.count - 1 {
                                listName += text
                            } else{
                                listName += text + ", "
                            }
                            APIService.shared.searchAll(keySearch: text) {[self] (data, error) in
                                if let data = data as? [MediaModel]{
                                    cate.media += data
                                    if index == list.count - 1 {
                                        cate.name = listName
                                        listCate.append(cate)
                                        collView.reloadData()
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }

    func refresh(){
        let count = UserDefaults.standard.integer(forKey: "NumberOfList")
        for index in 0..<count{
            let cate = CategoryModel()
            let list = UserDefaults.standard.stringArray(forKey: "\(index)")!
            
            if list.isEmpty {
//                print("empty")
//                print(index.description)
                if index == count - 1 {
                    listCate = []
                    collView.reloadData()
                }
            } else {
//                print("full")
//                print(index.description)
                cate.index = index
                var listName = ""
                listCate = []
                for (index, text) in list.enumerated() {
                    if index == list.count - 1 {
                        listName += text
                    } else{
                        listName += text + ", "
                    }
                    APIService.shared.searchAll(keySearch: text) {[self] (data, error) in
                        if let data = data as? [MediaModel]{
                            cate.media += data
                            if index == list.count - 1 {
                                cate.name = listName
                                listCate.append(cate)
                                collView.reloadData()
                            }
                        }
                    }
                }
            }
        }
    }
}

extension UserController: NewBroadCellDelegate{
    func didSelectIcon() {
        let vc = storyboard?.instantiateViewController(withIdentifier: PickUpController.className) as! PickUpController
        navigationController?.pushViewController(vc, animated: false)
        vc.onComplete = {[self] (index) in
            
            let list = UserDefaults.standard.stringArray(forKey: "\(index)")!
            let cate = CategoryModel()
            if list.isEmpty {
                
            } else {
                cate.index = index
                var listName = ""
                for (index, text) in list.enumerated() {
                    if index == list.count - 1 {
                        listName += text
                    } else{
                        listName += text + ", "
                    }
                    APIService.shared.searchAll(keySearch: text) {[self] (data, error) in
                        if let data = data as? [MediaModel]{
                            cate.media += data
                            if index == list.count - 1 {
                                cate.name = listName
                                listCate.append(cate)
                                collView.reloadData()
                            }
                        }
                    }
                }
            }
        }
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
    
    func didSelectItemAt(_ cell: NewBroadCell) {
        let vc = storyboard?.instantiateViewController(withIdentifier: User2Controller.className) as! User2Controller
        navigationController?.pushViewController(vc, animated: false)
        vc.onComplete = {[self] in
            refresh()
        }
        vc.onDelete = {[self] in
            refresh()
        }
    }
    
    
}
extension UserController: WeatherDelegate{
    func didSelectViewWeather(_ listW: WeatherModel) {
        let vc = storyboard?.instantiateViewController(withIdentifier: PopUp7Controller.className) as! PopUp7Controller
        vc.modalPresentationStyle = .custom
        vc.modalTransitionStyle = .crossDissolve
        vc.item = listW
        self.present(vc, animated: true, completion: nil)
    }

}
