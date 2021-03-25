//
//  Book2Cell.swift
//  NOW
//
//  Created by dovietduy on 3/1/21.
//

import UIKit
import MarqueeLabel
class Book2Cell: UITableViewCell {
    @IBOutlet weak var lblTitle: MarqueeLabel!
    @IBOutlet weak var lblAuthor: UILabel!
    @IBOutlet weak var imgView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    override func prepareForReuse() {
        lblTitle.textColor = .darkGray
        lblAuthor.textColor = .darkGray
    }
    
}
