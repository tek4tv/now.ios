//
//  LiveCell.swift
//  VTCNow
//
//  Created by dovietduy on 1/25/21.
//

import UIKit
class Type2ItemCell: UICollectionViewCell{
    static let reuseIdentifier = "Type2ItemCell"
    @IBOutlet weak var thumbImage: LazyImageView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var viewShadow: UIView!
    fileprivate var futureDate: Date? = nil
    var item = MediaModel(){
        didSet{
            futureDate = item.schedule.toDate()
            if isOnLive(){
                
            } else{
                NotificationCenter.default.addObserver(self, selector: #selector(countDown(_:)),name: NSNotification.Name ("countDownTimer"), object: nil)
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
   
    @objc func countDown(_ sender: Notification){
        if let futureDate = futureDate{
            let interval = futureDate - Date()
            if let hour = interval.hour, let minute = interval.minute, let second = interval.second{
                let timeStr = String(format: "%02d:%02d:%02d", hour, minute % 60, second % 60)
                
                if hour <= 0 && minute <= 0 && second <= 0{
                    if item.name.contains("Trực tiếp"){
                        item.timePass = "Trực tiếp"
                    } else {
                        item.timePass = "Đang phát"
                    }
                    lblTime.textColor = #colorLiteral(red: 0.5108931065, green: 0.1515108645, blue: 0.2585203648, alpha: 1)
                    NotificationCenter.default.removeObserver(self, name: NSNotification.Name.init("countDownTimer"), object: nil)
                } else{
                    item.timePass = "\(timeStr)"
                    lblTime.textColor = .white
                }
            }
            lblTime.text = item.timePass
        }
    }
    func isOnLive() -> Bool{
        if let futureDate = futureDate{
            let interval = futureDate - Date()
            if let hour = interval.hour, let minute = interval.minute, let second = interval.second{
                let timeStr = String(format: "%02d:%02d:%02d", hour, minute % 60, second % 60)
                
                if hour <= 0 && minute <= 0 && second <= 0{
                    if item.name.contains("Trực tiếp"){
                        lblTime.text = "Trực tiếp"
                    } else {
                        lblTime.text = "Đang phát"
                    }
                    lblTime.textColor = #colorLiteral(red: 0.5110089779, green: 0.1506488323, blue: 0.2548394501, alpha: 1)
                    return true
                } else{
                    item.timePass = "\(timeStr)"
                    lblTime.textColor = .white
                    return false
                }
            }
        }
        return false
    }
    override func prepareForReuse() {
        lblTime.textColor = .white
        lblTime.text = ""
        thumbImage.image = #imageLiteral(resourceName: "placeHolderImage")
    }
}
