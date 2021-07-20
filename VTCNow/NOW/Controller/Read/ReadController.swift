//
//  ReadController.swift
//  NOW
//
//  Created by dovietduy on 3/2/21.
//

import UIKit
import FirebaseDynamicLinks
extension ReadController{
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
class ReadController: UIViewController {
    @IBOutlet weak var collView: UICollectionView!
    var page = 1
    override func viewDidLoad() {
        super.viewDidLoad()
        collView.delegate = self
        collView.dataSource = self
        collView.register(UINib(nibName: WeatherCell.reuseIdentifier, bundle: nil), forCellWithReuseIdentifier: WeatherCell.reuseIdentifier)
        collView.register(UINib(nibName: ReadCell.reuseIdentifier, bundle: nil), forCellWithReuseIdentifier: ReadCell.reuseIdentifier)
        // Do any additional setup after loading the view.
        let layout = UICollectionViewFlowLayout()
        //layout.itemSize = CGSize(width: 414 * scaleW, height: 434 * scaleW)
        collView.collectionViewLayout = layout
        collView.refreshControl = UIRefreshControl()
        collView.refreshControl?.addTarget(self, action: #selector(pullToRefresh(_:)), for: .valueChanged)
    }
    @objc func pullToRefresh(_ sender: Any){
        reads = []
        page = 1
        APIService.shared.getRead { (data, error) in
            if let data = data as? [ReadModel]{
                reads = data
                self.collView.refreshControl?.endRefreshing()
                self.collView.reloadData()
            }
        }
    }
}
extension ReadController: UICollectionViewDelegate, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        default:
            return reads.count
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch indexPath.section {
        case 0:
            return CGSize(width: 414 * scaleW, height: 70 * scaleW)
        default:
            return CGSize(width: 414 * scaleW, height: 434 * scaleW)
        }
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            break
        default:
            if indexPath.row == reads.count - 5{
                page += 1
                APIService.shared.getRead (page: page.description) { (data, error) in
                    if let data = data as? [ReadModel]{
                        reads += data
                        self.collView.reloadData()
                    }
                }
            }
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
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ReadCell.reuseIdentifier, for: indexPath) as! ReadCell
            if indexPath.row < reads.count{
                let item = reads[indexPath.row]
                cell.delegate = self
                cell.lblTitle.text = item.title
                cell.lblDescription.text = item.description
                cell.lblTime.text = "· " + item.getTimePass()
                if let url = URL(string: item.image344_220){
                    cell.imgThumb.loadImage(fromURL: url)
                }
                cell.item = item
            }
            
            return cell
        }
        
        
    }
    @objc func didSelectBtnSearch(_ sender: Any){
        let vc = storyboard?.instantiateViewController(withIdentifier: SearchController.className) as! SearchController
        self.navigationController?.pushViewController(vc, animated: false)
    }
}
extension ReadController: WeatherDelegate{
    func didSelectViewWeather(_ listW: WeatherModel) {
        let vc = storyboard?.instantiateViewController(withIdentifier: PopUp7Controller.className) as! PopUp7Controller
        vc.modalPresentationStyle = .custom
        vc.modalTransitionStyle = .crossDissolve
        vc.item = listW
        self.present(vc, animated: true, completion: nil)
    }

}
extension ReadController: UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            break
        default:
            let vc = storyboard?.instantiateViewController(withIdentifier: ReadDetailWebviewController.className) as! ReadDetailWebviewController
            vc.url = reads[indexPath.row].detailUrl
            navigationController?.pushViewController(vc, animated: false)
        }
    }
}
extension ReadController: ReadCellDelegate{
    func didSelectViewShare(_ cell: ReadCell) {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "www.now.vtc.vn"
        components.path = "/about"
        let itemIDQueryItem = URLQueryItem(name: "id", value: "\(cell.item.detailUrl)")
        let typeQueryItem = URLQueryItem(name: "type", value: "news")
        components.queryItems = [typeQueryItem, itemIDQueryItem]
        
        guard let linkParameter = components.url else { return }
        //print("I am sharing \(linkParameter.absoluteString)")
        
        // Create the big dynamic link
        guard let sharedLink = DynamicLinkComponents.init(link: linkParameter, domainURIPrefix: "https://h6z5d.app.goo.gl") else {
           // print("Couldn't create FDL components")
            return
        }
        
        sharedLink.iOSParameters = DynamicLinkIOSParameters(bundleID: "vn.vtc.now")
        sharedLink.iOSParameters?.appStoreID = "1355778168"
        sharedLink.iOSParameters?.minimumAppVersion = "1.3.0"
        sharedLink.iOSParameters?.fallbackURL = URL(string: cell.item.detailUrl)
        sharedLink.androidParameters = DynamicLinkAndroidParameters(packageName: "com.accedo.vtc")
        sharedLink.socialMetaTagParameters = DynamicLinkSocialMetaTagParameters()
        sharedLink.socialMetaTagParameters?.title = "\(cell.item.title)"
        sharedLink.socialMetaTagParameters?.imageURL = URL(string: cell.item.image344_220)
        guard let longURL = sharedLink.url else { return }
        //print("The long dynamic link is \(longURL.absoluteString)")
        
        sharedLink.shorten { url, warnings, error in
            if let error = error {
                print("Oh no! Got error \(error)")
                return
            }
//            if let warnings = warnings {
//                for warning in warnings {
//                    //print("FDL warnings: \(warning)")
//                }
//            }
            guard let url = url else {return}
            //print("I have a short URL to share! \(url.absoluteString)")
            let ac = UIActivityViewController(activityItems: [url], applicationActivities: nil)
            ac.popoverPresentationController?.sourceView = self.view
            self.present(ac, animated: true)
        }
//        guard let url = URL(string: cell.item.detailUrl) else {
//            return
//        }
//        let itemsToShare = [url]
//        let ac = UIActivityViewController(activityItems: itemsToShare, applicationActivities: nil)
//        ac.popoverPresentationController?.sourceView = self.view
//        self.present(ac, animated: false)
    }
    
    
}
