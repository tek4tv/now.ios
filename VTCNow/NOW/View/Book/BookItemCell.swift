//
//  PhimItemCell.swift
//  VTCNow
//
//  Created by dovietduy on 1/27/21.
//

import UIKit
class BookItemCell: UICollectionViewCell {
    static let reuseIdentifier = "BookItemCell"
    @IBOutlet weak var thumbImage: LazyImageView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblAuthor: UILabel!
    @IBOutlet weak var viewImage: UIView!
    @IBOutlet weak var viewEpisode: UIView!
    @IBOutlet weak var lblEpisode: UILabel!
    @IBOutlet weak var lblTotalEpisode: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        lblAuthor.text = ""
    }
    override func prepareForReuse() {
        thumbImage.image = #imageLiteral(resourceName: "placeHolderImage")
        lblAuthor.text = ""
        viewEpisode.isHidden = true
    }
}
