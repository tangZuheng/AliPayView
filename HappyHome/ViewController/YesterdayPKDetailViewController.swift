//
//  YesterdayPKDetailViewController.swift
//  HappyHome
//
//  Created by kaka on 16/10/20.
//  Copyright © 2016年 kaka. All rights reserved.
//

import UIKit
import SDWebImage
import AVFoundation

class YesterdayPKDetailViewController: BaseViewController {
    
    var model:YesterdayPKModel!
    
    var img:UIImageView?
    var name:UILabel?
    
    var leftProgressView: CircleProgressView!
    var rightProgressView: CircleProgressView!
    
    let leftHead = UIImageView()
    let rightHead = UIImageView()
    
    let leftPlayButton = UIButton()
    let rightPlayButton = UIButton()
    
    let leftNictname = UILabel()
    let rightNictname = UILabel()
    
    let leftWinIcon = UIImageView()
    let righWintIcon = UIImageView()
    
    let commitButton = UIButton()
    
    var leftPlayTime : Int64 = 0
    var rightPlayTime : Int64 = 0
    
    var leftPlay:Bool = false   // 左边是否正在播放播放
    {
        
        didSet {
            if leftPlay {
                self.rightPlay = false
                leftPlayButton.setBackgroundImage(UIImage.init(named: "Judge_pause"), forState: .Normal)
                let musicURL = NSURL.init(string: self.model.soundname!)!
                MusicPlayerManager.sharedInstance.play(musicURL, callBack: { (tmpProgress, playProgress) in
                    if !NSThread.isMainThread() {
                        dispatch_async(dispatch_get_main_queue(), {
                            if MusicPlayerManager.sharedInstance.playTime >= 0.01
                            {
                                self.leftProgressView.progress = Double(MusicPlayerManager.sharedInstance.progress)
                                self.leftPlayTime = Int64(MusicPlayerManager.sharedInstance.playTime)
                            }
                        })
                    }
                    else {
                        if MusicPlayerManager.sharedInstance.playTime >= 0.01
                        {
                            self.leftProgressView.progress = Double(MusicPlayerManager.sharedInstance.progress)
                            self.leftPlayTime = Int64(MusicPlayerManager.sharedInstance.playTime)
                        }
                    }
                })
                MusicPlayerManager.sharedInstance.player?.seekToTime(CMTimeMake(self.leftPlayTime,1))
            }
            else {
                leftPlayButton.setBackgroundImage(UIImage.init(named: "Judge_play"), forState: .Normal)
                MusicPlayerManager.sharedInstance.pause()
            }
        }
    }
    
