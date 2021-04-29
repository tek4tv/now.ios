//
//  UserController.swift
//  NOW
//
//  Created by dovietduy on 3/9/21.
//

import UIKit
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
        collView.register(UINib(nibName: NewBroadCell.className, bundle: nil), forCellWithReuseIdentifier: NewBroadCell.className)
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 414 * scaleW, height: 250 * scaleW)
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
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
}
extension UserController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        listCate.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.row {
        case 0..<listCate.count:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NewBroadCell.className, for: indexPath) as! NewBroadCell
            let item = listCate[indexPath.row]
            cell.delegate = self
            cell.lblTitle.text = item.name
            cell.imgAdd.image = #imageLiteral(resourceName: "NEXT")
            cell.data = item
            return cell
        default:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NewBroadCell.className, for: indexPath) as! NewBroadCell
            cell.lblTitle.text = "Chọn theo nhiều chủ đề"
            cell.data = CategoryModel()
            return cell
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
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

    func refresh(){
        let count = UserDefaults.standard.integer(forKey: "NumberOfList")
        for index in 0..<count{
            let cate = CategoryModel()
            let list = UserDefaults.standard.stringArray(forKey: "\(index)")!
            
            if list.isEmpty {
                print("empty")
                print(index.description)
                if index == count - 1 {
                    listCate = []
                    collView.reloadData()
                }
            } else {
                print("full")
                print(index.description)
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
