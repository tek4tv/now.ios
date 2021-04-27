//
//  PopUp7Controller.swift
//  NOW
//
//  Created by dovietduy on 3/10/21.
//

import UIKit

class PopUp7Controller: UIViewController {
    @IBOutlet weak var lbloC: UILabel!
    @IBOutlet weak var lblCity: UILabel!
    @IBOutlet weak var imgIcon: UIImageView!
    
    @IBOutlet weak var collView: UICollectionView!
    @IBOutlet weak var viewBack: UIView!
    let thu: [String: String] = [
        "Mon": "Th 2",
        "Tue": "Th 3",
        "Wed": "Th 4",
        "Thu": "Th 5",
        "Fri": "Th 6",
        "Sat": "Th 7",
        "Sun": "CN"
    ]
    var item: WeatherModel!
    override func viewDidLoad() {
        super.viewDidLoad()
        collView.delegate = self
        collView.dataSource = self
        collView.register(UINib(nibName: DailyCell.className, bundle: nil), forCellWithReuseIdentifier: DailyCell.className)
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: (369 * scaleW) / 6.0, height: 100 * scaleW)
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 5 * scaleW
        layout.sectionInset = UIEdgeInsets(top: 0, left: 10 * scaleW, bottom: 0, right: 10 * scaleW)
        collView.collectionViewLayout = layout
        viewBack.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didSelectViewBack(_:))))
        lblCity.text = item.name
        lbloC.text = Int(item.data.temperature.rounded(.toNearestOrEven)).description
        imgIcon.image = UIImage(named: item.data.icon)
    }
    @objc func didSelectViewBack(_ sender: Any){
        dismiss(animated: true, completion: nil)
    }
}
extension PopUp7Controller: UICollectionViewDelegate, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 6
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DailyCell.className, for: indexPath) as! DailyCell
        let data = item.daily[indexPath.row + 1]
        cell.lblHigh.text = Int(data.temperatureHigh.rounded(.toNearestOrEven)).description + "°"
        cell.lblLow.text = Int(data.temperatureLow.rounded(.toNearestOrEven)).description + "°"
        cell.lblThu.text = thu[getDayOfDate(Date(timeIntervalSince1970: Double(data.time)))]
        cell.imgIcon.image = UIImage(named: data.icon)
        return cell
    }
    func getDayOfDate(_ date: Date?) -> String{
        guard let inputDate = date else {
            return ""
        }
        let formatter = DateFormatter()
        formatter.dateFormat = "EEE"
        return formatter.string(from: inputDate)
    }
    
}
