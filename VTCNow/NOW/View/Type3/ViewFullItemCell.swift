//
//  ViewFullItemCell.swift
//  NOW
//
//  Created by dovietduy on 4/1/21.
//

import UIKit

class ViewFullItemCell: UICollectionViewCell {
    static let reuseIdentifier = "ViewFullItemCell"
    @IBOutlet weak var imgThumb: LazyImageView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var lblDescription: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        lblDescription.isHidden = true
        animate()
       // animate2()
    }
    func animate(){
        UIView.animate(withDuration: 10.0, delay: 0.0, options: .curveEaseIn) {
            self.imgThumb.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
        } completion: { (Bool) in
            UIView.animate(withDuration: 10.0, delay: 0.0, options: .curveEaseIn) {
                self.imgThumb.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            } completion: { (Bool) in
                self.animate()
            }
        }
    }
    func animate2(){
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
            self.lblDescription.isHidden = false
            DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                self.lblDescription.isHidden = true
                self.animate2()
            }
        }
    }
}
