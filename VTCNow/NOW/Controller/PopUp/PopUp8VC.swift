//
//  PopUp8VC.swift
//  NOW
//
//  Created by Apple on 05/07/2021.
//

import UIKit

class PopUp8VC: UIViewController {
    var isClickUpdate = false
    var count = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(willResignActive), name: UIApplication.willResignActiveNotification, object: nil)
    }
    deinit{
        NotificationCenter.default.removeObserver(self)
    }
    @IBAction func didSelectBtnDeSau(_ sender: UIButton) {
        APIService.shared.getRootPlaylist {[weak self] (data, error) in
            if let data = data as? RootModel{
                root = data
                self?.load()
            }
        }
    }
    @IBAction func didSelectBtnCapNhat(_ sender: Any) {
        self.isClickUpdate = true
        if let url = URL(string: "itms-apps://itunes.apple.com/app/1355778168"),
           UIApplication.shared.canOpenURL(url){
            UIApplication.shared.open(url)
        }
    }
    @objc func willResignActive(_ notification: Notification) {
        if isClickUpdate {
            APIService.shared.getRootPlaylist {[weak self] (data, error) in
                if let data = data as? RootModel{
                    root = data
                    self?.load()
                    NotificationCenter.default.removeObserver(self!)
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
                    print(data2.name + " " + data2.layout.type + " - " + data2.layout.subType)
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
                                                vc.modalPresentationStyle = .fullScreen
                                                self?.present(vc, animated: false, completion: nil)
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
}
