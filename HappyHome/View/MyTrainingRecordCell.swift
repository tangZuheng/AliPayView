//
//  MyTrainingRecordCell.swift
//  HappyHome
//
//  Created by kaka on 16/10/6.
//  Copyright © 2016年 kaka. All rights reserved.
//

import UIKit
import SDWebImage

class MyTrainingRecordCell: UITableViewCell {
    
    let iconView = UIImageView()
    let nameLabel = UILabel()
    let updateTimeLabel = myUILabel()
    let recore_lengthLabel = UILabel()
    let playButton = UIButton()
    
//    let audioPlayerManage = AudioPlayerManage()
    
    var recordObject:RecordObject?
    
    var playing = false
        {
            didSet {
                if !playing {
                    if AudioPlayerManage.sharedManager.soundURL == recordObject!.recordUrl {
                        AudioPlayerManage.sharedManager.pausePlaying()
                    }
                    
                    self.playButton.setImage(UIImage.init(named: "user_play"), forState: .Normal)
                    if self.displayLink != nil {
                        self.displayLink!.paused = true
                    }
                    let dfmatter = NSDateFormatter()
                    dfmatter.dateFormat = "mm:ss"
                    let recordLengthDate = NSDate(timeIntervalSince1970: self.recordObject!.recordLength!)
                    self.recore_lengthLabel.text = dfmatter.stringFromDate(recordLengthDate)
                    self.recore_lengthLabel.textColor = UIColor.init(rgb: 0x999999)
                    
                }
                else {
                    if AudioPlayerManage.sharedManager.soundURL == recordObject!.recordUrl {
                        AudioPlayerManage.sharedManager.startPlaying()
                    }
                    self.playButton.setImage(UIImage.init(named: "user_pause"), forState: .Normal)
                    
                    self.displayLink = CADisplayLink.init(target: self, selector: #selector(MyTrainingRecordCell.updateTime))
                    self.displayLink!.frameInterval = 1
                    self.displayLink!.paused = false
                    self.displayLink?.addToRunLoop(NSRunLoop.currentRunLoop(), forMode: NSRunLoopCommonModes)
                    
                    NSNotificationCenter.defaultCenter().postNotificationName(PausePlayingNotification, object: self)
                    
                }
        }
    }
    
    //定时器
    var displayLink:CADisplayLink?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.initfaceView()
        self.initControlEvent()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
//        self.audioPlayerManage.stopPlaying()
        BeanUtils.setPropertysToNil(self)
    }
    
    func initfaceView() {
        iconView.image = UIImage.init(named: "defaultImg")
        self.contentView.addSubview(iconView)

        iconView.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(5)
            make.left.equalTo(5)
            make.bottom.equalTo(-5)
            make.width.equalTo(iconView.snp_height)
        }
        
        nameLabel.font = UIFont.systemFontOfSize(12)
        nameLabel.textColor = UIColor.init(rgb: 0x666666)
        self.contentView.addSubview(nameLabel)
        nameLabel.snp_makeConstraints { (make) in
            make.top.equalTo(10)
            make.left.equalTo(iconView.snp_right).offset(10)
            make.width.equalTo(200)
            make.height.equalTo(15)
        }
        

        updateTimeLabel.font = UIFont.systemFontOfSize(10)
        updateTimeLabel.textColor = UIColor.init(rgb: 0x999999)
        self.contentView.addSubview(updateTimeLabel)
        updateTimeLabel.verticalAlignment = VerticalAlignmentBottom
        updateTimeLabel.snp_makeConstraints { (make) in
            make.bottom.equalTo(-8)
            make.left.equalTo(iconView.snp_right).offset(10)
            make.width.equalTo(100)
            make.height.equalTo(10)
        }
        
        let record_timeIcon = UIImageView()
        record_timeIcon.image = UIImage.init(named: "record_time")
        self.contentView.addSubview(record_timeIcon)
        record_timeIcon.snp_makeConstraints { (make) in
            make.bottom.equalTo(-8)
            make.left.equalTo(self.updateTimeLabel.snp_right).offset(10)
        }
        
        recore_lengthLabel.font = UIFont.systemFontOfSize(10)
        recore_lengthLabel.textColor = UIColor.init(rgb: 0x999999)
        self.contentView.addSubview(recore_lengthLabel)
        recore_lengthLabel.snp_makeConstraints { (make) in
            make.bottom.equalTo(-8)
            make.left.equalTo(record_timeIcon.snp_right).offset(10)
            make.width.equalTo(40)
            make.height.equalTo(10)
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
            AudioPlayerManage.sharedManager.soundURL = self.recordObject?.recordUrl
            self.playing = !self.playing
        }
         
        
        NSNotificationCenter.defaultCenter().rac_addObserverForName(PausePlayingNotification, object: nil).subscribeNext { notificationCenter in
//            print(notificationCenter)
            let not_object = notificationCenter.object as! MyTrainingRecordCell
            if not_object != self{
                if self.playing {
                    self.playing = false
                }
            }
        }
        
        
    }
    
    func setModel(model:RecordObject) -> Void {

        recordObject = model
//        iconView.image = UIImage.init(named: model.img)
        iconView.sd_setImageWithURL(NSURL.init(string: model.img), placeholderImage: placeholderImage!)
        let nameText = NSMutableAttributedString.init(string: model.spotsName+"  "+model.explainName)
        nameText.addAttributes([NSForegroundColorAttributeName : UIColor.init(rgb: 0x282828)], range: NSMakeRange(0, model.spotsName.characters.count))
        nameText.addAttributes([NSFontAttributeName : UIFont.systemFontOfSize(14)], range: NSMakeRange(0, model.spotsName.characters.count))
        nameLabel.attributedText = nameText;

        let dfmatter = NSDateFormatter()
        dfmatter.dateFormat="yyyy.MM.dd hh:mm:ss"
        updateTimeLabel.text = dfmatter.stringFromDate(model.updateTime!)
        
        let recordLengthDate = NSDate(timeIntervalSince1970: model.recordLength!)
        dfmatter.dateFormat = "mm:ss"
        recore_lengthLabel.text = dfmatter.stringFromDate(recordLengthDate)
        
        if AudioPlayerManage.sharedManager.soundURL == model.recordUrl {
            self.playing = AudioPlayerManage.sharedManager.audioPlayer.playing
        }
        else {
            self.playing = false
        }
//        audioPlayerManage.soundURL = model.recordUrl
    }
    
    func updateTime() -> Void {
        let dfmatter = NSDateFormatter()
        dfmatter.dateFormat = "mm:ss"
        let time = self.recordObject!.recordLength! - AudioPlayerManage.sharedManager.audioPlayer.currentTime
        if time > 0 {
            let recordLengthDate = NSDate(timeIntervalSince1970: time)
            self.recore_lengthLabel.text = dfmatter.stringFromDate(recordLengthDate)
            self.recore_lengthLabel.textColor = UIColor.init(rgb: 0xff3838)
        }
        else {
            self.playing = false
//            self.audioPlayerManage.soundURL = self.recordObject!.recordUrl
        }
    }
    
}
