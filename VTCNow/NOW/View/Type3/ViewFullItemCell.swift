//
//  ViewFullItemCell.swift
//  NOW
//
//  Created by dovietduy on 4/1/21.
//

import UIKit

class ViewFullItemCell: UICollectionViewCell {

    @IBOutlet weak var imgThumb: LazyImageView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblTime: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        animate()
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
}
