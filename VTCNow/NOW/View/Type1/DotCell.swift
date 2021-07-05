//
//  DotCell.swift
//  VTC Now
//
//  Created by dovietduy on 3/17/21.
//

import UIKit

class DotCell: UICollectionViewCell {
    static let reuseIdentifier = "DotCell"
    @IBOutlet weak var viewDot: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    override func prepareForReuse() {
        viewDot.backgroundColor = .gray
    }
}
