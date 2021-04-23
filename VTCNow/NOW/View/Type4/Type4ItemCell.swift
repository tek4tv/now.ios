//
//  TVShowItemCell.swift
//  VTCNow
//
//  Created by dovietduy on 1/27/21.
//

import UIKit

class Type4ItemCell: UICollectionViewCell {

    @IBOutlet weak var thumbImage: LazyImageView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblEpisode: UILabel!
    @IBOutlet weak var lblTotalEpisode: UILabel!
    @IBOutlet weak var lblCountry: UILabel!
    @IBOutlet weak var viewEpisode: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    override func prepareForReuse() {
        thumbImage.image = #imageLiteral(resourceName: "placeHolderImage")
        viewEpisode.isHidden = true
        lblCountry.isHidden = true
    }
}
