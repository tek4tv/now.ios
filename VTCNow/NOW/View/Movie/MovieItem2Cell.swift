//
//  MovieItem2Cell.swift
//  NOW
//
//  Created by dovietduy on 4/7/21.
//

import UIKit

class MovieItem2Cell: UICollectionViewCell {
    static let reuseIdentifier = "MovieItem2Cell"
    @IBOutlet weak var imgThumb: LazyImageView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblCountry: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
