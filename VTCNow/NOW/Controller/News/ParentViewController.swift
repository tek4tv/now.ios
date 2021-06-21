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
        settings.style.selectedBarBackgroundColor = #colorLiteral(red: 0.5225926042, green: 0.0004706631007, blue: 0.2674992383, alpha: 1)
        settings.style.buttonBarItemFont = .systemFont(ofSize: 14 * scaleW)
        settings.style.selectedBarHeight = 2.0
        settings.style.buttonBarMinimumLineSpacing = 15 * scaleW
        settings.style.buttonBarItemTitleColor = .black
        settings.style.buttonBarLeftContentInset = 20 * scaleW
        settings.style.buttonBarRightContentInset = 0
        changeCurrentIndexProgressive = {(oldCell: ButtonBarViewCell?, newCell: ButtonBarViewCell?, progressPercentage: CGFloat, changeCurrentIndex: Bool, animated: Bool) -> Void in
            guard changeCurrentIndex == true else { return }
            oldCell?.label.textColor = .gray
            newCell?.label.textColor = #colorLiteral(red: 0.5225926042, green: 0.0004706631007, blue: 0.2674992383, alpha: 1)
        }
        super.viewDidLoad()
        viewBack.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didSelectViewBack(_:))))
    }
    
    @objc func didSelectViewBack(_ sender: Any){
        self.navigationController?.popViewController(animated: false)
    }
    override func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
        var child :[UIViewController] = []
        let child0 = storyboard?.instantiateViewController(withIdentifier: NewsController.className) as! NewsController
        child0.name = "Mới nhất"
        child0.category = news
        child.append(child0)
        for item in news.components{
            let childAdd = storyboard?.instantiateViewController(withIdentifier: NewsController.className) as! NewsController
            childAdd.name = item.name
            childAdd.category = item.category
            child.append(childAdd)
        }
        return child
    }
}
