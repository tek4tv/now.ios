//
//  CollectionViewCell.swift
//  VTCNow
//
//  Created by dovietduy on 1/28/21.
//

import UIKit
import AVFoundation

class VideoCell: UICollectionViewCell {

    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var view3Dot: UIView!
    @IBOutlet weak var viewCare: UIView!
    @IBOutlet weak var lblCare: UILabel!
    @IBOutlet weak var imgTick: UIImageView!
    @IBOutlet weak var thumbImage: LazyImageView!
    
    @IBOutlet weak var videoView: UIView!
    var indexPath: IndexPath!
    var delegate: VideoCellDelegate!
    var isCare = false
    var item: MediaModel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        view3Dot.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didSelect3Dot(_:))))
        viewCare.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didSelectCare(_:))))
        videoView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didSelectVideo(_:))))
        if news.name == "Đừng bỏ lỡ"{
            NotificationCenter.default.addObserver(self, selector: #selector(countDown(_:)), name: NSNotification.Name.init("countDownTimer2"), object: nil)
           
        }else{
            NotificationCenter.default.removeObserver(self)
        }
    }
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    override func prepareForReuse() {
        lblTime.text = ""
        lblTime.textColor = .gray
        lblCare.isHidden = false
        imgTick.isHidden = true
        thumbImage.image = #imageLiteral(resourceName: "placeHolderImage")
    }
    @objc func countDown(_ notification: Notification){
        if let futureDate = item.schedule.toDate(){
            let interval = futureDate - Date()
            if let day = interval.day, let hour = interval.hour, let minute = interval.minute, let second = interval.second{
                let timeStr = String(format: "%02d:%02d:%02d", hour, minute % 60, second % 60)
                item.timePass = "Còn \(timeStr)"
                lblTime.textColor = .gray
                lblTime.text = item.timePass
                if day < 0{
                    lblTime.text = item.getTimePass()
                } else if hour <= 0 && minute <= 0 && second <= 0{
                    NotificationCenter.default.removeObserver(self, name: NSNotification.Name ("countDownTimer2"), object: nil)
                    item.timePass = "Trực tiếp"
                    lblTime.textColor = .red
                    lblTime.text = item.timePass
                }
            }
        }
    }

    @objc func didSelect3Dot(_ sender: Any){
        self.delegate?.didSelect3Dot(self)
    }
    @objc func didSelectVideo(_ sender: Any){
        self.delegate?.didSelectVideo(self)
    }
    @objc func didSelectCare(_ sender: Any){
        isCare = !isCare
        if isCare{
            lblCare.isHidden = true
            imgTick.isHidden = false
        } else{
            lblCare.isHidden = false
            imgTick.isHidden = true
        }
    }
    
}

protocol VideoCellDelegate {
    func didSelect3Dot(_ cell: VideoCell)
    func didSelectVideo(_ cell: VideoCell)
}
