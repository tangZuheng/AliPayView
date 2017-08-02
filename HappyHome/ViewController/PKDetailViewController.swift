//
//  PKDetailViewController.swift
//  HappyHome
//
//  Created by kaka on 16/10/8.
//  Copyright © 2016年 kaka. All rights reserved.
//

import UIKit
import HandyJSON
import CXAlertView

class PKDetailViewController: BaseViewController,UIAlertViewDelegate {

    var model:ScenceModel!
    var pointModel:ScencePointModel!
    var presentTime:NSTimeInterval!
    
    var img:UIImageView?
    var name:UILabel?
    
    let startTime = UILabel()
    let endTime = UILabel()
    let slider = UISlider()
    
    let startButton = UIButton()
    
    var state = 1
    
    //最大时间10分钟
    var maxTime:NSTimeInterval = 600
    
    //定时器
    var displayLink:CADisplayLink?
    
    var audioRecorderManage = AudioRecorderManage.init()
    
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
        
//        if self.audioRecorderManage.audioRecorder.recording {
//            self.audioRecorderManage.stopRecord()
//        }
        self.audioRecorderManage.deleteRecording()
        super.viewWillDisappear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func initfaceView(){
        self.title = "PK"

        self.navigationController!.navigationBar.tintColor = UIColor.whiteColor()
        self.navigationController!.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        self.navigationController!.navigationBar.barTintColor = UIColor.blackColor()
        self.navigationController!.navigationBar.alpha = 0.4
        
        img = UIImageView()
        img?.image = UIImage.init(named: "defaultImg_unknown")
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
//        name?.text = "测试"
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
        self.updateView()
    }
    
