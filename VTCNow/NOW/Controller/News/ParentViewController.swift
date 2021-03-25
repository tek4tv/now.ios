//
//  MyPagerTabStripName.swift
//  VTCNow
//
//  Created by dovietduy on 1/28/21.
//

import Foundation
import XLPagerTabStrip
import AVFoundation
import AVKit

class ParentViewController: ButtonBarPagerTabStripViewController {
    @IBOutlet weak var viewBack: UIView!
    override func viewDidLoad() {
        
        
        //NotificationCenter.default.addObserver(self, selector: #selector(didOpenVideo(_:)), name: NSNotification.Name("openVideo"), object: nil)
        // change selected bar color
        settings.style.buttonBarBackgroundColor = .white
        settings.style.buttonBarItemBackgroundColor = .white
        settings.style.selectedBarBackgroundColor = .black
        settings.style.buttonBarItemFont = .systemFont(ofSize: 12)
        settings.style.selectedBarHeight = 2.0
        settings.style.buttonBarMinimumLineSpacing = 0
        settings.style.buttonBarItemTitleColor = .black
        settings.style.buttonBarLeftContentInset = 0
        settings.style.buttonBarRightContentInset = 0
        changeCurrentIndexProgressive = {(oldCell: ButtonBarViewCell?, newCell: ButtonBarViewCell?, progressPercentage: CGFloat, changeCurrentIndex: Bool, animated: Bool) -> Void in
            guard changeCurrentIndex == true else { return }
            oldCell?.label.textColor = .gray
            newCell?.label.textColor = .black
        }
        super.viewDidLoad()
        viewBack.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didSelectViewBack(_:))))
    }
    
    @objc func didSelectViewBack(_ sender: Any){
        self.navigationController?.popViewController(animated: true)
    }
    override func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
        var child :[UIViewController] = []
        for item in news.components{
            let childAdd = storyboard?.instantiateViewController(withIdentifier: NewsController.className) as! NewsController
            childAdd.name = item.name
            childAdd.category = item.category
            child.append(childAdd)
        }
        return child
    }
}
