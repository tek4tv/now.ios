//
//  PopUp4Controller.swift
//  NOW
//
//  Created by dovietduy on 2/22/21.
//

import UIKit

class PopUp4Controller: UIViewController {
    @IBOutlet weak var viewBack: UIView!
    @IBOutlet weak var viewCancel: UIView!
    @IBOutlet weak var view025: UIView!
    @IBOutlet weak var view05: UIView!
    @IBOutlet weak var view075: UIView!
    @IBOutlet weak var view1: UIView!
    @IBOutlet weak var view125: UIView!
    @IBOutlet weak var view15: UIView!
    @IBOutlet weak var view175: UIView!
    @IBOutlet weak var view2: UIView!
    @IBOutlet var listImage: [UIImageView] = []
    var value: Double = 1.0
    var onComplete: ((Double) -> Void)!
    override func viewDidLoad() {
        super.viewDidLoad()
        viewBack.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didSelectViewBack(_:))))
        viewCancel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didSelectViewBack(_:))))
        view025.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didSelectView025(_:))))
        view05.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didSelectView05(_:))))
        view075.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didSelectView075(_:))))
        view1.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didSelectView1(_:))))
        view125.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didSelectView125(_:))))
        view15.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didSelectView15(_:))))
        view175.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didSelectView175(_:))))
        view2.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didSelectView2(_:))))
        switch value {
        case 0.25:
            for (index, item) in listImage.enumerated(){
                if index == 0{
                    item.image = #imageLiteral(resourceName: "icons8-tick-box-52")
                }
                else{
                    item.image = nil
                }
            }
        case 0.5:
            for (index, item) in listImage.enumerated(){
                if index == 1{
                    item.image = #imageLiteral(resourceName: "icons8-tick-box-52")
                }
                else{
                    item.image = nil
                }
            }
        case 0.75:
            for (index, item) in listImage.enumerated(){
                if index == 2{
                    item.image = #imageLiteral(resourceName: "icons8-tick-box-52")
                }
                else{
                    item.image = nil
                }
            }
        case 1.0:
            for (index, item) in listImage.enumerated(){
                if index == 3{
                    item.image = #imageLiteral(resourceName: "icons8-tick-box-52")
                }
                else{
                    item.image = nil
                }
            }
        case 1.25:
            for (index, item) in listImage.enumerated(){
                if index == 4{
                    item.image = #imageLiteral(resourceName: "icons8-tick-box-52")
                }
                else{
                    item.image = nil
                }
            }
        case 1.5:
            for (index, item) in listImage.enumerated(){
                if index == 5{
                    item.image = #imageLiteral(resourceName: "icons8-tick-box-52")
                }
                else{
                    item.image = nil
                }
            }
        case 1.75:
            for (index, item) in listImage.enumerated(){
                if index == 6{
                    item.image = #imageLiteral(resourceName: "icons8-tick-box-52")
                }
                else{
                    item.image = nil
                }
            }
        case 2.0:
            for (index, item) in listImage.enumerated(){
                if index == 7{
                    item.image = #imageLiteral(resourceName: "icons8-tick-box-52")
                }
                else{
                    item.image = nil
                }
            }
        default:
            break
        }
    }
    @objc func didSelectViewBack(_ sender: Any){
        dismiss(animated: true, completion: nil)
        onComplete?(value)
    }
    @objc func didSelectView025(_ sender: Any){
        value = 0.25
        for (index, item) in listImage.enumerated(){
            if index == 0{
                item.image = #imageLiteral(resourceName: "icons8-tick-box-52")
            }
            else{
                item.image = nil
            }
        }
    }
    @objc func didSelectView05(_ sender: Any){
        value = 0.5
        for (index, item) in listImage.enumerated(){
            if index == 1{
                item.image = #imageLiteral(resourceName: "icons8-tick-box-52")
            }
            else{
                item.image = nil
            }
        }
    }
    @objc func didSelectView075(_ sender: Any){
        value = 0.75
        for (index, item) in listImage.enumerated(){
            if index == 2{
                item.image = #imageLiteral(resourceName: "icons8-tick-box-52")
            }
            else{
                item.image = nil
            }
        }
    }
    @objc func didSelectView1(_ sender: Any){
        value = 1.0
        for (index, item) in listImage.enumerated(){
            if index == 3{
                item.image = #imageLiteral(resourceName: "icons8-tick-box-52")
            }
            else{
                item.image = nil
            }
        }
    }
    @objc func didSelectView125(_ sender: Any){
        value = 1.25
        for (index, item) in listImage.enumerated(){
            if index == 4{
                item.image = #imageLiteral(resourceName: "icons8-tick-box-52")
            }
            else{
                item.image = nil
            }
        }
    }
    @objc func didSelectView15(_ sender: Any){
        value = 1.5
        for (index, item) in listImage.enumerated(){
            if index == 5{
                item.image = #imageLiteral(resourceName: "icons8-tick-box-52")
            }
            else{
                item.image = nil
            }
        }
    }
    @objc func didSelectView175(_ sender: Any){
        value = 1.75
        for (index, item) in listImage.enumerated(){
            if index == 6{
                item.image = #imageLiteral(resourceName: "icons8-tick-box-52")
            }
            else{
                item.image = nil
            }
        }
    }
    @objc func didSelectView2(_ sender: Any){
        value = 2.0
        for (index, item) in listImage.enumerated(){
            if index == 7{
                item.image = #imageLiteral(resourceName: "icons8-tick-box-52")
            }
            else{
                item.image = nil
            }
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
