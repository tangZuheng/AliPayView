//
//  AudioRecorderManage.swift
//  HappyHome
//
//  Created by kaka on 16/10/5.
//  Copyright © 2016年 kaka. All rights reserved.
//

import UIKit
import AVFoundation

//@objc public protocol AudioRecorderManageDelegate: NSObjectProtocol {
//    /**
//     *  播放完成
//     *
//     *  @param audioPlayer 音频播放器
//     */
//    optional func didAudioPlayerFinishPlay(audioPlayer :AVAudioPlayer)
//}

class AudioRecorderManage: NSObject,AVAudioRecorderDelegate,AVAudioPlayerDelegate {
    
    var delegate:ZHAudioPlayerDelegate?
    
    var audioRecorder:AVAudioRecorder!
    var audioPlayer:AVAudioPlayer!
    
    var state:Int = 0  //0=开始前 1=开始录音 2=暂停录音 3=结束录音
    
    //录音名
    var recordingName:String!
    
    ////定义音频的编码参数，这部分比较重要，决定录制音频文件的格式、音质、容量大小等，建议采用AAC的编码方式
    let recordSettings = [AVSampleRateKey : NSNumber(float: Float(44100.0)),//声音采样率
        AVFormatIDKey : NSNumber(int: Int32(kAudioFormatMPEG4AAC)),//编码格式
        AVNumberOfChannelsKey : NSNumber(int: 1),//采集音轨
        AVEncoderAudioQualityKey : NSNumber(int: Int32(AVAudioQuality.Low.rawValue))]//音频质量
    
    func directoryURL() -> NSURL? {
        //定义并构建一个url来保存音频，音频文件名为ddMMyyyyHHmmss.caf
        //根据时间来设置存储文件名
        let currentDateTime = NSDate()
        let formatter = NSDateFormatter()
        formatter.dateFormat = "ddMMyyyyHHmmss"
        recordingName = formatter.stringFromDate(currentDateTime)+".caf"
        print(recordingName)
        
        let fileManager = NSFileManager.defaultManager()
        let urls = fileManager.URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
        let documentDirectory = urls[0] as NSURL
        let soundURL = documentDirectory.URLByAppendingPathComponent(recordingName)
        return soundURL
    }
    
    override init() {
        super.init()
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(AVAudioSessionCategoryPlayAndRecord)
            try audioRecorder = AVAudioRecorder(URL: self.directoryURL()!,
                                                settings: recordSettings)//初始化实例
//            audioRecorder.delegate = self
        } catch {
        }
    }
    
    func startRecord() {
        //开始录音
        if !audioRecorder.recording {
            let audioSession = AVAudioSession.sharedInstance()
            do {
                try audioSession.setActive(true)
                audioRecorder.record()
                self.state = 1
                configBreakObserver()
                print("record!")
            } catch {
                
            }
        }
    }
    
    func pauseRecord() {
        //暂停录音
        if audioRecorder.recording {
            audioRecorder.pause()
        }
        self.state = 2
    }
    
    func stopRecord() {
        //停止录音
        audioRecorder.stop()
        self.state = 3
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setActive(false)
            print("stop!!")
            
            } catch {
        }
    }
    
    func startPlaying() {
        //开始播放
        if (!audioRecorder.recording){
            do {
                try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
                try AVAudioSession.sharedInstance().setActive(true)
                if audioPlayer == nil {
                    try audioPlayer = AVAudioPlayer(contentsOfURL: audioRecorder.url)
                }
                audioPlayer.play()
                audioPlayer.delegate = self
                configBreakObserver()
                print("play!!")
            } catch {
                
            }
        }
    }
    
    func pausePlaying() {
        //暂停播放
        if (!audioRecorder.recording){
            do {
                if audioPlayer == nil {
                    try audioPlayer = AVAudioPlayer(contentsOfURL: audioRecorder.url)
                }
                audioPlayer.pause()
                print("pause!!")
            } catch {
            }
        }
    }
    
    func deleteRecording() {
        //删除录音
        
        if self.audioRecorder.recording {
            self.stopRecord()
        }
        if self.audioPlayer != nil {
            if self.audioPlayer.playing {
                self.pausePlaying()
            }
        }
        
        let fileManager = NSFileManager.defaultManager()
        do {
            try fileManager.removeItemAtURL(audioRecorder.url)
        }
        catch _{
            
        }

        
    }
    
//    func audioRecorderBeginInterruption(recorder: AVAudioRecorder) {
//        audioRecorder.pause()
//    }
//    
//    func audioPlayerEndInterruption(player: AVAudioPlayer, withOptions flags: Int) {
//        audioRecorder.record()
//    }
    
    func audioPlayerDidFinishPlaying(player: AVAudioPlayer, successfully flag: Bool) {
        if self.delegate != nil {
            self.delegate?.didAudioPlayerFinishPlay?(player)
        }
    }
    
    
}

extension AudioRecorderManage {
    //  监听打断
    func configBreakObserver() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(handleInterruption), name: AVAudioSessionInterruptionNotification, object: AVAudioSession.sharedInstance())
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(handleRouteChange), name: AVAudioSessionRouteChangeNotification, object: AVAudioSession.sharedInstance())
    }
    func removeNotification()  {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    //  来电打断
    @objc private func handleInterruption(noti: NSNotification) {
        guard noti.name == AVAudioSessionInterruptionNotification else { return }
        guard let info = noti.userInfo, typenumber = info[AVAudioSessionInterruptionTypeKey]?.unsignedIntegerValue, type = AVAudioSessionInterruptionType(rawValue: typenumber) else { return }
        switch type {
        case .Began:
            if self.state == 1{
                self.pauseRecord()
            }
            else {
                NSNotificationCenter.defaultCenter().postNotificationName(PauseAllPlayingNotification, object: nil)
            }
            break
        case .Ended:
            if self.state == 2 {
                let view = CountdownView()
                view.show(3, andBlock: { (UIView) in
                    self.startRecord()
                })
            }
            break
        }
    }
    
    //拔出耳机等设备变更操作
    @objc private func handleRouteChange(noti: NSNotification) {
        
        func analysisInputAndOutputPorts(noti: NSNotification) {
            guard let info = noti.userInfo, previousRoute = info[AVAudioSessionRouteChangePreviousRouteKey] as? AVAudioSessionRouteDescription else { return }
            let inputs = previousRoute.inputs
            let outputs = previousRoute.outputs
            print(inputs)
            print(outputs)
        }
        
        guard noti.name == AVAudioSessionRouteChangeNotification else { return }
        guard let info = noti.userInfo, typenumber = info[AVAudioSessionRouteChangeReasonKey]?.unsignedIntegerValue, type = AVAudioSessionRouteChangeReason(rawValue: typenumber) else { return }
        switch type {
        case .Unknown:
            break
        case .NewDeviceAvailable:
            break
        case .OldDeviceUnavailable:
            NSNotificationCenter.defaultCenter().postNotificationName(PauseAllPlayingNotification, object: nil)
            break
        case .CategoryChange:
            break
        case .Override:
            break
        case .WakeFromSleep:
            break
        case .NoSuitableRouteForCategory:
            break
        case .RouteConfigurationChange:
            break
        }
    }

}

// MARK: - for AVAudioSession
//extension AudioRecorderManage {
//    
//    private func configAudioSession() {
//        do {
//            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
//            try AVAudioSession.sharedInstance().setActive(true)
//        } catch {
//            print("启动后台模式失败，error -- \(error)")
//        }
//    }
//
//}
