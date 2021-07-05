//
//  PhimItemCell.swift
//  VTCNow
//
//  Created by dovietduy on 1/27/21.
//

import UIKit
class MovieItemCell: UICollectionViewCell {
    static let reuseIdentifier = "MovieItemCell"
    @IBOutlet weak var thumbImage: LazyImageView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblCountry: UILabel!
    @IBOutlet weak var viewImage: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    override func prepareForReuse() {
        thumbImage.image = #imageLiteral(resourceName: "placeHolderImage")
        lblCountry.text = ""
    }
}
