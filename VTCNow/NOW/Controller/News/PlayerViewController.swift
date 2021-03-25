//
//  PlayerViewController.swift
//  NOW
//
//  Created by dovietduy on 2/5/21.
//

import UIKit
import AVKit

class PlayerViewController: AVPlayerViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    typealias DissmissBlock = () -> Void
    var onDismiss: DissmissBlock?
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if isBeingDismissed {
            onDismiss?()
        }
    }

}
