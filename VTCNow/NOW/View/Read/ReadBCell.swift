//
//  ReadBCell.swift
//  NOW
//
//  Created by dovietduy on 3/2/21.
//

import UIKit

class ReadBCell: UICollectionViewCell {
    @IBOutlet weak var view3Dot: UIView!
    @IBOutlet weak var viewCare: UIView!
    @IBOutlet weak var lblCare: UILabel!
    @IBOutlet weak var imgTick: UIImageView!
    @IBOutlet weak var imgThumb: LazyImageView!
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var lblTitle: UILabel!
    var isCare = false
    var item: ReadModel!
    var delegate: VideoCellDelegate!
    override func awakeFromNib() {
        super.awakeFromNib()
        viewCare.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didSelectCare(_:))))
        // Initialization code
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
