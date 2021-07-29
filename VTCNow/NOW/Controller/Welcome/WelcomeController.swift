//
//  WelcomeController.swift
//  VTCNow
//
//  Created by dovietduy on 1/26/21.
//

import UIKit
import Kingfisher
import AVFoundation
var isOffClass = false
var overViewImages: [UIImage?] = []
class WelcomeController: UIViewController {
    // @IBOutlet weak var heightLogo: NSLayoutConstraint!
    @IBOutlet weak var viewAlert: UIView!
    @IBOutlet weak var viewShadow: UIView!
    @IBOutlet weak var imgThumb: UIImageView!
    @IBOutlet weak var lbl3: UILabel!
    @IBOutlet weak var lbl4: UILabel!
    var count = 0
    var isClickUpdate = false
    var versionAppstore = ""
    var versionApp = ""
    var isConnectWifi = false
    let activityIndicatorView: UIActivityIndicatorView = {
        let aiv = UIActivityIndicatorView(style: .whiteLarge)
        aiv.color = #colorLiteral(red: 0.5225926042, green: 0.0004706631007, blue: 0.2674992383, alpha: 1)
        aiv.translatesAutoresizingMaskIntoConstraints = false
        return aiv
    }()
    func getCurrentVersion() throws {
        guard let info = Bundle.main.infoDictionary,
              let currentVersion = info["CFBundleShortVersionString"] as? String
        else {
            throw VersionError.invalidBundleInfo
        }
        self.versionApp = currentVersion
    }
    
