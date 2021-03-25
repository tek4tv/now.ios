//
//  ReadDetailController.swift
//  NOW
//
//  Created by dovietduy on 3/3/21.
//

import UIKit
import WebKit
import AVFoundation
class ReadDetailController: UIViewController, WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.heightWebView.constant = webView.scrollView.contentSize.height
            print(self.webView.scrollView.contentSize.height)
        }
    }
    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var viewBack: UIView!
    @IBOutlet weak var collView: UICollectionView!
    @IBOutlet weak var heightWebView: NSLayoutConstraint!
    @IBOutlet weak var heightCollView: NSLayoutConstraint!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var heigthPlayView: NSLayoutConstraint!

    @IBOutlet weak var viewPlayer: PlayerView!
    @IBOutlet weak var btnPlay: UIButton!
    @IBOutlet weak var lblCurrentTime: UILabel!
    @IBOutlet weak var slider: CustomSlider!
    @IBOutlet weak var lblDuration: UILabel!
    @IBOutlet weak var btnFullScreen: UIButton!
    @IBOutlet weak var btnSetting: UIButton!
    @IBOutlet weak var imgShadow: UIImageView!
    var timeObserver: Any?
    var player: AVPlayer!
    var playerLayer: AVPlayerLayer!
    var isPlaying = false
    var isEnded = false
    var timer = Timer()
    var listResolution: [StreamResolution] = []
    var speed: Double = 1.0

    var data = ReadDetailModel()
    var data2 = ReadModel()
    var video = NewsVideoModel()
    var html = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        if data2.isVideoArticle == 1{
            heightWebView.constant = 0
            didOpenVideo()
        }else{
            loadHTML(data.content)
            webView.scrollView.isScrollEnabled = false
            webView.navigationDelegate = self
            heigthPlayView.constant = 0
            hidePlayerController()
        }
        lblTitle.text = data2.title
        
        
        //
        viewPlayer.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didSelectViewPlayer(_:))))
        viewBack.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didSelectViewBack(_:))))
        slider.addTarget(self, action: #selector(sliderDidEndSliding), for: [.touchUpInside, .touchUpOutside])
        slider.setThumbImage(UIImage(named: "ic_circle2"), for: .highlighted)
        collView.delegate = self
        collView.dataSource = self
        collView.register(UINib(nibName: Type3ItemCell.className, bundle: nil), forCellWithReuseIdentifier: Type3ItemCell.className)
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 10 * scaleW, bottom: 0, right: 10 * scaleW)
        layout.itemSize = CGSize(width: 190 * scaleW, height: 200 * scaleW)
        collView.collectionViewLayout = layout
        heightCollView.constant = 4 * 200 * scaleW
    }
    @IBAction func didSelectBtnFullScreen(_ sender: Any) {
        self.viewPlayer.player?.pause()
        self.btnPlay.setBackgroundImage(#imageLiteral(resourceName: "icons8-play-48"), for: .normal)
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
            self?.btnPlay.setBackgroundImage(#imageLiteral(resourceName: "icons8-pause-48"), for: .normal)
        }
        present(vc, animated: true) {
            vc.player?.play()
            vc.addObserver(self, forKeyPath: #keyPath(UIViewController.view.frame), options: [.old, .new], context: nil)
        }
        
    }
    @IBAction func didSelectBtnPlay(_ sender: Any) {
        if isPlaying{
            viewPlayer.player?.pause()
            btnPlay.setBackgroundImage(#imageLiteral(resourceName: "icons8-play-48"), for: .normal)
        } else{
            if isEnded{
                viewPlayer.player?.seek(to: CMTime.zero)
                isEnded = false
            }
            viewPlayer.player?.play()
            viewPlayer.player?.rate = Float(speed)
            btnPlay.setBackgroundImage(#imageLiteral(resourceName: "icons8-pause-48"), for: .normal)
        }
        isPlaying = !isPlaying
    }
    var isTapping = false
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
        
        
    }
    @objc func sliderDidEndSliding(){
        addTimeObserver()
        viewPlayer.player?.play()
        isPlaying = true
        isSliderChanging = false
        DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
            if self.isSliderChanging == false{
                self.hidePlayerController()
                self.view.layoutIfNeeded()
            }
        }
    }
    @objc func didSelectViewPlayer(_ sender: Any){
        if isTapping{
            hidePlayerController()
            view.layoutIfNeeded()
            timer.invalidate()
        } else{
            showPlayerController()
            view.layoutIfNeeded()
            timer = Timer.scheduledTimer(withTimeInterval: 5.0, repeats: false, block: {[weak self] timer in
                if self?.isSliderChanging == false{
                    self?.hidePlayerController()
                    self?.view.layoutIfNeeded()
                    self?.isTapping = false
                    timer.invalidate()
                }
                
            })
        }
        isTapping = !isTapping
    }
    @IBAction func didSelectBtnSetting(_ sender: Any) {
        var flag = false
        for item in listResolution{
            if item.resolution == viewPlayer.player?.currentItem?.presentationSize{
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
        vc.modalPresentationStyle = .overFullScreen
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
    func didOpenVideo(){
        if let timeObserver = timeObserver {
            viewPlayer.player?.removeTimeObserver(timeObserver)
            self.timeObserver = nil
        }
        UIView.animate(withDuration: 0.5) {
            self.hidePlayerController()
            self.view.layoutIfNeeded()
        }
        if let url = URL(string: "https://media.vtc.vn/" + video.videoURL){
            do {
                try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playback, mode: .default, options: [])
            }
            catch {
                print("Setting category to AVAudioSessionCategoryPlayback failed.")
            }
            //
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
            viewPlayer.player?.play()
            viewPlayer.player?.addObserver(self, forKeyPath: "currentItem.loadedTimeRanges", options: .new, context: nil)
            NotificationCenter.default.addObserver(self, selector:#selector(self.playerDidFinishPlaying(note:)),name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: nil)
            isPlaying = true
            btnPlay.setBackgroundImage(#imageLiteral(resourceName: "icons8-pause-48"), for: .normal)
            
            addTimeObserver()
            
        }
        
    }
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "currentItem.loadedTimeRanges", viewPlayer != nil, let duration = viewPlayer.player?.currentItem?.duration.seconds, duration > 0.0{
            self.lblDuration.text = getTimeString(from: (viewPlayer.player?.currentItem!.duration)!)
        }
        
    }
    @objc func playerDidFinishPlaying(note: NSNotification){
        btnPlay.setBackgroundImage(#imageLiteral(resourceName: "icons8-play-48"), for: .normal)
        viewPlayer.player?.pause()
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
        timeObserver = viewPlayer.player?.addPeriodicTimeObserver(forInterval: interval, queue: mainQueue, using: {[weak self] (time) in
            guard let currentItem = self?.viewPlayer.player?.currentItem, currentItem.duration >= CMTime.zero else {return}
            guard currentItem.status.rawValue == AVPlayerItem.Status.readyToPlay.rawValue else {return}
            self?.slider.maximumValue =  (Float(currentItem.duration.seconds) > 0) ? Float(currentItem.duration.seconds) : 0
            self?.slider.minimumValue = 0
            self?.slider.value = Float(currentItem.currentTime().seconds)
            self?.lblCurrentTime.text = self?.getTimeString(from: currentItem.currentTime())
        })
    }
    func hidePlayerController(){
        self.imgShadow.isHidden = true
        self.btnFullScreen.isHidden = true
        self.btnSetting.isHidden = true
        self.lblCurrentTime.isHidden = true
        self.lblDuration.isHidden = true
        self.slider.isHidden = true
        self.btnPlay.isHidden = true
    }
    func showPlayerController(){
        self.imgShadow.isHidden = false
        self.btnFullScreen.isHidden = false
        self.btnSetting.isHidden = false
        self.lblCurrentTime.isHidden = false
        self.lblDuration.isHidden = false
        self.slider.isHidden = false
        self.btnPlay.isHidden = false
    }
    func loadHTML(_ content: String){
        html =
        """
                <html lang="en">

                <head>
                  <meta charset="utf-8">
                  <title>Swiper demo</title>
                  <link href="https://vjs.zencdn.net/7.10.2/video-js.css" rel="stylesheet" />
                  <script src="https://code.jquery.com/jquery-3.2.1.slim.min.js" integrity="sha384-KJ3o2DKtIkvYIK3UENzmM7KCkRr/rE9/Qpg6aAZGJwFDMVNA/GpGFF93hXpG5KkN" crossorigin="anonymous"></script>
                  <script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.12.9/umd/popper.min.js" integrity="sha384-ApNbgh9B+Y1QKtv3Rn7W3mgPxhU9K/ScQsAP7hUibX39j7fakFPskvXusvfa0b4Q" crossorigin="anonymous"></script>
                  <script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/js/bootstrap.min.js" integrity="sha384-JZR6Spejh4U02d8jOt6vLEHfe/JQGiRRSQQxSfFWpi1MquVdAyjUar5+76PVCmYl" crossorigin="anonymous"></script>
                  <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
                              <script type="text/javascript" src="//cdnjs.cloudflare.com/ajax/libs/jquery.lazy/1.7.10/jquery.lazy.min.js"></script>
                              <script type="text/javascript" src="//cdnjs.cloudflare.com/ajax/libs/jquery.lazy/1.7.10/jquery.lazy.plugins.min.js"></script>
                              <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/css/bootstrap.min.css" integrity="sha384-Gn5384xqQ1aoWXA+058RXPxPg6fy4IWvTNh0E263XmFcJlSAwiGgFAW/dAiS6JXm" crossorigin="anonymous">
                              <script src="https://vjs.zencdn.net/7.10.2/video.min.js"></script>
                            
                    <style>
                      body {
                        font-size: 35px;
                        margin-left: 10px;
                        margin-right: 10px;
                      }
                   
                    p{padding-left:10px;padding-right:10px;}
                    img {
                      width: 100%;
                    }
                    .vjs-big-play-button {
                    top: 50% ;
                    left: 50% ;
                  }
                 .video-js{
                   height: 450px;
                 }
                    .expEdit{
                      background-color: rgb(243, 243, 243);
                      padding-top: 5px;
                      padding-bottom: 5px;
                    }
                     </style>
                </head>

                <body>
                <div>
                  \(content)
                </div>
                  <script>
                     
                    $(document).ready(function(){
                           $(".lazy").each(function () {
                                $(this).attr("src", $(this).attr("data-src"));
                                $(this).removeAttr("data-src");
                                $(this).addClass('img-fluid');
                            });
                            var dataId = $(".video-element").data("id");
                var text = '<div id="loadding" class="hidden d-flex justify-content-center" style="margin-bottom:60px; align-items:center">';
                            text + '=  < i class="demo-icon icon-spin5 animate-spin" ></i >';
                            text += '</div >';
                            $(".video-element").html(text);
                            if (dataId) {
                                if (dataId.length > 0) {
                                    var html = '';
                                    $.ajax({
                                        url: "https://api.vtcnews.tek4tv.vn/api/home/video/GetVideoById?text=" + dataId,
                                        type: 'GET'
                                    }).done(function (data) {
                                       
                                        html += '<video id="my-video"';
                                        html += 'class="video-js lazy"';
                                        html += 'controls';
                                        html += ' preload="auto"';
                                        html += ' height="300" ';
                                        html += 'poster="MY_VIDEO_POSTER.jpg"';
                                        html += ' data-setup="{}" style="width:100%">';
                                        html += '  <source src="https://media.vtc.vn' + data[0].URL + '" type="video/mp4" />';
                                        html += '   <source src="MY_VIDEO.webm" type="video/webm" />';
                                        html += '</video> ';
                                        $(".video-element").html(html);
                                    })
                                }
                            }
                            
                });
                   
                    </script>
                  </body>
                  </html>
                """
        webView.loadHTMLString(html, baseURL: nil)
        
        
    }
    @objc func didSelectViewBack(_ sender: Any){
        navigationController?.popViewController(animated: true)
    }
    @IBAction func didSelectBtn3Dot(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(withIdentifier: PopUp6Controller.className) as! PopUp6Controller
        vc.data = data2
        vc.modalPresentationStyle = .custom
        vc.modalTransitionStyle = .crossDissolve
        present(vc, animated: true, completion: nil)
    }
}
extension ReadDetailController: UICollectionViewDelegate, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if reads.count >= 8 {
            return 8
        }
        return reads.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Type3ItemCell.className, for: indexPath) as! Type3ItemCell
        let item = reads[indexPath.row]
        cell.lblTitle.text = item.title
        cell.lblTime.text = item.timePass
        if let url = URL(string: item.image16_9){
            cell.thumbImage.loadImage(fromURL: url)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if reads[indexPath.row].isVideoArticle == 1{
            APIService.shared.getReadVideo(id: reads[indexPath.row].id) {[self] (data, error) in
                if let data = data as? NewsVideoModel{
                    let vc = storyboard?.instantiateViewController(withIdentifier: ReadDetailController.className) as! ReadDetailController
                    vc.video = data
                    vc.data2 = reads[indexPath.row]
                    navigationController?.pushViewController(vc, animated: true)
                }
            }
        }else{
            APIService.shared.getReadDetail(id: reads[indexPath.row].id.description) {[self] (data, error) in
                if let data = data as? ReadDetailModel{
                    let vc = storyboard?.instantiateViewController(withIdentifier: ReadDetailController.className) as! ReadDetailController
                    vc.data = data
                    vc.data2 = reads[indexPath.row]
                    navigationController?.pushViewController(vc, animated: true)
                }
            }
        }
        
        
    }
}
