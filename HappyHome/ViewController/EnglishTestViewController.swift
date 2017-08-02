//
//  EnglishTestViewController.swift
//  HappyHome
//
//  Created by kaka on 16/11/12.
//  Copyright © 2016年 kaka. All rights reserved.
//

import UIKit
import HandyJSON

class EnglishTestViewController: BaseViewController,UITableViewDataSource,UITableViewDelegate,ZHAudioPlayerDelegate{

    let tableView = UITableView.init()
    let startButton = UIButton()
    let progressView = CircleProgressView()
    
    var isPlayEnd = false
    
    var englishTestModel:EnglishTestModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initfaceView()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillDisappear(animated: Bool) {
        ZHAudioPlayer.sharedInstance().stopAudio()
        super.viewWillDisappear(animated)
    }

    
    func initfaceView()
    {
        self.view.backgroundColor = UIColor.init(rgb: 0x252525)
        
        let backButton = UIButton()
        backButton.setImage(UIImage.init(named: "关闭按钮"), forState: .Normal)
        self.view.addSubview(backButton)
        backButton.snp_makeConstraints { (make) -> Void in
            make.top.equalToSuperview().offset(30)
            make.left.equalToSuperview().offset(20)
        }
        backButton.rac_signalForControlEvents(UIControlEvents.TouchUpInside).subscribeNext { _ in
            self.navigationController?.popViewControllerAnimated(true)
        }
        
        tableView.backgroundColor = UIColor.clearColor()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.estimatedRowHeight = 44
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.separatorStyle = .None
        tableView.tableHeaderView = self.getHeadView()
        self.view.addSubview(tableView)
        tableView.frame = CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGH - 64)
        
        self.initDataSouce()
        
    }
    
    func initDataSouce(){
        self.startMBProgressHUD()
        NetWorkingManager.sharedManager.GetEnglishTest(EnglishTestManage.shareSingle().lastTestid!) { (retObject, error) in
            self.stopMBProgressHUD()
            if error == nil {
                self.englishTestModel = JSONDeserializer<EnglishTestModel>.deserializeFrom( retObject?.objectForKey("data")! as! NSDictionary)
                EnglishTestManage.shareSingle().lastTestid = self.englishTestModel!.testid
                EnglishTestManage.shareSingle().lastTime = NSDate()
                EnglishTestManage.shareSingle().englishTestNumber = EnglishTestManage.shareSingle().englishTestNumber - 1
                EnglishTestManage.shareSingle().savaEnglishTest()
                self.tableView.reloadData()
            }
            else {
                self.showFailHUDWithText(error!.localizedDescription)
            }
        }
    }

    
    func getHeadView() -> UIView{
        let view = UIView()
        view.frame = CGRectMake(0, 0, SCREEN_WIDTH, 200)
        
        let label = UILabel()
        label.numberOfLines = 0
        label.textColor = UIColor.whiteColor()
        label.font = UIFont.systemFontOfSize(18)
        label.text = "After each conversation,one question will be asked about what was said and please choose the right answer to the question."
        view.addSubview(label)
        label.snp_makeConstraints { (make) -> Void in
            make.top.equalToSuperview().offset(20)
            make.left.equalTo(20)
            make.right.equalToSuperview().offset(-20)
        }
        
        startButton.setImage(UIImage.init(named: "开始按钮"), forState: .Normal)
        view.addSubview(startButton)
        startButton.snp_makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(label.snp_bottom).offset(30)
        }
        
        progressView.backgroundColor = UIColor.clearColor()
        progressView.trackWidth = 4
        progressView.trackBackgroundColor = UIColor.init(rgb: 0x666666)
        progressView.trackFillColor = UIColor.init(rgb: 0xe7e7e7)
        progressView.centerFillColor = UIColor.init(rgb: 0x252525)
        view.insertSubview(progressView, atIndex: 0)
        progressView.snp_makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(label.snp_bottom).offset(30)
            make.height.width.equalTo(startButton.snp_width)
        }
        
        startButton.rac_signalForControlEvents(UIControlEvents.TouchUpInside).subscribeNext { _ in
            ZHAudioPlayer.sharedInstance().delegate = self
            ZCMBProgressHUD.startMBProgressHUD()
            ZHAudioPlayer.sharedInstance().manageAudioWithUrlPath(self.englishTestModel?.questionurl, playOrPause: true)
        }
        
        return view
    }
    
    
    //MARK: UITableViewDataSource
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if englishTestModel == nil {
            return 0
        }
        return (englishTestModel?.answers?.count)!
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let identifir = "EnglishTestCellIdentifir"
        var cell:EnglishTestCell? = tableView.dequeueReusableCellWithIdentifier(identifir) as? EnglishTestCell
        if cell == nil {
            cell = EnglishTestCell.init(style: .Default, reuseIdentifier: identifir)
            cell?.selectionStyle = .None
            cell?.accessoryType = .None
        }
        cell?.englsihLabel?.text = englishTestModel?.answers![indexPath.row] as? String
        return cell!
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if isPlayEnd {
            if indexPath.row == self.englishTestModel!.tureanswer {
                EnglishTestManage.shareSingle().lastPassTime = NSDate()
                EnglishTestManage.shareSingle().savaEnglishTest()
                let view = UIAlertView.init(title: "", message: "Your English is good!", delegate: nil, cancelButtonTitle: "Got it")
                view.rac_buttonClickedSignal().subscribeNext({ (indexNumber) in
                    if indexNumber as! Int == 0 {
                        UserModel.sharedUserModel.selectLanguage = 0
                        self.navigationController?.popToRootViewControllerAnimated(false)
                        self.presentViewController(ControllerManager.sharedManager().rootViewController!, animated: true, completion: {
                            
                        })
                    }
                })
                view.show()
            }
            else {
                let view = UIAlertView.init(title: "", message: "Sorry,the answer is not me!", delegate: nil, cancelButtonTitle: "Got it")
                view.rac_buttonClickedSignal().subscribeNext({ (indexNumber) in
                    if indexNumber as! Int == 0 {
                        self.navigationController?.popViewControllerAnimated(true)
                    }
                })
                view.show()
            }
        }
    }
    
    
    //ZHAudioPlayerDelegate
    func didAudioPlayerBeginPlay(audioPlayer: AVAudioPlayer!) {
        ZCMBProgressHUD.stopMBProgressHUD()
        startButton.hidden = true
    }
    
//    func didAudioPlayerStopPlay(audioPlayer: AVAudioPlayer!) {
//        
//    }
    
    func didAudioPlayerFinishPlay(audioPlayer: AVAudioPlayer!) {
        isPlayEnd = true
        startButton.hidden = false
        startButton.enabled = false
    }
    
    func didAudioPlayerFailPlay(audioPlayer: AVAudioPlayer!) {
        ZCMBProgressHUD.stopMBProgressHUD()
        self.showFailHUDWithText("录音加载失败...")
    }
    
    func didAudioPlayerUpdateProgess(audioPlayer: AVAudioPlayer!) {
        self.progressView.progress = audioPlayer.currentTime/audioPlayer.duration
    }
}
