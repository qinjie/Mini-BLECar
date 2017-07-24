//
//  AudioRecorderManager.swift
//  BLEProject
//
//  Created by Anh Tuan on 7/21/17.
//  Copyright © 2017 Anh Tuan. All rights reserved.
//

import Foundation
import AVFoundation

class AudioRecorderManager : NSObject {
    static let shared = AudioRecorderManager()
    
    var recordingSession : AVAudioSession!
    var recorder : AVAudioRecorder?
    
    func setup(){
        recordingSession = AVAudioSession.sharedInstance()
        
        do {
            try recordingSession.setCategory(AVAudioSessionCategoryPlayAndRecord, with: .defaultToSpeaker)
            try recordingSession.setActive(true)
            
            recordingSession.requestRecordPermission({ (allowed: Bool) in
                if (allowed){
                    print("Mic authorized")
                } else {
                    print("Mic not authorized")
                }
            })
        } catch {
            print("Failed to set Category",error.localizedDescription)
        }
    }

    //get the path for the folder we will be saving the file to
    var meterTimer: Timer?
    var recorderApc0 : Float = 0
    var recorderPeak0 : Float = 0
    
    func updateTimer(){
        if let recorder = self.recorder {
            recorder.updateMeters()
            self.recorderApc0 = recorder.averagePower(forChannel: 0)
            self.recorderPeak0 = recorder.peakPower(forChannel: 0)
        }
    }
    
    func recorded(fileName: String) -> Bool {
        let url = getUserPath().appendingPathComponent(fileName + ".m4a")
        
        let audioURL = URL.init(fileURLWithPath: url.path)
        
        let recordedSettings : [String:Any] = [
            AVFormatIDKey:NSNumber(value: kAudioFormatAppleLossless),
            AVEncoderAudioQualityKey:AVAudioQuality.high.rawValue,
            AVEncoderBitRateKey:120000.0,
            AVNumberOfChannelsKey:1,
            AVSampleRateKey: 44100.0
        ]
        
        do {
            recorder = try AVAudioRecorder(url: audioURL, settings: recordedSettings)
            recorder?.delegate = self
            recorder?.isMeteringEnabled = true
            recorder?.prepareToRecord()
            
            self.meterTimer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
            
            
            print("Recording")
            
            return true
        } catch {
            return false
        }
    }
    
    
    //Stop the recorder
    func finishRecording(){
        self.recorder?.stop()
        self.meterTimer?.invalidate()
    }
    
    func getUserPath() -> URL {
        return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }
}

extension AudioRecorderManager : AVAudioRecorderDelegate {
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        print("Audio Manager Did finish Recording")
    }
    func audioRecorderEncodeErrorDidOccur(_ recorder: AVAudioRecorder, error: Error?) {
        print("Error encoding")
    }
}
