//
//  ReadCell.swift
//  NOW
//
//  Created by dovietduy on 4/15/21.
//

import UIKit

class ReadCell: UICollectionViewCell {

    @IBOutlet weak var viewContainer: UIView!
    @IBOutlet weak var imgThumb: LazyImageView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var viewShare: UIView!
    var item: ReadModel!
    var delegate: ReadCellDelegate!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        viewContainer.dropShadow()
        viewShare.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didSelectViewShare(_:))))
    }
    @objc func didSelectViewShare(_ sender: Any){
        delegate?.didSelectViewShare(self)
    }
}
protocol ReadCellDelegate: class {
    func didSelectViewShare(_ cell: ReadCell)
}
