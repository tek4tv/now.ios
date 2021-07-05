//
//  NewsCell.swift
//  VTCNow
//
//  Created by dovietduy on 1/25/21.
//

import UIKit
class Type3ItemCell: UICollectionViewCell {
    static let reuseIdentifier = "Type3ItemCell"
    @IBOutlet weak var thumbImage: LazyImageView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var viewImage: LazyImageView!
    //@IBOutlet weak var viewBookmark: UIView!
    @IBOutlet weak var viewShare: UIView!
    @IBOutlet weak var lblEpisode: UILabel!
    @IBOutlet weak var lblTotalEpisode: UILabel!
    @IBOutlet weak var viewEpisode: UIView!
    var delegate: Type3ItemCellDelegate!
    var data = MediaModel()
    var row = 0
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        viewImage.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didSelectViewImage(_:))))
        //viewBookmark.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didSelectViewBookmark(_:))))
        viewShare.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didSelectViewShare(_:))))
        lblTitle.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didSelectLblTitle(_:))))
    }
    override func prepareForReuse() {
        thumbImage.image = #imageLiteral(resourceName: "placeHolderImage")
        viewEpisode.isHidden = true
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
    @objc func didSelectLblTitle(_ sender: Any){
        delegate?.didSelectViewImage(self)
    }
}
protocol Type3ItemCellDelegate: AnyObject {
    func didSelectViewImage(_ cell: Type3ItemCell)
    func didSelectViewBookmark(_ cell: Type3ItemCell)
    func didSelectViewShare(_ cell: Type3ItemCell)
}
