//
//  ReadACell.swift
//  NOW
//
//  Created by dovietduy on 3/2/21.
//

import UIKit

class ReadACell: UICollectionViewCell {
    @IBOutlet weak var view3Dot: UIView!
    @IBOutlet weak var viewCare: UIView!
    @IBOutlet weak var lblCare: UILabel!
    @IBOutlet weak var imgTick: UIImageView!
    @IBOutlet weak var imgThumb: LazyImageView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblTime: UILabel!
    var isCare = false
    var item: ReadModel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        viewCare.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didSelectCare(_:))))
    }
    @objc func didSelectCare(_ sender: Any){
        isCare = !isCare
        if isCare{
            lblCare.isHidden = true
            imgTick.isHidden = false
        } else{
            lblCare.isHidden = false
            imgTick.isHidden = true
        }
    }
    
}
