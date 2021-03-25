//
//  NewsCell.swift
//  VTCNow
//
//  Created by dovietduy on 1/25/21.
//

import UIKit
class SubTypeCell: UICollectionViewCell {

    @IBOutlet weak var thumbImage: LazyImageView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblTime: UILabel!
    var item: MediaModel!
    override func awakeFromNib() {
        super.awakeFromNib()
        NotificationCenter.default.addObserver(self, selector: #selector(countDown(_:)),name: NSNotification.Name ("countDownTimer2"), object: nil)
    }
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    @objc func countDown(_ sender: Notification){
        if item != nil, sharedItem != nil, sharedItem.fileCode != ""{
            if let futureDate = item.schedule.toDate(){
                let interval = futureDate - Date()
                if let hour = interval.hour, let minute = interval.minute, let second = interval.second{
                    let timeStr = String(format: "%02d:%02d:%02d", hour, minute % 60, second % 60)
                    sharedItem.timePass = "Còn \(timeStr)"
                    lblTime.textColor = .gray
                    if hour <= 0 && minute <= 0 && second <= 0{
                        sharedItem.timePass = "Trực tiếp"
//                        viewDot.backgroundColor = .red
                        lblTime.textColor = .red
                    }
                }
                lblTime.text = sharedItem.timePass
            }
         
        }
    }
    override func prepareForReuse() {
        thumbImage.image = #imageLiteral(resourceName: "placeHolderImage")
        lblTime.textColor = .gray
    }
}
