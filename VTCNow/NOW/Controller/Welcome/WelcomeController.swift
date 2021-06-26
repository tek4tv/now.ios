//
//  WelcomeController.swift
//  VTCNow
//
//  Created by dovietduy on 1/26/21.
//

import UIKit
var isOffClass = false

class WelcomeController: UIViewController {
    @IBOutlet weak var heightLogo: NSLayoutConstraint!
    var count = 0
    var isClickUpdate = false
    var versionAppstore = ""
    var versionApp = ""
    func isUpdateAvailable() throws -> Bool {
        guard let info = Bundle.main.infoDictionary,
              let currentVersion = info["CFBundleShortVersionString"] as? String,
              let identifier = info["CFBundleIdentifier"] as? String,
              let url = URL(string: "http://itunes.apple.com/lookup?bundleId=\(identifier)") else {
            throw VersionError.invalidBundleInfo
        }
        let data = try Data(contentsOf: url)
        guard let json = try JSONSerialization.jsonObject(with: data, options: [.allowFragments]) as? [String: Any] else {
            throw VersionError.invalidResponse
        }
        if let result = (json["results"] as? [Any])?.first as? [String: Any], let version = result["version"] as? String {
            print("Version: \(version)")
            print("CurrenVersion: \(currentVersion)")
            self.versionApp = currentVersion
            self.versionAppstore = version
            return version != currentVersion
        }
        throw VersionError.invalidResponse
    }
    
    enum VersionError: Error {
        case invalidResponse, invalidBundleInfo
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(willResignActive), name: UIApplication.willResignActiveNotification, object: nil)
        //heightLogo.constant = 0
    }
    @objc func willResignActive(_ notification: Notification) {
        if isClickUpdate {
            APIService.shared.getRootPlaylist {[weak self] (data, error) in
                if let data = data as? RootModel{
                    root = data
                    self?.load()
                }
            }
        }
    }
    @available(iOS 12.0, *)
    func checkNetwork(){
        if NetworkMonitor.shared.isConnected {
            DispatchQueue.global().async {
                do {
                    _ = try self.isUpdateAvailable()
                    DispatchQueue.main.async {
                        if self.versionApp != self.versionAppstore {
                            let alert = UIAlertController(title: "Phiên bản VTC NOW mới", message: "Hãy cập nhật ứng dựng để có trải nghiệm tốt nhất", preferredStyle: UIAlertController.Style.alert)
                            alert.addAction(UIAlertAction(title: "Cập nhật", style: .cancel, handler: { action in
                                self.isClickUpdate = true
                                if let url = URL(string: "itms-apps://itunes.apple.com/app/1355778168"),
                                   UIApplication.shared.canOpenURL(url){
                                    UIApplication.shared.open(url)
                                }
                            }))
                            alert.addAction(UIAlertAction(title: "Bỏ qua", style: .destructive, handler: { action in
                                APIService.shared.getRootPlaylist {[weak self] (data, error) in
                                    if let data = data as? RootModel{
                                        root = data
                                        self?.load()
                                    }
                                }
                            }))
                            self.present(alert, animated: true, completion: nil)
                        } else {
                            APIService.shared.getRootPlaylist {[weak self] (data, error) in
                                if let data = data as? RootModel{
                                    root = data
                                    self?.load()
                                }
                            }
                        }
                    }
                } catch {
                    print(error)
                }
            }
                
        } else{
            let alert = UIAlertController(title: "Không có kết nối mạng", message: "Hãy kiểm tra lại kết nối mạng của bạn trong cài đặt", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Thử lại", style: UIAlertAction.Style.default, handler: { action in
                self.checkNetwork()
            }
            ))
            self.present(alert, animated: true, completion: nil)
        }
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
       // self.heightLogo.constant = 128 * scaleW
        if #available(iOS 12.0, *) {
            checkNetwork()
        } else {
            // Fallback on earlier versions
            UIView.animate(withDuration: 0.5,delay: 0, options: [],animations: { [weak self] in
                self?.view.layoutIfNeeded()
                APIService.shared.getRootPlaylist {[weak self] (data, error) in
                    if let data = data as? RootModel{
                        root = data
                        self?.load()
                    }
                }
            }, completion: nil)
        }
    }
    func load(){
        let item = root.components[count]
        APIService.shared.getPlaylist(privateKey: item.privateKey) {[weak self] (data2, error2) in
            if let data2 = data2 as? CategoryModel{
                categorys.append(data2)
                self?.count += 1
//                print(data2.name + " " + data2.layout.type + " - " + data2.layout.subType)
                if categorys.count == root.components.count{
                    APIService.shared.getLive { (data, error) in
                        if let data = data as? [ChannelModel]{
                            lives = data
                        }
                        APIService.shared.getOverView { (data, error) in
                            if let data = data as? CategoryModel {
                                overView = data
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