    var rightPlay:Bool = false  // 右边时候正在播放播放
        {
        didSet {
            if rightPlay {
                self.leftPlay = false
                rightPlayButton.setBackgroundImage(UIImage.init(named: "Judge_pause"), forState: .Normal)
                let musicURL = NSURL.init(string: self.model.pksoundname!)!
                MusicPlayerManager.sharedInstance.play(musicURL, callBack: { (tmpProgress, playProgress) in
                    if !NSThread.isMainThread() {
                        dispatch_async(dispatch_get_main_queue(), {
                            if MusicPlayerManager.sharedInstance.playTime >= 0.01
                            {
                                self.rightProgressView.progress = Double(MusicPlayerManager.sharedInstance.progress)
                                self.rightPlayTime = Int64(MusicPlayerManager.sharedInstance.playTime)
                            }
                        })
                    }
                    else {
                        if MusicPlayerManager.sharedInstance.playTime >= 0.01
                        {
                            self.rightProgressView.progress = Double(MusicPlayerManager.sharedInstance.progress)
                            self.rightPlayTime = Int64(MusicPlayerManager.sharedInstance.playTime)
                        }
                    }
                })
                MusicPlayerManager.sharedInstance.player?.seekToTime(CMTimeMake(self.rightPlayTime,1))
            }
            else {
                rightPlayButton.setBackgroundImage(UIImage.init(named: "Judge_play"), forState: .Normal)
                MusicPlayerManager.sharedInstance.pause()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initfaceView()
        self.initControlEvent()
    }
    
    override func viewWillDisappear(animated: Bool) {
        
        self.navigationController!.navigationBar.tintColor = colorForNavigationTint()
        self.navigationController!.navigationBar.barTintColor = UIColor.whiteColor()
        self.navigationController!.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: colorForNavigationBarTitle()]
        self.navigationController!.navigationBar.alpha = 1
        
        MusicPlayerManager.sharedInstance.stop()
        
        super.viewWillDisappear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func initfaceView(){
        if UserModel.sharedUserModel.selectLanguage == 1 {
            self.title = self.model.sname
        }
        else {
            self.title = self.model.senglishname
        }
        
        self.navigationController!.navigationBar.tintColor = UIColor.whiteColor()
        self.navigationController!.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        self.navigationController!.navigationBar.barTintColor = UIColor.blackColor()
        self.navigationController!.navigationBar.alpha = 0.4
        
        img = UIImageView()
        img?.sd_setImageWithURL(NSURL.init(string: model.ppicture!), placeholderImage: placeholderImage)
        self.view.addSubview(img!)
        img!.snp_makeConstraints { (make) -> Void in
            make.width.height.equalTo(SCREEN_WIDTH)
            make.top.equalTo(0)
        }
        
        let nameBack = UIView()
        nameBack.backgroundColor = UIColor.blackColor()
        nameBack.alpha = 0.3
        img?.addSubview(nameBack)
        nameBack.snp_makeConstraints { (make) in
            make.width.equalTo(img!)
            make.height.equalTo(35)
            make.bottom.equalTo(img!).offset(0)
        }
        
        name = UILabel()
//        name?.text = model.pname
        name?.textColor = UIColor.whiteColor()
        if UserModel.sharedUserModel.selectLanguage == 1 {
            name?.text = model.pname
        }
        else {
            name?.text = model.penglishname
        }
        name?.textColor = UIColor.whiteColor()
        self.view.addSubview(name!)
        name!.snp_makeConstraints { (make) -> Void in
            make.left.equalTo(10)
            make.right.equalTo(10)
            make.height.equalTo(nameBack)
            make.bottom.equalTo(img!).offset(0)
        }
        
        let bottomView = UIView()
        bottomView.backgroundColor = UIColor.init(rgb: 0x232323)
        self.view .addSubview(bottomView)
        bottomView.snp_makeConstraints { (make) in
            make.width.equalTo(self.view)
            make.bottom.equalTo(self.view).offset(0)
            make.top.equalTo(img!.snp_bottom).offset(20)
        }
        
        let vsImg = UIImageView.init(image: UIImage.init(named: "PK_VS"))
        bottomView.addSubview(vsImg)
        vsImg.snp_makeConstraints { (make) in
            make.top.equalTo(60)
            make.centerX.equalToSuperview()
        }
        
        //左边播放
        leftProgressView = CircleProgressView()
        leftProgressView.backgroundColor = UIColor.clearColor()
        leftProgressView.trackWidth = 4
        leftProgressView.trackBackgroundColor = UIColor.init(rgb: 0x666666)
        leftProgressView.trackFillColor = UIColor.init(rgb: 0xe7e7e7)
        bottomView.addSubview(leftProgressView)
        leftProgressView.snp_makeConstraints { (make) in
            make.width.height.equalTo(75*SCREEN_SCALE)
            make.centerY.equalTo(vsImg).offset(5)
            make.left.equalTo(20)
        }
        
        leftHead.image = placeholderHead
        leftHead.layer.masksToBounds = true
        leftHead.layer.cornerRadius = (75*SCREEN_SCALE-8)/2
        leftHead.sd_setImageWithURL(NSURL.init(string: model.header!), placeholderImage: placeholderHead)
        leftProgressView.addSubview(leftHead)
        leftHead.snp_makeConstraints { (make) in
            make.edges.equalTo(leftProgressView).inset(UIEdgeInsetsMake(4, 4, 4, 4))
        }
        
        leftPlayButton.setBackgroundImage(UIImage.init(named: "Judge_play"), forState: .Normal)
        leftProgressView.addSubview(leftPlayButton)
        leftPlayButton.snp_makeConstraints { (make) in
            make.edges.equalTo(leftProgressView).inset(UIEdgeInsetsMake(4, 4, 4, 4))
        }
        
//        leftWinIcon.image = UIImage.init(named: "yesterdayPK_win")
        bottomView.addSubview(leftWinIcon)
        leftWinIcon.snp_makeConstraints { (make) -> Void in
            make.left.equalTo(leftProgressView.snp_left)
            make.top.equalTo(leftProgressView.snp_top)
        }
        
        leftNictname.font = UIFont.systemFontOfSize(14)
        leftNictname.textColor = UIColor.whiteColor()
        leftNictname.textAlignment = .Center
        leftNictname.text = model.nickname
        bottomView.addSubview(leftNictname)
        leftNictname.snp_makeConstraints { (make) in
            make.left.equalTo(20)
            make.top.equalTo(leftProgressView.snp_bottom).offset(20)
            make.height.equalTo(20)
            make.width.height.equalTo(75*SCREEN_SCALE)
        }
        
        //右边播放
        rightProgressView = CircleProgressView()
        rightProgressView.backgroundColor = UIColor.clearColor()
        rightProgressView.trackWidth = 4
        rightProgressView.trackBackgroundColor = UIColor.init(rgb: 0x666666)
        rightProgressView.trackFillColor = UIColor.init(rgb: 0xe7e7e7)
        bottomView.addSubview(rightProgressView)
        rightProgressView.snp_makeConstraints { (make) in
            make.width.height.equalTo(75*SCREEN_SCALE)
            make.centerY.equalTo(vsImg).offset(5)
            make.right.equalTo(-20)
        }
        
        rightHead.image = placeholderHead
        rightHead.layer.masksToBounds = true
        rightHead.layer.cornerRadius = (75*SCREEN_SCALE-8)/2
        rightHead.sd_setImageWithURL(NSURL.init(string: model.pkheader!), placeholderImage: placeholderHead)
        rightProgressView.addSubview(rightHead)
        rightHead.snp_makeConstraints { (make) in
            make.edges.equalTo(rightProgressView).inset(UIEdgeInsetsMake(4, 4, 4, 4))
        }
        
        rightPlayButton.setBackgroundImage(UIImage.init(named: "Judge_play"), forState: .Normal)
        rightProgressView.addSubview(rightPlayButton)
        rightPlayButton.snp_makeConstraints { (make) in
            make.edges.equalTo(rightProgressView).inset(UIEdgeInsetsMake(4, 4, 4, 4))
        }
        
        bottomView.addSubview(righWintIcon)
        righWintIcon.snp_makeConstraints { (make) -> Void in
            make.left.equalTo(rightProgressView.snp_left)
            make.top.equalTo(rightProgressView.snp_top)
        }
        
        rightNictname.font = UIFont.systemFontOfSize(14)
        rightNictname.textColor = UIColor.whiteColor()
        rightNictname.textAlignment = .Center
        rightNictname.text = model.pknickname
        bottomView.addSubview(rightNictname)
        rightNictname.snp_makeConstraints { (make) in
            make.right.equalTo(-20)
            make.top.equalTo(leftNictname)
            make.height.equalTo(20)
            make.width.equalTo(leftNictname)
        }
        
        commitButton.setTitle("不服上述", forState: .Normal)
        commitButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        commitButton.titleLabel?.font = UIFont.systemFontOfSize(16)
        commitButton.backgroundColor = UIColor.init(rgb: 0xff3838)
        
        bottomView.addSubview(commitButton)
        commitButton.snp_makeConstraints { (make) in
            make.width.equalToSuperview()
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview()
            make.height.equalTo(40)
        }
        
        
        if model.pkresult < 10 {
            leftWinIcon.image = UIImage.init(named: "yesterdayPK_win")
            leftWinIcon.hidden = false
            righWintIcon.hidden = true
            commitButton.enabled = false
            commitButton.backgroundColor = UIColor.grayColor()
        }
        else if model.pkresult == 10 {
            leftWinIcon.image = UIImage.init(named: "yesterdayPK_pin")
            righWintIcon.image = UIImage.init(named: "yesterdayPK_pin")
            leftWinIcon.hidden = false
            righWintIcon.hidden = false
            commitButton.enabled = false
            commitButton.backgroundColor = UIColor.grayColor()
        }
        else {
            righWintIcon.image = UIImage.init(named: "yesterdayPK_win")
            righWintIcon.hidden = false
            leftWinIcon.hidden = true
            commitButton.enabled = true
            commitButton.backgroundColor = UIColor.init(rgb: 0xff3838)
        }
        
    }
    
    //所有事件
    func initControlEvent(){
        leftPlayButton.rac_signalForControlEvents(UIControlEvents.TouchUpInside).subscribeNext { _ in
            self.leftPlay = !self.leftPlay
            
        }
        rightPlayButton.rac_signalForControlEvents(UIControlEvents.TouchUpInside).subscribeNext { _ in
            self.rightPlay = !self.rightPlay
        }
        
        commitButton.rac_signalForControlEvents(UIControlEvents.TouchUpInside).subscribeNext { _ in
            let view = UIAlertView.init(title: "", message: "亲，您确定要上述？一次上述不成功，当月失去其他上述机会!", delegate: nil, cancelButtonTitle: "确定", otherButtonTitles: "取消")
            view.rac_buttonClickedSignal().subscribeNext({ (indexNumber) in
                if indexNumber as! Int == 0 {
                    self.startMBProgressHUD()
                    NetWorkingManager.sharedManager.JudgeReportAppeal(self.model.soundid!, completion: { (retObject, error) in
                        self.stopMBProgressHUD()
                        if error == nil {
                            self.showSuccessHUDWithText(retObject?.valueForKey("message") as! String)
                        }
                        else {
                            self.showFailHUDWithText(error!.localizedDescription)
                        }
                    })
                }
            })
            view.show()
        }
        
        NSNotificationCenter.defaultCenter().rac_addObserverForName(AVPlayerItemDidPlayToEndTimeNotification, object: nil).subscribeNext {
            notificationCenter in
            NSOperationQueue.mainQueue().addOperationWithBlock {
                if self.leftPlay {
                    self.leftPlay = false
                    self.leftPlayTime = 0
                    self.leftProgressView.progress = 0
                }
                if self.rightPlay {
                    self.rightPlay = false
                    self.rightPlayTime = 0
                    self.rightProgressView.progress = 0
                }
            }
        }
        
        NSNotificationCenter.defaultCenter().rac_addObserverForName(AVPlayerItemDidFieldTimeNotification, object: nil).subscribeNext {
            notificationCenter in
            NSOperationQueue.mainQueue().addOperationWithBlock {
                self.showFailHUDWithText("录音加载失败...")
                if self.leftPlay {
                    self.leftPlay = false
                    self.leftProgressView.progress = 0
                }
                if self.rightPlay {
                    self.rightPlay = false
                    self.rightProgressView.progress = 0
                }
            }
        }
        
        NSNotificationCenter.defaultCenter().rac_addObserverForName(PauseAllPlayingNotification, object: nil).subscribeNext {
            notificationCenter in
            NSOperationQueue.mainQueue().addOperationWithBlock {
                if self.leftPlay {
                    self.leftPlay = false
                }
                if self.rightPlay {
                    self.rightPlay = false
                }
            }
        }
    }
}
