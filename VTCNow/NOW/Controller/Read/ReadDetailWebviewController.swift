//
//  ReadDetailWebviewController.swift
//  NOW
//
//  Created by Nguyễn Văn Chiến on 3/31/21.
//

import UIKit
import WebKit

class ReadDetailWebviewController: UIViewController {
    var url = ""
    @IBOutlet weak var webview: WKWebView!
    @IBOutlet weak var viewBack: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        webview.load(NSURLRequest(url: NSURL(string: url)! as URL) as URLRequest)
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
        viewBack.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didSelectViewBack(_:))))
    }
    @objc func didSelectViewBack(_ sender: Any){
        navigationController?.popViewController(animated: false)
    }
}
extension ReadDetailWebviewController:UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
