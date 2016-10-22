//
//  JudgeDetailViewController.swift
//  HappyHome
//
//  Created by kaka on 16/10/9.
//  Copyright © 2016年 kaka. All rights reserved.
//

import UIKit
import HandyJSON
import SDWebImage
import AVFoundation

class JudgeDetailViewController: BaseViewController {

    var model:ScenceModel!
    var pointModel:ScencePointModel!
    
    var leftSoundModel:SoundModel!
    var rightSoundModel:SoundModel!
    
    var img:UIImageView?
    var name:UILabel?
    
    var leftProgressView: CircleProgressView!
    var rightProgressView: CircleProgressView!
    
    let leftHead = UIImageView()
    let rightHead = UIImageView()
    
    let leftPlayButton = UIButton()
    let rightPlayButton = UIButton()
    
    let leftTipButton = UIButton()
    let rightTipButton = UIButton()
    
    let leftWinButton = UIButton()
    let centerWinButton = UIButton()
    let rightWinButton = UIButton()
    let commitButton = UIButton()
    
    var leftPlay:Bool = false   // 左边是否已经播放
    var rightPlay:Bool = false  // 右边时候已经播放
    var result:Int! = 0         //1为左边胜，2为平手，3为右边胜
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initfaceView()
        self.initDataSouce()
        self.initControlEvent()
    }
    
    override func viewWillDisappear(animated: Bool) {
        
        self.navigationController!.navigationBar.tintColor = colorForNavigationBarTitle()
        self.navigationController!.navigationBar.barTintColor = UIColor.whiteColor()
        self.navigationController!.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: colorForNavigationBarTitle()]
        self.navigationController!.navigationBar.alpha = 1
        
        super.viewWillDisappear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func initfaceView(){
        self.title = "评委"
        
        self.navigationController!.navigationBar.tintColor = UIColor.whiteColor()
        self.navigationController!.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        self.navigationController!.navigationBar.barTintColor = UIColor.blackColor()
        self.navigationController!.navigationBar.alpha = 0.4
        
        img = UIImageView()
        img?.image = UIImage.init(named: "defaultImg")
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
        leftProgressView.addSubview(leftHead)
        leftHead.snp_makeConstraints { (make) in
            make.edges.equalTo(leftProgressView).inset(UIEdgeInsetsMake(4, 4, 4, 4))
        }
        
        leftPlayButton.setBackgroundImage(UIImage.init(named: "Judge_play"), forState: .Normal)
        leftProgressView.addSubview(leftPlayButton)
        leftPlayButton.snp_makeConstraints { (make) in
            make.edges.equalTo(leftProgressView).inset(UIEdgeInsetsMake(4, 4, 4, 4))
        }
        
        
        leftTipButton.setBackgroundImage(UIImage.init(named: "Judge_tip"), forState: .Normal)
        bottomView.addSubview(leftTipButton)
        leftTipButton.snp_makeConstraints { (make) in
            make.width.height.equalTo(25*SCREEN_SCALE)
            make.right.equalTo(leftProgressView.snp_right)
            make.bottom.equalTo(leftProgressView.snp_bottom).offset(-5)
        }
        
        
        rightProgressView = CircleProgressView()
        rightProgressView.backgroundColor = UIColor.clearColor()
        rightProgressView.trackWidth = 4
        rightProgressView.trackBackgroundColor = UIColor.init(rgb: 0x666666)
        rightProgressView.trackFillColor = UIColor.init(rgb: 0xe7e7e7)
//        rightProgressView.centerImage = UIImage.init(named: "user_head")
//        rightProgressView.progress = 0.4
        bottomView.addSubview(rightProgressView)
        rightProgressView.snp_makeConstraints { (make) in
            make.width.height.equalTo(75*SCREEN_SCALE)
            make.centerY.equalTo(vsImg).offset(5)
            make.right.equalTo(-20)
        }
        
        rightHead.image = placeholderHead
        rightHead.layer.masksToBounds = true
        rightHead.layer.cornerRadius = (75*SCREEN_SCALE-8)/2
        rightProgressView.addSubview(rightHead)
        rightHead.snp_makeConstraints { (make) in
            make.edges.equalTo(rightProgressView).inset(UIEdgeInsetsMake(4, 4, 4, 4))
        }
        
        rightPlayButton.setBackgroundImage(UIImage.init(named: "Judge_play"), forState: .Normal)
        rightProgressView.addSubview(rightPlayButton)
        rightPlayButton.snp_makeConstraints { (make) in
            make.edges.equalTo(rightProgressView).inset(UIEdgeInsetsMake(4, 4, 4, 4))
        }
        
        
        rightTipButton.setBackgroundImage(UIImage.init(named: "Judge_tip"), forState: .Normal)
        bottomView.addSubview(rightTipButton)
        rightTipButton.snp_makeConstraints { (make) in
            make.width.height.equalTo(25*SCREEN_SCALE)
            make.left.equalTo(rightProgressView.snp_left)
            make.bottom.equalTo(rightProgressView.snp_bottom).offset(-5)
        }
        
        
        leftWinButton.setTitle("我赢了", forState: .Normal)
        leftWinButton.titleLabel?.font = UIFont.systemFontOfSize(14)
        leftWinButton.setTitleColor(UIColor.init(rgb: 0x282828), forState: .Normal)
        leftWinButton.setTitleColor(UIColor.whiteColor(), forState: .Selected)
        leftWinButton.setBackgroundImage(createImageWithColor(UIColor.init(rgb: 0xe5e5e5)), forState: .Normal)
        leftWinButton.setBackgroundImage(createImageWithColor(UIColor.init(rgb: 0xff3838)), forState: .Selected)

        leftWinButton.layer.masksToBounds = true
        leftWinButton.layer.cornerRadius = 2
        bottomView.addSubview(leftWinButton)
        leftWinButton.snp_makeConstraints { (make) in
            make.width.equalTo(75*SCREEN_SCALE)
            make.height.equalTo(25*SCREEN_SCALE)
            make.left.equalTo(leftProgressView.snp_left)
            make.top.equalTo(leftProgressView.snp_bottom).offset(25*SCREEN_SCALE)
        }
        
        centerWinButton.setTitle("差不多", forState: .Normal)
        centerWinButton.titleLabel?.font = UIFont.systemFontOfSize(14)
        centerWinButton.setTitleColor(UIColor.init(rgb: 0x282828), forState: .Normal)
        centerWinButton.setTitleColor(UIColor.whiteColor(), forState: .Selected)
        centerWinButton.setBackgroundImage(createImageWithColor(UIColor.init(rgb: 0xe5e5e5)), forState: .Normal)
        centerWinButton.setBackgroundImage(createImageWithColor(UIColor.init(rgb: 0xff3838)), forState: .Selected)
        
        centerWinButton.layer.masksToBounds = true
        centerWinButton.layer.cornerRadius = 2
        bottomView.addSubview(centerWinButton)
        centerWinButton.snp_makeConstraints { (make) in
            make.width.equalTo(leftWinButton.snp_width)
            make.height.equalTo(leftWinButton.snp_height)
            make.top.equalTo(leftWinButton.snp_top)
            make.centerX.equalToSuperview()
        }
        
        rightWinButton.setTitle("我赢了", forState: .Normal)
        rightWinButton.titleLabel?.font = UIFont.systemFontOfSize(14)
        rightWinButton.setTitleColor(UIColor.init(rgb: 0x282828), forState: .Normal)
        rightWinButton.setTitleColor(UIColor.whiteColor(), forState: .Selected)
        rightWinButton.setBackgroundImage(createImageWithColor(UIColor.init(rgb: 0xe5e5e5)), forState: .Normal)
        rightWinButton.setBackgroundImage(createImageWithColor(UIColor.init(rgb: 0xff3838)), forState: .Selected)
        
        rightWinButton.layer.masksToBounds = true
        rightWinButton.layer.cornerRadius = 2
        bottomView.addSubview(rightWinButton)
        rightWinButton.snp_makeConstraints { (make) in
            make.width.equalTo(leftWinButton.snp_width)
            make.height.equalTo(leftWinButton.snp_height)
            make.top.equalTo(leftWinButton.snp_top)
            make.right.equalTo(rightProgressView.snp_right)
        }
        
        
        commitButton.setTitle("确定", forState: .Normal)
        commitButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        commitButton.titleLabel?.font = UIFont.systemFontOfSize(16)
        commitButton.backgroundColor = UIColor.init(rgb: 0xff3838)
        self.updateCommitButton()
//        commitButton.setImage(createImageWithColor(UIColor.init(rgb: 0xff3838)), forState: .Normal)
//        commitButton.setImage(createImageWithColor(UIColor.grayColor()), forState: .Disabled)
        
        
        
        bottomView.addSubview(commitButton)
        commitButton.snp_makeConstraints { (make) in
            make.width.equalToSuperview()
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview()
            make.height.equalTo(40)
        }
    }
    
    func updateView() {
        leftPlay = false
        rightPlay = false
        result = 0
        
        img?.sd_setImageWithURL(NSURL.init(string: self.pointModel.ppicture!), placeholderImage: placeholderImage!)
        name?.text = self.pointModel.pname
        
        self.leftHead.sd_setImageWithURL(NSURL.init(string: self.leftSoundModel.userheader!), placeholderImage: placeholderHead)
        self.rightHead.sd_setImageWithURL(NSURL.init(string: self.rightSoundModel.userheader!), placeholderImage: placeholderHead)
    }
    
    func initDataSouce(){
        self.startMBProgressHUD()
        NetWorkingManager.sharedManager.JudgeIndex(self.model.sid!) { (retObject, error) in
            self.stopMBProgressHUD()
            if error == nil {
                let data = retObject?.objectForKey("data")
                if data != nil {
                    self.leftSoundModel = JSONDeserializer<SoundModel>.deserializeFrom(data?.objectForKey("soundBean") as! NSDictionary)
                    self.rightSoundModel = JSONDeserializer<SoundModel>.deserializeFrom(data?.objectForKey("pksoundBean") as! NSDictionary)
                    self.pointModel  = JSONDeserializer<ScencePointModel>.deserializeFrom(data?.objectForKey("pointBean") as! NSDictionary)
                    self.updateView()
                    self.updateCommitButton()
                }
            }
            else {
                ZCMBProgressHUD.showResultHUDWithResult(true, andText: error!.localizedDescription, toView: self.navigationController?.view, andSecond: 2, completionBlock: {
                    self.navigationController?.popViewControllerAnimated(true)
                })
            }
        }
    }
    //所有事件
    func initControlEvent(){
        leftWinButton.rac_signalForControlEvents(UIControlEvents.TouchUpInside).subscribeNext { _ in
            if !self.leftWinButton.selected
            {
                self.result = 1
                self.updateCommitButton()
            }
        }
        
        centerWinButton.rac_signalForControlEvents(UIControlEvents.TouchUpInside).subscribeNext { _ in
            if !self.centerWinButton.selected
            {
                self.result = 2
                self.updateCommitButton()
            }
        }
        
        rightWinButton.rac_signalForControlEvents(UIControlEvents.TouchUpInside).subscribeNext { _ in
            if !self.rightWinButton.selected
            {
                self.result = 3
                self.updateCommitButton()
            }
        }
        leftPlayButton.rac_signalForControlEvents(UIControlEvents.TouchUpInside).subscribeNext { _ in
            NetAudioPlayerManage.sharedManager.soundURL = NSURL.init(string: self.leftSoundModel.soundname!)
            NetAudioPlayerManage.sharedManager.startPlaying()
            
            self.startMBProgressHUD()
            self.leftPlayButton.hidden = true
//            self.rightPlayButton.enabled = false
            self.leftPlay = true
            self.updateCommitButton()
        }
        rightPlayButton.rac_signalForControlEvents(UIControlEvents.TouchUpInside).subscribeNext { _ in
            NetAudioPlayerManage.sharedManager.soundURL = NSURL.init(string: self.rightSoundModel.soundname!)
            NetAudioPlayerManage.sharedManager.startPlaying()
            
            self.startMBProgressHUD()
            self.rightPlayButton.hidden = true
//            self.leftPlayButton.enabled = false
            self.rightPlay = true
            self.updateCommitButton()
        }
        
        leftTipButton.rac_signalForControlEvents(UIControlEvents.TouchUpInside).subscribeNext { _ in
            let alertView = TipAlertView.init(title: "请选择举报内容", contentView: nil, cancelButtonTitle: "取消")
            alertView.addButtonWithTitle("确定", type: .Default, handler: { (CXAlertVie, AlertButtonItem) in
                
            })
            alertView.show()
        }
        
        
        rightTipButton.rac_signalForControlEvents(UIControlEvents.TouchUpInside).subscribeNext { _ in
            let alertView = TipAlertView.init(title: "请选择举报内容", contentView: nil, cancelButtonTitle: "取消")
            alertView.addButtonWithTitle("确定", type: .Default, handler: { (CXAlertVie, AlertButtonItem) in
                
            })
            alertView.show()
        }
        
        
        commitButton.rac_signalForControlEvents(UIControlEvents.TouchUpInside).subscribeNext { _ in
            //提交结果
            self.startMBProgressHUD()
            NetWorkingManager.sharedManager.JudgeResult(self.leftSoundModel.soundid!, pksoundid: self.rightSoundModel.soundid!, result: self.result, completion: { (retObject, error) in
                self.stopMBProgressHUD()
                if error == nil {
                    let view = UIAlertView.init(title: "", message: "亲，谢谢你对我们评委工作的支持，评论下一条？", delegate: nil, cancelButtonTitle: "确定", otherButtonTitles: "取消")
                        view.rac_buttonClickedSignal().subscribeNext({ (indexNumber) in
                        if indexNumber as! Int == 0 {
                            self.initDataSouce()
                        }
                        else {
                            self.navigationController?.popViewControllerAnimated(true)
                        }
                    })
                    view.show()
                }
                else {
                    self.showFailHUDWithText(error!.localizedDescription)
                }
            })
            
            
        }
        
        NSNotificationCenter.defaultCenter().rac_addObserverForName(MusicTimeIntervalNotification, object: nil).subscribeNext {
            notificationCenter in
            
            self.stopMBProgressHUD()
            
            let not_object = notificationCenter.object as! String
            if not_object == self.leftSoundModel.soundname{
                self.leftProgressView.progress = CMTimeGetSeconds(NetAudioPlayerManage.sharedManager.audioPlayer.currentTime())/self.leftSoundModel.soundtime!
            }
            else {
                self.rightProgressView.progress = CMTimeGetSeconds(NetAudioPlayerManage.sharedManager.audioPlayer.currentTime())/self.rightSoundModel.soundtime!
            }
        }
        NSNotificationCenter.defaultCenter().rac_addObserverForName(AVPlayerItemDidPlayToEndTimeNotification, object: nil).subscribeNext {
            notificationCenter in
            if self.leftPlayButton.hidden{
                self.leftPlayButton.hidden = false
                self.leftProgressView.progress = 0
                
            }
            else {
                self.rightPlayButton.hidden = false
                self.rightProgressView.progress = 0
                
            }
            self.leftPlayButton.enabled = true
            self.rightPlayButton.enabled = true
            
        }
        
        
    }
    
    
    
    //
    func updateCommitButton() {
        
        leftTipButton.enabled = leftPlay
        rightTipButton.enabled = rightPlay
        
        leftWinButton.enabled = leftPlay&&rightPlay
        centerWinButton.enabled = leftPlay&&rightPlay
        rightWinButton.enabled = leftPlay&&rightPlay
        
        if result == 0 {
            self.leftWinButton.selected = false
            self.centerWinButton.selected = false
            self.rightWinButton.selected = false
        }
        else if result == 1 {
            self.leftWinButton.selected = true
            self.centerWinButton.selected = false
            self.rightWinButton.selected = false
        }
        else if result == 2 {
            self.leftWinButton.selected = false
            self.centerWinButton.selected = true
            self.rightWinButton.selected = false
        }
        else if result == 3 {
            self.leftWinButton.selected = false
            self.centerWinButton.selected = false
            self.rightWinButton.selected = true
        }
        
        commitButton.enabled = (result != 0)&&leftPlay&&rightPlay
        if commitButton.enabled {
            commitButton.backgroundColor = UIColor.init(rgb: 0xff3838)
        }
        else {
            commitButton.backgroundColor = UIColor.init(rgb: 0xe5e5e5)
        }
    }
}
