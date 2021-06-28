//
//  HighLightController.swift
//  NOW
//
//  Created by dovietduy on 1/29/21.
//

import UIKit
import AVFoundation
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
        collView.register(UINib(nibName: Type7Cell.className, bundle: nil), forCellWithReuseIdentifier: Type7Cell.className)
        collView.register(UINib(nibName: Type8Cell.className, bundle: nil), forCellWithReuseIdentifier: Type8Cell.className)
        collView.register(UINib(nibName: Type9Cell.className, bundle: nil), forCellWithReuseIdentifier: Type9Cell.className)
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
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.post(name: NSNotification.Name("StopVOD5"), object: nil)
    }
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    @objc func didSelectBookItem(_ sender: Any){
        let vc = storyboard?.instantiateViewController(withIdentifier: BookPlayerController.className) as! BookPlayerController
        navigationController?.pushViewController(vc, animated: false)
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
                if data2.name == "Sách hay"{
                    bookCate = data2
                } else{
                    self?.categorys2.append(data2)
                    self?.countD += 1
//                    print(data2.name + " " + data2.layout.type + " - " + data2.layout.subType)
                }
                if self?.categorys2.count == root.components.count - 1{
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
//        return categorys.count + 2
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = 414 * scaleW
        let section = indexPath.section
        if section == 0{
            return CGSize(width: width, height: 80 * scaleW)
//        } else if section == 1 {
//            return CGSize(width: width, height: 232 * scaleW)
//        } else if section == 2 {
//            return CGSize(width: width, height: 105 * scaleW)
        } else if section == 1{
            return CGSize(width: width, height: 60 * scaleW)
        } else if section == 2{
            return CGSize(width: width, height: 260 * scaleW)
        } else if section == 3{
            return CGSize(width: width, height: 115 * scaleW)
        } else {
            let item = categorys[section - 3]
//            let item = categorys[section - 2]
            switch item.layout.type {
            case "1":
                return CGSize(width: width, height: 260 * scaleW)
            case "2":
                let temp = 70 + 180 + 160
                let height: CGFloat = CGFloat(temp)
                return CGSize(width: width, height: height * scaleW)
            case "3":
                var temp = 70 + 12 * 220 + 385 + 210 + 320 + 25 * 8 + 25 * 7 + 30 + 160
                if isOffClass{
                    temp = 70 + 12 * 220 + 385 + 210 + 320 + 25 * 8 + 25 * 7 + 30
                }
                let height: CGFloat = CGFloat(temp)
                return CGSize(width: width, height: height * scaleW)
            case "4", "14":
                if item.name == "Phim bộ"{
                    let temp = 70 + 200 + 10
                    let height: CGFloat = CGFloat(temp)
                    return CGSize(width: width, height: height * scaleW)
                }
                let temp = 70 + 180 * 2 + 30
                let height: CGFloat = CGFloat(temp)
                return CGSize(width: width, height: height * scaleW)
            case "5", "8":
                if item.name == "Âm nhạc"{
                    let temp = 70 + 180 * 2 + 30
                    let height: CGFloat = CGFloat(temp)
                    return CGSize(width: width, height: height * scaleW)
                }
                let temp = 70 + 210
                let height: CGFloat = CGFloat(temp)
                return CGSize(width: width, height: height * scaleW)
            case "6", "7" :
                let temp = 70 + 260 + 15
                let height: CGFloat = CGFloat(temp)
                return CGSize(width: width, height: height * scaleW )
            default:
                return CGSize(width: 0, height: 200)
            }
        }
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let section = indexPath.section
        if section == 0{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: WeatherCell.className, for: indexPath) as! WeatherCell
            cell.delegate = self
            cell.viewSearch.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didSelectBtnSearch(_:))))
            return cell
        } else if section == 1{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HashTagCell.className, for: indexPath) as! HashTagCell
            cell.delegate = self
            return cell
        } else if section == 2{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Type1Cell.className, for: indexPath) as! Type1Cell
            if categorys.count > 0{
                cell.delegate = self
                cell.data = categorys[0]
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
                cell.delegate = self
                cell.data = item
                return cell
            case "2":
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Type2Cell.className, for: indexPath) as! Type2Cell
                cell.delegate = self
                cell.data = item
                return cell
            case "3":
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Type3Cell.className, for: indexPath) as! Type3Cell
                cell.delegate = self
                cell.data = item
                cell.refresh()
                return cell
            case "4", "14":
                if item.name == "Phim bộ"{
                    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Type9Cell.className, for: indexPath) as! Type9Cell
                    cell.delegate = self
                    cell.data = item
                    return cell
                }
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Type4Cell.className, for: indexPath) as! Type4Cell
                cell.delegate = self
                cell.data = item
                return cell
            case "5", "8":
                if item.name == "Âm nhạc"{
                    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Type8Cell.className, for: indexPath) as! Type8Cell
                    cell.delegate = self
                    cell.data = item
                    return cell
                }
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Type5Cell.className, for: indexPath) as! Type5Cell
                cell.delegate = self
                cell.data = item
                return cell
            case "6", "7":
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Type6Cell.className, for: indexPath) as! Type6Cell
                cell.delegate = self
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
            case "1", "2", "12", "13", "14":
                if cate.components.isEmpty{
                    news = cate
                    let vc = storyboard?.instantiateViewController(withIdentifier: HighLight2Controller.className) as! HighLight2Controller
                    self.navigationController?.pushViewController(vc, animated: false)
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
                                    self?.navigationController?.pushViewController(vc, animated: false)
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
                                self?.navigationController?.pushViewController(vc, animated: false)
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
                                self?.navigationController?.pushViewController(vc, animated: false)
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
                                self?.navigationController?.pushViewController(vc, animated: false)
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
                                self?.navigationController?.pushViewController(vc, animated: false)
                            }
                        }
                    }
                }
            case "5":
                news = cate
                let vc = storyboard?.instantiateViewController(withIdentifier: MovieSetController.className) as! MovieSetController
                vc.isPushByTVShow = true
                navigationController?.pushViewController(vc, animated: false)
            case "20":
                news = cate
                let vc = storyboard?.instantiateViewController(withIdentifier: MovieSetController.className) as! MovieSetController
                navigationController?.pushViewController(vc, animated: false)
            default:
                news = cate
                let vc = storyboard?.instantiateViewController(withIdentifier: HighLight2Controller.className) as! HighLight2Controller
                self.navigationController?.pushViewController(vc, animated: false)
                break
            }
        }
    }
    @objc func didSelectBtnSearch(_ sender: Any){
        let vc = storyboard?.instantiateViewController(withIdentifier: SearchController.className) as! SearchController
        self.navigationController?.pushViewController(vc, animated: false)
    }
}
extension HighLightController: WeatherDelegate{
    func didSelectViewWeather(_ listW: WeatherModel) {
        let vc = storyboard?.instantiateViewController(withIdentifier: PopUp7Controller.className) as! PopUp7Controller
        vc.modalPresentationStyle = .custom
        vc.modalTransitionStyle = .crossDissolve
        vc.item = listW
        self.present(vc, animated: true, completion: nil)
    }

}
extension HighLightController: CategoryCellDelegate {
    func didSelectItem(_ cate: CategoryModel) {
        switch cate.layout.subType {
        case "1", "2", "12", "13", "14":
            if cate.components.isEmpty{
                news = cate
                let vc = storyboard?.instantiateViewController(withIdentifier: HighLight2Controller.className) as! HighLight2Controller
                self.navigationController?.pushViewController(vc, animated: false)
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
                                self?.navigationController?.pushViewController(vc, animated: false)
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
                            self?.navigationController?.pushViewController(vc, animated: false)
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
                            self?.navigationController?.pushViewController(vc, animated: false)
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
                            self?.navigationController?.pushViewController(vc, animated: false)
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
                            self?.navigationController?.pushViewController(vc, animated: false)
                        }
                    }
                }
            }
        case "5":
            news = cate
            let vc = storyboard?.instantiateViewController(withIdentifier: MovieSetController.className) as! MovieSetController
            vc.isPushByTVShow = true
            navigationController?.pushViewController(vc, animated: false)
        case "20":
            news = cate
            let vc = storyboard?.instantiateViewController(withIdentifier: MovieSetController.className) as! MovieSetController
            navigationController?.pushViewController(vc, animated: false)
        default:
            news = cate
            let vc = storyboard?.instantiateViewController(withIdentifier: HighLight2Controller.className) as! HighLight2Controller
            self.navigationController?.pushViewController(vc, animated: false)
            break
        }
    }
}
extension HighLightController: Type1CellDelegate{
    func didSelectItemAt(_ cell: Type1Cell) {
        let vc = storyboard?.instantiateViewController(withIdentifier: HighLight2Controller.className) as! HighLight2Controller
        self.navigationController?.pushViewController(vc, animated: false)
    }
    
//    func didSelectItemAt(_ data: MediaModel, _ list: [MediaModel], _ cell: Type1Cell) {
//        let vc = storyboard?.instantiateViewController(withIdentifier: VideoController.className) as! VideoController
//        vc.item = data
//        vc.listData = list
//        navigationController?.pushViewController(vc, animated: false)
//    }
}
extension HighLightController: Type2CellDelegate{
    func didSelectBanner(_ cell: Type2Cell) {
        APIService.shared.getPlaylist(privateKey: smallBanner.privateKey) {[weak self] (data, error) in
            if let data = data as? CategoryModel {
                news = data
                let vc = self?.storyboard?.instantiateViewController(withIdentifier: HighLight2Controller.className) as! HighLight2Controller
                self?.navigationController?.pushViewController(vc, animated: false)
            }
        }
    }
    
