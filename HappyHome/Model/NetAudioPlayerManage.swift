//
//  NetAudioPlayerManage.swift
//  HappyHome
//
//  Created by kaka on 16/10/15.
//  Copyright © 2016年 kaka. All rights reserved.
//

import UIKit
import AVFoundation

class NetAudioPlayerManage: NSObject {
    static let sharedManager = NetAudioPlayerManage()
    
    private override init() {
        
    }
    
    deinit {
        //        NSNotificationCenter.defaultCenter().removeObserver(self)
        BeanUtils.setPropertysToNil(self)
    }
    
    var timeObserve:AnyObject!
    var audioPlayer:AVPlayer!
    var soundURL:NSURL!
        {
        didSet{
            if audioPlayer != nil {
                audioPlayer.removeObserver(self, forKeyPath: "status")
                audioPlayer.removeTimeObserver(timeObserve)
            }
            
            audioPlayer = AVPlayer.init(URL: soundURL)
            audioPlayer.addObserver(self, forKeyPath: "status", options: .New, context: nil)
            timeObserve = audioPlayer.addPeriodicTimeObserverForInterval(CMTimeMake(1, 1), queue: dispatch_get_main_queue()) { (time) in
                print(time)
                
                NSNotificationCenter.defaultCenter().postNotificationName(MusicTimeIntervalNotification, object: String(self.soundURL))
            }
        }
    }
    func startPlaying() {
        //开始播放
        if audioPlayer != nil {
            audioPlayer.play()
            print("play!!")
        }
        
    }
    
    func pausePlaying() {
        //暂停播放
        if audioPlayer != nil {
            audioPlayer.pause()
            print("pause!!")
        }
        
    }
    
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        let player = object as! AVPlayer
        if keyPath == "status" {
            if player.status == .ReadyToPlay {
                print(1)
            }
            else if player.status == .Failed {
                print(2)
            }
            else {
                print(3)
            }
        }
    }

}
