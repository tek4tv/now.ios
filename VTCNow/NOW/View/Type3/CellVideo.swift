//
//  CellVideo.swift
//  NOW
//
//  Created by Apple on 23/06/2021.
//

import UIKit
import AVFoundation
import MUXSDKStats
class CellVideo: UITableViewCell {
    static let reuseIdentifier = "CellVideo"
    @IBOutlet weak var imgThumb: LazyImageView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var lblCountDown: UILabel!
    
    @IBOutlet weak var viewPlayer: PlayerView!
    @IBOutlet weak var btnPlay: UIButton!
    @IBOutlet weak var lblCurrentTime: UILabel!
    @IBOutlet weak var slider: CustomSlider!
    @IBOutlet weak var lblDuration: UILabel!
    @IBOutlet weak var viewFullScreen: UIView!
    @IBOutlet weak var viewSetting: UIView!
    @IBOutlet weak var imgShadow: UIImageView!
    @IBOutlet weak var viewCast: UIView!
    @IBOutlet weak var btnForward: UIButton!
    @IBOutlet weak var btnReplay: UIButton!
    @IBOutlet weak var viewShare: UIView!
    var isOn = true
    var delegate: CellVideoDelegate!
    
    var indexPath: IndexPath!
    var item: MediaModel!{
        didSet{
            if item.path != "" {
                
                if Array(item.path)[item.path.count - 1] == "/" {
                    if isOnLive(){
                        
                    } else{
                        isOn = false
                        NotificationCenter.default.addObserver(self, selector: #selector(countDown(_:)), name: NSNotification.Name.init("countDownTimer2"), object: nil)
                    }
                }
            }else{
                if isOnLive(){
                    
                } else{
                    isOn = false
                    NotificationCenter.default.addObserver(self, selector: #selector(countDown(_:)), name: NSNotification.Name.init("countDownTimer2"), object: nil)
                }
            }
        }
    }
    var timeObserver: Any?
    var isCare = false
    var isPlaying = false
    var isEnded = false
    var timer = Timer()
    var listResolution: [StreamResolution] = []
    var speed: Double = 1.0
    
    let activityIndicatorView: UIActivityIndicatorView = {
        let aiv = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.whiteLarge)
        aiv.color = #colorLiteral(red: 0.5225926042, green: 0.0004706631007, blue: 0.2674992383, alpha: 1)
        aiv.translatesAutoresizingMaskIntoConstraints = false
        //aiv.startAnimating()
        return aiv
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        viewPlayer.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didSelectViewPlayer(_:))))
        viewSetting.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didSelectViewSetting(_:))))
        viewFullScreen.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didSelectBtnFullScreen(_:))))
        viewShare.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didSelectViewShare(_:))))
        
        slider.addTarget(self, action: #selector(sliderDidEndSliding), for: [.touchUpInside, .touchUpOutside])
        
        hidePlayerController()
        //
        viewPlayer.addSubview(activityIndicatorView)
        activityIndicatorView.centerXAnchor.constraint(equalTo: viewPlayer.centerXAnchor).isActive = true
        activityIndicatorView.centerYAnchor.constraint(equalTo: viewPlayer.centerYAnchor).isActive = true
        //
        NotificationCenter.default.addObserver(self, selector: #selector(stopVOD(_:)), name: NSNotification.Name("stopVOD"), object: nil)
        
        
        
    }
    @objc func release(_ noti: Notification){
        NotificationCenter.default.removeObserver(self)
        viewPlayer.player?.removeObserver(self, forKeyPath: "currentItem.loadedTimeRanges", context: nil)
        viewPlayer.player?.removeObserver(self, forKeyPath: "timeControlStatus", context: nil)
        timer.invalidate()
        if let timeObserver = timeObserver {
            viewPlayer.player?.removeTimeObserver(timeObserver)
            self.timeObserver = nil
        }
    }
    deinit {
        NotificationCenter.default.removeObserver(self)
        if let timeObserver = timeObserver {
            viewPlayer.player?.removeTimeObserver(timeObserver)
            self.timeObserver = nil
        }
        timer.invalidate()
    }
    @objc func stopVOD(_ sender: Any){
        isPlaying = false
        if viewPlayer.player != nil {
            viewPlayer.player?.pause()
            viewPlayer.player?.replaceCurrentItem(with: nil)
        }
        viewPlayer.player?.replaceCurrentItem(with: nil)
    }
    @objc func didSelectViewShare(_ sender: Any){
        delegate?.didSelectViewShare(self)
    }
    @objc func didSelectViewBookmark(_ sender: Any){
        delegate?.didSelectViewBookmark(self)
    }
    
    @objc func playerDidFinishPlaying(note: NSNotification){
        btnPlay.setBackgroundImage(#imageLiteral(resourceName: "PLAY"), for: .normal)
        viewPlayer.player?.pause()
        isEnded = true
        isPlaying = false
        UserDefaults.standard.removeObject(forKey: item.privateID)
        UserDefaults.standard.synchronize()
        delegate?.didFinish()
    }
    var isTapping = false
    
    @objc func didSelectViewPlayer(_ sender: Any){
        if isTapping{
            hidePlayerController()
            timer.invalidate()
        } else{
            showPlayerController()
            timer = Timer.scheduledTimer(withTimeInterval: 5.0, repeats: false, block: {[weak self] timer in
                if self?.isSliderChanging == false{
                    self?.hidePlayerController()
                    self?.isTapping = false
                    timer.invalidate()
                }
                
            })
        }
        isTapping = !isTapping
        delegate?.scrollToTop(self)
    }
    var isSliderChanging = false
    @IBAction func sliderValueChanged(_ sender: UISlider) {
        viewPlayer.player?.pause()
        isPlaying = false
        if let timeObserver = timeObserver {
            viewPlayer.player?.removeTimeObserver(timeObserver)
            self.timeObserver = nil
        }
        
        isSliderChanging = true
        isEnded = false
        viewPlayer.player?.seek(to: CMTimeMake(value: Int64(sender.value) * 1000, timescale: 1000), toleranceBefore: CMTime.zero, toleranceAfter: CMTime.zero)
        guard let currentItem = self.viewPlayer.player?.currentItem, currentItem.duration >= CMTime.zero else {return}
        self.lblCurrentTime.text = self.getTimeString(from: currentItem.currentTime())
    }
    @objc func sliderDidEndSliding(){
        addTimeObserver()
        viewPlayer.player?.play()
        isPlaying = true
        isSliderChanging = false
        _ = Timer.scheduledTimer(withTimeInterval: 5.0, repeats: false, block: {[weak self] timer in
            if self?.isSliderChanging == false{
                self?.hidePlayerController()
            }
        })
    }
    @IBAction func didSelectBtnPlay(_ sender: Any) {
        if isPlaying{
            viewPlayer.player?.pause()
            btnPlay.setBackgroundImage(#imageLiteral(resourceName: "PLAY"), for: .normal)
        } else{
            if isEnded{
                viewPlayer.player?.seek(to: CMTime.zero)
                isEnded = false
            }
            viewPlayer.player?.play()
            viewPlayer.player?.rate = Float(speed)
            btnPlay.setBackgroundImage(#imageLiteral(resourceName: "PAUSE"), for: .normal)
        }
        isPlaying = !isPlaying
        
        //
        imgThumb.isHidden = true
        delegate?.scrollToTop(self)
    }
    @IBAction func didSelectBtnForward(_ sender: Any) {
        guard let duration = viewPlayer.player?.currentItem?.duration else { return }
        let currentTime = CMTimeGetSeconds(viewPlayer.player!.currentTime())
        let newTime = currentTime + 5.0
        
        if newTime < (CMTimeGetSeconds(duration) - 5.0) {
            let time: CMTime = CMTimeMake(value: Int64(newTime * 1000), timescale: 1000)
            viewPlayer.player?.seek(to: time, toleranceBefore: CMTime.zero, toleranceAfter: CMTime.zero)
        }
    }
    @IBAction func didSelectBtnReplay(_ sender: Any) {
        let currentTime = CMTimeGetSeconds(viewPlayer.player!.currentTime())
        var newTime = currentTime - 5.0
        
        if newTime < 0 {
            newTime = 0
        }
        let time: CMTime = CMTimeMake(value: Int64(newTime * 1000), timescale: 1000)
        viewPlayer.player?.seek(to: time, toleranceBefore: CMTime.zero, toleranceAfter: CMTime.zero)
    }
    func hidePlayerController(){
        self.imgShadow.isHidden = true
        self.viewFullScreen.isHidden = true
        self.viewSetting.isHidden = true
        self.lblCurrentTime.isHidden = true
        self.lblDuration.isHidden = true
        self.slider.isHidden = true
        self.btnPlay.isHidden = true
        self.viewCast.isHidden = true
        self.btnReplay.isHidden = true
        self.btnForward.isHidden = true
    }
    func showPlayerController(){
        self.imgShadow.isHidden = false
        self.viewFullScreen.isHidden = false
        self.viewSetting.isHidden = false
        self.lblCurrentTime.isHidden = false
        self.lblDuration.isHidden = false
        self.slider.isHidden = false
        self.btnPlay.isHidden = false
        self.viewCast.isHidden = false
        self.btnReplay.isHidden = false
        self.btnForward.isHidden = false
    }
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "currentItem.loadedTimeRanges", viewPlayer != nil, let duration = viewPlayer.player?.currentItem?.duration.seconds, duration > 0.0{
            self.lblDuration.text = getTimeString(from: (viewPlayer.player?.currentItem!.duration)!)
            activityIndicatorView.stopAnimating()
        }
        if keyPath == "timeControlStatus"{
            if (viewPlayer.player?.timeControlStatus == .playing) {
                
                activityIndicatorView.stopAnimating()
                imgThumb.isHidden = true
                //player is playing
            }
            else if (viewPlayer.player?.timeControlStatus == .paused) {
                //player is pause
            }
            else if (viewPlayer.player?.timeControlStatus == .waitingToPlayAtSpecifiedRate) {
                //player is waiting to play
                activityIndicatorView.startAnimating()
                
            }
        }
    }
    func addTimeObserver(){
        let interval = CMTime(seconds: 0.5, preferredTimescale: CMTimeScale(NSEC_PER_SEC))
        let mainQueue = DispatchQueue.main
        timeObserver = viewPlayer.player?.addPeriodicTimeObserver(forInterval: interval, queue: mainQueue, using: {[weak self] (time) in
            guard let currentItem = self?.viewPlayer.player?.currentItem, currentItem.duration >= CMTime.zero else {return}
            guard currentItem.status.rawValue == AVPlayerItem.Status.readyToPlay.rawValue else {return}
            self?.slider.maximumValue =  (Float(currentItem.duration.seconds) > 0) ? Float(currentItem.duration.seconds) : 0
            self?.slider.minimumValue = 0
            self?.slider.value = Float(currentItem.currentTime().seconds)
            self?.lblCurrentTime.text = self?.getTimeString(from: currentItem.currentTime())
            UserDefaults.standard.setValue(currentItem.currentTime().seconds, forKey: self!.item.privateID)
        })
    }
    func getTimeString(from time: CMTime) -> String{
        let totalSeconds = CMTimeGetSeconds(time)
        let hours = Int(totalSeconds / 3600)
        let minutes = Int(totalSeconds / 60) % 60
        let seconds = Int(totalSeconds.truncatingRemainder(dividingBy: 60))
        if hours > 0{
            return String(format: "%d:%02d:%02d", hours, minutes, seconds)
        } else{
            return String(format: "%02d:%02d", minutes, seconds)
        }
    }
    override func prepareForReuse() {
        imgThumb.image = nil
        lblTime.text = ""
        lblCountDown.text = ""
        lblTime.textColor = .lightGray
        viewPlayer.player?.pause()
        viewPlayer.player?.replaceCurrentItem(with: nil)
        btnPlay.setBackgroundImage(#imageLiteral(resourceName: "PLAY"), for: .normal)
    }
    @objc func countDown(_ notification: Notification){
        if let futureDate = item.schedule.toDate(){
            let interval = futureDate - Date()
            if let hour = interval.hour, let minute = interval.minute, let second = interval.second{
                let timeStr = String(format: "%02d:%02d:%02d", hour, minute % 60, second % 60)
                if hour <= 0 && minute <= 0 && second <= 0{
                    viewPlayer.player?.play()
                    isOn = true
                    lblCountDown.isHidden = true
                    imgShadow.isHidden = true
                    imgThumb.isHidden = true
                    NotificationCenter.default.removeObserver(self, name: NSNotification.Name.init("countDownTimer2"), object: nil)
                } else{
                    item.timePass = "\(timeStr)"
                    lblCountDown.isHidden = false
                    imgShadow.isHidden = false
                    lblCountDown.text = timeStr
                    activityIndicatorView.stopAnimating()
                    imgThumb.isHidden = false
                }
            }
            lblTime.text = item.timePass
        }
    }
    func isOnLive() -> Bool{
        print(item.name)
        if let futureDate = item.schedule.toDate(){
            let interval = futureDate - Date()
            if let hour = interval.hour, let minute = interval.minute, let second = interval.second{
                let timeStr = String(format: "%02d:%02d:%02d", hour, minute % 60, second % 60)
                if hour <= 0 && minute <= 0 && second <= 0{
                    if item.name.contains("Trực tiếp") {
                        lblTime.text = "Trực tiếp"
                    } else{
                        lblTime.text = "Đang phát"
                    }
                    lblTime.textColor = #colorLiteral(red: 0.5069422722, green: 0.000876982871, blue: 0.2585287094, alpha: 1)
                    lblCountDown.isHidden = true
                    return true
                } else{
                    lblTime.text = "\(timeStr)"
                    return false
                }
            }
        }
        return false
    }
    func setup(){
        btnPlay.isHidden = true
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playback, mode: .default, options: [])
        }
        catch {
            print("Setting category to AVAudioSessionCategoryPlayback failed.")
        }
        //activityIndicatorView.startAnimating()
        listResolution = []
        var link = ""
        if item.path != "" {
            link = item.path
            if Array(link)[link.count - 1] == "/" {
                link = item.fileCode
            }
        }else{
            link = item.fileCode
        }
        if let url = URL(string: link.replacingOccurrences(of: "\\", with: "/")){
            if link.contains(".m3u8"){
                StreamHelper.shared.getPlaylist(from: url) { [weak self] (result) in
                    switch result {
                    case .success(let playlist):
                        self?.listResolution = StreamHelper.shared.getStreamResolutions(from: playlist)
                        self?.listResolution.insert(StreamResolution(maxBandwidth: 0, averageBandwidth: 0, resolution: CGSize(width: 854.0, height: 480.0)), at: 0)
                        self?.listResolution[0].isTicked = true
                    case .failure(let error):
                        print(error.localizedDescription)
                    }
                }
            }
            
        }
        viewPlayer.player?.addObserver(self, forKeyPath: "currentItem.loadedTimeRanges", options: .new, context: nil)
        viewPlayer.player?.addObserver(self, forKeyPath: "timeControlStatus", options: [.old, .new], context: nil)
        NotificationCenter.default.addObserver(self, selector:#selector(self.playerDidFinishPlaying(note:)),name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: nil)
        isPlaying = true
        btnPlay.setBackgroundImage(#imageLiteral(resourceName: "PAUSE"), for: .normal)
        addTimeObserver()
        if let temp = UserDefaults.standard.value(forKey: item.privateID) as? Double, temp > 0.0{
            let time: CMTime = CMTimeMake(value: Int64(temp * 1000), timescale: 1000)
            viewPlayer.player?.seek(to: time, toleranceBefore: CMTime.zero, toleranceAfter: .zero)
        }
    }
    func monitor(_ item: MediaModel){ 
        let playerData = MUXSDKCustomerPlayerData(environmentKey: environmentKey)
        playerData?.playerName = "AVPlayer"
        let videoData = MUXSDKCustomerVideoData()
        videoData.videoId = item.privateID
        videoData.videoTitle = item.name
        MUXSDKStats.monitorAVPlayerLayer(viewPlayer.layer as! AVPlayerLayer, withPlayerName: "iOS AVPlayer", playerData: playerData!, videoData: videoData)
    }
    func setBitRate(){
        for (index, temp) in listResolution.enumerated(){
            if index == 0, temp.isTicked {
                viewPlayer.player?.currentItem?.preferredPeakBitRate = 0
            } else if index != 0, temp.isTicked {
                viewPlayer.player?.currentItem?.preferredPeakBitRate = temp.maxBandwidth
            }
        }
    }
    func setSpeed(){
        viewPlayer.player?.rate = Float(speed)
    }
    @objc func didSelectViewSetting(_ sender: Any) {
        var flag = false
        for item in listResolution{
            if item.resolution.height == viewPlayer.player?.currentItem?.presentationSize.height{
                let temp = StreamResolution(maxBandwidth: item.maxBandwidth, averageBandwidth: item.averageBandwidth, resolution: item.resolution)
                temp.isTicked = item.isTicked
                listResolution[0] = temp
            }
            if item.isTicked {
                flag = true
            }
        }
        if flag == false, listResolution.count > 0{
            listResolution[0].isTicked = true
        }
        delegate?.didSelectViewSetting(self)
    }
    @objc func didSelectBtnFullScreen(_ sender: Any) {
        self.viewPlayer.player?.pause()
        self.btnPlay.setBackgroundImage(#imageLiteral(resourceName: "PLAY"), for: .normal)
        self.isPlaying = false
        let newPlayer = self.viewPlayer.player
        self.viewPlayer.player = nil
        
        delegate?.didSelectViewFullScreen(self, newPlayer!)
    }
}

protocol CellVideoDelegate: AnyObject {
    func didSelectViewSetting(_ cell: CellVideo)
    func didSelectViewFullScreen(_ cell: CellVideo, _ newPlayer: AVPlayer)
    func didSelectViewCast()
    func didSelectViewShare(_ cell: CellVideo)
    func didSelectViewBookmark(_ cell: CellVideo)
    func didFinish()
    func scrollToTop(_ cell: CellVideo)
}
