//
//  PhimItemCell.swift
//  VTCNow
//
//  Created by dovietduy on 1/27/21.
//

import UIKit
class MusicItemCell: UICollectionViewCell {
    static let reuseIdentifier = "MusicItemCell"
    @IBOutlet weak var thumbImage: LazyImageView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblAuthor: UILabel!
    @IBOutlet weak var viewImage: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        //lblAuthor.text = ""
    }
    override func prepareForReuse() {
        thumbImage.image = #imageLiteral(resourceName: "placeHolderImage")
        //lblAuthor.text = ""
    }
}
