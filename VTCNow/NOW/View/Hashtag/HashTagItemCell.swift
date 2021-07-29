//
//  HashTagItemCell.swift
//  NOW
//
//  Created by dovietduy on 3/31/21.
//

import UIKit

class HashTagItemCell: UICollectionViewCell {
    static let reuseIdentifier = "HashTagItemCell"
    @IBOutlet weak var lblTitle: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    var isHeightCalculated: Bool = false
    
    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        
        //We need to cache our calculation to prevent a crash.
        
        if !isHeightCalculated {
            
            layoutIfNeeded()
            let size = contentView.systemLayoutSizeFitting(layoutAttributes.size)
            var newFrame = layoutAttributes.frame
            newFrame.size.width = CGFloat(ceilf(Float(size.width)))
            layoutAttributes.frame = newFrame
            isHeightCalculated = true
            
        }
        return layoutAttributes
    }
}
