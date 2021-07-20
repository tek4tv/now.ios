//
//  VideoController.swift
//  NOW
//
//  Created by dovietduy on 4/7/21.
//

import UIKit
import AVFoundation
import MUXSDKStats
import FirebaseDynamicLinks
extension VideoController{
    override var preferredStatusBarStyle: UIStatusBarStyle {
        if #available(iOS 13.0, *) {
            return .darkContent
        } else {
            // Fallback on earlier versions
            return .default
        }
    }
}
class VideoController: UIViewController{
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        URLCache.shared.removeAllCachedResponses()
        URLCache.shared.diskCapacity = 0
        URLCache.shared.memoryCapacity = 0
    }
    @IBOutlet weak var collView: UICollectionView!
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var imgAudio: LazyImageView!
    @IBOutlet weak var viewBack: UIView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblCast: UILabel!
    @IBOutlet weak var viewShare: UIView!
    @IBOutlet weak var viewPlayer: PlayerView!
    @IBOutlet weak var btnPlay: UIButton!
    @IBOutlet weak var btnNext: UIButton!
    @IBOutlet weak var btnPrevious: UIButton!
    @IBOutlet weak var lblCurrentTime: UILabel!
    @IBOutlet weak var slider: CustomSlider!
    @IBOutlet weak var lblDuration: UILabel!
    @IBOutlet weak var viewFullScreen: UIView!
    @IBOutlet weak var viewSetting: UIView!
    @IBOutlet weak var imgShadow: UIImageView!
    @IBOutlet weak var viewCast: UIView!
    @IBOutlet weak var lblDescription: UILabel!
    
    @IBOutlet weak var heightCollView: NSLayoutConstraint!
    
    var item: MediaModel!
    var listData: [MediaModel] = []
    var timeObserver: Any?
    var isPlaying = false
    var isEnded = false
    var timer = Timer()
    var listResolution: [StreamResolution] = []
    var speed: Double = 1.0
    var isXemThem = true
    let activityIndicatorView: UIActivityIndicatorView = {
        let aiv = UIActivityIndicatorView(style: .whiteLarge)
        aiv.color = #colorLiteral(red: 0.5225926042, green: 0.0004706631007, blue: 0.2674992383, alpha: 1)
        aiv.translatesAutoresizingMaskIntoConstraints = false
        //aiv.startAnimating()
        return aiv
    }()
    deinit {
        NotificationCenter.default.removeObserver(self)
        viewPlayer.player?.removeObserver(self, forKeyPath: "currentItem.loadedTimeRanges", context: nil)
        viewPlayer.player?.removeObserver(self, forKeyPath: "timeControlStatus", context: nil)
        timer.invalidate()
        if let timeObserver = timeObserver {
            viewPlayer.player?.removeTimeObserver(timeObserver)
            self.timeObserver = nil
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        //
        collView.delegate = self
        collView.dataSource = self
        collView.register(UINib(nibName: Type4ItemCell.reuseIdentifier, bundle: nil), forCellWithReuseIdentifier: Type4ItemCell.reuseIdentifier)
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: (414 - 60) / 2.01 * scaleW, height: 190 * scaleW)
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.sectionInset = UIEdgeInsets(top: 10 * scaleW, left: 20 * scaleW, bottom: 0, right: 20 * scaleW)
        collView.collectionViewLayout = layout
        // Do any additional setup after loading the view.
        viewPlayer.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didSelectViewPlayer(_:))))
        viewSetting.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didSelectViewSetting(_:))))
        viewFullScreen.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didSelectBtnFullScreen(_:))))
        slider.addTarget(self, action: #selector(sliderDidEndSliding), for: [.touchUpInside, .touchUpOutside])
        viewBack.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didSelectViewBack(_:))))
        viewShare.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didSelectViewShare(_:))))
        hidePlayerController()
        //
        viewPlayer.addSubview(activityIndicatorView)
        activityIndicatorView.centerXAnchor.constraint(equalTo: viewPlayer.centerXAnchor).isActive = true
        activityIndicatorView.centerYAnchor.constraint(equalTo: viewPlayer.centerYAnchor).isActive = true
        
        openVideoAudio()
        let count = listData.count
        let no1 = Double(count) / 2.0
        let no2 = Double(count / 2)
        if no1 > no2 {
            heightCollView.constant = CGFloat((no2 + 1) * 190) * scaleW
        } else {
            heightCollView.constant = CGFloat(no2 * 190) * scaleW
        }
