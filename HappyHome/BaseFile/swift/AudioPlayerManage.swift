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
    var audioPlayer:AVAudioPlayer!
    var soundURL:NSURL!
    
    func startPlaying() {
        //开始播放
        do {
            if audioPlayer == nil {
                try audioPlayer = AVAudioPlayer(contentsOfURL: soundURL)
//                audioPlayer.delegate = self
            }
            audioPlayer.play()
            print("play!!")
        } catch {
        }
    }
    
    func pausePlaying() {
        //暂停播放
        do {
            if audioPlayer == nil {
                try audioPlayer = AVAudioPlayer(contentsOfURL: soundURL)
            }
            audioPlayer.pause()
            print("pause!!")
        } catch {
        }
    }
}
