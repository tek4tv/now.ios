//
//  HomeController.swift
//  VTCNow
//
//  Created by dovietduy on 1/26/21.
//

import UIKit
import AVFoundation
import MarqueeLabel
//import GoogleInteractiveMediaAds
class HomeController: UITabBarController, UITabBarControllerDelegate{//}, IMAAdsLoaderDelegate , IMAAdsManagerDelegate {
//    func adsManagerDidRequestContentPause(_ adsManager: IMAAdsManager!) {
//        // Pause the content for the SDK to play ads.
//        viewPlayer.player?.pause()
//    }
//
//    func adsManagerDidRequestContentResume(_ adsManager: IMAAdsManager!) {
//        // Resume the content since the SDK is done playing ads (at least for now).
//        viewPlayer.player?.play()
//    }
//
//    func adsManager(_ adsManager: IMAAdsManager!, didReceive event: IMAAdEvent!) {
//        if event.type == IMAAdEventType.LOADED {
//            adsManager.start()
//        }
//    }
//
//    func adsManager(_ adsManager: IMAAdsManager!, didReceive error: IMAAdError!) {
//        // Fall back to playing content
//        print("AdsManager error: " + error.message)
//        //viewPlayer.player?.play()
//    }
//
//    func adsLoader(_ loader: IMAAdsLoader!, adsLoadedWith adsLoadedData: IMAAdsLoadedData!) {
//        adsManager = adsLoadedData.adsManager
//        adsManager.delegate = self
//        adsManager.initialize(with: nil)
//    }
//
//    func adsLoader(_ loader: IMAAdsLoader!, failedWith adErrorData: IMAAdLoadingErrorData!) {
//        print("Error loading ads: " + adErrorData.adError.message)
//        //viewPlayer.player?.play()
//    }
//    static let AdTagURLString = "https://pubads.g.doubleclick.net/gampad/ads?sz=640x480&iu=/124319096/external/single_ad_samples&ciu_szs=300x250&impl=s&gdfp_req=1&env=vp&output=vast&unviewed_position_start=1&cust_params=deployment%3Ddevsite%26sample_ct%3Dskippablelinear&correlator="
//
//    var adsLoader: IMAAdsLoader!
//    var adsManager: IMAAdsManager!
//    var playerViewController: AVPlayerViewController!
//    var contentPlayhead: IMAAVPlayerContentPlayhead?
//    func setUpAdsLoader() {
//        adsLoader = IMAAdsLoader(settings: nil)
//        adsLoader.delegate = self
//    }
//    @objc func contentDidFinishPlaying(_ notification: Notification) {
//        //adsLoader.contentComplete()
//    }
//    func requestAds() {
//        // Create ad display container for ad rendering.
//        let adDisplayContainer = IMAAdDisplayContainer(adContainer: viewPlayer, companionSlots: nil)
//        // Create an ad request with our ad tag, display container, and optional user context.
//        let request = IMAAdsRequest(
//            adTagUrl: HomeController.AdTagURLString,
//            adDisplayContainer: adDisplayContainer,
//            contentPlayhead: contentPlayhead,
//            userContext: nil)
//
//        adsLoader.requestAds(with: request)
//        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
//            self.adsLoader.contentComplete()
//        }
//    }
    
//    @IBOutlet var viewContainer: UIView!
//    @IBOutlet weak var viewBack: UIView!
//    @IBOutlet weak var viewPlayer: PlayerView!
//    @IBOutlet weak var btnPlay: UIButton!
//    @IBOutlet weak var btnPlay2: UIButton!
//    @IBOutlet weak var btnDelete: UIButton!
//    @IBOutlet weak var lblCurrentTime: UILabel!
//    @IBOutlet weak var slider: CustomSlider!
//    @IBOutlet weak var lblDuration: UILabel!
//    @IBOutlet weak var viewFullScreen: UIView!
//    @IBOutlet weak var btnSetting: UIButton!
//    @IBOutlet weak var imgShadow: UIImageView!
//    @IBOutlet weak var imgCountDown: LazyImageView!
//    @IBOutlet weak var viewHeader: UIView!
//    @IBOutlet weak var viewBackward: UIView!
//    @IBOutlet weak var viewForward: UIView!
//
//    @IBOutlet weak var lblTime: UILabel!
//    @IBOutlet weak var lblTitle: UILabel!
//    @IBOutlet weak var lblTitle2: MarqueeLabel!
//    @IBOutlet weak var lblDescription: UILabel!
//
//    @IBOutlet weak var topViewPlayer: NSLayoutConstraint!
//    @IBOutlet weak var widthViewPlayer: NSLayoutConstraint!
//    @IBOutlet weak var heightCollView: NSLayoutConstraint!
//
//
//    @IBOutlet weak var view3Dot: UIButton!
//    @IBOutlet weak var viewCare: UIView!
//    @IBOutlet weak var lblCare: UILabel!
//    @IBOutlet weak var imgTick: UIImageView!
//    @IBOutlet weak var lblMayBeCare: UILabel!
//    @IBOutlet weak var viewLine: UIView!
//    @IBOutlet weak var collView: UICollectionView!
//    @IBOutlet weak var scrollView: UIScrollView!
//    @IBOutlet weak var imgThumb: UIImageView!
//    @IBOutlet weak var viewCountDown: UIView!
//    @IBOutlet weak var lblCountDown: UILabel!
//    @IBOutlet weak var txfView: UITextField!
//    let activityIndicatorView: UIActivityIndicatorView = {
//        let aiv = UIActivityIndicatorView(style: .whiteLarge)
//        aiv.translatesAutoresizingMaskIntoConstraints = false
//        aiv.startAnimating()
//        return aiv
//    }()
//    var timeObserver: Any?
//    var isCare = false
//    var player: AVPlayer!
//    var playerLayer: AVPlayerLayer!
//    var isPlaying = false
//    var isEnded = false
//    var timer = Timer()
//    var listResolution: [StreamResolution] = []
//    var speed: Double = 1.0
    
