
//  AudioPlayerManage.swift
//  HappyHome
//
//  Created by kaka on 16/10/7.
//  Copyright © 2016年 kaka. All rights reserved.
//

import UIKit
import AVFoundation

class AudioPlayerManage: NSObject, AVAudioPlayerDelegate{
    
    static let sharedManager = AudioPlayerManage()
    
    var delegate:ZHAudioPlayerDelegate?
    
    private override init() {
        
    }
    
    deinit {
//        NSNotificationCenter.defaultCenter().removeObserver(self)
        BeanUtils.setPropertysToNil(self)
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    var audioPlayer:AVAudioPlayer!
    var soundURL:NSURL!
    {
        didSet{
            do {
                try audioPlayer = AVAudioPlayer(contentsOfURL: soundURL)
            }
            catch {
                
            }
        }
    }
    func startPlaying() {
        //开始播放
        if audioPlayer != nil {
            do {
                try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
                try AVAudioSession.sharedInstance().setActive(true)
                
            } catch {
                
            }
            audioPlayer.play()
            audioPlayer.delegate = self
            configBreakObserver()
            print("play!!")
        }
    }
    
    func pausePlaying() {
        //暂停播放
        if audioPlayer != nil {
            audioPlayer.pause()
            if self.delegate != nil {
                self.delegate?.didAudioPlayerPausePlay?(audioPlayer)
            }
            print("pause!!")
        }
    }
    
    func stopPlaying() {
        //停止播放
        if audioPlayer != nil {
            audioPlayer.stop()
            if self.delegate != nil {
                self.delegate?.didAudioPlayerStopPlay?(audioPlayer)
            }
            print("stop!!")
        }
    }
    
    func audioPlayerDidFinishPlaying(player: AVAudioPlayer, successfully flag: Bool) {
        if self.delegate != nil {
            self.delegate?.didAudioPlayerFinishPlay?(player)
        }
    }
    
    //  监听打断
    private func configBreakObserver() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(handleInterruption), name: AVAudioSessionInterruptionNotification, object: AVAudioSession.sharedInstance())
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(handleRouteChange), name: AVAudioSessionRouteChangeNotification, object: AVAudioSession.sharedInstance())
    }
    
    //  来电打断
    @objc private func handleInterruption(noti: NSNotification) {
        guard noti.name == AVAudioSessionInterruptionNotification else { return }
        guard let info = noti.userInfo, typenumber = info[AVAudioSessionInterruptionTypeKey]?.unsignedIntegerValue, type = AVAudioSessionInterruptionType(rawValue: typenumber) else { return }
        typenumber
        switch type {
        case .Began:
            NSNotificationCenter.defaultCenter().postNotificationName(PauseAllPlayingNotification, object: nil)
            break
        case .Ended:
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
