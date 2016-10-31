//
//  RegisterViewController.swift
//  HappyHome
//
//  Created by kaka on 16/10/8.
//  Copyright © 2016年 kaka. All rights reserved.
//

import UIKit

class RegisterViewController: BaseViewController {

    var loginButton:UIButton?
    var registerButton:UIButton?
    
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
    
    override func viewWillAppear(animated: Bool) {
        self.navigationController!.navigationBarHidden = false
        super.viewDidAppear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func initfaceView(){
        
        self.title = "注册"
        
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
        usernameField.keyboardType = .NumberPad
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
        codeField.leftView = UIView.init(frame: CGRectMake(0, 0, 8, 0))
        codeField.leftViewMode = .Always
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
            make.width.equalTo(SCREEN_WIDTH-240)
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
            make.width.equalTo(150)
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
        
        let nicknameLeft = UIView()
        nicknameLeft.snp_makeConstraints { (make) in
            make.height.equalTo(35)
            make.width.equalTo(30)
        }
        
        let nicknameView = UIImageView.init(image: UIImage.init(named: "user_nackname"))
        nicknameLeft.addSubview(nicknameView)
        nicknameView.snp_makeConstraints { (make) in
            make.center.equalToSuperview()
        }
        
        let nicknameField = UITextField()
        nicknameField.leftViewMode = .Always
        nicknameField.leftView = nicknameLeft
        nicknameField.placeholder = "请输入用户昵称"
//        nicknameField.secureTextEntry = true
        nicknameField.backgroundColor = UIColor.whiteColor()
//        nicknameField.borderStyle = .RoundedRect
        nicknameField.font = UIFont.systemFontOfSize(14)
        nicknameField.layer.masksToBounds = true
        nicknameField.layer.cornerRadius = 2
        nicknameField.layer.borderWidth = 0.5
        nicknameField.layer.borderColor = UIColor.init(rgb: 0xe5e5e5).CGColor
        self.view.addSubview(nicknameField)
        
        nicknameField.snp_makeConstraints { (make) in
            make.top.equalTo(passwordField.snp_bottom).offset(15)
            make.centerX.equalTo(self.view)
            make.left.equalTo(40)
            make.height.equalTo(35)
        }
        
        loginButton = UIButton()
        loginButton?.setTitle("登录", forState: .Normal)
        loginButton?.setTitleColor(UIColor.init(rgb: 0xff3838), forState: .Normal)
        loginButton?.titleLabel?.font = UIFont.systemFontOfSize(14)
        loginButton?.backgroundColor = UIColor.whiteColor()
        loginButton?.layer.borderWidth = 1
        loginButton?.layer.borderColor = UIColor.init(rgb: 0xff3838).CGColor
        loginButton?.layer.masksToBounds = true
        loginButton?.layer.cornerRadius = 2
        self.view.addSubview(loginButton!)
        
        registerButton = UIButton()
        registerButton?.setTitle("注册", forState: .Normal)
        registerButton?.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        registerButton?.titleLabel?.font = UIFont.systemFontOfSize(14)
        registerButton?.backgroundColor = UIColor.init(rgb: 0xff3838)
        registerButton?.layer.masksToBounds = true
        registerButton?.layer.cornerRadius = 2
        self.view.addSubview(registerButton!)
        
        loginButton!.snp_makeConstraints { (make) -> Void in
            make.right.equalTo(-40)
            make.top.equalTo(nicknameField.snp_bottom).offset(50)
            make.height.equalTo(35)
            make.width.equalTo((SCREEN_WIDTH-90)/2)
        }
        registerButton!.snp_makeConstraints { (make) -> Void in
            make.left.equalTo(40)
            make.top.equalTo((loginButton?.snp_top)!)
            make.width.equalTo((loginButton?.snp_width)!)
            make.height.equalTo((loginButton?.snp_height)!)
        }
        
        sendButton.rac_signalForControlEvents(UIControlEvents.TouchUpInside).subscribeNext { _ in
            if ConfirmMobileNumber.isPhoneNumber(usernameField.text!)
            {
                self.startMBProgressHUD()
                NetWorkingManager.sharedManager.registerSendCode(usernameField.text!,type: 1, completion: { (retObject, error) in
                    self.stopMBProgressHUD()
                    if error == nil {
                        self.isCounting = true
                    }
                    else {
                        self.showFailHUDWithText(error!.localizedDescription)
                    }
                })
            }
            else {
                self.showFailHUDWithText("请输入正确的手机号码!")
            }
        }
        
        registerButton!.rac_signalForControlEvents(UIControlEvents.TouchUpInside).subscribeNext { _ in
            if !ConfirmMobileNumber.isPhoneNumber(usernameField.text!){
                self.showFailHUDWithText("请输入正确的手机号码!")
                return
            }
            if codeField.text?.characters.count == 0 {
                self.showFailHUDWithText("请输入正确的验证码!")
                return
            }
            if !(passwordField.text?.characters.count >= 6 && passwordField.text?.characters.count <= 16) {
                self.showFailHUDWithText("请输入6-16位密码")
                return
            }
            self.startMBProgressHUD()
            NetWorkingManager.sharedManager.register(usernameField.text!, code: codeField.text!, username: usernameField.text!, password: passwordField.text!, nickname: nicknameField.text!, completion: { (retObject, error) in
                self.stopMBProgressHUD()
                if error == nil {
                    let dic = retObject?.valueForKey("data") as! NSDictionary
                    UserModel.sharedUserModel.setUserModel(dic)
                    UserModel.sharedUserModel.savaUserModel()
                    NSNotificationCenter.defaultCenter().postNotificationName(LoginStateUpdateNotification, object: nil)
                    self.navigationController?.popToRootViewControllerAnimated(true)
                }
                else {
                    self.showFailHUDWithText(error!.localizedDescription)
                }
            })
            
        }
        
        loginButton!.rac_signalForControlEvents(UIControlEvents.TouchUpInside).subscribeNext { _ in
            for temp in self.navigationController!.viewControllers
            {
                if temp is LoginViewController {
                    self.navigationController?.popToViewController(temp, animated: true)
                    return
                }
            }
            self.pushLoginController()
        }
        
    }
    
    func updateTime(timer: NSTimer) {
        // 计时开始时，逐秒减少remainingSeconds的值
        remainingSeconds -= 1
    }

}