    override func viewDidLoad() {
        //setUpAdsLoader()
        super.viewDidLoad()
//        txfView.delegate = self
//        viewPlayer.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didSelectViewPlayer(_:))))
//        viewBackward.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didSelectViewBackward(_:))))
//        viewForward.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didSelectViewForward(_:))))
//        slider.addTarget(self, action: #selector(sliderDidEndSliding), for: [.touchUpInside, .touchUpOutside])
//        slider.setThumbImage(UIImage(named: "ic_circle2"), for: .highlighted)
//        NotificationCenter.default.addObserver(self, selector: #selector(didOpenVideo(_:)), name: NSNotification.Name("openVideo"), object: nil)
//        NotificationCenter.default.addObserver(self, selector: #selector(didStopVideo(_:)), name: NSNotification.Name("StopPlayVideo"), object: nil)
//        NotificationCenter.default.addObserver(self, selector: #selector(didStopMP3(_:)), name: NSNotification.Name("StopMP3Video"), object: nil)
//
//        NotificationCenter.default.addObserver(self, selector: #selector(rotated(_:)), name: UIDevice.orientationDidChangeNotification, object: nil)
//        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(didSwipeDown(_:)))
//        let swipeUp = UISwipeGestureRecognizer(target: self, action: #selector(didSwipeUp(_:)))
//
//        swipeUp.direction = .up
//        swipeDown.direction = .down
//
//        viewContainer.addGestureRecognizer(swipeDown)
//        viewContainer.addGestureRecognizer(swipeUp)
//        viewContainer.alpha = 0
//        viewBack.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didSelectViewBack(_:))))
//        viewCare.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didSelectCare(_:))))
//        viewFullScreen.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didSelectBtnFullScreen(_:))))
//        //
//        collView.delegate = self
//        collView.dataSource = self
//        collView.register(UINib(nibName: SubTypeCell.className, bundle: nil), forCellWithReuseIdentifier: SubTypeCell.className)
//        let layout = UICollectionViewFlowLayout()
//        layout.itemSize = CGSize(width: 190 * scaleW, height: 200 * scaleW)
//        layout.sectionInset = UIEdgeInsets(top: 0, left: 8 * scaleW, bottom: 0, right: 8 * scaleW)
//        layout.minimumLineSpacing = 0
//        layout.minimumInteritemSpacing = 0
//        collView.collectionViewLayout = layout
        self.delegate = self
        
        
//        viewPlayer.addSubview(activityIndicatorView)
//        activityIndicatorView.centerXAnchor.constraint(equalTo: viewPlayer.centerXAnchor).isActive = true
//        activityIndicatorView.centerYAnchor.constraint(equalTo: viewPlayer.centerYAnchor).isActive = true
    }
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        NotificationCenter.default.post(name: NSNotification.Name("openMessage"), object: nil)
//    }
//    @objc func rotated(_ sender: Any) {
//        if self.viewContainer.alpha == 1{
//            if UIDevice.current.orientation.isLandscape{
//                self.viewPlayer.player?.pause()
//                self.btnPlay.setBackgroundImage(#imageLiteral(resourceName: "icons8-play-49"), for: .normal)
//                self.isPlaying = false
//                let newPlayer = self.viewPlayer.player
//                self.viewPlayer.player = nil
//                let vc = PlayerView2Controller()
//
//
//                vc.player = newPlayer
//                vc.onDismiss = {[weak self] in
//                    self?.viewPlayer.player = vc.player
//                    vc.player = nil
//                    self?.viewPlayer.player?.play()
//                    self?.isPlaying = true
//                    self?.btnPlay.setBackgroundImage(#imageLiteral(resourceName: "icons8-pause-49"), for: .normal)
//                    if let window = UIApplication.shared.keyWindow {
//                        window.addSubview((self?.viewContainer)!)
//                    }
//                }
//                present(vc, animated: true) {
//                    vc.player?.play()
//                    vc.addObserver(self, forKeyPath: #keyPath(UIViewController.view.frame), options: [.old, .new], context: nil)
//                }
//            }
//        }
//
//
//    }
//    @objc func didStopVideo(_ notification: Notification){
//        didSelectBtnDelete(Any.self)
//    }
//    @objc func didStopMP3(_ notification: Notification){
//        if let item = sharedItem, item.path.contains("mp3"){
//            isPlaying = false
//            viewPlayer.player?.pause()
//            btnPlay.setBackgroundImage(#imageLiteral(resourceName: "icons8-play-49"), for: .normal)
//            self.btnPlay2.setImage(#imageLiteral(resourceName: "icons8-play-48"), for: .normal)
//        }
//    }
//    func setHeightCollView(){
//        let count = sharedList.count
//        if (Double(count) / 2.0) > (Double(count/2)){
//            heightCollView.constant = CGFloat((count/2 + 1) * 220) * scaleW
//        } else{
//            heightCollView.constant = CGFloat((count/2) * 220) * scaleW
//        }
//        scrollView.setContentOffset(CGPoint.zero, animated: true)
//    }
//
//    @objc func didSelectBtnFullScreen(_ sender: Any) {
//        self.viewPlayer.player?.pause()
//        self.btnPlay.setBackgroundImage(#imageLiteral(resourceName: "icons8-play-49"), for: .normal)
//        self.isPlaying = false
//        let newPlayer = self.viewPlayer.player
//        self.viewPlayer.player = nil
//        let vc = PlayerViewController()
//
//
//        vc.player = newPlayer
//        vc.onDismiss = {[weak self] in
//            self?.viewPlayer.player = vc.player
//            vc.player = nil
//            self?.viewPlayer.player?.play()
//            self?.isPlaying = true
//            self?.btnPlay.setBackgroundImage(#imageLiteral(resourceName: "icons8-pause-49"), for: .normal)
//            if let window = UIApplication.shared.keyWindow {
//                window.addSubview((self?.viewContainer)!)
//            }
//        }
//        present(vc, animated: true) {
//            vc.player?.play()
//            vc.addObserver(self, forKeyPath: #keyPath(UIViewController.view.frame), options: [.old, .new], context: nil)
//        }
//
//    }
//    @IBAction func didSelectBtn3Dot(_ sender: Any) {
//        let vc = storyboard?.instantiateViewController(withIdentifier: "PopUpController") as! PopUpController
//        vc.data = sharedItem
//        vc.modalPresentationStyle = .custom
//        vc.modalTransitionStyle = .crossDissolve
//        present(vc, animated: true, completion: nil)
//    }
//    @objc func didSelectCare(_ sender: Any){
//        isCare = !isCare
//        if isCare{
//            lblCare.isHidden = true
//            imgTick.isHidden = false
//        } else{
//            lblCare.isHidden = false
//            imgTick.isHidden = true
//        }
//    }
//    deinit {
//        NotificationCenter.default.removeObserver(self)
//        timer.invalidate()
//    }
//    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
//        didSwipeDown(Any.self)
//        
//        NotificationCenter.default.post(name: NSNotification.Name("stopVideo"), object: nil)
//    }
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        guard let items = tabBar.items else { return }
        guard let index = items.firstIndex(of: item) else{return}
        if  index != tabBarIndex, tabBarIndex == 1{
            NotificationCenter.default.post(name: NSNotification.Name("StopPlayBook"), object: nil)
        } else if index != tabBarIndex, tabBarIndex == 2{
            NotificationCenter.default.post(name: NSNotification.Name("stopLive"), object: nil)
        }
        if index == 2{
            NotificationCenter.default.post(name: NSNotification.Name("StopPlayBook"), object: nil)
        }
        if index == 1{
            NotificationCenter.default.post(name: NSNotification.Name("StopPlayBook"), object: nil)
        }
        if index == 3{
            NotificationCenter.default.post(name: NSNotification.Name("StopPlayBook"), object: nil)
        }
        tabBarIndex = index
    }

