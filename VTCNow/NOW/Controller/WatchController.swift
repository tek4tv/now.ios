//
//  WatchController.swift
//  NOW
//
//  Created by dovietduy on 3/8/21.
//

import UIKit
import AVFoundation
import GoogleInteractiveMediaAds
class WatchController: UIViewController {//}, IMAAdsLoaderDelegate , IMAAdsManagerDelegate{
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
//        // Initialize the ads manager.
//        adsManager.initialize(with: nil)
//    }
//
//    func adsLoader(_ loader: IMAAdsLoader!, failedWith adErrorData: IMAAdLoadingErrorData!) {
//        print("Error loading ads: " + adErrorData.adError.message)
//        //viewPlayer.player?.play()
//    }
    var player: AVPlayer!
    var playerLayer: AVPlayerLayer!
    var isPlaying = false
    var isEnded = false
    var timer = Timer()
    var listResolution: [StreamResolution] = []
    var speed: Double = 1.0
    @IBOutlet weak var collView: UICollectionView!
    let activityIndicatorView: UIActivityIndicatorView = {
        let aiv = UIActivityIndicatorView(style: .whiteLarge)
        aiv.translatesAutoresizingMaskIntoConstraints = false
        aiv.startAnimating()
        return aiv
    }()
    @IBOutlet weak var viewPlayer: PlayerView!
    @IBOutlet weak var btnFullScreen: UIButton!
    @IBOutlet weak var btnSetting: UIButton!
    @IBOutlet weak var imgShadow: UIImageView!
    var listData: [ChannelModel] = []
    var index = IndexPath(row: 0, section: 0)
    
    
    
    static let AdTagURLString = "https://pubads.g.doubleclick.net/gampad/ads?sz=640x480&iu=/124319096/external/single_ad_samples&ciu_szs=300x250&impl=s&gdfp_req=1&env=vp&output=vast&unviewed_position_start=1&cust_params=deployment%3Ddevsite%26sample_ct%3Dskippablelinear&correlator="
    
    var adsLoader: IMAAdsLoader!
    var adsManager: IMAAdsManager!
    var playerViewController: AVPlayerViewController!
    var contentPlayhead: IMAAVPlayerContentPlayhead?
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated);
        
    }
