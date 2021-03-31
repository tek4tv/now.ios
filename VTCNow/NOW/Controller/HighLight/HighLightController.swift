//
//  HighLightController.swift
//  NOW
//
//  Created by dovietduy on 1/29/21.
//

import UIKit
//import FirebaseDatabase
class HighLightController: UIViewController {
    @IBOutlet weak var collView: UICollectionView!
    var categorys2: [CategoryModel] = []
    var countD = 0
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        collView.delegate = self
        collView.dataSource = self
        collView.register(UINib(nibName: WeatherCell.className, bundle: nil), forCellWithReuseIdentifier: WeatherCell.className)
        collView.register(UINib(nibName: HashTagCell.className, bundle: nil), forCellWithReuseIdentifier: HashTagCell.className)
        collView.register(UINib(nibName: CategoryCell.className, bundle: nil), forCellWithReuseIdentifier: CategoryCell.className)
        collView.register(UINib(nibName: Type1Cell.className, bundle: nil), forCellWithReuseIdentifier: Type1Cell.className)
        collView.register(UINib(nibName: Type2Cell.className, bundle: nil), forCellWithReuseIdentifier: Type2Cell.className)
        collView.register(UINib(nibName: Type3Cell.className, bundle: nil), forCellWithReuseIdentifier: Type3Cell.className)
        collView.register(UINib(nibName: Type4Cell.className, bundle: nil), forCellWithReuseIdentifier: Type4Cell.className)
        collView.register(UINib(nibName: Type5Cell.className, bundle: nil), forCellWithReuseIdentifier: Type5Cell.className)
        collView.register(UINib(nibName: Type6Cell.className, bundle: nil), forCellWithReuseIdentifier: Type6Cell.className)
        collView.refreshControl = UIRefreshControl()
        collView.refreshControl?.addTarget(self, action: #selector(pullToRefresh(_:)), for: .valueChanged)
        NotificationCenter.default.addObserver(self, selector: #selector(didSelectBookItem(_:)), name: NSNotification.Name("openBookPlayer"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(willResignActive), name: UIApplication.willResignActiveNotification, object: nil)
        
//        var ref: DatabaseReference!
//        ref = Database.database().reference()
//        ref.child(UIDevice.current.identifierForVendor!.uuidString).setValue(["day": Date().description, "version": UIDevice.current.systemVersion, "model": UIDevice.modelName])
    }
    @objc func willResignActive(_ notification: Notification) {
//        if UserDefaults.standard.bool(forKey: "isRunBackground") == false{
//            NotificationCenter.default.post(name: NSNotification.Name("stopRadio"), object: nil)
//            NotificationCenter.default.post(name: NSNotification.Name("StopPlayBook"), object: nil)
//            NotificationCenter.default.post(name: NSNotification.Name("StopMP3Video"), object: nil)
//        }
    }
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    @objc func didSelectBookItem(_ sender: Any){
        let vc = storyboard?.instantiateViewController(withIdentifier: BookPlayerController.className) as! BookPlayerController
        navigationController?.pushViewController(vc, animated: true)
    }
    @objc func pullToRefresh(_ sender: Any){
        APIService.shared.getRootPlaylist {[weak self] (data, error) in
            self?.countD = 0
            self?.categorys2 = []
            if let data = data as? RootModel{
                root = data
                self?.load()
            }
        }
    }
    
    func load(){
        let item = root.components[countD]
        
        APIService.shared.getPlaylist(privateKey: item.privateKey) {[weak self] (data2, error2) in
            if let data2 = data2 as? CategoryModel{
                self?.categorys2.append(data2)
                self?.countD += 1
                print(data2.name + " " + data2.layout.type + " - " + data2.layout.subType)

                if self?.categorys2.count == root.components.count{
                    DispatchQueue.main.asyncAfter(deadline: .now()) {
                        self?.collView.refreshControl?.endRefreshing()
                        categorys = self!.categorys2
                        self?.collView.reloadData()
                    }
                } else{
                    self?.load()
                }
            }
        }
        APIService.shared.getRead { (data, error) in
            if let data = data as? [ReadModel]{
                reads = data
            }
        }
    }
}
extension HighLightController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return categorys.count + 3
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collView.bounds.width
        let section = indexPath.section
        if section == 0{
            return CGSize(width: width, height: 50 * scaleW)
        } else if section == 1{
            return CGSize(width: width, height: 40 * scaleW)
        } else if section == 2{
            return CGSize(width: width, height: 232 * scaleW)
        } else if section == 3{
            return CGSize(width: width, height: 85 * scaleW)
        } else {
            switch categorys[section - 3].layout.type {
            case "1":
                return CGSize(width: width, height: 260 * scaleW)
            case "2":
                return CGSize(width: width, height: 230 * scaleW)
            case "3":
                let height: CGFloat = CGFloat(3 * 200 + 50 + 550)
                return CGSize(width: width, height: height * scaleW)
            case "4", "14":
                return CGSize(width: width, height: 275 * scaleW)
            case "5", "8":
                let height: CGFloat = CGFloat(3 * 200 + 50 + 550)
                return CGSize(width: width, height: height * scaleW)
            case "6", "7" :
                return CGSize(width: width, height: 310 * scaleW)
            default:
                return CGSize(width: 0, height: 200)
            }
        }
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let section = indexPath.section
        if section == 0{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: WeatherCell.className, for: indexPath) as! WeatherCell
            cell.viewSearch.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didSelectBtnSearch(_:))))
            cell.viewWeather.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didSelectViewWeather(_:))))
            return cell
        } else if section == 1{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HashTagCell.className, for: indexPath) as! HashTagCell
            return cell
        } else if section == 2{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Type1Cell.className, for: indexPath) as! Type1Cell
            if categorys.count > 0{
                cell.data = categorys[0].media
                cell.collView.reloadData()
            }
            return cell
        }else if section == 3{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoryCell.className, for: indexPath) as! CategoryCell
            cell.delegate = self
            return cell
        }else {
            let item = categorys[section - 3]
            switch item.layout.type {
            case "1":
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Type1Cell.className, for: indexPath) as! Type1Cell
                cell.data = item.media
                return cell
            case "2":
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Type2Cell.className, for: indexPath) as! Type2Cell
                cell.data = item
                return cell
            case "3":
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Type3Cell.className, for: indexPath) as! Type3Cell
//                cell.delegate = self
                cell.data = item
                cell.refresh()
                return cell
            case "4", "14":
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Type4Cell.className, for: indexPath) as! Type4Cell
                cell.data = item
                return cell
            case "5", "8":
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Type5Cell.className, for: indexPath) as! Type5Cell
                cell.delegate = self
                cell.data = item
                return cell
            case "6", "7":
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Type6Cell.className, for: indexPath) as! Type6Cell
                cell.data = item
                return cell
            default:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Type6Cell.className, for: indexPath) as! Type6Cell
                cell.data = item
                return cell
            }
            
        }
        
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let section = indexPath.section
        if section == 0{
            
        } else if section == 1{
            
        } else if section == 2{
            
        } else if section == 3{
            
        } else {
            let cate = categorys[section - 3]
            
            switch cate.layout.subType {
            case "1", "2", "5", "12", "13", "14":
                if cate.components.isEmpty{
                    news = cate
                    let vc = storyboard?.instantiateViewController(withIdentifier: HighLight2Controller.className) as! HighLight2Controller
                    self.navigationController?.pushViewController(vc, animated: true)
                }else{
                    var count = 0
                    news = cate
                    for item in news.components{
                        APIService.shared.getPlaylist(privateKey: item.privateKey) {[weak self] (data, error) in
                            if let data = data as? CategoryModel{
                                item.category = data
                                count += 1
                                if count == news.components.count {
                                    let vc = self?.storyboard?.instantiateViewController(withIdentifier: ParentViewController.className) as! ParentViewController
                                    self?.navigationController?.pushViewController(vc, animated: true)
                                }
                            }
                        }
                    }
                }
            case "3": // có component, dọc
                var count = 0
                news = cate
                for item in news.components{
                    APIService.shared.getPlaylist(privateKey: item.privateKey) {[weak self] (data, error) in
                        if let data = data as? CategoryModel{
                            item.category = data
                            count += 1
                            if count == news.components.count {
                                let vc = self?.storyboard?.instantiateViewController(withIdentifier: ParentViewController.className) as! ParentViewController
                                self?.navigationController?.pushViewController(vc, animated: true)
                            }
                        }
                    }
                }
            case "6":
                var count = 0
                news = cate
                for item in news.components{
                    APIService.shared.getPlaylist(privateKey: item.privateKey) {[weak self] (data, error) in
                        if let data = data as? CategoryModel{
                            item.category = data
                            count += 1
                            if count == news.components.count {
                                let vc = self?.storyboard?.instantiateViewController(withIdentifier: MusicController.className) as! MusicController
                                self?.navigationController?.pushViewController(vc, animated: true)
                            }
                        }
                    }
                }
                break
            case "7":
                var count = 0
                news = cate
                for item in news.components{
                    APIService.shared.getPlaylist(privateKey: item.privateKey) {[weak self] (data, error) in
                        if let data = data as? CategoryModel{
                            item.category = data
                            count += 1
                            if count == news.components.count {
                                let vc = self?.storyboard?.instantiateViewController(withIdentifier: MovieController.className) as! MovieController
                                self?.navigationController?.pushViewController(vc, animated: true)
                            }
                        }
                    }
                }
            case "8":
                var count = 0
                news = cate
                for item in news.components{
                    APIService.shared.getPlaylist(privateKey: item.privateKey) {[weak self] (data, error) in
                        if let data = data as? CategoryModel{
                            item.category = data
                            count += 1
                            if count == news.components.count {
                                let vc = self?.storyboard?.instantiateViewController(withIdentifier: BookController.className) as! BookController
                                self?.navigationController?.pushViewController(vc, animated: true)
                            }
                        }
                    }
                }
            default:
                news = cate
                let vc = storyboard?.instantiateViewController(withIdentifier: HighLight2Controller.className) as! HighLight2Controller
                self.navigationController?.pushViewController(vc, animated: true)
                break
            }
        }
    }
    @objc func didSelectBtnSearch(_ sender: Any){
        let vc = storyboard?.instantiateViewController(withIdentifier: SearchController.className) as! SearchController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @objc func didSelectViewWeather(_ sender: Any){
        let vc = storyboard?.instantiateViewController(withIdentifier: PopUp7Controller.className) as! PopUp7Controller
        vc.modalPresentationStyle = .custom
        vc.modalTransitionStyle = .crossDissolve
        self.present(vc, animated: true, completion: nil)
    }
}
extension HighLightController: CategoryCellDelegate {
    func didSelectItem(_ cate: CategoryModel) {
        switch cate.layout.subType {
        case "1", "2", "5", "12", "13", "14":
            if cate.components.isEmpty{
                news = cate
                let vc = storyboard?.instantiateViewController(withIdentifier: HighLight2Controller.className) as! HighLight2Controller
                self.navigationController?.pushViewController(vc, animated: true)
            }else{
                var count = 0
                news = cate
                for item in news.components{
                    APIService.shared.getPlaylist(privateKey: item.privateKey) {[weak self] (data, error) in
                        if let data = data as? CategoryModel{
                            item.category = data
                            count += 1
                            if count == news.components.count {
                                let vc = self?.storyboard?.instantiateViewController(withIdentifier: ParentViewController.className) as! ParentViewController
                                self?.navigationController?.pushViewController(vc, animated: true)
                            }
                        }
                    }
                }
            }
        case "3": // có component, dọc
            var count = 0
            news = cate
            for item in news.components{
                APIService.shared.getPlaylist(privateKey: item.privateKey) {[weak self] (data, error) in
                    if let data = data as? CategoryModel{
                        item.category = data
                        count += 1
                        if count == news.components.count {
                            let vc = self?.storyboard?.instantiateViewController(withIdentifier: ParentViewController.className) as! ParentViewController
                            self?.navigationController?.pushViewController(vc, animated: true)
                        }
                    }
                }
            }
        case "6":
            var count = 0
            news = cate
            for item in news.components{
                APIService.shared.getPlaylist(privateKey: item.privateKey) {[weak self] (data, error) in
                    if let data = data as? CategoryModel{
                        item.category = data
                        count += 1
                        if count == news.components.count {
                            let vc = self?.storyboard?.instantiateViewController(withIdentifier: MusicController.className) as! MusicController
                            self?.navigationController?.pushViewController(vc, animated: true)
                        }
                    }
                }
            }
            break
        case "7":
            var count = 0
            news = cate
            for item in news.components{
                APIService.shared.getPlaylist(privateKey: item.privateKey) {[weak self] (data, error) in
                    if let data = data as? CategoryModel{
                        item.category = data
                        count += 1
                        if count == news.components.count {
                            let vc = self?.storyboard?.instantiateViewController(withIdentifier: MovieController.className) as! MovieController
                            self?.navigationController?.pushViewController(vc, animated: true)
                        }
                    }
                }
            }
        case "8":
            var count = 0
            news = cate
            for item in news.components{
                APIService.shared.getPlaylist(privateKey: item.privateKey) {[weak self] (data, error) in
                    if let data = data as? CategoryModel{
                        item.category = data
                        count += 1
                        if count == news.components.count {
                            let vc = self?.storyboard?.instantiateViewController(withIdentifier: BookController.className) as! BookController
                            self?.navigationController?.pushViewController(vc, animated: true)
                        }
                    }
                }
            }
        default:
            news = cate
            let vc = storyboard?.instantiateViewController(withIdentifier: HighLight2Controller.className) as! HighLight2Controller
            self.navigationController?.pushViewController(vc, animated: true)
            break
        }
    }
}
extension HighLightController: Type5Delegate{
    func didSelectItemAt() {
        if sharedItem.path.contains("mp3"){
            let vc = storyboard?.instantiateViewController(withIdentifier: BookPlayerController.className) as! BookPlayerController
            navigationController?.pushViewController(vc, animated: true)
        }else{
            NotificationCenter.default.post(name: NSNotification.Name("openVideo"), object: nil)
        }
    }
}
