//
//  TVShowItemCell.swift
//  VTCNow
//
//  Created by dovietduy on 1/27/21.
//

import UIKit

class Type8ItemCell: UICollectionViewCell {

    @IBOutlet weak var thumbImage: LazyImageView!
    @IBOutlet weak var lblTitle: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    override func prepareForReuse() {
        thumbImage.image = #imageLiteral(resourceName: "placeHolderImage")
    }
}