//    func setUpAdsLoader() {
//        adsLoader = IMAAdsLoader(settings: nil)
//        adsLoader.delegate = self
//    }
    
    func requestAds() {
        // Create ad display container for ad rendering.
        let adDisplayContainer = IMAAdDisplayContainer(adContainer: viewPlayer)
        // Create an ad request with our ad tag, display container, and optional user context.
        let request = IMAAdsRequest(
            adTagUrl: WatchController.AdTagURLString,
            adDisplayContainer: adDisplayContainer,
            contentPlayhead: contentPlayhead,
            userContext: nil)
        adsLoader.requestAds(with: request)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.adsLoader.contentComplete()
        }
    }
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    func setUpContentPlayer() {
        // Load AVPlayer with path to your content.
        
        
        
    }
    @objc func contentDidFinishPlaying(_ notification: Notification) {
        
          adsLoader.contentComplete()
        
    }

    override func viewDidLoad() {
//        setUpContentPlayer()
//        setUpAdsLoader()
        
        super.viewDidLoad()
        collView.delegate = self
        collView.dataSource = self
        collView.register(UINib(nibName: WatchCell.className, bundle: nil), forCellWithReuseIdentifier: WatchCell.className)
        viewPlayer.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didSelectViewPlayer(_:))))
        let layout = UICollectionViewFlowLayout()
        let width = (UIScreen.main.bounds.width - 30 * scaleW) / 4.5
        layout.itemSize = CGSize(width: width, height: width)
        layout.sectionInset = UIEdgeInsets(top: 0, left: 15 * scaleW, bottom: 0, right:  15 * scaleW)
        collView.collectionViewLayout = layout
        NotificationCenter.default.addObserver(self, selector: #selector(stopPlaying(_:)), name: NSNotification.Name("stopLive"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(reStartPlaying(_:)), name: NSNotification.Name("replayLive"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(rotated(_:)), name: UIDevice.orientationDidChangeNotification, object: nil)
        APIService.shared.getLive { (data, error) in
            if let data = data as? [ChannelModel]{
                self.listData = data
                self.collView.reloadData()
                self.didOpenVideo()
            }
        }
        // Do any additional setup after loading the view.
        viewPlayer.addSubview(activityIndicatorView)
        activityIndicatorView.centerXAnchor.constraint(equalTo: viewPlayer.centerXAnchor).isActive = true
        activityIndicatorView.centerYAnchor.constraint(equalTo: viewPlayer.centerYAnchor).isActive = true
    }

    @objc func rotated(_ sender: Any) {
        if tabBarIndex == 1{
            if UIDevice.current.orientation.isLandscape{
                self.viewPlayer.player?.pause()
                
                self.isPlaying = false
                let newPlayer = self.viewPlayer.player
                self.viewPlayer.player = nil
                let vc = PlayerView2Controller()
                vc.player = newPlayer
                vc.onDismiss = {[weak self] in
                    self?.viewPlayer.player = vc.player
                    vc.player = nil
                    self?.viewPlayer.player?.play()
                    self?.isPlaying = true
                    
                }
                present(vc, animated: true) {
                    vc.player?.play()
                    vc.addObserver(self, forKeyPath: #keyPath(UIViewController.view.frame), options: [.old, .new], context: nil)
                }
            }
        }
    }
    @objc func stopPlaying(_ notification: Notification){
        viewPlayer.player?.pause()
        //viewPlayer.player = nil
    }
    @objc func reStartPlaying(_ notification: Notification){
        viewPlayer.player?.play()
    }
    @IBAction func didSelectBtnFullScreen(_ sender: Any) {
        self.viewPlayer.player?.pause()
        
        self.isPlaying = false
        let newPlayer = self.viewPlayer.player
        self.viewPlayer.player = nil
        let vc = PlayerViewController()
        
        vc.player = newPlayer
        vc.onDismiss = {[weak self] in
            self?.viewPlayer.player = vc.player
            vc.player = nil
            self?.viewPlayer.player?.play()
            self?.isPlaying = true
            
        }
        present(vc, animated: true) {
            vc.player?.play()
            vc.addObserver(self, forKeyPath: #keyPath(UIViewController.view.frame), options: [.old, .new], context: nil)
        }
        
    }

    var isTapping = false
    
    @objc func didSelectViewPlayer(_ sender: Any){
        if isTapping{
            hidePlayerController()
            view.layoutIfNeeded()
            timer.invalidate()
        } else{
            showPlayerController()
            view.layoutIfNeeded()
            timer = Timer.scheduledTimer(withTimeInterval: 5.0, repeats: false, block: {[weak self] timer in
                self?.hidePlayerController()
                self?.view.layoutIfNeeded()
                self?.isTapping = false
                timer.invalidate()
            })
        }
        isTapping = !isTapping
    }
    func hidePlayerController(){
        self.imgShadow.isHidden = true
        self.btnFullScreen.isHidden = true
        self.btnSetting.isHidden = true
        
    }
    func showPlayerController(){
        self.imgShadow.isHidden = false
        self.btnFullScreen.isHidden = false
        self.btnSetting.isHidden = false
        
    }
    func didOpenVideo(){
        //requestAds()
        
        //activityIndicatorView.startAnimating()
        UIView.animate(withDuration: 0.5) {
            self.hidePlayerController()
            self.view.layoutIfNeeded()
        }
        if let url = URL(string: listData[index.row].url[0].link){
            do {
                try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playback, mode: .default, options: [])
            }
            catch {
                print("Setting category to AVAudioSessionCategoryPlayback failed.")
            }
            //
            listResolution = []
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
            //
            player = AVPlayer(url: url)
            viewPlayer.player  = player
            contentPlayhead = IMAAVPlayerContentPlayhead(avPlayer: viewPlayer.player)
            
            //requestAds()
            viewPlayer.player?.play()
            viewPlayer.player?.addObserver(self, forKeyPath: "currentItem.loadedTimeRanges", options: .new, context: nil)
            viewPlayer.player?.addObserver(self, forKeyPath: "timeControlStatus", options: [.old, .new], context: nil)
            
            
            //let contentURL = URL(string: ViewController.ContentURLString)
            //let player = AVPlayer(url: contentURL!)
            //playerViewController = AVPlayerViewController()
            //playerViewController.player = player
            
//            NotificationCenter.default.addObserver(
//                self,
//                selector: #selector(WatchController.contentDidFinishPlaying(_:)),
//                name: NSNotification.Name.AVPlayerItemDidPlayToEndTime,
//                object: viewPlayer.player?.currentItem);
            
        }
    }
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "currentItem.loadedTimeRanges", viewPlayer != nil, let duration = viewPlayer.player?.currentItem?.duration.seconds, duration > 0.0{
        }
        if keyPath == "timeControlStatus"{
            if (viewPlayer.player?.timeControlStatus == .playing) {
                activityIndicatorView.stopAnimating()
                //player is playing
            }
            else if (viewPlayer.player?.timeControlStatus == .paused) {
                if tabBarIndex == 1 {
                    didOpenVideo()
                }
                //player is pause
            }
            else if (viewPlayer.player?.timeControlStatus == .waitingToPlayAtSpecifiedRate) {
                //player is waiting to play
                activityIndicatorView.startAnimating()

            }
        }
    }
    @IBAction func didSelectBtnSetting(_ sender: Any) {
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
}
extension WatchController: UICollectionViewDelegate, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return listData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: WatchCell.className, for: indexPath) as! WatchCell
        let item = listData[indexPath.row]
        if let url = URL(string: root.cdn.imageDomain + item.image[0].url.replacingOccurrences(of: "\\", with: "/" )){
            cell.imgThumb.loadImage(fromURL: url)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        index = indexPath
        didOpenVideo()
    }
}
