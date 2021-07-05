//
//  DanhMucItemCell.swift
//  VTCNow
//
//  Created by dovietduy on 1/26/21.
//

import UIKit

class CategoryItemCell: UICollectionViewCell {
    static let reuseIdentifier = "CategoryItemCell"
    @IBOutlet weak var thumbImage: LazyImageView!
    @IBOutlet weak var lblTitle: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