    @IBAction func didSelectViewCapNhat(_ sender: Any) {
        self.isClickUpdate = true
        if let url = URL(string: "itms-apps://itunes.apple.com/app/1355778168"),
           UIApplication.shared.canOpenURL(url){
            UIApplication.shared.open(url)
        }
    }
    @IBAction func didSelectViewDeSau(_ sender: UIButton) {
        APIService.shared.getRootPlaylist {[weak self] (data, error) in
            if let data = data as? RootModel{
                root = data
                self?.load()
            }
        }
        viewShadow.backgroundColor = .clear
        viewShadow.addSubview(activityIndicatorView)
        activityIndicatorView.centerXAnchor.constraint(equalTo: viewShadow.centerXAnchor).isActive = true
        activityIndicatorView.centerYAnchor.constraint(equalTo: viewShadow.centerYAnchor).isActive = true
        activityIndicatorView.startAnimating()
        viewAlert.isHidden = true
    }
    enum VersionError: Error {
        case invalidResponse, invalidBundleInfo
    }
    @objc func didSelectViewContainer(_ sender: Any){
        lbl3.textColor = .darkGray
        lbl4.textColor = .darkGray
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.lbl3.textColor = .lightGray
            self.lbl4.textColor = .lightGray
        }
        if isConnectWifi == false{
            if #available(iOS 12.0, *) {
                self.checkNetwork()
            } else {
                
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didSelectViewContainer(_:))))
        NotificationCenter.default.addObserver(self, selector: #selector(willResignActive), name: UIApplication.willResignActiveNotification, object: nil)
        viewShadow.alpha = 0.5
        do {
            try getCurrentVersion()
        } catch {
            print(error)
        }
    }
    
    deinit{
        NotificationCenter.default.removeObserver(self)
    }
    @objc func willResignActive(_ notification: Notification) {
        if isClickUpdate {
            count = 0
            APIService.shared.getRootPlaylist {[weak self] (data, error) in
                if let data = data as? RootModel{
                    root = data
                    self?.load()
                    NotificationCenter.default.removeObserver(self!)
                }
            }
        }
    }
    @available(iOS 12.0, *)
    func checkNetwork(){
        if NetworkMonitor.shared.isConnected {
            isConnectWifi = true
            APIService.shared.getAppVersion { data, error in
                if error != nil {
                    self.lbl3.isHidden = true
                    self.lbl4.isHidden = true
                    self.imgThumb.isHidden = true
                    self.count = 0
                    APIService.shared.getRootPlaylist {[weak self] (data, error) in
                        if let data = data as? RootModel{
                            root = data
                            self?.load()
                        }
                    }
                } else {
                    if let data = data as? String {
                        //                        print(data)
                        //                        print(self.versionApp)
                        if data != self.versionApp {
                            self.lbl3.isHidden = true
                            self.lbl4.isHidden = true
                            self.imgThumb.isHidden = true
                            self.viewShadow.isHidden = false
                            self.viewAlert.isHidden = false
                        } else {
                            self.lbl3.isHidden = true
                            self.lbl4.isHidden = true
                            self.imgThumb.isHidden = true
                            self.viewShadow.isHidden = true
                            self.viewAlert.isHidden = true
                            self.count = 0
                            APIService.shared.getRootPlaylist {[weak self] (data, error) in
                                if let data = data as? RootModel{
                                    root = data
                                    self?.load()
                                }
                            }
                        }
                    }
                }
            }
        } else{
            self.isConnectWifi = false
            self.lbl3.isHidden = false
            self.lbl4.isHidden = false
            self.imgThumb.isHidden = false
            self.viewShadow.isHidden = true
            self.viewAlert.isHidden = true
        }
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        ImageCache.default.diskStorage.config.expiration = .days(2)
        if #available(iOS 12.0, *) {
            checkNetwork()
        } else {
            // Fallback on earlier versions
            self.lbl3.isHidden = true
            self.lbl4.isHidden = true
            self.imgThumb.isHidden = true
            self.count = 0
            APIService.shared.getRootPlaylist {[weak self] (data, error) in
                if let data = data as? RootModel{
                    root = data
                    self?.load()
                }
            }
        }
    }
    func load(){
        if count < root.components.count {
            let item = root.components[count]
            APIService.shared.getPlaylist(privateKey: item.privateKey) {[weak self] (data2, error2) in
                if let data2 = data2 as? CategoryModel{
                    categorys.append(data2)
                    self?.count += 1
                    // print(data2.name + " " + data2.layout.type + " - " + data2.layout.subType)
                    if categorys.count == root.components.count{
                        APIService.shared.getOverView { (data, error) in
                            if let data = data as? CategoryModel {
                                overView = data
                                overViewImages = [UIImage?](repeating: nil, count: overView.media.count)
                                for (index, item) in overView.media.enumerated() {
                                    let imageView = UIImageView()
                                    if let url = URL(string: root.cdn.imageDomain + item.thumnail800_450.replacingOccurrences(of: "\\", with: "/" )){
                                        imageView.kf.setImage(with: url, options: [.cacheOriginalImage]) { result in
                                            switch result {
                                            case .success(_):
                                                overViewImages[index] = imageView.image
                                            case .failure(_):
                                                break
                                            }
                                        }
                                    }
                                }
                            }
                            APIService.shared.getOverViewVideo { (data, error) in
                                if let data = data as? CategoryModel {
                                    overView2 = data
                                }
                                APIService.shared.getBanner { (data, error) in
                                    if let data = data as? CategoryModel{
                                        banner = data
                                    }
                                    APIService.shared.getVideoHot { (data, error) in
                                        if let data = data as? CategoryModel{
                                            videoHot = data
                                        }
                                        APIService.shared.getSmallBanner { (data, error) in
                                            if let data = data as? CategoryModel {
                                                smallBanner = data
                                            }
                                            self?.activityIndicatorView.stopAnimating()
                                            
                                            let vc = self?.storyboard?.instantiateViewController(withIdentifier: HomeController.className) as! HomeController
                                            vc.modalTransitionStyle = .crossDissolve
                                            vc.modalPresentationStyle = .fullScreen
                                            self?.navigationController?.pushViewController(vc, animated: false)
                                        }
                                        APIService.shared.getPlaylist(privateKey: "7d20527f-5946-4b64-a42b-c33f9a5993aa") { (data, error) in
                                            if let data = data as? CategoryModel{
                                                let orderId = data.orderID
                                                if orderId < 0 {
                                                    isOffClass = true
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                        
                    } else{
                        self?.load()
                    }
                    if data2.name == "Sách hay"{
                        bookCate = data2
                        categorys.removeLast()
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
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

extension WelcomeController{
    override var preferredStatusBarStyle: UIStatusBarStyle {
        if #available(iOS 13.0, *) {
            return .darkContent
        } else {
            // Fallback on earlier versions
            return .default
        }
    }
}