    func didSelectItemAt(_ cell: Type2Cell) {
        let vc = storyboard?.instantiateViewController(withIdentifier: HighLight2Controller.className) as! HighLight2Controller
        self.navigationController?.pushViewController(vc, animated: false)
    }
    func didSelectViewMore(_ cell: Type2Cell) {
        news = cell.data
        let vc = storyboard?.instantiateViewController(withIdentifier: HighLight2Controller.className) as! HighLight2Controller
        self.navigationController?.pushViewController(vc, animated: false)
    }
}
extension HighLightController: Type3CellDelegate{
    func didSelectOverViewLabel() {
        news = overView2
        let vc = storyboard?.instantiateViewController(withIdentifier: HighLight2Controller.className) as! HighLight2Controller
        vc.isLoadMore = false
        self.navigationController?.pushViewController(vc, animated: false)
    }
    
    func didSelectOverView() {
        let vc = storyboard?.instantiateViewController(withIdentifier: HighLight2Controller.className) as! HighLight2Controller
        vc.isLoadMore = false
        self.navigationController?.pushViewController(vc, animated: false)
    }
    
    func didSelectBanner() {
        let vc = storyboard?.instantiateViewController(withIdentifier: HighLight2Controller.className) as! HighLight2Controller
        vc.isLoadMore = false
        self.navigationController?.pushViewController(vc, animated: false)
    }
    func didSelectBannerClass() {
        APIService.shared.getPlaylist(privateKey: "7d20527f-5946-4b64-a42b-c33f9a5993aa") { (data, error) in
            if let data = data as? CategoryModel{
                let vc = self.storyboard?.instantiateViewController(withIdentifier: MovieSetController.className) as! MovieSetController
                news = data
                vc.isPushByTVShow = true
                self.navigationController?.pushViewController(vc, animated: false)
            }
        }
    }
    func didSelectViewShare(_ cell: VideoCell) {
        guard let url = URL(string: "https://now.vtc.vn/viewvod/a/\(cell.item.privateID).html") else {
            return
        }
        let itemsToShare = [url]
        let ac = UIActivityViewController(activityItems: itemsToShare, applicationActivities: nil)
        ac.popoverPresentationController?.sourceView = self.view
        self.present(ac, animated: true)
    }
    
