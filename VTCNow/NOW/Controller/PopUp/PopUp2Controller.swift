//
//  PopUp2Controller.swift
//  NOW
//
//  Created by dovietduy on 2/22/21.
//

import UIKit

class PopUp2Controller: UIViewController {

    @IBOutlet weak var viewBack: UIView!
    @IBOutlet weak var viewQuality: UIView!
    @IBOutlet weak var viewCancel: UIView!
    @IBOutlet weak var lblQuality: UILabel!
    @IBOutlet weak var ViewSpeed: UIView!
    @IBOutlet weak var lblSpeed: UILabel!
    var onComplete: (([StreamResolution]) -> Void)!
    var onTickedSpeed : ((Double) -> Void)!
    var listResolution: [StreamResolution] = []
    var speed: Double = 1.0
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        viewBack.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didSelectViewBack(_:))))
        viewCancel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didSelectViewBack(_:))))
        viewQuality.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didSelectViewQuality(_:))))
        ViewSpeed.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didSelectViewSpeed(_:))))
        setLblQuality()
        setLblSpeed()
    }
    func setLblQuality(){
        var flag = false
        for (index, temp)in listResolution.enumerated(){
            
            if index == 0{
                if temp.isTicked {
                    lblQuality.text = "Chất lượng ◦ Tự động " + Int(temp.resolution.height).description + "p"
                    flag = true
                }
            }else{
                if temp.isTicked {
                    lblQuality.text = "Chất lượng ◦ " + Int(temp.resolution.height).description + "p"
                    flag = true
                }
            }
        }
        if flag == false, listResolution.count > 0{
            lblQuality.text = "Chất lượng ◦ Tự động " + Int(listResolution[0].resolution.height).description + "p"
            listResolution[0].isTicked = true
        }
    }
    func setLblSpeed(){
        if speed == 1.0 {
            lblSpeed.text = "Tốc độ phát ◦ Bình thường"
        } else {
            lblSpeed.text = "Tốc độ phát ◦ " + speed.description + "x"
        }
    }
    
    @objc func didSelectViewBack(_ sender: Any){
        dismiss(animated: true, completion: nil)
        onComplete?(listResolution)
        onTickedSpeed?(speed)
    }
    @objc func didSelectViewQuality(_ sender: Any){
        let vc = storyboard?.instantiateViewController(withIdentifier: PopUp3Controller.className) as! PopUp3Controller
        vc.modalPresentationStyle = .custom
        vc.modalTransitionStyle = .crossDissolve
        vc.setListResolution(listResolution)
        vc.onComplete = {[weak self] list in
            self?.listResolution = list
            self?.setLblQuality()
        }
        present(vc, animated: true, completion: nil)
    }
    @objc func didSelectViewSpeed(_ sender: Any){
        let vc = storyboard?.instantiateViewController(withIdentifier: PopUp4Controller.className) as! PopUp4Controller
        vc.modalPresentationStyle = .custom
        vc.modalTransitionStyle = .crossDissolve
        vc.value = speed
        vc.onComplete = {[weak self] value in
            self?.speed = value
            self?.setLblSpeed()
        }
        present(vc, animated: true, completion: nil)
    }

}
