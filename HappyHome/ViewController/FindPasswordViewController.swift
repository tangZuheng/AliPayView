//
//  FindPasswordViewController.swift
//  HappyHome
//
//  Created by kaka on 16/10/8.
//  Copyright © 2016年 kaka. All rights reserved.
//

import UIKit

class FindPasswordViewController: BaseViewController {

    var sendButton: UIButton!
    
    var countdownTimer: NSTimer?
    
    var remainingSeconds: Int = 0 {
        willSet {
            sendButton.setTitle("\(newValue)s", forState: .Normal)
            
            if newValue <= 0 {
                sendButton.setTitle("重新发送验证码", forState: .Normal)
                isCounting = false
            }
        }
    }
    
    var isCounting = false {
        willSet {
            if newValue {
                countdownTimer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: #selector(RegisterViewController.updateTime(_:)), userInfo: nil, repeats: true)
                
                remainingSeconds = 60
            } else {
                countdownTimer?.invalidate()
                countdownTimer = nil
            }
            
            sendButton.enabled = !newValue
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.initfaceView()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func initfaceView(){
        
        self.title = "找回密码"
        
        let usernameLeft = UIView()
        usernameLeft.snp_makeConstraints { (make) in
            make.height.equalTo(35)
            make.width.equalTo(30)
        }
        
        let usernameView = UIImageView.init(image: UIImage.init(named: "user_username"))
        usernameLeft.addSubview(usernameView)
        usernameView.snp_makeConstraints { (make) in
            make.center.equalToSuperview()
        }
        
        let usernameField = UITextField()
        usernameField.leftViewMode = .Always
        usernameField.leftView = usernameLeft
        usernameField.placeholder = "请输入注册手机号"
        usernameField.backgroundColor = UIColor.whiteColor()
        //        usernameField.borderStyle = .RoundedRect
        usernameField.font = UIFont.systemFontOfSize(14)
        usernameField.layer.masksToBounds = true
        usernameField.layer.cornerRadius = 2
        usernameField.layer.borderWidth = 0.5
        usernameField.layer.borderColor = UIColor.init(rgb: 0xe5e5e5).CGColor
        self.view.addSubview(usernameField)
        
        usernameField.snp_makeConstraints { (make) in
            make.top.equalTo(90)
            make.centerX.equalTo(self.view)
            make.left.equalTo(40)
            make.height.equalTo(35)
        }
        
        let codeField = UITextField()
        codeField.placeholder = "请输入短信验证码"
        codeField.backgroundColor = UIColor.whiteColor()
        //        codeField.borderStyle = .RoundedRect
        codeField.font = UIFont.systemFontOfSize(14)
        codeField.layer.masksToBounds = true
        codeField.layer.cornerRadius = 2
        codeField.layer.borderWidth = 0.5
        codeField.layer.borderColor = UIColor.init(rgb: 0xe5e5e5).CGColor
        self.view.addSubview(codeField)
        
        codeField.snp_makeConstraints { (make) in
            make.top.equalTo(usernameField.snp_bottom).offset(15)
            //            make.centerX.equalTo(self.view)
            make.width.equalTo(SCREEN_WIDTH-190)
            make.left.equalTo(40)
            make.height.equalTo(35)
        }
        
        sendButton = UIButton()
        sendButton.backgroundColor = UIColor.whiteColor()
        sendButton.setTitleColor(UIColor.init(rgb: 0x666666), forState: .Normal)
        sendButton.setTitle("发送验证码", forState: .Normal)
        sendButton.titleLabel?.font = UIFont.systemFontOfSize(14)
        sendButton.layer.masksToBounds = true
        sendButton.layer.cornerRadius = 2
        sendButton.layer.borderWidth = 0.5
        sendButton.layer.borderColor = UIColor.init(rgb: 0xe5e5e5).CGColor
        
        //        sendButton.addTarget(self, action: "sendButtonClick:", forControlEvents: .TouchUpInside)
        self.view.addSubview(sendButton)
        sendButton.snp_makeConstraints { (make) in
            make.top.equalTo(codeField)
            make.width.equalTo(100)
            make.right.equalTo(-40)
            make.height.equalTo(35)
        }
        
        let passwordLeft = UIView()
        passwordLeft.snp_makeConstraints { (make) in
            make.height.equalTo(35)
            make.width.equalTo(30)
        }
        
        let passwordView = UIImageView.init(image: UIImage.init(named: "user_password"))
        passwordLeft.addSubview(passwordView)
        passwordView.snp_makeConstraints { (make) in
            make.center.equalToSuperview()
        }
        
        let passwordField = UITextField()
        passwordField.leftViewMode = .Always
        passwordField.leftView = passwordLeft
        passwordField.placeholder = "请输入6-16位密码"
        passwordField.secureTextEntry = true
        passwordField.backgroundColor = UIColor.whiteColor()
        //        passwordField.borderStyle = .RoundedRect
        passwordField.font = UIFont.systemFontOfSize(14)
        passwordField.layer.masksToBounds = true
        passwordField.layer.cornerRadius = 2
        passwordField.layer.borderWidth = 0.5
        passwordField.layer.borderColor = UIColor.init(rgb: 0xe5e5e5).CGColor
        self.view.addSubview(passwordField)
        
        passwordField.snp_makeConstraints { (make) in
            make.top.equalTo(codeField.snp_bottom).offset(15)
            make.centerX.equalTo(self.view)
            make.left.equalTo(40)
            make.height.equalTo(35)
        }
        
        let commitButton = UIButton()
        commitButton.setTitle("确定", forState: .Normal)
        commitButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        commitButton.titleLabel?.font = UIFont.systemFontOfSize(14)
        commitButton.backgroundColor = UIColor.init(rgb: 0xcccccc)
//        commitButton.layer.borderWidth = 1
//        commitButton.layer.borderColor = UIColor.init(rgb: 0xff3838).CGColor
        commitButton.layer.masksToBounds = true
        commitButton.layer.cornerRadius = 2
        self.view.addSubview(commitButton)
        commitButton.snp_makeConstraints { (make) -> Void in
            make.left.equalTo(40)
            make.top.equalTo(passwordField.snp_bottom).offset(50)
            make.height.equalTo(35)
            make.centerX.equalTo(self.view)
        }
    }
    
    func updateTime(timer: NSTimer) {
        // 计时开始时，逐秒减少remainingSeconds的值
        remainingSeconds -= 1
    }

}
