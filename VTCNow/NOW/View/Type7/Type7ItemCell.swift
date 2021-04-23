//
//  Type7ItemCell.swift
//  NOW
//
//  Created by dovietduy on 4/2/21.
//

import UIKit

class Type7ItemCell: UICollectionViewCell {

    @IBOutlet weak var imgThumb: LazyImageView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblAuthor: UILabel!
    @IBOutlet weak var lblTotalEpisode: UILabel!
    @IBOutlet weak var lblEpisode: UILabel!
    @IBOutlet weak var viewEpisode: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    override func prepareForReuse() {
        viewEpisode.isHidden = true
    }
}