//    @objc func didOpenVideo(_ notification: Notification){
//        //requestAds()
//        activityIndicatorView.startAnimating()
//        if let window = UIApplication.shared.keyWindow {
//            window.addSubview(self.viewContainer)
//        }
//        lblCurrentTime.text = "00:00"
//        lblDuration.text = "00:00"
//        if let timeObserver = timeObserver {
//            viewPlayer.player?.removeTimeObserver(timeObserver)
//            self.timeObserver = nil
//        }
//        UIView.animate(withDuration: 0.5) {
//
//            self.topViewPlayer.constant = 104 * scaleH
//            self.widthViewPlayer.constant = 414 * scaleW
//            self.viewContainer.frame = CGRect(x: 0, y: 0, width: 414 * scaleW, height: UIScreen.main.bounds.height - self.tabBar.bounds.height)
//            self.hidePlayerController()
//            self.viewHeader.alpha = 1
//            self.showComponent()
//            self.view.layoutIfNeeded()
//        }
//        if let url = URL(string: sharedItem.path){
//            do {
//                try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playback, mode: .default, options: [])
//            }
//            catch {
//                print("Setting category to AVAudioSessionCategoryPlayback failed.")
//            }
//            //
//            listResolution = []
//            StreamHelper.shared.getPlaylist(from: url) { [weak self] (result) in
//                switch result {
//                case .success(let playlist):
//                    self?.listResolution = StreamHelper.shared.getStreamResolutions(from: playlist)
//                    self?.listResolution.insert(StreamResolution(maxBandwidth: 0, averageBandwidth: 0, resolution: CGSize(width: 854.0, height: 480.0)), at: 0)
//                    self?.listResolution[0].isTicked = true
//                case .failure(let error):
//                    print(error.localizedDescription)
//                }
//            }
//            //
//            player = AVPlayer(url: url)
//            viewPlayer.player  = player
//            contentPlayhead = IMAAVPlayerContentPlayhead(avPlayer: player)
//            viewPlayer.player?.play()
//            viewPlayer.player?.addObserver(self, forKeyPath: "currentItem.loadedTimeRanges", options: .new, context: nil)
//            viewPlayer.player?.addObserver(self, forKeyPath: "timeControlStatus", options: [.old, .new], context: nil)
//            isMessaging = false
//            NotificationCenter.default.addObserver(
//                self,
//                selector: #selector(HomeController.contentDidFinishPlaying(_:)),
//                name: NSNotification.Name.AVPlayerItemDidPlayToEndTime,
//                object: player.currentItem);
//            NotificationCenter.default.addObserver(self, selector:#selector(self.playerDidFinishPlaying(note:)),name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: nil)
//            isPlaying = true
//            btnPlay.setBackgroundImage(#imageLiteral(resourceName: "icons8-pause-49"), for: .normal)
//
//            addTimeObserver()
//            setHeightCollView()
//            //requestAds()
//        }
//        //
//        if sharedItem.country != ""{
//            self.lblTime.text = "Quốc gia: " + sharedItem.country
//        }else if sharedItem.cast != "" {
//            self.lblTime.text = sharedItem.cast
//        }else{
//            self.lblTime.text = sharedItem.timePass
//        }
//
//        self.lblTitle.text = sharedItem.name
//        self.lblTime.textColor = .gray
//        self.lblTitle2.text = sharedItem.name
//        self.btnPlay2.setImage(#imageLiteral(resourceName: "icons8-pause-49"), for: .normal)
//        self.lblDescription.text = sharedItem.descripTion
//
//        //
//        if sharedItem.fileCode != ""{
//            guard let player = viewPlayer.player else {
//                return
//            }
//            if sharedItem.timePass != "Trực tiếp"{
//                player.pause()
//                isPlaying = false
//                viewCountDown.isHidden = false
//            }
//
//            if let url = URL(string:root.cdn.imageDomain + sharedItem.thumnail.replacingOccurrences(of: "\\", with: "/" )){
//                imgCountDown.loadImage(fromURL: url)
//            }
//            NotificationCenter.default.addObserver(self, selector: #selector(countDown(_:)),name: NSNotification.Name ("countDownTimer"), object: nil)
//            timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true, block: {(timer) in
//                NotificationCenter.default.post(name: NSNotification.Name.init("countDownTimer2"), object: nil)
//            })
//        }
//        //
//        if sharedItem.path.contains("mp3"){
//            if let url = URL(string: root.cdn.imageDomain + sharedItem.image[0].url.replacingOccurrences(of: "\\", with: "/" )){
//                for view in viewPlayer.subviews{
//                    if view.tag == 123 {
//                        view.removeFromSuperview()
//                    }
//                }
//                let image = LazyImageView()
//                image.loadImage(fromURL: url)
//                image.contentMode = .scaleAspectFit
//                image.translatesAutoresizingMaskIntoConstraints = false
//                image.tag = 123
//                viewPlayer.insertSubview(image, at: 0)
//                        NSLayoutConstraint.activate([
//                            image.topAnchor.constraint(equalTo: viewPlayer.topAnchor),
//                            image.leadingAnchor.constraint(equalTo: viewPlayer.leadingAnchor),
//                            image.trailingAnchor.constraint(equalTo: viewPlayer.trailingAnchor),
//                            image.bottomAnchor.constraint(equalTo: viewPlayer.bottomAnchor)
//                        ])
//            }
//        }else{
//            for view in viewPlayer.subviews{
//                if view.tag == 123 {
//                    view.removeFromSuperview()
//                }
//            }
//        }
//
//        if let temp = UserDefaults.standard.value(forKey: sharedItem.privateID) as? Double, temp > 0.0{
//            let time: CMTime = CMTimeMake(value: Int64(temp * 1000), timescale: 1000)
//            viewPlayer.player?.seek(to: time, toleranceBefore: CMTime.zero, toleranceAfter: .zero)
//        }
//
//
//        collView.reloadData()
//    }
//    var imageView: UIImageView = {
//            let imageView = UIImageView(frame: .zero)
//            imageView.image = #imageLiteral(resourceName: "placeHolderImage")
//            imageView.contentMode = .scaleToFill
//            imageView.translatesAutoresizingMaskIntoConstraints = false
//            imageView.tag = 123
//            return imageView
//        }()
//    @objc func countDown(_ sender: Notification){
//        self.activityIndicatorView.stopAnimating()
//        if let futureDate = sharedItem.schedule.toDate(){
//            let interval = futureDate - Date()
//            if let hour = interval.hour, let minute = interval.minute, let second = interval.second{
//                let timeStr = String(format: "%02d:%02d:%02d", hour, minute % 60, second % 60)
//                sharedItem.timePass = "Còn \(timeStr)"
//                lblTime.textColor = .gray
//                lblCountDown.text = "\(timeStr)"
//                lblTime.text = sharedItem.timePass
//                if hour <= 0 && minute <= 0 && second <= 0{
//                    NotificationCenter.default.removeObserver(self, name: NSNotification.Name ("countDownTimer"), object: nil)
//                    guard let player = viewPlayer.player else {
//                        return
//                    }
//                    viewCountDown.isHidden = true
//                    player.play()
//                    isPlaying = true
//                    sharedItem.timePass = "Trực tiếp"
//                    lblTime.textColor = .red
//                    lblTime.text = sharedItem.timePass
//                    return
//                }
//            }
//        }
//    }
//    var isSliderChanging = false
//    @IBAction func sliderValueChanged(_ sender: UISlider) {
//        viewPlayer.player?.pause()
//        isPlaying = false
//        if let timeObserver = timeObserver {
//            viewPlayer.player?.removeTimeObserver(timeObserver)
//            self.timeObserver = nil
//        }
//
//        isSliderChanging = true
//        isEnded = false
//        viewPlayer.player?.seek(to: CMTimeMake(value: Int64(sender.value) * 1000, timescale: 1000), toleranceBefore: CMTime.zero, toleranceAfter: CMTime.zero)
//        guard let currentItem = self.viewPlayer.player?.currentItem, currentItem.duration >= CMTime.zero else {return}
//        self.lblCurrentTime.text = self.getTimeString(from: currentItem.currentTime())
//    }
//    @objc func sliderDidEndSliding(){
//        addTimeObserver()
//        viewPlayer.player?.play()
//        isPlaying = true
//        isSliderChanging = false
//        DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
//            if self.isSliderChanging == false{
//                self.hidePlayerController()
//                self.view.layoutIfNeeded()
//            }
//        }
//    }
//    @IBAction func didSelectBtnPlay2(_ sender: Any) {
//        didSelectBtnPlay(sender)
//    }
//    @IBAction func didSelectBtnPlay(_ sender: Any) {
//        if isPlaying{
//            viewPlayer.player?.pause()
//            btnPlay.setBackgroundImage(#imageLiteral(resourceName: "icons8-play-49"), for: .normal)
//            self.btnPlay2.setImage(#imageLiteral(resourceName: "icons8-play-48"), for: .normal)
//        } else{
//            if isEnded{
//                viewPlayer.player?.seek(to: CMTime.zero)
//                isEnded = false
//            }
//            viewPlayer.player?.play()
//            viewPlayer.player?.rate = Float(speed)
//            btnPlay.setBackgroundImage(#imageLiteral(resourceName: "icons8-pause-49"), for: .normal)
//            self.btnPlay2.setImage(#imageLiteral(resourceName: "icons8-pause-48"), for: .normal)
//        }
//        isPlaying = !isPlaying
//    }
//    var isTapping = false
//
//    @objc func didSelectViewPlayer(_ sender: Any){
//        if isTapping{
//            hidePlayerController()
//            view.layoutIfNeeded()
//            timer.invalidate()
//        } else{
//            showPlayerController()
//            view.layoutIfNeeded()
//            timer = Timer.scheduledTimer(withTimeInterval: 5.0, repeats: false, block: {[weak self] timer in
//                if self?.isSliderChanging == false{
//                    self?.hidePlayerController()
//                    self?.view.layoutIfNeeded()
//                    self?.isTapping = false
//                    timer.invalidate()
//                }
//
//            })
//        }
//        isTapping = !isTapping
//    }
//    @objc func didSwipeDown(_ sender: Any){
//        UIView.animate(withDuration: 0.5) {
//            self.viewContainer.frame = CGRect(x: 0, y: UIScreen.main.bounds.height - self.tabBar.bounds.height - 80 * scaleH, width: 414 * scaleW, height: 80 * scaleH)
//            self.topViewPlayer.constant = 0
//            self.widthViewPlayer.constant = 142 * scaleH
//            self.hideComponent()
//        }
//    }
//    @objc func didSwipeUp(_ sender: Any){
//        UIView.animate(withDuration: 0.5) {
//            self.viewContainer.frame = CGRect(x: 0, y: 0, width: 414 * scaleW, height: UIScreen.main.bounds.height - self.tabBar.bounds.height)
//            self.topViewPlayer.constant = 104 * scaleH
//            self.widthViewPlayer.constant = 414 * scaleW
//            self.showComponent()
//        }
//    }
//
//    func hidePlayerController(){
//        self.imgShadow.isHidden = true
//        self.viewFullScreen.isHidden = true
//        self.btnSetting.isHidden = true
//        self.lblCurrentTime.isHidden = true
//        self.lblDuration.isHidden = true
//        self.slider.isHidden = true
//        self.btnPlay.isHidden = true
//        self.viewForward.isHidden = true
//        self.viewBackward.isHidden = true
//    }
//    func showPlayerController(){
//        self.imgShadow.isHidden = false
//        self.viewFullScreen.isHidden = false
//        self.btnSetting.isHidden = false
//        self.lblCurrentTime.isHidden = false
//        self.lblDuration.isHidden = false
//        self.slider.isHidden = false
//        self.btnPlay.isHidden = false
//        self.viewForward.isHidden = false
//        self.viewBackward.isHidden = false
//    }
//    func hideComponent(){
//        viewHeader.isHidden = true
//        lblTime.isHidden = true
//        lblTitle.isHidden = true
//        lblDescription.isHidden = true
//        view3Dot.isHidden = true
//        viewCare.isHidden = true
//        collView.isHidden = true
//        viewLine.isHidden = true
//        lblMayBeCare.isHidden = true
//    }
//    func showComponent(){
//        viewContainer.alpha = 1
//        viewHeader.isHidden = false
//        lblTime.isHidden = false
//        lblTitle.isHidden = false
//        lblDescription.isHidden = false
//        view3Dot.isHidden = false
//        viewCare.isHidden = false
//        collView.isHidden = false
//        viewLine.isHidden = false
//        lblMayBeCare.isHidden = false
//    }
//    @objc func didSelectViewBackward(_ sender: Any){
//        let currentTime = CMTimeGetSeconds((viewPlayer.player?.currentTime())!)
//        var newTime = currentTime - 10.0
//        if newTime < 0{
//            newTime = 0
//        }
//        let time: CMTime = CMTimeMake(value: Int64(newTime * 1000), timescale: 1000)
//        viewPlayer.player?.seek(to: time, toleranceBefore: CMTime.zero, toleranceAfter: CMTime.zero)
//    }
//    @objc func didSelectViewForward(_ sender: Any){
//        guard let duration = viewPlayer.player?.currentItem?.duration else {
//            return
//        }
//        let currentTime = CMTimeGetSeconds((viewPlayer.player?.currentTime())!)
//        let newTime = currentTime + 10.0
//        if newTime < (CMTimeGetSeconds(duration) - 10.0){
//            let time: CMTime = CMTimeMake(value: Int64(newTime * 1000), timescale: 1000)
//            viewPlayer.player?.seek(to: time, toleranceBefore: CMTime.zero, toleranceAfter: CMTime.zero)
//        }
//
//    }
//    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
//        if keyPath == "currentItem.loadedTimeRanges", viewPlayer != nil, let duration = viewPlayer.player?.currentItem?.duration.seconds, duration > 0.0{
//            self.lblDuration.text = getTimeString(from: (viewPlayer.player?.currentItem!.duration)!)
//            activityIndicatorView.stopAnimating()
//        }
//        if keyPath == "timeControlStatus"{
//            if (viewPlayer.player?.timeControlStatus == .playing) {
//                activityIndicatorView.stopAnimating()
//                //player is playing
//            }
//            else if (viewPlayer.player?.timeControlStatus == .paused) {
//                //player is pause
//            }
//            else if (viewPlayer.player?.timeControlStatus == .waitingToPlayAtSpecifiedRate) {
//                //player is waiting to play
//                activityIndicatorView.startAnimating()
//
//            }
//        }
//    }
//    @objc func playerDidFinishPlaying(note: NSNotification){
//        btnPlay.setBackgroundImage(#imageLiteral(resourceName: "icons8-play-49"), for: .normal)
//        self.btnPlay2.setImage(#imageLiteral(resourceName: "icons8-play-48"), for: .normal)
//        viewPlayer.player?.pause()
//        isEnded = true
//        isPlaying = false
////        if UserDefaults.standard.bool(forKey: "isAutoNext") == false{
////            if idVideoPlaying < sharedList.count - 1{
////                idVideoPlaying += 1
////                print(idVideoPlaying)
////                sharedItem = sharedList[idVideoPlaying]
////                NotificationCenter.default.post(name: NSNotification.Name("openVideo"), object: nil)
////            }else{
////                idVideoPlaying = 0
////                sharedItem = sharedList[idVideoPlaying]
////                NotificationCenter.default.post(name: NSNotification.Name("openVideo"), object: nil)
////            }
////        }
//        UserDefaults.standard.removeObject(forKey: sharedItem.privateID)
//        UserDefaults.standard.synchronize()
//    }
//
//    func getTimeString(from time: CMTime) -> String{
//        let totalSeconds = CMTimeGetSeconds(time)
//        let hours = Int(totalSeconds / 3600)
//        let minutes = Int(totalSeconds / 60) % 60
//        let seconds = Int(totalSeconds.truncatingRemainder(dividingBy: 60))
//        if hours > 0{
//            return String(format: "%d:%02d:%02d", hours, minutes, seconds)
//        } else{
//            return String(format: "%02d:%02d", minutes, seconds)
//        }
//    }
//
//    func addTimeObserver(){
//        let interval = CMTime(seconds: 0.5, preferredTimescale: CMTimeScale(NSEC_PER_SEC))
//        let mainQueue = DispatchQueue.main
//        timeObserver = viewPlayer.player?.addPeriodicTimeObserver(forInterval: interval, queue: mainQueue, using: {[weak self] (time) in
//            guard let currentItem = self?.viewPlayer.player?.currentItem, currentItem.duration >= CMTime.zero else {return}
//            guard currentItem.status.rawValue == AVPlayerItem.Status.readyToPlay.rawValue else {return}
//            self?.slider.maximumValue =  (Float(currentItem.duration.seconds) > 0) ? Float(currentItem.duration.seconds) : 0
//            self?.slider.minimumValue = 0
//            self?.slider.value = Float(currentItem.currentTime().seconds)
//            self?.lblCurrentTime.text = self?.getTimeString(from: currentItem.currentTime())
//            self?.activityIndicatorView.stopAnimating()
//            UserDefaults.standard.setValue(currentItem.currentTime().seconds, forKey: sharedItem.privateID)
//        })
//    }
//    @objc func didSelectViewBack(_ sender: Any){
//        UIView.animate(withDuration: 1.0) {
//            self.viewContainer.alpha = 0
//            self.viewPlayer.player?.pause()
//            self.viewPlayer.player = nil
//        }
//    }
//    @IBAction func didSelectBtnDelete(_ sender: Any) {
//        UIView.animate(withDuration: 1.0) {
//            self.viewContainer.alpha = 0
//            self.viewPlayer.player?.pause()
//            self.viewPlayer.player = nil
//        }
//    }
//
//    @IBAction func didSelectBtnSetting(_ sender: Any) {
//        var flag = false
//        for item in listResolution{
//            if item.resolution.height == viewPlayer.player?.currentItem?.presentationSize.height{
//                let temp = StreamResolution(maxBandwidth: item.maxBandwidth, averageBandwidth: item.averageBandwidth, resolution: item.resolution)
//                temp.isTicked = item.isTicked
//                listResolution[0] = temp
//            }
//            if item.isTicked {
//                flag = true
//            }
//        }
//        if flag == false, listResolution.count > 0{
//            listResolution[0].isTicked = true
//        }
//
//        let vc = storyboard?.instantiateViewController(withIdentifier: PopUp2Controller.className) as! PopUp2Controller
//        vc.modalPresentationStyle = .custom
//        vc.modalTransitionStyle = .crossDissolve
//        vc.listResolution = listResolution
//        vc.speed = speed
//        vc.onComplete = {[weak self] list in
//            self?.listResolution = list
//            self?.setBitRate()
//        }
//        vc.onTickedSpeed = {[weak self] value in
//            self?.speed = value
//            self?.setSpeed()
//        }
//        present(vc, animated: true, completion: nil)
//
//    }
//    func setBitRate(){
//        for (index, temp) in listResolution.enumerated(){
//            if index == 0, temp.isTicked {
//                viewPlayer.player?.currentItem?.preferredPeakBitRate = 0
//            } else if index != 0, temp.isTicked {
//                viewPlayer.player?.currentItem?.preferredPeakBitRate = temp.maxBandwidth
//            }
//        }
//    }
//    func setSpeed(){
//        viewPlayer.player?.rate = Float(speed)
//    }
}

