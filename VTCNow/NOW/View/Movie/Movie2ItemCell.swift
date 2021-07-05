//
//  BannerItemCell.swift
//  VTCNow
//
//  Created by dovietduy on 1/25/21.
//

import UIKit
class Movie2ItemCell: UICollectionViewCell {
    static let reuseIdentifier = "Movie2ItemCell"
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
