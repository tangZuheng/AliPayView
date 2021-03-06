//
//  ListenDetailCell.swift
//  HappyHome
//
//  Created by kaka on 16/10/8.
//  Copyright © 2016年 kaka. All rights reserved.
//

import UIKit
import AVFoundation

class ListenDetailCell: UITableViewCell,ZHAudioPlayerDelegate {
    
    let headView = UIImageView()
    let headName = UILabel()
    let recore_lengthLabel = UILabel()
    let playButton = UIButton()
    
    var topObject:ScencePointTopModel!
    var playing = false
        {
        didSet {
            if !playing {
                self.playButton.setImage(UIImage.init(named: "user_play"), forState: .Normal)
                let dfmatter = NSDateFormatter()
                dfmatter.dateFormat = "mm:ss"
                let recordLengthDate = NSDate(timeIntervalSince1970: self.topObject!.soundtime!)
                self.recore_lengthLabel.text = dfmatter.stringFromDate(recordLengthDate)
                self.recore_lengthLabel.textColor = UIColor.init(rgb: 0x999999)
                ZHAudioPlayer.sharedInstance().pausePlayingAudio()
                
            }
            else {
                self.playButton.setImage(UIImage.init(named: "user_pause"), forState: .Normal)
                let dfmatter = NSDateFormatter()
                dfmatter.dateFormat = "mm:ss"
                self.recore_lengthLabel.textColor = UIColor.init(rgb: 0xff3838)
                NSNotificationCenter.defaultCenter().postNotificationName(PausePlayingNotification, object: self)
                ZHAudioPlayer.sharedInstance().delegate = self
                ZCMBProgressHUD.startMBProgressHUD()
                ZHAudioPlayer.sharedInstance().manageAudioWithUrlPath(self.topObject.soundname!, playOrPause: true)
            }
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.initfaceView()
        self.initControlEvent()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initfaceView() {
        headView.image = UIImage.init(named: "user_head")
        
        headView.layer.masksToBounds = true
        headView.layer.cornerRadius = (44 - 20)/2
        self.contentView.addSubview(headView)
        headView.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(10)
            make.left.equalTo(self.imageView!.snp_right).offset(10)
            make.bottom.equalTo(-10)
            make.width.equalTo(headView.snp_height)
        }
        
        headName.textColor = UIColor.init(rgb: 0x282828)
        headName.font = UIFont.systemFontOfSize(14)
        self.contentView.addSubview(headName)
        headName.snp_makeConstraints { (make) -> Void in
            make.left.equalTo(self.headView.snp_right).offset(10)
            make.width.equalTo(120*SCREEN_SCALE)
            make.centerY.equalToSuperview()
        }
        
        let record_timeIcon = UIImageView()
        record_timeIcon.image = UIImage.init(named: "record_time")
        self.contentView.addSubview(record_timeIcon)
        record_timeIcon.snp_makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.left.equalTo(self.headName.snp_right).offset(10)
        }
        
        recore_lengthLabel.text = "03:00"
        recore_lengthLabel.font = UIFont.systemFontOfSize(10)
        recore_lengthLabel.textColor = UIColor.init(rgb: 0x999999)
        self.contentView.addSubview(recore_lengthLabel)
        recore_lengthLabel.snp_makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.left.equalTo(record_timeIcon.snp_right).offset(10)
            make.width.equalTo(40)
        }
        
        playButton.setImage(UIImage.init(named: "user_play"), forState: .Normal)
        self.contentView.addSubview(playButton)
        playButton.snp_makeConstraints { (make) in
            make.right.equalTo(self.contentView.snp_right).offset(-10)
            make.centerY.equalToSuperview()
            make.height.width.equalTo(30)
        }
    }
    
    func initControlEvent() {
        playButton.rac_signalForControlEvents(UIControlEvents.TouchUpInside).subscribeNext { _ in
            self.playing = !self.playing
        }
        
        NSNotificationCenter.defaultCenter().rac_addObserverForName(PausePlayingNotification, object: nil).subscribeNext { notificationCenter in
            if notificationCenter.object is ListenDetailCell
            {
                let not_object = notificationCenter.object as! ListenDetailCell
                if not_object != self{
                    self.playing = false
                }
            }
        }
        
//        NSNotificationCenter.defaultCenter().rac_addObserverForName(AVPlayerItemDidPlayToEndTimeNotification, object: nil).subscribeNext {
//            notificationCenter in
//            NSOperationQueue.mainQueue().addOperationWithBlock {
//                self.playing = false
//                MusicPlayerManager.sharedInstance.stop()
//            }
//        }
        
        NSNotificationCenter.defaultCenter().rac_addObserverForName(PauseAllPlayingNotification, object: nil).subscribeNext {
            notificationCenter in
            NSOperationQueue.mainQueue().addOperationWithBlock {
                if self.playing {
                    self.playing = false
                }
            }
        }
    }
    
    func setModel(model:ScencePointTopModel) -> Void {
        topObject = model
        
        self.headView.sd_setImageWithURL(NSURL.init(string: model.header!), placeholderImage: placeholderHead)
        self.headName.text = model.nickname
        if !self.playing {
            let dfmatter = NSDateFormatter()
            let recordLengthDate = NSDate(timeIntervalSince1970: model.soundtime!)
            dfmatter.dateFormat = "mm:ss"
            recore_lengthLabel.text = dfmatter.stringFromDate(recordLengthDate)
        }
    }
    
    func didAudioPlayerBeginPlay(audioPlayer: AVAudioPlayer!) {
        ZCMBProgressHUD.stopMBProgressHUD()
    }
    
    func didAudioPlayerStopPlay(audioPlayer: AVAudioPlayer!) {
        self.playing = false
    }
    
    func didAudioPlayerFinishPlay(audioPlayer: AVAudioPlayer!) {
        self.playing = false
    }
    
    func didAudioPlayerFailPlay(audioPlayer: AVAudioPlayer!) {
        ZCMBProgressHUD.stopMBProgressHUD()
    }
    
    func didAudioPlayerUpdateProgess(audioPlayer: AVAudioPlayer!) {
        let dfmatter = NSDateFormatter()
        dfmatter.dateFormat = "mm:ss"
        var time = topObject.soundtime! - audioPlayer.currentTime
        if time < 0 {
            time = 0
        }
        let recordLengthDate = NSDate(timeIntervalSinceReferenceDate: time)
        self.recore_lengthLabel.text = dfmatter.stringFromDate(recordLengthDate)
    }
    
}
