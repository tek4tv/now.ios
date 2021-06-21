//
//  SpeechToTextController.swift
//  NOW
//
//  Created by dovietduy on 3/10/21.
//

import UIKit
import Speech

class SpeechToTextController: UIViewController, SFSpeechRecognizerDelegate {

    @IBOutlet weak var textView: UILabel!
    @IBOutlet weak var imgMic: UIImageView!
    @IBOutlet weak var viewBack: UIImageView!
    let audioEngine = AVAudioEngine()
    var request = SFSpeechAudioBufferRecognitionRequest()
    let speechRecognizer: SFSpeechRecognizer? = SFSpeechRecognizer(locale: Locale.init(identifier: "vi-VI"))
    var task: SFSpeechRecognitionTask!
    var isStart = false
    var onComplete: ((String) -> Void)!
    override func viewDidLoad() {
        super.viewDidLoad()
        viewBack.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didSelectViewBack(_:))))
        imgMic.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didSelectMic(_:))))
        requestPermision()
    }
    @objc func didSelectViewBack(_ sender: Any){
        dismiss(animated: true, completion: nil)
    }
    @objc func didSelectMic(_ sender: Any){
        let audioSession = AVAudioSession.sharedInstance()
        do {
          try audioSession.setCategory(.playAndRecord, options: .defaultToSpeaker)
          try audioSession.setActive(true, options: .notifyOthersOnDeactivation)
        }catch let error as NSError {
          print("ERROR:", error)
        }
        if imgMic.isUserInteractionEnabled{
            startSpeechRecognization()
            imgMic.image = #imageLiteral(resourceName: "icons8-microphone-96")
            imgMic.isUserInteractionEnabled = false
            DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
                self.cancelSpeechRecognization()
                self.imgMic.image = #imageLiteral(resourceName: "icons8-microphone-97")
                self.imgMic.isUserInteractionEnabled = true
                if self.textView.text == "Bấm nút để bắt đầu" || self.textView.text == "Thử lại lần nữa!"{
                    self.textView.text = "Thử lại lần nữa!"
                }else{
                    self.dismiss(animated: true, completion: nil)
                    self.onComplete?(self.textView.text ?? "")
                }
            }
        }
    }
    func requestPermision(){
        SFSpeechRecognizer.requestAuthorization { (authState) in
            OperationQueue.main.addOperation {
                if authState == .authorized{
                    print("Accepted")
                }
            }
        }
    }
    func startSpeechRecognization(){
        request = SFSpeechAudioBufferRecognitionRequest()
        let node = audioEngine.inputNode
        let recordingFormat = node.outputFormat(forBus: 0)
        node.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { (buffer, _) in
            self.request.append(buffer)
        }
        audioEngine.prepare()
        do{
            try audioEngine.start()
        }catch let error{
            print(error.localizedDescription)
        }
        guard let myRecognization = SFSpeechRecognizer(locale: Locale.init(identifier: "vi-VI")) else {
            print("Not allow on your local")
            return
        }
        if !myRecognization.isAvailable{
            print("Please try again")
        }
        task = speechRecognizer?.recognitionTask(with: request, resultHandler: { (response, error) in
            guard let response = response else{
                if error != nil{
                    print(error.debugDescription)
                }else{
                    print("Problem in giving response")
                }
                return
            }
            let message = response.bestTranscription.formattedString
            self.textView.text = message
        })
    }
    func cancelSpeechRecognization(){
        task.finish()
        task.cancel()
        task = nil
        request.endAudio()
        audioEngine.stop()
        audioEngine.inputNode.removeTap(onBus: 0)
    }
}
