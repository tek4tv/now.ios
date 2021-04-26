//
//  BookPlayerController.swift
//  NOW
//
//  Created by dovietduy on 2/28/21.
//

import UIKit
import AVFoundation
import MediaPlayer
import MarqueeLabel
class BookPlayerController: UIViewController {

    @IBOutlet weak var CdImage: UIImageView!
    @IBOutlet weak var backImage: LazyImageView!
    @IBOutlet weak var squareImage: LazyImageView!
    @IBOutlet weak var lblTitle: MarqueeLabel!
    @IBOutlet weak var lblAuthor: UILabel!
    @IBOutlet weak var lblTimeRun: UILabel!
    @IBOutlet weak var lblDuration: UILabel!
    @IBOutlet weak var btnPlay: UIButton!
    @IBOutlet weak var slider: CustomSlider!
    @IBOutlet weak var viewBack: UIView!
    @IBOutlet weak var viewShare: UIView!
    @IBOutlet weak var btnList: UIButton!
    @IBOutlet weak var btnPrevious: UIButton!
    @IBOutlet weak var btnNext: UIButton!
    var timeObserver: Any?
    var isPlaying = false
    var player: AVPlayer!
    var isEnded = false
    var isExpand = false
    var idPlaying = 0
    var data: MediaModel!
    var listData: [MediaModel] = []
    let activityIndicatorView1: UIActivityIndicatorView = {
        let aiv = UIActivityIndicatorView(style: .gray)
        aiv.translatesAutoresizingMaskIntoConstraints = false
        aiv.startAnimating()
        return aiv
    }()
    let activityIndicatorView2: UIActivityIndicatorView = {
        let aiv = UIActivityIndicatorView(style: .gray)
        aiv.translatesAutoresizingMaskIntoConstraints = false
        aiv.startAnimating()
        return aiv
    }()
    let activityIndicatorView3: UIActivityIndicatorView = {
        let aiv = UIActivityIndicatorView(style: .gray)
        aiv.translatesAutoresizingMaskIntoConstraints = false
        aiv.startAnimating()
        return aiv
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        slider.addTarget(self, action: #selector(sliderDidEndSliding), for: [.touchUpInside, .touchUpOutside])
        slider.setThumbImage(UIImage(named: "ic_circle2"), for: .highlighted)
        playAudio()
        
        
        viewBack.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didSelectBtnBack(_:))))
        viewShare.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didSelectViewShare(_:))))
        //
        NotificationCenter.default.post(name: NSNotification.Name("StopPlayVideo"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(didStopBook(_:)), name: NSNotification.Name("StopPlayBook"), object: nil)
        setupRemoteTransportControls()
        animation()
        btnList.isUserInteractionEnabled = false
        btnList.addSubview(activityIndicatorView1)
        activityIndicatorView1.centerXAnchor.constraint(equalTo: btnList.centerXAnchor).isActive = true
        activityIndicatorView1.centerYAnchor.constraint(equalTo: btnList.centerYAnchor).isActive = true
        btnNext.addSubview(activityIndicatorView2)
        activityIndicatorView2.centerXAnchor.constraint(equalTo: btnNext.centerXAnchor).isActive = true
        activityIndicatorView2.centerYAnchor.constraint(equalTo: btnNext.centerYAnchor).isActive = true
        btnPrevious.addSubview(activityIndicatorView3)
        activityIndicatorView3.centerXAnchor.constraint(equalTo: btnPrevious.centerXAnchor).isActive = true
        activityIndicatorView3.centerYAnchor.constraint(equalTo: btnPrevious.centerYAnchor).isActive = true
        APIService.shared.getEpisode(privateKey: data.privateID) {[self] (list, error) in
            if let list = list as? [MediaModel] {
                listData = list
                
                listData = listData.reversed()
                for (index, book) in listData.enumerated() {
                    if book.episode == data.episode {
                        idPlaying = index
                    }
                }
                btnList.isUserInteractionEnabled = true
                activityIndicatorView1.stopAnimating()
                activityIndicatorView2.stopAnimating()
                activityIndicatorView3.stopAnimating()
            }
        }
    }
    func animation(){
        UIView.animate(withDuration: 10, delay: 0, options: .curveLinear) {
            self.CdImage.transform = CGAffineTransform.identity
            self.CdImage.transform = CGAffineTransform(rotationAngle: -CGFloat.pi * 0.999)
        } completion: { (true) in
            UIView.animate(withDuration: 10, delay: 0, options: .curveLinear) {
                self.CdImage.transform = CGAffineTransform(rotationAngle: -CGFloat.pi * 0.999 * 2)
            } completion: { (true) in
                self.animation()
            }

        }
    }
    @objc func didStopBook(_ notification: Notification){
        if let player = player{
            player.pause()
            btnPlay.setBackgroundImage(#imageLiteral(resourceName: "PLAY nghe"), for: .normal)
            isPlaying = false
        }
        UIApplication.shared.endReceivingRemoteControlEvents()
        MPNowPlayingInfoCenter.default().nowPlayingInfo = [:]
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        UIApplication.shared.endReceivingRemoteControlEvents()
        MPNowPlayingInfoCenter.default().nowPlayingInfo = [:]
    }
    @objc func didSelectBtnBack(_ sender: Any) {
        navigationController?.popViewController(animated: false)
        if self.isPlaying {
            self.pause()
            self.isPlaying = false
            self.btnPlay.setBackgroundImage(#imageLiteral(resourceName: "PLAY nghe"), for: .normal)
        }
        UIApplication.shared.endReceivingRemoteControlEvents()
        MPNowPlayingInfoCenter.default().nowPlayingInfo = [:]
    }
    @objc func didSelectViewShare(_ sender: Any){
        guard let url = URL(string: data.path) else {
            return
        }
        let itemsToShare = [url]
        let ac = UIActivityViewController(activityItems: itemsToShare, applicationActivities: nil)
        ac.popoverPresentationController?.sourceView = self.view
        self.present(ac, animated: true)
    }
    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    @IBAction func didSelectBtnReplay5s(_ sender: Any) {
        let currentTime = CMTimeGetSeconds(player.currentTime())
        var newTime = currentTime - 5.0
        
        if newTime < 0 {
            newTime = 0
        }
        let time: CMTime = CMTimeMake(value: Int64(newTime * 1000), timescale: 1000)
        player.seek(to: time, toleranceBefore: CMTime.zero, toleranceAfter: CMTime.zero)
    }
    @IBAction func didSelectBtnForward5s(_ sender: Any) {
        guard let duration = player.currentItem?.duration else { return }
        let currentTime = CMTimeGetSeconds(player.currentTime())
        let newTime = currentTime + 5.0
        
        if newTime < (CMTimeGetSeconds(duration) - 5.0) {
            let time: CMTime = CMTimeMake(value: Int64(newTime * 1000), timescale: 1000)
            player.seek(to: time, toleranceBefore: CMTime.zero, toleranceAfter: CMTime.zero)
        }
    }
    @IBAction func didSelectList(_ sender: Any) {
        if listData.isEmpty {
            view.showToast(message: "Hệ thống đang gặp sự cố!")
        } else {
            let vc = storyboard?.instantiateViewController(withIdentifier: PopUp5Controller.className) as! PopUp5Controller
            vc.modalPresentationStyle = .overFullScreen
            vc.listData = listData
            vc.idPlaying = idPlaying
            present(vc, animated: true, completion: nil)
            vc.onDississ = {[self] (idPlaying) in
                self.idPlaying = idPlaying
                data = listData[idPlaying]
                playAudio()
            }
        }
        
    }
    func playAudio(){
        if let url = URL(string: data.path){
            do {
                try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playback, mode: .default, options: [])
            }
            catch {
                print("Setting category to AVAudioSessionCategoryPlayback failed.")
            }
            player = AVPlayer(url: url)
            player.play()
            player.addObserver(self, forKeyPath: "currentItem.loadedTimeRanges", options: .new, context: nil)
            NotificationCenter.default.addObserver(self, selector:#selector(self.playerDidFinishPlaying(note:)),name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: nil)
            isPlaying = true
            btnPlay.setBackgroundImage(#imageLiteral(resourceName: "PAUSE nghe"), for: .normal)
            addTimeObserver()
            if let url = URL(string: root.cdn.imageDomain + data.square.replacingOccurrences(of: "\\", with: "/" )){
                backImage.kf.setImage(with: url){_ in
                    self.backImage.image = self.backImage.blurImage(usingImage: self.backImage.image ?? UIImage(), blurAmount: 5.0)
                }
                
                squareImage.loadImage(fromURL: url)
            }
            lblTitle.text = data.name + " - Phần " + data.episode + "/" + data.totalEpisode + "       "
            lblAuthor.text = data.author
        }
        setupNowPlaying()
    }
    func setupRemoteTransportControls() {
        // Get the shared MPRemoteCommandCenter
        let commandCenter = MPRemoteCommandCenter.shared()
        
        // Add handler for Play Command
        commandCenter.playCommand.addTarget { [unowned self] event in
            
            if !self.isPlaying {
                self.play()
                self.isPlaying = true
                self.btnPlay.setBackgroundImage(#imageLiteral(resourceName: "PAUSE nghe"), for: .normal)
                return .success
            }
            return .commandFailed
        }

        // Add handler for Pause Command
        commandCenter.pauseCommand.addTarget { [unowned self] event in
        
            if self.isPlaying {
                self.pause()
                self.isPlaying = false
                self.btnPlay.setBackgroundImage(#imageLiteral(resourceName: "PLAY nghe"), for: .normal)
                return .success
            }
            return .commandFailed
        }
        commandCenter.previousTrackCommand.addTarget{ [unowned self] event in
            self.didSelectBtnPrevious(Any.self)
            self.setupNowPlaying()
            return .success
        }
        commandCenter.nextTrackCommand.addTarget{ [unowned self] event in
            self.didSelectBtnNext(Any.self)
            self.setupNowPlaying()
            return .success
        }
    }
    func setupNowPlaying() {
        // Define Now Playing Info
        guard let player = player else {
            return
        }
        var nowPlayingInfo = [String : Any]()
        nowPlayingInfo[MPMediaItemPropertyTitle] = data.name
        nowPlayingInfo[MPMediaItemPropertyArtwork] = MPMediaItemArtwork(boundsSize: self.squareImage.image!.size) { size in
            return #imageLiteral(resourceName: "logo")
        }
        nowPlayingInfo[MPNowPlayingInfoPropertyElapsedPlaybackTime] = player.currentTime
        nowPlayingInfo[MPMediaItemPropertyPlaybackDuration] = player.currentItem?.duration
        nowPlayingInfo[MPNowPlayingInfoPropertyPlaybackRate] = player.rate

        // Set the metadata
        MPNowPlayingInfoCenter.default().nowPlayingInfo = nowPlayingInfo
    }
    func play() {
        player.play()
        updateNowPlaying(isPause: false)
    }

    func pause() {
        player.pause()
        updateNowPlaying(isPause: true)
    }

    func updateNowPlaying(isPause: Bool) {
        // Define Now Playing Info
        var nowPlayingInfo = MPNowPlayingInfoCenter.default().nowPlayingInfo!

        nowPlayingInfo[MPNowPlayingInfoPropertyElapsedPlaybackTime] = player.currentTime
        nowPlayingInfo[MPNowPlayingInfoPropertyPlaybackRate] = isPause ? 0 : 1

        // Set the metadata
        MPNowPlayingInfoCenter.default().nowPlayingInfo = nowPlayingInfo
    }
    @objc func playerDidFinishPlaying(note: NSNotification){
        btnPlay.setBackgroundImage(#imageLiteral(resourceName: "PLAY nghe"), for: .normal)
        player.pause()
        isEnded = true
        isPlaying = false
        
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
    func addTimeObserver(){
        let interval = CMTime(seconds: 0.5, preferredTimescale: CMTimeScale(NSEC_PER_SEC))
        let mainQueue = DispatchQueue.main
        timeObserver = player.addPeriodicTimeObserver(forInterval: interval, queue: mainQueue, using: {[weak self] (time) in
            guard let currentItem = self?.player.currentItem, currentItem.duration >= CMTime.zero else {return}
            guard currentItem.status.rawValue == AVPlayerItem.Status.readyToPlay.rawValue else {return}
            self?.slider.maximumValue =  (Float(currentItem.duration.seconds) > 0) ? Float(currentItem.duration.seconds) : 0
            self?.slider.minimumValue = 0
            self?.slider.value = Float(currentItem.currentTime().seconds)
            self?.lblTimeRun.text = self?.getTimeString(from: currentItem.currentTime())
        })
    }
    @IBAction func sliderValueChanged(_ sender: UISlider) {
        player.pause()
        isPlaying = false
        if let timeObserver = timeObserver {
            player.removeTimeObserver(timeObserver)
            self.timeObserver = nil
        }
        player.seek(to: CMTimeMake(value: Int64(sender.value) * 1000, timescale: 1000), toleranceBefore: CMTime.zero, toleranceAfter: CMTime.zero)
        guard let currentItem = self.player.currentItem, currentItem.duration >= CMTime.zero else {return}
        self.lblTimeRun.text = self.getTimeString(from: currentItem.currentTime())
        
    }
    @objc func sliderDidEndSliding(){
        addTimeObserver()
        player.play()
        isPlaying = true
    }
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "currentItem.loadedTimeRanges", player != nil, let duration = player.currentItem?.duration.seconds, duration > 0.0{
            self.lblDuration.text = getTimeString(from: (player.currentItem!.duration))
        }
    }
    @IBAction func didSelectBtnPlay(_ sender: Any) {
        if isPlaying{
            player.pause()
            btnPlay.setBackgroundImage(#imageLiteral(resourceName: "PLAY nghe"), for: .normal)
            
        } else{
            player.play()
            btnPlay.setBackgroundImage(#imageLiteral(resourceName: "PAUSE nghe"), for: .normal)
        }
        isPlaying = !isPlaying
    }
    @IBAction func didSelectBtnNext(_ sender: Any) {
        if listData.isEmpty {
            
        } else {
            if idPlaying < listData.count - 1 {
                idPlaying += 1
                data = listData[idPlaying]
                playAudio()
            }else{
                idPlaying = 0
                data = listData[idPlaying]
                playAudio()
            }
        }
        
    }
    @IBAction func didSelectBtnPrevious(_ sender: Any) {
        if listData.isEmpty {
            
        } else {
            if idPlaying > 0{
                idPlaying -= 1
                data = listData[idPlaying]
                playAudio()
            }else{
                idPlaying = listData.count - 1
                data = listData[idPlaying]
                playAudio()
            }
        }
    }
    
}

