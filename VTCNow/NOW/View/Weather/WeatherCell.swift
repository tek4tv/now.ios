//
//  ThoiTietCell.swift
//  VTCNow
//
//  Created by dovietduy on 1/25/21.
//

import UIKit

class WeatherCell: UICollectionViewCell {
    static let reuseIdentifier = "WeatherCell"
    @IBOutlet weak var viewSearch: UIView!
    @IBOutlet weak var viewWeather: UIView!
    @IBOutlet weak var lblCity: UILabel!
    @IBOutlet weak var lblC: UILabel!
    @IBOutlet weak var icon: UIImageView!
    var delegate: WeatherDelegate!
    var timer = Timer()
    var index = 0
    var count = 0 {
        didSet{
            if count == 5 {
                lblCity.text = listW[0].name
                lblC.text = Int(listW[0].data.temperature.rounded(.toNearestOrEven)).description + "°C"
                icon.image = UIImage(named: listW[0].data.icon)
                timer = Timer.scheduledTimer(withTimeInterval: 5.0, repeats: true, block: {[self] (timer) in
                    
                    if index < 4 {
                        index += 1
                    } else{
                        index = 0
                    }
                    lblCity.text = listW[index].name
                    lblC.text = Int(listW[index].data.temperature.rounded(.toNearestOrEven)).description + "°C"
                    icon.image = UIImage(named: listW[index].data.icon)
                })
            }
        }
    }
    var listW: [WeatherModel] = [
        WeatherModel("Hà Nội", lat: "21.027763", long: "105.834160"),
        WeatherModel("Hồ Chí Minh", lat: "10.823099", long: "106.629662"),
        WeatherModel("Hải Phòng", lat: "20.844912", long: "106.688087"),
        WeatherModel("Đà Nẵng", lat: "16.054407", long: "108.202164"),
        WeatherModel("Cần Thơ", lat: "10.036200", long: "105.788033"),
    ]
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.getWeathers()
        viewWeather.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didSelectViewWeather(_:))))
    }
    @objc func didSelectViewWeather(_ sender: Any){
        delegate?.didSelectViewWeather(listW[index])
    }
    func getWeathers(){
        APIService.shared.getWeatherHN() { (data, list, error) in
            if let data = data as? TodayModel{
                self.listW[0].data = data
                self.count += 1
            }
            if let list = list as? [DailyModel] {
                self.listW[0].daily = list
            }
        }
        APIService.shared.getWeatherHCM() { (data, list, error) in
            if let data = data as? TodayModel{
                self.listW[1].data = data
                self.count += 1
            }
            if let list = list as? [DailyModel] {
                self.listW[1].daily = list
            }
        }
        APIService.shared.getWeatherHP() { (data, list, error) in
            if let data = data as? TodayModel{
                self.listW[2].data = data
                self.count += 1
            }
            if let list = list as? [DailyModel] {
                self.listW[2].daily = list
            }
        }
        APIService.shared.getWeatherDN() { (data, list, error) in
            if let data = data as? TodayModel{
                self.listW[3].data = data
                self.count += 1
            }
            if let list = list as? [DailyModel] {
                self.listW[3].daily = list
            }
        }
        APIService.shared.getWeatherCT() { (data, list, error) in
            if let data = data as? TodayModel{
                self.listW[4].data = data
                self.count += 1
            }
            if let list = list as? [DailyModel] {
                self.listW[4].daily = list
            }
        }
    }
}
protocol WeatherDelegate: AnyObject {
    func didSelectViewWeather(_ listW: WeatherModel)
}
