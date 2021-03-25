//
//  PhimItemCell.swift
//  VTCNow
//
//  Created by dovietduy on 1/27/21.
//

import UIKit
class BookItemCell: UICollectionViewCell {

    @IBOutlet weak var thumbImage: LazyImageView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblAuthor: UILabel!
    @IBOutlet weak var viewImage: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        viewImage.dropShadow()
        lblAuthor.text = ""
    }
    override func prepareForReuse() {
        thumbImage.image = #imageLiteral(resourceName: "placeHolderImage")
        lblAuthor.text = ""
    }
}
