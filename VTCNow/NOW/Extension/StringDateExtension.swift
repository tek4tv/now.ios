//
//  StringDateExtension.swift
//  VTCNow
//
//  Created by dovietduy on 1/26/21.
//

import Foundation
import AVKit
extension String{
    func toJsonArray() -> [[String: Any]]{
        let data = self.data(using: .utf8)!
        do {
            if let jsonArray = try JSONSerialization.jsonObject(with: data, options : .allowFragments) as? [[String: Any]]{
                return jsonArray
            } else {
                return []
            }
        } catch let error as NSError {
            print(error)
        }
        return []
    }
    func toJson() -> [String: Any]{
        let data = self.data(using: .utf8)!
        do {
            if let jsonArray = try JSONSerialization.jsonObject(with: data, options : .allowFragments) as? [String: Any]{
                return jsonArray
            } else {
                return ["":""]
            }
        } catch let error as NSError {
            print(error)
        }
        return ["":""]
    }
    func toDate() -> Date?{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy'-'MM'-'dd'T'HH':'mm':'ss"
        let date = dateFormatter.date(from: self)
        if date != nil{
            return date
        } else{
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MM'/'dd'/'yyyy HH':'mm':'ss a"
            let date = dateFormatter.date(from: self)
            if date != nil{
                return date
            }else{
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy'-'MM'-'dd'T'HH':'mm':'ss'.'SSS"
                return dateFormatter.date(from: self)
            }
        }
        
    }
    func toMinute() -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm:ss"
        if let date = dateFormatter.date(from: self){
            let components = Calendar.current.dateComponents([.hour, .minute], from: date)
            let minutes = components.hour! * 60 + components.minute!
            return "\(minutes) phút"
        }
        return ""
    }
}
extension Date {

    static func -(recent: Date, previous: Date) -> (month: Int?, day: Int?, hour: Int?, minute: Int?, second: Int?) {
        let day = Calendar.current.dateComponents([.day], from: previous, to: recent).day
        let month = Calendar.current.dateComponents([.month], from: previous, to: recent).month
        let hour = Calendar.current.dateComponents([.hour], from: previous, to: recent).hour
        let minute = Calendar.current.dateComponents([.minute], from: previous, to: recent).minute
        let second = Calendar.current.dateComponents([.second], from: previous, to: recent).second

        return (month: month, day: day, hour: hour, minute: minute, second: second)
    }

}
class CustomSlider: UISlider {

    @IBInspectable var trackHeight: CGFloat = 3 * scaleH

    @IBInspectable var thumbRadius: CGFloat = 12 * scaleH

    // Custom thumb view which will be converted to UIImage
    // and set as thumb. You can customize it's colors, border, etc.
    private lazy var thumbView: UIView = {
        let thumb = UIView()
        thumb.backgroundColor = #colorLiteral(red: 0.5019607843, green: 0.01176470588, blue: 0.2588235294, alpha: 1)
        thumb.layer.borderWidth = 0.4
        thumb.layer.borderColor = UIColor.darkGray.cgColor
        return thumb
    }()

    override func awakeFromNib() {
        super.awakeFromNib()
        let thumb = thumbImage(radius: thumbRadius)
        setThumbImage(thumb, for: .normal)
    }

    private func thumbImage(radius: CGFloat) -> UIImage {
        // Set proper frame
        // y: radius / 2 will correctly offset the thumb

        thumbView.frame = CGRect(x: 0, y: radius / 2, width: radius, height: radius)
        thumbView.layer.cornerRadius = radius / 2

        // Convert thumbView to UIImage
        // See this: https://stackoverflow.com/a/41288197/7235585

        let renderer = UIGraphicsImageRenderer(bounds: thumbView.bounds)
        return renderer.image { rendererContext in
            thumbView.layer.render(in: rendererContext.cgContext)
        }
    }

    override func trackRect(forBounds bounds: CGRect) -> CGRect {
        // Set custom track height
        // As seen here: https://stackoverflow.com/a/49428606/7235585
        var newRect = super.trackRect(forBounds: bounds)
        newRect.size.height = trackHeight
        return newRect
    }

}
