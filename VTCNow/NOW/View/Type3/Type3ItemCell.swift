//
//  NewsCell.swift
//  VTCNow
//
//  Created by dovietduy on 1/25/21.
//

import UIKit
class Type3ItemCell: UICollectionViewCell {

    @IBOutlet weak var thumbImage: LazyImageView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var viewImage: LazyImageView!
    @IBOutlet weak var viewBookmark: UIView!
    @IBOutlet weak var viewShare: UIView!
    var delegate: Type3ItemCellDelegate!
    var data = MediaModel()
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        viewImage.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didSelectViewImage(_:))))
        viewBookmark.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didSelectViewBookmark(_:))))
        viewShare.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didSelectViewShare(_:))))
    }
    override func prepareForReuse() {
        thumbImage.image = #imageLiteral(resourceName: "placeHolderImage")
    }
    @objc func didSelectViewImage(_ sender: Any){
        delegate?.didSelectViewImage(self)
    }
    @objc func didSelectViewBookmark(_ sender: Any){
        delegate?.didSelectViewBookmark(self)
    }
    @objc func didSelectViewShare(_ sender: Any){
        delegate?.didSelectViewShare(self)
    }
}
protocol Type3ItemCellDelegate {
    func didSelectViewImage(_ cell: Type3ItemCell)
    func didSelectViewBookmark(_ cell: Type3ItemCell)
    func didSelectViewShare(_ cell: Type3ItemCell)
}
