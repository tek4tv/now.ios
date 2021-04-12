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
    var delegate: Type2CellDelegate!
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
        collView.register(UINib(nibName: Type2ItemCell.className, bundle: nil), forCellWithReuseIdentifier: Type2ItemCell.className)
        collView.register(UINib(nibName: ViewMoreCell.className, bundle: nil), forCellWithReuseIdentifier: ViewMoreCell.className)
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 10
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 10 * scaleW)
        collView.collectionViewLayout = layout
    }
    func stopTimer(){
        timer.invalidate()
    }
    
}
extension Type2Cell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if data.media.count >= 7{
            return 7
        }
        return data.media.count
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch indexPath.row {
        case 0...5:
            return CGSize(width: 160 * scaleW, height: 180 * scaleW)
        default:
            return CGSize(width: 168 * scaleW, height: 180 * scaleW)
        }
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let item = data.media[indexPath.row]
        switch indexPath.row {
        case 0...5:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Type2ItemCell.className, for: indexPath) as! Type2ItemCell
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
                        
                        if hour <= 0 && minute <= 0 && second <= 0{
                            item.timePass = "Đang phát"
                            cell.lblTime.textColor = #colorLiteral(red: 0.6784313725, green: 0.1294117647, blue: 0.1529411765, alpha: 1)
                        } else{
                            item.timePass = "\(timeStr)"
                            cell.lblTime.textColor = .white
                        }
                    }
                    cell.lblTime.text = item.timePass
                    
                }
            }
            if let url = URL(string: root.cdn.imageDomain + item.thumnail.replacingOccurrences(of: "\\", with: "/" )){
                cell.thumbImage.loadImage(fromURL: url)
            }
            return cell
        default:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ViewMoreCell.className, for: indexPath) as! ViewMoreCell
            
            if let url = URL(string: root.cdn.imageDomain + item.thumnail.replacingOccurrences(of: "\\", with: "/" )){
                cell.imgThumb.loadImage(fromURL: url)
            }
            return cell
        }
        
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0...5:
            let temp = self.data.copy()
            let item = data.media[indexPath.row]
            temp.media.remove(at: indexPath.row)
            temp.media.insert(item, at: 0)
            news = temp
            delegate?.didSelectItemAt(self)
        default:
            delegate?.didSelectViewMore(self)
        }
    }
}
protocol Type2CellDelegate {
    func didSelectItemAt(_ cell: Type2Cell)
    func didSelectViewMore(_ cell: Type2Cell)
}
