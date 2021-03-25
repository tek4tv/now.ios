//
//  PhimItemCell.swift
//  VTCNow
//
//  Created by dovietduy on 1/27/21.
//

import UIKit
class Type6ItemCell: UICollectionViewCell {

    @IBOutlet weak var lblCountry: UILabel!
    @IBOutlet weak var thumbImage: LazyImageView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var viewTime: UIView!
    @IBOutlet weak var viewImage: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        viewImage.dropShadow()
    }
    override func prepareForReuse() {
        thumbImage.image = #imageLiteral(resourceName: "placeHolderImage")
        viewTime.isHidden = true
    }
}
