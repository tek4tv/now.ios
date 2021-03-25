//
//  UserController.swift
//  NOW
//
//  Created by dovietduy on 3/9/21.
//

import UIKit
class UserController: UIViewController {

    @IBOutlet weak var swRunBackground: UISwitch!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let num = UserDefaults.standard.integer(forKey: "isRunBackground")
        if num == 1{
            swRunBackground.thumbTintColor = #colorLiteral(red: 0.5019607843, green: 0.01176470588, blue: 0.2588235294, alpha: 1)
        } else{
            swRunBackground.thumbTintColor = .gray
        }
//        swRunBackground.setOn(isRunBG, animated: true)
//        if isRunBG {
//            swRunBackground.thumbTintColor = #colorLiteral(red: 0.5019607843, green: 0.01176470588, blue: 0.2588235294, alpha: 1)
//        } else{
//            swRunBackground.thumbTintColor = .gray
//        }
        
    }
    
    @IBAction func runBackground(_ sender: UISwitch) {
        if sender.isOn{
            UserDefaults.standard.setValue(1, forKey: "isRunBackground")
            swRunBackground.thumbTintColor = #colorLiteral(red: 0.5019607843, green: 0.01176470588, blue: 0.2588235294, alpha: 1)
        } else{
            UserDefaults.standard.setValue(0, forKey: "isRunBackground")
            swRunBackground.thumbTintColor = .gray
        }
    }
    
}
