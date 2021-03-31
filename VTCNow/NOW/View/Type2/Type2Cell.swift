//
//  DungBoLoCell.swift
//  VTCNow
//
//  Created by dovietduy on 1/25/21.
//

import UIKit

class Type2Cell: UICollectionViewCell {

    @IBOutlet weak var collView: UICollectionView!
    @IBOutlet weak var lblTitle: UILabel!
    var timer = Timer()
    var data = CategoryModel(){
        didSet{
            lblTitle.text = data.name
            if data.name != oldValue.name{
                collView.reloadData()
            }
            if data.name == "Đừng bỏ lỡ"{
                timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true, block: {(timer) in
                    NotificationCenter.default.post(name: NSNotification.Name.init("countDownTimer"), object: nil)
                })
            }
        }
    }
    deinit {
        NotificationCenter.default.removeObserver(self)
        timer.invalidate()
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        collView.delegate = self
        collView.dataSource = self
        collView.register(UINib(nibName: "Type2ItemCell", bundle: nil), forCellWithReuseIdentifier: "Type2ItemCell")
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 160 * scaleW, height: collView.bounds.height * scaleW)
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 10 * scaleW
        layout.sectionInset = UIEdgeInsets(top: 0, left: 10 * scaleW, bottom: 0, right: 0)
        collView.collectionViewLayout = layout
        
    }
    func stopTimer(){
        timer.invalidate()
    }
    
}
extension Type2Cell: UICollectionViewDelegate, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if data.media.count >= 6{
            return 6
        }
        return data.media.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Type2ItemCell.className, for: indexPath) as! Type2ItemCell
        let item = data.media[indexPath.row]
        cell.lblTitle.text = item.name
        cell.item = item
        if item.timePass == "Đang phát"{
            cell.lblTime.textColor = #colorLiteral(red: 0.6784313725, green: 0.1294117647, blue: 0.1529411765, alpha: 1)
            cell.lblTime.text = "Đang phát"
        } else{
            if let futureDate = item.schedule.toDate(){
                let interval = futureDate - Date()
                if let hour = interval.hour, let minute = interval.minute, let second = interval.second{
                    let timeStr = String(format: "%02d:%02d:%02d", hour, minute % 60, second % 60)
                    item.timePass = "\(timeStr)"
                    if hour <= 0 && minute <= 0 && second <= 0{
                        item.timePass = "Đang phát"
                    }
                }
                cell.lblTime.text = item.timePass
                
            }
        }
        if let url = URL(string: root.cdn.imageDomain + item.thumnail.replacingOccurrences(of: "\\", with: "/" )){
            cell.thumbImage.loadImage(fromURL: url)
        }
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        sharedItem = data.media[indexPath.row]
        sharedList = data.media
        NotificationCenter.default.post(name: NSNotification.Name("openVideo"), object: nil)
//        APIService.shared.getDetailVideo(privateKey: data.media[indexPath.row].privateID) { (data, error) in // khong có fileCode
//            if let data = data as? MediaModel{
//                sharedItem = data
//                sharedList = self.data.media
//                NotificationCenter.default.post(name: NSNotification.Name("openVideo"), object: nil)
//            }
//        }
    }
}
