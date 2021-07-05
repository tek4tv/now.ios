//
//  Type7ItemCell.swift
//  NOW
//
//  Created by dovietduy on 4/2/21.
//

import UIKit

class Type7ItemCell: UICollectionViewCell {
    static let reuseIdentifier = "Type7ItemCell"
    @IBOutlet weak var imgThumb: LazyImageView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblAuthor: UILabel!
    @IBOutlet weak var lblTotalEpisode: UILabel!
    @IBOutlet weak var lblEpisode: UILabel!
    @IBOutlet weak var viewEpisode: UIView!
    @IBOutlet weak var viewImage: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        viewImage.dropShadow()
    }
    override func prepareForReuse() {
        viewEpisode.isHidden = true
    }
}