//        var row = Double(listData.count) / 2.0
//        row = row.rounded(.toNearestOrEven)
//        heightCollView.constant = CGFloat(row * 190) * scaleW
        
        //
        lblDescription.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didSelectLbl(_:))))
        //
        if let url = URL(string: root.cdn.imageDomain + item.thumnail.replacingOccurrences(of: "\\", with: "/" )){
            imgAudio.loadImage(fromURL: url)
            imgAudio.isHidden = false
        }
    }
    @objc func didSelectLbl(_ sender: Any){
        if isXemThem == true {
            if item.descripTion.count > 150 {
                lblDescription.text = item.descripTion + "..."
                let partTwo = NSAttributedString(string: "Ẩn bớt", attributes: [NSAttributedString.Key.font: lblDescription.font!, NSAttributedString.Key.foregroundColor: #colorLiteral(red: 0.5069422722, green: 0.000876982871, blue: 0.2585287094, alpha: 1) ])
                let combination = NSMutableAttributedString()
                
                combination.append(lblDescription.attributedText!)
                combination.append(partTwo)
                lblDescription.attributedText = combination
            }
        }else{
            if item.descripTion.count > 150 {
                lblDescription.text = item.descripTion.prefix(150) + "..."
                let partTwo = NSAttributedString(string: "Xem thêm", attributes: [NSAttributedString.Key.font: lblDescription.font!, NSAttributedString.Key.foregroundColor: #colorLiteral(red: 0.5069422722, green: 0.000876982871, blue: 0.2585287094, alpha: 1) ])
                let combination = NSMutableAttributedString()
                
                combination.append(lblDescription.attributedText!)
                combination.append(partTwo)
                lblDescription.attributedText = combination
            }
        }
        isXemThem = !isXemThem
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
    }
    @objc func didSelectViewBack(_ sender: Any){
        self.viewPlayer.player?.pause()
        self.viewPlayer.player?.replaceCurrentItem(with: nil)
        NotificationCenter.default.removeObserver(self)
        timer.invalidate()
        if let timeObserver = timeObserver {
            viewPlayer.player?.removeTimeObserver(timeObserver)
            self.timeObserver = nil
        }
        self.navigationController?.popViewController(animated: false)
    }
    @objc func didSelectViewShare(_ sender: Any){
        var components = URLComponents()
        components.scheme = "https"
        components.host = "www.now.vtc.vn"
        components.path = "/about"
        let itemIDQueryItem = URLQueryItem(name: "id", value: item.privateID)
        let typeQueryItem = URLQueryItem(name: "type", value: "movie")
        components.queryItems = [typeQueryItem, itemIDQueryItem]
        
        guard let linkParameter = components.url else { return }
        //print("I am sharing \(linkParameter.absoluteString)")
        
        // Create the big dynamic link
        guard let sharedLink = DynamicLinkComponents.init(link: linkParameter, domainURIPrefix: "https://h6z5d.app.goo.gl") else {
           // print("Couldn't create FDL components")
            return
        }
        
        sharedLink.iOSParameters = DynamicLinkIOSParameters(bundleID: "vn.vtc.now")
        sharedLink.iOSParameters?.appStoreID = "1355778168"
        sharedLink.iOSParameters?.minimumAppVersion = "1.3.0"
        sharedLink.iOSParameters?.fallbackURL = URL(string: "https://now.vtc.vn/viewvod/a/\(item.privateID).html")
        sharedLink.androidParameters = DynamicLinkAndroidParameters(packageName: "com.accedo.vtc")
        sharedLink.socialMetaTagParameters = DynamicLinkSocialMetaTagParameters()
        sharedLink.socialMetaTagParameters?.title = "\(item.name)"
        sharedLink.socialMetaTagParameters?.imageURL = URL(string: root.cdn.imageDomain + item.thumnail.replacingOccurrences(of: "\\", with: "/"))
        guard let longURL = sharedLink.url else { return }
        //print("The long dynamic link is \(longURL.absoluteString)")
        
        sharedLink.shorten { url, warnings, error in
            if let error = error {
                print("Oh no! Got error \(error)")
                return
            }
//            if let warnings = warnings {
//                for warning in warnings {
//                    //print("FDL warnings: \(warning)")
//                }
//            }
            guard let url = url else {return}
            //print("I have a short URL to share! \(url.absoluteString)")
            let ac = UIActivityViewController(activityItems: [url], applicationActivities: nil)
            ac.popoverPresentationController?.sourceView = self.view
            self.present(ac, animated: true)
        }
//        guard let url = URL(string: "https://now.vtc.vn/viewvod/a/\(item.privateID).html") else {
//            return
//        }
//        let itemsToShare = [url]
//        let ac = UIActivityViewController(activityItems: itemsToShare, applicationActivities: nil)
//        ac.popoverPresentationController?.sourceView = self.view
//        self.present(ac, animated: true)
    }
    @objc func playerDidFinishPlaying(note: NSNotification){
        btnPlay.setBackgroundImage(#imageLiteral(resourceName: "PLAY"), for: .normal)
        viewPlayer.player?.pause()
        isEnded = true
        isPlaying = false
        UserDefaults.standard.removeObject(forKey: item.privateID)
        UserDefaults.standard.synchronize()

        
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
    func monitor(_ item: MediaModel){
        let playerData = MUXSDKCustomerPlayerData(environmentKey: environmentKey)
        playerData?.playerName = "AVPlayer"
        let videoData = MUXSDKCustomerVideoData()
        videoData.videoId = item.privateID
        videoData.videoTitle = item.name
        MUXSDKStats.monitorAVPlayerLayer(viewPlayer.layer as! AVPlayerLayer, withPlayerName: "iOS AVPlayer", playerData: playerData!, videoData: videoData)
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
    }
    @IBAction func didSelectBtnNext(_ sender: Any) {
//        listData.append(item)
//        item = listData[0]
//        listData.remove(at: 0)
//        collView.reloadData()
//        openVideoAudio()
        guard let duration = viewPlayer.player?.currentItem?.duration else { return }
        let currentTime = CMTimeGetSeconds(viewPlayer.player!.currentTime())
        let newTime = currentTime + 5.0
        
        if newTime < (CMTimeGetSeconds(duration) - 5.0) {
            let time: CMTime = CMTimeMake(value: Int64(newTime * 1000), timescale: 1000)
            viewPlayer.player?.seek(to: time, toleranceBefore: CMTime.zero, toleranceAfter: CMTime.zero)
        }
    }
    @IBAction func didSelectBtnPrevious(_ sender: Any) {
//        listData.insert(item, at: 0)
//        let count = listData.count
//        item = listData[count - 1]
//        listData.remove(at: count - 1)
//        collView.reloadData()
//        openVideoAudio()
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
        self.btnNext.isHidden = true
        self.btnPrevious.isHidden = true
        self.viewCast.isHidden = true
    }
    func showPlayerController(){
        self.imgShadow.isHidden = false
        self.viewFullScreen.isHidden = false
        self.viewSetting.isHidden = false
        self.lblCurrentTime.isHidden = false
        self.lblDuration.isHidden = false
        self.slider.isHidden = false
        self.btnPlay.isHidden = false
        self.btnNext.isHidden = false
        self.btnPrevious.isHidden = false
        self.viewCast.isHidden = false
    }
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "currentItem.loadedTimeRanges", viewPlayer != nil, let duration = viewPlayer.player?.currentItem?.duration.seconds, duration > 0.0{
            self.lblDuration.text = getTimeString(from: (viewPlayer.player?.currentItem!.duration)!)
            activityIndicatorView.stopAnimating()
        }
        if keyPath == "timeControlStatus"{
            if (viewPlayer.player?.timeControlStatus == .playing) {
                imgAudio.isHidden = true
                activityIndicatorView.stopAnimating()
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
    func openVideoAudio(){
        
        if let url = URL(string: item.path.replacingOccurrences(of: "\\", with: "/")){
            listResolution = []
            do {
                try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playback, mode: .default, options: [])
            }
            catch {
                print("Setting category to AVAudioSessionCategoryPlayback failed.")
            }
            if item.path.contains("m3u8"){
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
            
            viewPlayer.player  = AVPlayer(url: url)
            monitor(item)
            viewPlayer.player?.play()
            viewPlayer.player?.addObserver(self, forKeyPath: "currentItem.loadedTimeRanges", options: .new, context: nil)
            viewPlayer.player?.addObserver(self, forKeyPath: "timeControlStatus", options: [.old, .new], context: nil)
            NotificationCenter.default.addObserver(self, selector:#selector(self.playerDidFinishPlaying(note:)),name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: nil)
            isPlaying = true
            btnPlay.setBackgroundImage(#imageLiteral(resourceName: "PAUSE"), for: .normal)
            lblTitle.text = item.name
            if item.episode != "" {
                lblCast.text = "Tập " + item.episode + "/" + item.totalEpisode
            } else if item.country != "" {
                lblCast.text = "Quốc gia: " + item.country
            } else{
                lblCast.text = item.getTimePass()
            }
            

            lblDescription.text = item.descripTion
            if item.descripTion.count > 150 {
                lblDescription.text = item.descripTion.prefix(150) + "..."
                let partTwo = NSAttributedString(string: "Xem thêm", attributes: [NSAttributedString.Key.font: lblDescription.font!, NSAttributedString.Key.foregroundColor: #colorLiteral(red: 0.5069422722, green: 0.000876982871, blue: 0.2585287094, alpha: 1) ])
                let combination = NSMutableAttributedString()

                combination.append(lblDescription.attributedText!)
                combination.append(partTwo)
                lblDescription.attributedText = combination
            }
            addTimeObserver()
        }
        if item.path.contains("mp3"){
            if let url = URL(string: root.cdn.imageDomain + item.thumnail.replacingOccurrences(of: "\\", with: "/" )){
                imgAudio.loadImage(fromURL: url)
            }
        }
        if let temp = UserDefaults.standard.value(forKey: item.privateID) as? Double, temp > 0.0{
            let time: CMTime = CMTimeMake(value: Int64(temp * 1000), timescale: 1000)
            viewPlayer.player?.seek(to: time, toleranceBefore: CMTime.zero, toleranceAfter: .zero)
        }
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
        let vc = storyboard?.instantiateViewController(withIdentifier: PopUp2Controller.className) as! PopUp2Controller
        vc.modalPresentationStyle = .custom
        vc.modalTransitionStyle = .crossDissolve
        vc.listResolution = listResolution
        vc.speed = speed
        vc.onComplete = {[weak self] list in
            self?.listResolution = list
            self?.setBitRate()
        }
        vc.onTickedSpeed = {[weak self] value in
            self?.speed = value
            self?.setSpeed()
        }
        present(vc, animated: true, completion: nil)
    }
    @objc func didSelectBtnFullScreen(_ sender: Any) {
        
        self.viewPlayer.player?.pause()
        self.btnPlay.setBackgroundImage(#imageLiteral(resourceName: "PLAY"), for: .normal)
        self.isPlaying = false
        let newPlayer = self.viewPlayer.player
        self.viewPlayer.player = nil
        if #available(iOS 13.0, *) {
            let vc = storyboard?.instantiateViewController(withIdentifier: FullScreenController.className) as! FullScreenController
            vc.player = newPlayer
            vc.item = item
            vc.listResolution = self.listResolution
            vc.onDismiss = {[weak self] in
                self?.viewPlayer.player = vc.player
                vc.player = nil
                self?.viewPlayer.player?.play()
                self?.isPlaying = true
                self?.btnPlay.setBackgroundImage(#imageLiteral(resourceName: "PAUSE"), for: .normal)
            }
            vc.modalPresentationStyle = .fullScreen
            present(vc, animated: true, completion: nil)
        } else {
            let vc = PlayerViewController()
            
            
            vc.player = newPlayer
            vc.onDismiss = {[weak self] in
                self?.viewPlayer.player = vc.player
                vc.player = nil
                self?.viewPlayer.player?.play()
                self?.isPlaying = true
                self?.btnPlay.setBackgroundImage(#imageLiteral(resourceName: "PAUSE"), for: .normal)
            }
            present(vc, animated: true) {
                vc.player?.play()
                vc.addObserver(self, forKeyPath: #keyPath(UIViewController.view.frame), options: [.old, .new], context: nil)
            }
        }
        
    }
}

extension VideoController: UICollectionViewDelegate, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        listData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Type4ItemCell.reuseIdentifier, for: indexPath) as! Type4ItemCell
        if indexPath.row < listData.count {
            let item = listData[indexPath.row]
            if let url = URL(string: root.cdn.imageDomain + item.thumnail.replacingOccurrences(of: "\\", with: "/" )){
                cell.thumbImage.loadImage(fromURL: url)
            }
            cell.lblTitle.text = item.name
            if item.country != "" {
                cell.lblCountry.isHidden = false
                cell.lblCountry.text = item.country
            }
            if item.episode != "" {
                cell.viewEpisode.isHidden = false
                cell.lblEpisode.text = item.episode
                cell.lblTotalEpisode.text = item.totalEpisode
                cell.lblCountry.isHidden = false
                cell.lblCountry.text = item.getTimePass()
            } else {
                cell.viewEpisode.isHidden = true
            }
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        let count = listData.count
//        
//        var list: [MediaModel] = []
//        if count == 1{
//            list = []
//        } else if count == 2{
//            if indexPath.row == 0 {
//                list.append(listData[1])
//            } else{
//                list.append(listData[0])
//            }
//        } else if count >= 3 {
//            if indexPath.row == 0{
//                list = Array(listData[1...count-1])
//            } else if indexPath.row == count-1 {
//                list = Array(listData[0...count - 2])
//            } else{
//                if item.episode != "" {
//                    list = Array(listData[0...indexPath.row-1]).reversed() + Array(listData[indexPath.row+1...count-1])
//                    
//                }else{
//                    list = Array(listData[indexPath.row+1...count-1] + listData[0...indexPath.row-1])
//                }
//                
//            }
//        }
//        list.append(item)
//        item = listData[indexPath.row]
//        listData = list
//        collView.reloadData()
        if item.episode == "" {
            let count = listData.count
            
            var list: [MediaModel] = []
            if count == 1{
                list = []
            } else if count == 2{
                if indexPath.row == 0 {
                    list.append(listData[1])
                } else{
                    list.append(listData[0])
                }
            } else if count >= 3 {
                if indexPath.row == 0{
                    list = Array(listData[1...count-1])
                } else if indexPath.row == count-1 {
                    list = Array(listData[0...count - 2])
                } else{
                    list = Array(listData[indexPath.row+1...count-1] + listData[0...indexPath.row-1])
                }
            }
            list.append(item)
            item = listData[indexPath.row]
            listData = list
            collView.reloadData()
        } else {
            item = listData[indexPath.row]
        }
        if let url = URL(string: root.cdn.imageDomain + item.thumnail.replacingOccurrences(of: "\\", with: "/" )){
            imgAudio.loadImage(fromURL: url)
            imgAudio.isHidden = false
        }
        viewPlayer.player?.replaceCurrentItem(with: nil)
        openVideoAudio()
        scrollView.setContentOffset(CGPoint.zero, animated: true)
    }
    
}

