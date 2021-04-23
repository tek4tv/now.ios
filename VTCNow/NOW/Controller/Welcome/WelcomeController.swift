//
//  WelcomeController.swift
//  VTCNow
//
//  Created by dovietduy on 1/26/21.
//

import UIKit

class WelcomeController: UIViewController {
    @IBOutlet weak var heightLogo: NSLayoutConstraint!
    var count = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        heightLogo.constant = 0
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.heightLogo.constant = 128 
        UIView.animate(withDuration: 0.5,
                       delay: 0,
                       options: [],
                       animations: { [weak self] in
                        self?.view.layoutIfNeeded()
                        APIService.shared.getRootPlaylist {[weak self] (data, error) in
                            if let data = data as? RootModel{
                                root = data
                                self?.load()
                            }
                        }
          }, completion: nil)

    }
    func load(){
        let item = root.components[count]
        APIService.shared.getPlaylist(privateKey: item.privateKey) {[weak self] (data2, error2) in
            if let data2 = data2 as? CategoryModel{
                categorys.append(data2)
                self?.count += 1
                print(data2.name + " " + data2.layout.type + " - " + data2.layout.subType)
                print(data2.privateKey)
                if categorys.count == root.components.count{
                    APIService.shared.getLive { (data, error) in
                        if let data = data as? [ChannelModel]{
                            lives = data
                            let vc = self?.storyboard?.instantiateViewController(withIdentifier: HomeController.className) as! HomeController
                            vc.modalTransitionStyle = .crossDissolve
                            vc.modalPresentationStyle = .fullScreen
                            self?.navigationController?.pushViewController(vc, animated: false)
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

