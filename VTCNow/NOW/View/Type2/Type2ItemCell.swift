//
//  LiveCell.swift
//  VTCNow
//
//  Created by dovietduy on 1/25/21.
//

import UIKit
class Type2ItemCell: UICollectionViewCell{
    @IBOutlet weak var thumbImage: LazyImageView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var viewDot: UIView!
    var item = MediaModel()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        NotificationCenter.default.addObserver(self, selector: #selector(countDown(_:)),name: NSNotification.Name ("countDownTimer"), object: nil)
    }
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
   
    @objc func countDown(_ sender: Notification){
        if let futureDate = item.schedule.toDate(){
            let interval = futureDate - Date()
            if let day = interval.day, let hour = interval.hour, let minute = interval.minute, let second = interval.second{
                let timeStr = String(format: "%02d:%02d:%02d", hour, minute % 60, second % 60)
                item.timePass = "Còn \(timeStr)"
                if day < 0{
                    item.timePass = "\(-day) ngày trước"
                }else
                if hour <= 0 && minute <= 0 && second <= 0{
                    item.timePass = "Trực tiếp"
                    viewDot.backgroundColor = .red
                    lblTime.textColor = .red
                }
            }
            lblTime.text = item.timePass
        }
    }
    override func prepareForReuse() {
        viewDot.backgroundColor = .darkGray
        lblTime.textColor = .darkGray
        thumbImage.image = #imageLiteral(resourceName: "placeHolderImage")
    }
}