class CustomTabBar : UITabBar {
    override open func sizeThatFits(_ size: CGSize) -> CGSize {
        super.sizeThatFits(size)
        var sizeThatFits = super.sizeThatFits(size)
        sizeThatFits.height = 90 * scaleH
        return sizeThatFits
    }
}

//extension HomeController: UICollectionViewDelegate, UICollectionViewDataSource{
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return sharedList.count
//    }
//
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SubTypeCell.className, for: indexPath) as! SubTypeCell
//        let item = sharedList[indexPath.row]
//        cell.lblTitle.text = item.name
//
//        if item.country != ""{
//            cell.lblTime.text = "Quốc gia: " + item.country
//        }else if item.cast != "" {
//            cell.lblTime.text = item.cast
//        }else{
//            cell.lblTime.text = item.timePass
//        }
//        cell.item = item
//        if let url = URL(string: root.cdn.imageDomain + item.thumnail.replacingOccurrences(of: "\\", with: "/" )){
//            cell.thumbImage.loadImage(fromURL: url)
//        }
//        return cell
//    }
//
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        sharedItem = sharedList[indexPath.row]
//        NotificationCenter.default.post(name: NSNotification.Name("openVideo"), object: nil)
//    }
//}
//extension HomeController: UITextFieldDelegate {
//    func textFieldShouldReturn(_ textField: UITextField) -> Bool{
//        txfView.endEditing(true)
//        return true
//    }
//}
