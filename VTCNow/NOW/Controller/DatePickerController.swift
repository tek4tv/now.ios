//
//  DatePickerController.swift
//  NOW
//
//  Created by dovietduy on 6/9/21.
//

import UIKit

class DatePickerController: UIViewController {

    @IBOutlet weak var viewBack: UIView!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var viewDone: UIView!
    var onComplete: ((Date) -> Void)!
    override func viewDidLoad() {
        super.viewDidLoad()

        viewBack.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didSelectViewBack(_:))))
        viewDone.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didSelectViewDone(_:))))
    }
    @objc func didSelectViewBack(_ sender: Any){
        dismiss(animated: false, completion: nil)
    }
    @objc func didSelectViewDone(_ sender: Any){
        onComplete?(datePicker.date)
        dismiss(animated: false, completion: nil)
    }
}