    //所有事件
    func initControlEvent(){
        startButton.rac_signalForControlEvents(UIControlEvents.TouchUpInside).subscribeNext { _ in
            if 1 == self.state {
                
                
                let viewLabel = UILabel.init()
                viewLabel.frame = CGRectMake(0, 0, 250, 100)
                viewLabel.numberOfLines = 0
                viewLabel.font = UIFont.systemFontOfSize(14)
                let viewLabelText = NSMutableAttributedString.init(string: "亲，请保证手机电量充足，录音结束前请勿退出，任何形式的退出都会浪费掉您今天唯一的PK机会。\n按结束完成PK，录音自动上传，PK结果请于明天在PK记录-昨日PK查询。")
                viewLabelText.addAttributes([NSForegroundColorAttributeName : UIColor.redColor()], range: NSMakeRange(45, 37))
                viewLabel.attributedText = viewLabelText
                
                let alertView = CXAlertView.init(title: nil, contentView: viewLabel, cancelButtonTitle: "取消")
                alertView.addButtonWithTitle("确定", type: .Default, handler: { (CXAlertVie, AlertButtonItem) in
                    alertView.dismiss()

                    self.startMBProgressHUD()
                    NetWorkingManager.sharedManager.checkPK(self.model.sid!, completion: { (retObject, error) in
                        self.stopMBProgressHUD()
                        if error == nil {
                            let code = retObject?.objectForKey("code") as! Int
                            if code == 103 {
                                self.showFailHUDWithText((retObject?.objectForKey("message"))! as! String)
                            }
                            else {
                                self.pointModel = JSONDeserializer<ScencePointModel>.deserializeFrom(retObject?.objectForKey("data")?.objectForKey("pointBean") as! NSDictionary)
                                self.presentTime = retObject?.objectForKey("data")?.objectForKey("presentTime") as! NSTimeInterval
                                self.img?.sd_setImageWithURL(NSURL.init(string: self.pointModel.ppicture!), placeholderImage: placeholderImage!)
                                
                                if UserModel.sharedUserModel.selectLanguage == 1 {
                                    self.name?.text = self.pointModel.pname
                                }
                                else {
                                    self.name?.text = self.pointModel.penglishname
                                }
                                
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
                        }
                        else {
                            self.showFailHUDWithText(error!.localizedDescription)
                        }
                    })
                })
                
                alertView.show()
                
                
//                let view = UIAlertView.init(title: "", message: "亲，请保证手机电量充足，录音结束前请勿退出，任何形式的退出都会浪费掉您今天唯一的PK机会。\n按结束完成PK，录音自动上传，PK结果请于明天在PK记录-昨日PK查询。", delegate: nil, cancelButtonTitle: "确定", otherButtonTitles: "取消")
//                view.delegate = self
//                
//                
//                view.rac_buttonClickedSignal().subscribeNext({ (indexNumber) in
//                    if indexNumber as! Int == 0 {
//                        self.startMBProgressHUD()
//                        NetWorkingManager.sharedManager.checkPK(self.model.sid!, completion: { (retObject, error) in
//                            self.stopMBProgressHUD()
//                            if error == nil {
//                                let code = retObject?.objectForKey("code") as! Int
//                                if code == 103 {
//                                    self.showFailHUDWithText((retObject?.objectForKey("message"))! as! String)
//                                }
//                                else {
//                                    self.pointModel = JSONDeserializer<ScencePointModel>.deserializeFrom(retObject?.objectForKey("data")?.objectForKey("pointBean") as! NSDictionary)
//                                    self.presentTime = retObject?.objectForKey("data")?.objectForKey("presentTime") as! NSTimeInterval
//                                    self.img?.sd_setImageWithURL(NSURL.init(string: self.pointModel.ppicture!), placeholderImage: placeholderImage!)
//                                    
//                                    if UserModel.sharedUserModel.selectLanguage == 1 {
//                                        self.name?.text = self.pointModel.pname
//                                    }
//                                    else {
//                                        self.name?.text = self.pointModel.penglishname
//                                    }
//                                    
//                                    let view = CountdownView()
//                                    view.show(5, andBlock: { (UIView) in
//                                        print("倒计时到了")
//                                        self.state = 2
//                                        self.updateView()
//                                        self.audioRecorderManage.startRecord()
//                                        self.displayLink = CADisplayLink.init(target: self, selector: #selector(TrainingRecordViewController.updateTime))
//                                        self.displayLink!.frameInterval = 1
//                                        self.displayLink!.paused = false
//                                        self.displayLink?.addToRunLoop(NSRunLoop.currentRunLoop(), forMode: NSRunLoopCommonModes)
//                                    })
//                                    
//                                }
//                            }
//                            else {
//                                self.showFailHUDWithText(error!.localizedDescription)
//                            }
//                        })
//                    }
//                })
//                view.show()
            }
            else {
                self.savePKRecord()
            }
        }

    }
    
    func updateView() -> Void {
        if 1 == self.state {
            //开始录制前
            maxTime = 600
            endTime.text = "10:00"
            
//            startButton.enabled = true
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
            
            if  nowTime >= maxTime{
                self.state = 3
                self.updateView()
                self.audioRecorderManage.stopRecord()
                self.displayLink!.paused = true
                self.savePKRecord()
            }
        }
    }
    
    func savePKRecord() {
        //保存录音到数据库
        self.maxTime = self.audioRecorderManage.audioRecorder.currentTime
        self.audioRecorderManage.stopRecord()
        let model = PKRecordModel()
        model.uid = UserModel.sharedUserModel.uid
        model.sid = self.pointModel.sid
        model.pid = self.pointModel.pid
        model.language = UserModel.sharedUserModel.selectLanguage
        model.presentTime = self.presentTime
        model.soundtime = self.maxTime
        model.fileURL = self.audioRecorderManage.recordingName
        
        PKRecordManage.sharedManager.insertDataSql(model)
        ZCMBProgressHUD.showResultHUDWithResult(true, andText: "亲，录音已上传，就等着好消息吧!", toView: self.navigationController?.view, andSecond: 2, completionBlock: {
            
            self.audioRecorderManage = AudioRecorderManage.init()
            self.navigationController?.popViewControllerAnimated(true)
        })
    }

//    func willPresentAlertView(alertView: UIAlertView) {
//        for viewSub in alertView.subviews {
//            if viewSub .isKindOfClass(UILabel.classForCoder())
//            {
//                let viewLabel = viewSub as! UILabel
//                let viewLabelText = NSMutableAttributedString.init(string: "亲，请保证手机电量充足，录音结束前请勿退出，任何形式的退出都会浪费掉您今天唯一的PK机会。\n按结束完成PK，录音自动上传，PK结果请于明天在PK记录-昨日PK查询。")
//                viewLabelText.addAttributes([NSForegroundColorAttributeName : UIColor.redColor()], range: NSMakeRange(44, 36))
//                viewLabel.attributedText = viewLabelText
//            }
//        }
//    }
    
}
