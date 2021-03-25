//
//  ListenController.swift
//  NOW
//
//  Created by dovietduy on 3/1/21.
//

import UIKit
import AVFoundation

class ListenController: UIViewController {

    @IBOutlet weak var imgThumb: LazyImageView!
    @IBOutlet weak var tblView: UITableView!
    @IBOutlet weak var lblChanel: UILabel!
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var viewChanel: UIView!
    @IBOutlet weak var imgPlay: UIImageView!
    @IBOutlet weak var viewPlayer: UIView!
    @IBOutlet weak var lblListen: UILabel!
    @IBOutlet weak var viewButton: UIView!
    
    @IBOutlet weak var heightTable: NSLayoutConstraint!
    
    var player: AVPlayer!
    var isPlaying = false
    var isTapping = false
    var listData: [ChannelModel] = []
    var index = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tblView.delegate = self
        tblView.dataSource = self
        tblView.register(UINib(nibName: ChanelCell.className, bundle: nil), forCellReuseIdentifier: ChanelCell.className)
        // Do any additional setup after loading the view.
        viewChanel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didSelectViewChanel(_:))))
        viewPlayer.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didSelectViewPlayer(_:))))
        NotificationCenter.default.addObserver(self, selector: #selector(stopPlaying(_:)), name: NSNotification.Name("stopRadio"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(reStartPlaying(_:)), name: NSNotification.Name("replayRadio"), object: nil)
        APIService.shared.getRadio { (data, error) in
            if let data = data as? [ChannelModel] {
                self.listData = data
                if let url = URL(string: root.cdn.imageDomain + data[0].image[0].url.replacingOccurrences(of: "\\", with: "/" )){
                    self.imgThumb.loadImage(fromURL: url)
                }
                self.lblChanel.text = self.listData[0].name
                self.lblDescription.text = self.listData[0].description
                self.openChannel()
                self.tblView.reloadData()
            }
        }
        
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    @objc func stopPlaying(_ notification: Notification){
        if let player = player{
            player.pause()
            lblListen.text = "NGHE"
            isPlaying = false
            imgPlay.image = #imageLiteral(resourceName: "icons8-play-96")
        }
    }
    @objc func reStartPlaying(_ notification: Notification){
        if let player = player{
            player.play()
            lblListen.text = "ĐANG NGHE"
            isPlaying = true
            imgPlay.image = #imageLiteral(resourceName: "icons8-pause-96")
        }
    }
    func openChannel(){
        if let url = URL(string: listData[index].url[0].link){
            do {
                try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playback, mode: .default, options: [])
                try AVAudioSession.sharedInstance().setActive(true)
                
            }
            catch {
                print("Setting category to AVAudioSessionCategoryPlayback failed.")
            }
            
            player = AVPlayer(url: url)
            player.play()
            lblListen.text = "ĐANG NGHE"
            isPlaying = true
            imgPlay.image = #imageLiteral(resourceName: "icons8-pause-96")
        }
    }
    @objc func didSelectViewPlayer(_ sender: Any){
        if isPlaying{
            player.pause()
            lblListen.text = "NGHE"
            //lblListen.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            //viewPlayer.backgroundColor = #colorLiteral(red: 0.5019607843, green: 0.01176470588, blue: 0.2588235294, alpha: 1)
            imgPlay.image = #imageLiteral(resourceName: "icons8-play-96")
        } else {
            guard let player = player else {
                return
            }
            player.play()
            lblListen.text = "ĐANG NGHE"
            //lblListen.textColor = #colorLiteral(red: 0.5019607843, green: 0.01176470588, blue: 0.2588235294, alpha: 1)
            //viewPlayer.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            imgPlay.image = #imageLiteral(resourceName: "icons8-pause-96")
        }
        isPlaying = !isPlaying
    }
    @objc func didSelectViewChanel(_ sender: Any){
        if isTapping{
            tblView.isHidden = true
        }else{
            tblView.isHidden = false
        }
        isTapping = !isTapping
        heightTable.constant = CGFloat(listData.count * 50) * scaleH
    }
}
extension ListenController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ChanelCell.className, for: indexPath) as! ChanelCell
        let item = listData[indexPath.row]
        cell.lblTitle.text = item.name
        cell.lblDescription.text = item.description
        if indexPath.row == index{
            cell.lblTitle.textColor = #colorLiteral(red: 0.5019607843, green: 0.01176470588, blue: 0.2588235294, alpha: 1)
            cell.lblDescription.textColor = #colorLiteral(red: 0.5019607843, green: 0.01176470588, blue: 0.2588235294, alpha: 1)
        }else{
            cell.lblTitle.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            cell.lblDescription.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        }
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        lblChanel.text = listData[indexPath.row].name
        lblDescription.text = listData[indexPath.row].description
        index = indexPath.row
        if let url = URL(string: root.cdn.imageDomain + listData[indexPath.row].image[0].url.replacingOccurrences(of: "\\", with: "/" )){
            self.imgThumb.loadImage(fromURL: url)
        }
        openChannel()
        tblView.isHidden = true
        tblView.reloadData()
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50 * scaleH
    }
}