    func didSelectViewSetting(_ cell: VideoCell) {
        let vc = storyboard?.instantiateViewController(withIdentifier: PopUp2Controller.className) as! PopUp2Controller
        vc.modalPresentationStyle = .custom
        vc.modalTransitionStyle = .crossDissolve
        vc.listResolution = cell.listResolution
        vc.speed = cell.speed
        vc.onComplete = { list in
            cell.listResolution = list
            cell.setBitRate()
        }
        vc.onTickedSpeed = { value in
            cell.speed = value
            cell.setSpeed()
        }
        present(vc, animated: true, completion: nil)
    }
    
    func didSelectViewFullScreen(_ cell: VideoCell, _ newPlayer: AVPlayer) {
        if #available(iOS 13.0, *) {
            let vc = storyboard?.instantiateViewController(withIdentifier: FullScreenController.className) as! FullScreenController
            vc.player = newPlayer
            vc.item = cell.item
            vc.listResolution = cell.listResolution
            vc.onDismiss = { () in
                cell.viewPlayer.player = vc.viewPlayer.player
                vc.player = nil
                cell.viewPlayer.player?.play()
                cell.isPlaying = true
                cell.btnPlay.setBackgroundImage(#imageLiteral(resourceName: "PAUSE"), for: .normal)
            }
            vc.modalPresentationStyle = .fullScreen
            present(vc, animated: true, completion: nil)
        } else {
            let vc = PlayerViewController()
            vc.player = newPlayer
            vc.videoGravity = .resizeAspect
            vc.onDismiss = { () in
                cell.viewPlayer.player = vc.player
                vc.player = nil
                cell.viewPlayer.player?.play()
                cell.isPlaying = true
                cell.btnPlay.setBackgroundImage(#imageLiteral(resourceName: "PAUSE"), for: .normal)
            }
            present(vc, animated: true) {
                vc.player?.play()
                vc.addObserver(self, forKeyPath: #keyPath(UIViewController.view.frame), options: [.old, .new], context: nil)
            }
        }
    }
    
    func didSelectViewImage(_ cell: Type3ItemCell) {
        let vc = storyboard?.instantiateViewController(withIdentifier: HighLight2Controller.className) as! HighLight2Controller
        self.navigationController?.pushViewController(vc, animated: false)
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
extension HighLightController: Type4CellDelegate{
    func didSelectItemAt(_ data: MediaModel, _ listData: [MediaModel], _ cell: Type4Cell) {
        if data.endTimecode != ""{
            APIService.shared.getRelatedEpisode(code: data.endTimecode) {[weak self] (list1, error) in
                if let list1 = list1 as? [MediaModel] {
                    let vc = self?.storyboard?.instantiateViewController(withIdentifier: VideoController.className) as! VideoController
                    vc.item = data
                    vc.listData = list1
                    self?.navigationController?.pushViewController(vc, animated: false)
                }
            }
        } else{
            let vc = storyboard?.instantiateViewController(withIdentifier: VideoController.className) as! VideoController
            vc.item = data
            vc.listData = listData
            navigationController?.pushViewController(vc, animated: false)
        }
    }
}
extension HighLightController: Type8CellDelegate{
    func didSelectItemAt(_ data: MediaModel, _ listData: [MediaModel], _ cell: Type8Cell) {
        let vc = storyboard?.instantiateViewController(withIdentifier: MusicPlayerController.className) as! MusicPlayerController
        vc.item = data
        vc.listData = listData
        navigationController?.pushViewController(vc, animated: false)
    }
}
extension HighLightController: Type5CellDelegate{
    func didSelectViewImage() {
        let vc = storyboard?.instantiateViewController(withIdentifier: HighLight2Controller.className) as! HighLight2Controller
        self.navigationController?.pushViewController(vc, animated: false)
    }
    
    func didSelectView2Share(_ cell: Type3ItemCell) {
        guard let url = URL(string: "https://now.vtc.vn/viewvod/a/\(cell.data.privateID).html") else {
            return
        }
        let itemsToShare = [url]
        let ac = UIActivityViewController(activityItems: itemsToShare, applicationActivities: nil)
        ac.popoverPresentationController?.sourceView = self.view
        self.present(ac, animated: true)
    }
    func didSelectViewMore(_ cell: Type5Cell) {
        news = cell.data
        let vc = storyboard?.instantiateViewController(withIdentifier: HighLight2Controller.className) as! HighLight2Controller
        self.navigationController?.pushViewController(vc, animated: false)
    }
}
extension HighLightController: Type9CellDelegate{
    func didSelectViewImage(_ data: MediaModel, _ list: [MediaModel], _ cell: Type9Cell) {
        if data.endTimecode != ""{
            APIService.shared.getRelatedEpisode(code: data.endTimecode) {[weak self] (list1, error) in
                if let list1 = list1 as? [MediaModel] {
                    let vc = self?.storyboard?.instantiateViewController(withIdentifier: VideoController.className) as! VideoController
                    vc.item = data
                    vc.listData = list1
                    self?.navigationController?.pushViewController(vc, animated: false)
                }
            }
        } else{
            let vc = storyboard?.instantiateViewController(withIdentifier: VideoController.className) as! VideoController
            vc.item = data
            vc.listData = list
            navigationController?.pushViewController(vc, animated: false)
        }
        
    }
    
//    func didSelectView2Share(_ cell: Type3ItemCell) {
//        guard let url = URL(string: cell.data.path) else {
//            return
//        }
//        let itemsToShare = [url]
//        let ac = UIActivityViewController(activityItems: itemsToShare, applicationActivities: nil)
//        ac.popoverPresentationController?.sourceView = self.view
//        self.present(ac, animated: true)
//    }
    func didSelectViewMore(_ cell: Type9Cell) {
        news = cell.data
        let vc = storyboard?.instantiateViewController(withIdentifier: HighLight2Controller.className) as! HighLight2Controller
        self.navigationController?.pushViewController(vc, animated: false)
    }
}
extension HighLightController: Type6CellDelegate{
    func didSelectItemAt(_ data: MediaModel, _ list: [MediaModel], _ cell: Type6Cell) {
        let vc = storyboard?.instantiateViewController(withIdentifier: VideoController.className) as! VideoController
        vc.item = data
        vc.listData = list
        navigationController?.pushViewController(vc, animated: false)
    }
    func didSelectViewMore(_ cell: Type6Cell) {
        var count = 0
        news = cell.data
        for item in news.components{
            APIService.shared.getPlaylist(privateKey: item.privateKey) {[weak self] (data, error) in
                if let data = data as? CategoryModel{
                    item.category = data
                    count += 1
                    if count == news.components.count {
                        let vc = self?.storyboard?.instantiateViewController(withIdentifier: MovieController.className) as! MovieController
                        self?.navigationController?.pushViewController(vc, animated: false)
                    }
                }
            }
        }
    }
}

extension HighLightController: HashTagCellDelegate{
    func didSelectItemAt(_ word: String) {
        APIService.shared.searchWithTag(privateKey: word, keySearch: ""){[self] (data, error) in
            if let data = data as? [MediaModel]{
                let vc = storyboard?.instantiateViewController(withIdentifier: HighLight2Controller.className) as! HighLight2Controller
                news.media = data
                vc.isPushByHashTag = true
                vc.isLoadMore = false
                navigationController?.pushViewController(vc, animated: false)
            }
        }
    }

}
extension HighLightController: UIScrollViewDelegate{
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        NotificationCenter.default.post(name: NSNotification.Name("scrollViewDidScroll"), object: nil)
    }
}
