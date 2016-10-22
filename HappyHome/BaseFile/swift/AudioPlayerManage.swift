//
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
    
    private override init() {
        
    }
    
    deinit {
//        NSNotificationCenter.defaultCenter().removeObserver(self)
        BeanUtils.setPropertysToNil(self)
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
    
    func stopPlaying() {
        //停止播放
        if audioPlayer != nil {
            audioPlayer.stop()
            print("stop!!")
        }
    }
}
