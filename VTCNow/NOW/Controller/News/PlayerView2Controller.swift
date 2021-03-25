//
//  PlayerView2Controller.swift
//  VTC Now
//
//  Created by dovietduy on 3/18/21.
//

import UIKit
import AVKit
class PlayerView2Controller: AVPlayerViewController {

    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(rotated(_:)), name: UIDevice.orientationDidChangeNotification, object: nil)
        // Do any additional setup after loading the view.
    }
    
    typealias DissmissBlock = () -> Void
    var onDismiss: DissmissBlock?
    
    @objc func rotated(_ sender: Any) {
        
        if UIDevice.current.orientation.isLandscape {
        } else {
            dismiss(animated: false, completion: nil)
        }
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if isBeingDismissed {
            onDismiss?()
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
