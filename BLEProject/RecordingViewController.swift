//
//  RecordingViewController.swift
//  BLEProject
//
//  Created by Anh Tuan on 7/21/17.
//  Copyright © 2017 Anh Tuan. All rights reserved.
//

import UIKit
import AVFoundation

import UIKit
import AVFoundation

class RecordingViewController: UIViewController{
    
    @IBOutlet weak var micBtn : UIButton!
    
    var recordingSession: AVAudioSession!
    
    var audioPlayer : AVAudioPlayer?
    var audioRecorder : AVAudioRecorder?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupRecorder()
    }
    
    func setupRecorder(){
        recordingSession = AVAudioSession.sharedInstance()
        do {
            try recordingSession.setCategory(AVAudioSessionCategoryPlayAndRecord)
            try recordingSession.setActive(true)
            recordingSession.requestRecordPermission({ (allowed) in
                DispatchQueue.main.async {
                    if (allowed) {
                        self.loadRecordingUI()
                    } else {
                        //failed to record
                    }
                }
            })
        } catch {
            
        }
    }
    
    func loadRecordingUI(){
        self.micBtn.setTitle("Tap to Record", for: UIControlState.normal)
        self.micBtn.addTarget(self, action: #selector(self.recordTapped), for: UIControlEvents.touchUpInside)
    }
    
    func startRecording(){
        let audioFilename = getDocumentsDirectory().appendingPathComponent("recording.m4a")
        
        let settings = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 12000,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]
        
        do {
            audioRecorder = try AVAudioRecorder(url: audioFilename, settings: settings)
            audioRecorder?.delegate = self
            audioRecorder?.record()
            
            self.micBtn.setTitle("Tap to Stop", for: .normal)
        } catch {
            finishRecording(success: false)
        }
    }
    
    func recordTapped() {
        if audioRecorder == nil {
            startRecording()
        } else {
            finishRecording(success: true)
        }
    }
    
    func finishRecording(success: Bool) {
        audioRecorder?.stop()
        audioRecorder = nil
        
        if success {
            self.micBtn.setTitle("Tap to Re-record", for: .normal)
        } else {
            self.micBtn.setTitle("Tap to Record", for: .normal)
            // recording failed :(
        }
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }
    
    @IBAction func play(_ sender : UIButton){
        if (AudioPlayerManager.shared.isPlaying) {
            AudioPlayerManager.shared.pause()
        } else {
            let path = AudioPlayerManager.shared.audioFIleInUserDocuments(fileName: "recording")
            AudioPlayerManager.shared.play(path: path)
            
        }
        
        
        let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        
        print("File Location:",url.path)
        
        
        if FileManager.default.fileExists(atPath: url.path){
            print("File found and ready to play")
        }else{
            print("no FIle")
        }

    }
    //record audio
  
}
extension RecordingViewController : AVAudioRecorderDelegate {
    
    func audioPlayerDecodeErrorDidOccur(_ player: AVAudioPlayer, error: Error?) {
        //println("Audio Play Decode Error")
    }
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if !flag {
            self.finishRecording(success: false)
        }
    }
    
    func audioRecorderEncodeErrorDidOccur(_ recorder: AVAudioRecorder, error: Error?) {
        //   println("Audio Record Encode Error")
    }

}
