//
//  BannerCell.swift
//  NOW
//
//  Created by dovietduy on 5/28/21.
//

import UIKit

class BannerCell: UICollectionViewCell {
    static let reuseIdentifier = "BannerCell"
    @IBOutlet weak var imgThumb: LazyImageView!
    var delegate: BannerCellDelegate!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        imgThumb.isUserInteractionEnabled = true
        imgThumb.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didSelectImg(_:))))
    }
    @objc func didSelectImg(_ sender: Any){
        delegate?.didSelectImage()
    }
}
protocol BannerCellDelegate: Type3Cell{
    func didSelectImage()
}
