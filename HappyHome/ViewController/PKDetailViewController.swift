//
//  PKDetailViewController.swift
//  HappyHome
//
//  Created by kaka on 16/10/8.
//  Copyright © 2016年 kaka. All rights reserved.
//

import UIKit

class PKDetailViewController: BaseViewController {

    var img:UIImageView?
    var name:UILabel?
    
    let startTime = UILabel()
    let endTime = UILabel()
    let slider = UISlider()
    
    let startButton = UIButton()
    
    var state = 1
    
    //最大时间3分钟
    var maxTime:NSTimeInterval = 180
    
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
        //        if self.audioRecorderManage.audioPlayer !=nil &&self.audioRecorderManage.audioPlayer.playing {
        //            self.audioRecorderManage.pausePlaying()
        //        }
        self.audioRecorderManage.audioRecorder.deleteRecording()
        
        super.viewWillDisappear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func initfaceView(){
        self.title = "测试"

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
        name?.text = "测试"
        name?.textColor = UIColor.whiteColor()
        self.view.addSubview(name!)
        name!.snp_makeConstraints { (make) -> Void in
            make.width.equalTo(img!)
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
        endTime.text = "03:00"
        bottomView.addSubview(endTime)
        endTime.snp_makeConstraints { (make) in
            make.top.equalTo(startTime)
            make.right.equalTo(bottomView).offset(-13)
            make.width.equalTo(startTime.snp_width)
            make.height.equalTo(startTime)
        }
        
        slider.minimumTrackTintColor = UIColor.init(rgb: 0xfbbebe);
        slider.maximumTrackTintColor = UIColor.init(rgb: 0xdcdcdc);
        //        slider.value = 0.5
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
                view.show(2, andBlock: { (UIView) in
                    print("倒计时到了")
                    self.state = 2
                    self.updateView()
                    //                    AudioRecorderManage.getSavePath()
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
        self.updateView()
    }
    
    func updateView() -> Void {
        if 1 == self.state {
            //开始录制前
            maxTime = 180
            endTime.text = "03:00"
            
            startButton.enabled = true
            startButton.setImage(UIImage.init(named: "开始按钮"), forState: .Normal)

        }
        else if 2 == self.state {
            //正在录制
            startButton.enabled = true
            
            startButton.setImage(UIImage.init(named: "停止按钮"), forState: .Normal)
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
            
            if  nowTime >= 180{
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
