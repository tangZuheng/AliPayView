//
//  TrainingRecordViewController.swift
//  HappyHome
//
//  Created by kaka on 16/10/4.
//  Copyright © 2016年 kaka. All rights reserved.
//

import UIKit

class TrainingRecordViewController: BaseViewController {
    
    var model:ScenceModel!
    var pointModel:ScencePointModel!
    
    var img:UIImageView?
    var name:UILabel?
    
    let startTime = UILabel()
    let endTime = UILabel()
    let slider = UISlider()
    
    let startButton = UIButton()
    let playButton = UIButton()
    let completeButton = UIButton()
    
    var state = 1
    
    //最大时间3分钟
    var maxTime:NSTimeInterval = 600
    
    //定时器
    var displayLink:CADisplayLink?
    
    var audioRecorderManage = AudioRecorderManage.init()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.initfaceView()
    }
    
    override func viewWillDisappear(animated: Bool) {
        
        self.navigationController!.navigationBar.tintColor = colorForNavigationBarTitle()
        self.navigationController!.navigationBar.barTintColor = UIColor.whiteColor()
        self.navigationController!.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: colorForNavigationBarTitle()]
        self.navigationController!.navigationBar.alpha = 1
        
        if self.audioRecorderManage.audioRecorder.recording {
            self.audioRecorderManage.stopRecord()
        }
        if self.audioRecorderManage.audioPlayer != nil {
            if self.audioRecorderManage.audioPlayer.playing {
                self.audioRecorderManage.pausePlaying()
            }
        }
        self.audioRecorderManage.audioRecorder.deleteRecording()
        
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
        img?.sd_setImageWithURL(NSURL.init(string: self.pointModel.ppicture!), placeholderImage: placeholderImage!)
//        img?.image = UIImage.init(named: "defaultImg")
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
        if UserModel.sharedUserModel.selectLanguage == 1 {
            name?.text = self.pointModel.pname
        }
        else {
            name?.text = self.pointModel.penglishname
        }
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
        
        startTime.textColor = UIColor.whiteColor()
        startTime.text = "00:00"
        bottomView.addSubview(startTime)
        startTime.snp_makeConstraints { (make) in
            make.left.equalTo(13)
            make.top.equalTo(40)
            make.width.equalTo(50)
            make.height.equalTo(20)
        }
        
        endTime.textColor = UIColor.whiteColor()
