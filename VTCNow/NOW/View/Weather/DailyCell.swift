//
//  DailyCell.swift
//  NOW
//
//  Created by dovietduy on 3/10/21.
//

import UIKit

class DailyCell: UICollectionViewCell {
    static let reuseIdentifier = "DailyCell"
    @IBOutlet weak var imgIcon: UIImageView!
    @IBOutlet weak var lblThu: UILabel!
    @IBOutlet weak var lblHigh: UILabel!
    @IBOutlet weak var lblLow: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
