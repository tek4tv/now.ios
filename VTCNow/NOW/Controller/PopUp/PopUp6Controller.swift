//
//  PopUp6Controller.swift
//  NOW
//
//  Created by dovietduy on 3/2/21.
//

import UIKit

class PopUp6Controller: UIViewController {

    
    @IBOutlet weak var viewBack: UIView!
    @IBOutlet weak var viewCancel: UIView!
    @IBOutlet weak var viewShare: UIView!
    
    var data: ReadModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewBack.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didSelectViewBack(_:))))
        viewCancel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didSelectViewBack(_:))))
        viewShare.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didSelectViewShare(_:))))
        
    }
   
    @objc func didSelectViewBack(_ sender: Any){
        //self.navigationController?.popViewController(animated: true)
        dismiss(animated: true, completion: nil)
    }
    @objc func didSelectViewShare(_ sender: Any){
        guard let url = URL(string: data.detailUrl) else {
            return
        }
        let itemsToShare = [url]
        let ac = UIActivityViewController(activityItems: itemsToShare, applicationActivities: nil)
        ac.popoverPresentationController?.sourceView = self.view
        self.present(ac, animated: true)
    }


}
