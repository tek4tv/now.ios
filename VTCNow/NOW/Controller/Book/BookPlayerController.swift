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
    @IBOutlet weak var viewRepeat: UIView!
    @IBOutlet weak var viewShuffle: UIView!
    @IBOutlet weak var viewShare: UIView!
    @IBOutlet weak var imgRepeat: UIImageView!
    @IBOutlet weak var imgShuffle: UIImageView!
    var timeObserver: Any?
    var isPlaying = false
    var player: AVPlayer!
    var isEnded = false
    var isExpand = false
    var repeatType = 0
    var isShuffle = false
    var idShuffle = idBookPlaying
    override func viewDidLoad() {
        super.viewDidLoad()
        slider.addTarget(self, action: #selector(sliderDidEndSliding), for: [.touchUpInside, .touchUpOutside])
        slider.setThumbImage(UIImage(named: "ic_circle2"), for: .highlighted)
        playAudio()
        
        
        viewBack.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didSelectBtnBack(_:))))
        viewShare.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didSelectViewShare(_:))))
        viewRepeat.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didSelectViewRepeat(_:))))
        viewShuffle.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didSelectViewShuffle(_:))))
        //
        NotificationCenter.default.post(name: NSNotification.Name("StopPlayVideo"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(didStopBook(_:)), name: NSNotification.Name("StopPlayBook"), object: nil)
        setupRemoteTransportControls()
        animation()
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
            btnPlay.setBackgroundImage(#imageLiteral(resourceName: "icons8-circled-play-96 (2)"), for: .normal)
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
        navigationController?.popViewController(animated: true)
        if self.isPlaying {
            self.pause()
            self.isPlaying = false
            self.btnPlay.setBackgroundImage(#imageLiteral(resourceName: "icons8-circled-play-96 (2)"), for: .normal)
        }
        UIApplication.shared.endReceivingRemoteControlEvents()
        MPNowPlayingInfoCenter.default().nowPlayingInfo = [:]
    }
    @objc func didSelectViewShare(_ sender: Any){
        guard let url = URL(string: sharedItem.path) else {
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
    var listStored = sharedList
    @objc func didSelectViewShuffle(_ sender: Any) {
        if isShuffle {
            imgShuffle.image = #imageLiteral(resourceName: "icons8-cross-shuffle-64")
            sharedList = listStored
            idShuffle = idBookPlaying
        }else{
            imgShuffle.image = #imageLiteral(resourceName: "icons8-cross-shuffle-64 (1)")
            let temp = listStored[idBookPlaying]
            sharedList.remove(at: idBookPlaying)
            sharedList.shuffle()
            idShuffle = (0...sharedList.count - 1).randomElement()!
            sharedList.insert(temp, at: idShuffle)
        }
        isShuffle = !isShuffle
    }
    @objc func didSelectViewRepeat(_ sender: Any) {
        if repeatType < 2{
            repeatType += 1
        }else{
            repeatType = 0
        }
        switch repeatType {
        case 0:
            imgRepeat.image = #imageLiteral(resourceName: "icons8-repeat-48")
            break
        case 1:
            imgRepeat.image = #imageLiteral(resourceName: "icons8-repeat-48 (1)")
            break
        case 2:
            imgRepeat.image = #imageLiteral(resourceName: "icons8-repeat-one-64")
            break
        default:
            break
        }
        
    }
    @IBAction func didSelectList(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(withIdentifier: PopUp5Controller.className) as! PopUp5Controller
        vc.modalPresentationStyle = .overFullScreen
        vc.idBook = idShuffle
        vc.isShuffle = isShuffle
        vc.repeatType = repeatType
        vc.onSelected = {[weak self] in
            self?.playAudio()
            self?.idShuffle = idBookPlaying
        }
        present(vc, animated: true, completion: nil)
    }
    func playAudio(){
        if let url = URL(string: sharedItem.path){
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
            btnPlay.setBackgroundImage(#imageLiteral(resourceName: "icons8-pause-button-96 (1)"), for: .normal)
            addTimeObserver()
            if let url = URL(string: root.cdn.imageDomain + sharedItem.square.replacingOccurrences(of: "\\", with: "/" )){
                backImage.kf.setImage(with: url){_ in
                    self.backImage.image = self.backImage.blurImage(usingImage: self.backImage.image ?? UIImage(), blurAmount: 5.0)
                }
                
                squareImage.loadImage(fromURL: url)
            }
            lblTitle.text = sharedItem.name + sharedItem.episode
            if sharedItem.cast != ""{
                lblAuthor.text = sharedItem.cast
            }else{
                lblAuthor.text = sharedItem.author
            }
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
                self.btnPlay.setBackgroundImage(#imageLiteral(resourceName: "icons8-pause-button-96 (1)"), for: .normal)
                return .success
            }
            return .commandFailed
        }

        // Add handler for Pause Command
        commandCenter.pauseCommand.addTarget { [unowned self] event in
        
            if self.isPlaying {
                self.pause()
                self.isPlaying = false
                self.btnPlay.setBackgroundImage(#imageLiteral(resourceName: "icons8-circled-play-96 (2)"), for: .normal)
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
        nowPlayingInfo[MPMediaItemPropertyTitle] = sharedItem.name
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
        btnPlay.setBackgroundImage(#imageLiteral(resourceName: "icons8-circled-play-96 (2)"), for: .normal)
        player.pause()
        isEnded = true
        isPlaying = false
        switch repeatType {
        case 0:
            if idBookPlaying == sharedList.count - 1{
                
            }else{
                idBookPlaying += 1
                sharedItem = sharedList[idBookPlaying]
                playAudio()
            }
            break
        case 1:
            if idBookPlaying < sharedList.count - 1{
                idBookPlaying += 1
                sharedItem = sharedList[idBookPlaying]
                playAudio()
            }else{
                idBookPlaying = 0
                sharedItem = sharedList[idBookPlaying]
                playAudio()
            }
            break
        case 2:
            sharedItem = sharedList[idBookPlaying]
            playAudio()
            break
        default:
            break
        }
        idShuffle = idBookPlaying
        
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
            btnPlay.setBackgroundImage(#imageLiteral(resourceName: "icons8-circled-play-96 (2)"), for: .normal)
            
        } else{
            player.play()
            btnPlay.setBackgroundImage(#imageLiteral(resourceName: "icons8-pause-button-96 (1)"), for: .normal)
        }
        isPlaying = !isPlaying
    }
    @IBAction func didSelectBtnNext(_ sender: Any) {
        if idBookPlaying < sharedList.count - 1{
            idBookPlaying += 1
            sharedItem = sharedList[idBookPlaying]
            playAudio()
        }else{
            idBookPlaying = 0
            sharedItem = sharedList[idBookPlaying]
            playAudio()
        }
        idShuffle = idBookPlaying
    }
    @IBAction func didSelectBtnPrevious(_ sender: Any) {
        if idBookPlaying > 0{
            idBookPlaying -= 1
            sharedItem = sharedList[idBookPlaying]
            playAudio()
        }else{
            idBookPlaying = sharedList.count - 1
            sharedItem = sharedList[idBookPlaying]
            playAudio()
        }
        idShuffle = idBookPlaying
    }
    
}

