//
//  SearchCell.swift
//  NOW
//
//  Created by dovietduy on 2/25/21.
//

import UIKit

class SearchCell: UITableViewCell {

    @IBOutlet weak var viewFillText: UIView!
    @IBOutlet weak var lblName: UILabel!
    var delegate: SearchCellDelegate!
    override func awakeFromNib() {
        super.awakeFromNib()
        viewFillText.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didSelectViewFillText(_:))))
        // Initialization code
    }

    @objc func didSelectViewFillText(_ sender: Any){
        delegate?.didSelectViewFillText(lblName.text ?? "")
    }
    
}
protocol SearchCellDelegate: class {
    func didSelectViewFillText(_ text: String)
}
