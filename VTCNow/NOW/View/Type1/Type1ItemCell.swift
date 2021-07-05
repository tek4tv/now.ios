//
//  BannerItemCell.swift
//  VTCNow
//
//  Created by dovietduy on 1/25/21.
//

import UIKit
class Type1ItemCell: UICollectionViewCell {
    static let reuseIdentifier = "Type1ItemCell"
    @IBOutlet weak var thumbImage: LazyImageView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblTime: UILabel!
    var item = MediaModel(){
        didSet{
            if item.path != "" {
                lblTime.text = item.getTimePass()
                if Array(item.path)[item.path.count - 1] == "/" {
                    _ = self.isOnLive()
                }
            }else{
                _ = self.isOnLive()
            }
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    override func prepareForReuse() {
        thumbImage.image = #imageLiteral(resourceName: "placeHolderImage")
        lblTime.text = ""
        lblTime.textColor = .lightGray
    }
    func isOnLive() -> Bool{
        if let futureDate = item.schedule.toDate(){
            let interval = futureDate - Date()
            if let hour = interval.hour, let minute = interval.minute, let second = interval.second{
                
                if hour <= 0 && minute <= 0 && second <= 0{
                    if item.name.contains("Trực tiếp"){
                        lblTime.text = "Trực tiếp"
                    } else {
                        lblTime.text = "Đang phát"
                    }
                    lblTime.textColor = #colorLiteral(red: 0.6784313725, green: 0.1294117647, blue: 0.1529411765, alpha: 1)
                    return true
                } else{
                    lblTime.text = item.timePass
                    lblTime.textColor = .lightGray
                    return false
                }
            }
        }
        return false
    }
}