//        endTime.text = "10:00"
        bottomView.addSubview(endTime)
        endTime.snp_makeConstraints { (make) in
            make.top.equalTo(startTime)
            make.right.equalTo(bottomView).offset(-13)
            make.width.equalTo(startTime.snp_width)
            make.height.equalTo(startTime)
        }
        
        slider.minimumTrackTintColor = UIColor.init(rgb: 0xff3838);
        slider.maximumTrackTintColor = UIColor.init(rgb: 0xdcdcdc);
        slider.setThumbImage(UIImage.init(named: "进度点"), forState: .Normal)
        slider.userInteractionEnabled = false
        bottomView.addSubview(slider)
        slider.snp_makeConstraints { (make) in
            make.left.equalTo(startTime.snp_right).offset(15)
            make.right.equalTo(endTime.snp_left).offset(-15)
            make.centerY.equalTo(startTime.snp_centerY)
            make.height.equalTo(startTime)
        }
        
        bottomView.addSubview(startButton)
        startButton.snp_makeConstraints { (make) in
            make.centerX.equalTo(bottomView)
            make.bottom.equalTo(bottomView).offset(-50)
        }
        startButton.rac_signalForControlEvents(UIControlEvents.TouchUpInside).subscribeNext { _ in
            if 1 == self.state {
                let view = CountdownView()
                view.show(5, andBlock: { (UIView) in
                    print("倒计时到了")
                    self.state = 2
                    self.updateView()
                    self.audioRecorderManage.startRecord()
                    self.displayLink = CADisplayLink.init(target: self, selector: #selector(TrainingRecordViewController.updateTime))
                    self.displayLink!.frameInterval = 1
                    self.displayLink!.paused = false
                    self.displayLink?.addToRunLoop(NSRunLoop.currentRunLoop(), forMode: NSRunLoopCommonModes)
                })
            }
            else {
                self.state = 3
                self.maxTime = self.audioRecorderManage.audioRecorder.currentTime
                self.updateView()
                self.audioRecorderManage.stopRecord()
            }
        }
        
        playButton.enabled = false
        bottomView.addSubview(playButton)
        playButton.snp_makeConstraints { (make) in
            make.centerY.equalTo(startButton)
            make.right.equalTo(startButton.snp_left).offset(-20)
        }
        playButton.rac_signalForControlEvents(UIControlEvents.TouchUpInside).subscribeNext { _ in
            if 3 == self.state || 5 == self.state {
                self.audioRecorderManage.startPlaying()
                self.displayLink!.paused = false
                self.state = 4
                self.updateView()
            }
            else {
                self.audioRecorderManage.pausePlaying()
                self.state = 5
                self.updateView()

            }
        }
        
        completeButton.enabled = false
        bottomView.addSubview(completeButton)
        completeButton.snp_makeConstraints { (make) in
            make.centerY.equalTo(startButton)
            make.left.equalTo(startButton.snp_right).offset(20)
        }
        completeButton.rac_signalForControlEvents(UIControlEvents.TouchUpInside).subscribeNext { _ in
            self.audioRecorderManage.pausePlaying()
            self.state = 3
            self.updateView()
            let view = UIAlertView.init(title: "提示", message: "保存或者删除？", delegate: nil, cancelButtonTitle: "保存",otherButtonTitles:"删除")
            view.rac_buttonClickedSignal().subscribeNext({ (indexNumber) in
                if indexNumber as! Int == 0 {
                    var sname = self.model.sname
                    var pname = self.pointModel.pname
                    if UserModel.sharedUserModel.selectLanguage == 0 {
                        sname = self.model.senglishname
                        pname = self.pointModel.penglishname
                    }
                    SQLiteManage.sharedManager.insertRecord(String(self.audioRecorderManage.recordingName), imgVal: self.pointModel.ppicture! ,  spotsNameVal: sname!, explainNameVal: pname! ,recordLengthVal: self.maxTime)
                }
                else {
                    self.audioRecorderManage.audioRecorder.deleteRecording()
                }
                self.state = 1
                self.audioRecorderManage = AudioRecorderManage.init()
                self.updateView()
            })
            view.show()
        }
        
        self.updateView()
    }
    
    func updateView() -> Void {
        if 1 == self.state {
            //开始录制前
            maxTime = 600
            endTime.text = "10:00"
            
            startButton.enabled = true
            playButton.enabled = false
            completeButton.enabled = false
            
            startButton.setImage(UIImage.init(named: "开始按钮"), forState: .Normal)
            playButton.setImage(UIImage.init(named: "播放按钮-灰"), forState: .Normal)
            completeButton.setImage(UIImage.init(named: "保存按钮-灰"), forState: .Normal)
        }
        else if 2 == self.state {
            //正在录制
            startButton.enabled = true
            playButton.enabled = false
            completeButton.enabled = false
            
            startButton.setImage(UIImage.init(named: "停止按钮"), forState: .Normal)
            playButton.setImage(UIImage.init(named: "播放按钮-灰"), forState: .Normal)
            completeButton.setImage(UIImage.init(named: "保存按钮-灰"), forState: .Normal)
        }
        else if 3 == self.state {
            //录制结束
            startButton.enabled = false
            playButton.enabled = true
            completeButton.enabled = true
            
            startButton.setImage(UIImage.init(named: "开始按钮-灰"), forState: .Normal)
            playButton.setImage(UIImage.init(named: "播放按钮"), forState: .Normal)
            completeButton.setImage(UIImage.init(named: "保存按钮"), forState: .Normal)
            
            let dateEnd = NSDate(timeIntervalSince1970: maxTime)
            let dformatter = NSDateFormatter()
            dformatter.dateFormat = "mm:ss"
            
            startTime.text = "00:00"
            endTime.text = dformatter.stringFromDate(dateEnd)
            self.slider.value = 0
        }
        else if 4 == self.state {
            //正在播放
            startButton.enabled = false
            playButton.enabled = true
            completeButton.enabled = true
            
            startButton.setImage(UIImage.init(named: "开始按钮-灰"), forState: .Normal)
            playButton.setImage(UIImage.init(named: "暂停按钮"), forState: .Normal)
            completeButton.setImage(UIImage.init(named: "保存按钮"), forState: .Normal)
        }
        else if 5 == self.state {
            //暂停播放
            startButton.enabled = false
            playButton.enabled = true
            completeButton.enabled = true
            
            startButton.setImage(UIImage.init(named: "开始按钮-灰"), forState: .Normal)
            playButton.setImage(UIImage.init(named: "播放按钮"), forState: .Normal)
            completeButton.setImage(UIImage.init(named: "保存按钮"), forState: .Normal)
        }
    }
    
    func updateTime() -> Void {
        if 2 == self.state {
            let nowTime = self.audioRecorderManage.audioRecorder.currentTime
            //转换为时间
            let timeInterval:NSTimeInterval = nowTime
            let dateStart = NSDate(timeIntervalSince1970: timeInterval)
            let dateEnd = NSDate(timeIntervalSince1970: maxTime - timeInterval)
            
            let dformatter = NSDateFormatter()
            dformatter.dateFormat = "mm:ss"
            //        print("当前日期时间：\(dformatter.stringFromDate(date))")
            startTime.text = dformatter.stringFromDate(dateStart)
            endTime.text = dformatter.stringFromDate(dateEnd)
            slider.value = Float(nowTime/maxTime)
            
            if  nowTime >= maxTime{
                self.state = 3
                self.updateView()
                self.audioRecorderManage.stopRecord()
                self.displayLink!.paused = true
            }
        }
        else if 4 == state {
            let nowTime = self.audioRecorderManage.audioPlayer.currentTime
//            let deviceCurrentTime = self.audioRecorderManage.audioRecorder.deviceCurrentTime

            //转换为时间
            let timeInterval:NSTimeInterval = nowTime
            let dateStart = NSDate(timeIntervalSince1970: timeInterval)
            let dateEnd = NSDate(timeIntervalSince1970: maxTime - timeInterval)
            
            let dformatter = NSDateFormatter()
            dformatter.dateFormat = "mm:ss"
            //        print("当前日期时间：\(dformatter.stringFromDate(date))")
            startTime.text = dformatter.stringFromDate(dateStart)
            endTime.text = dformatter.stringFromDate(dateEnd)
            slider.value = Float(nowTime/maxTime)
            
            if  nowTime >= maxTime{
                self.state = 3
                self.updateView()
                self.audioRecorderManage.stopRecord()
                self.displayLink!.paused = true
            }
        }
    }
}
