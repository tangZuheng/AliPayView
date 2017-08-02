//
//  LoginViewController.swift
//  HappyHome
//
//  Created by kaka on 16/10/8.
//  Copyright © 2016年 kaka. All rights reserved.
//

import UIKit
import ReactiveCocoa
import HandyJSON

class LoginViewController: BaseViewController {
    
    let usernameField = UITextField()
    let passwordField = UITextField()
    
    var loginButton:UIButton?
    var registerButton:UIButton?
    let forgetButton = UIButton()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.initfaceView()
        self.initControlEvent()
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
        
        self.title = "登录"
        
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
        
        
        usernameField.leftViewMode = .Always
        usernameField.leftView = usernameLeft
        usernameField.placeholder = "请输入注册手机号"
        usernameField.backgroundColor = UIColor.whiteColor()
//        usernameField.borderStyle = .RoundedRect
        usernameField.keyboardType = .NumberPad
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
        
        
        passwordField.leftViewMode = .Always
        passwordField.leftView = passwordLeft
        passwordField.placeholder = "请输入6-16位密码"
        passwordField.secureTextEntry = true
        passwordField.backgroundColor = UIColor.whiteColor()
        passwordField.font = UIFont.systemFontOfSize(14)
        passwordField.layer.masksToBounds = true
        passwordField.layer.cornerRadius = 2
        passwordField.layer.borderWidth = 0.5
        passwordField.layer.borderColor = UIColor.init(rgb: 0xe5e5e5).CGColor
        self.view.addSubview(passwordField)
        
        passwordField.snp_makeConstraints { (make) in
            make.top.equalTo(usernameField.snp_bottom).offset(15)
            make.centerX.equalTo(self.view)
            make.left.equalTo(40)
            make.height.equalTo(35)
        }
        
        loginButton = UIButton()
        loginButton?.setTitle("登录", forState: .Normal)
        loginButton?.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        loginButton?.titleLabel?.font = UIFont.systemFontOfSize(14)
        loginButton?.backgroundColor = UIColor.init(rgb: 0xff3838)
        loginButton?.layer.masksToBounds = true
        loginButton?.layer.cornerRadius = 2
        self.view.addSubview(loginButton!)
        
        registerButton = UIButton()
        registerButton?.setTitle("注册", forState: .Normal)
        registerButton?.setTitleColor(UIColor.init(rgb: 0xff3838), forState: .Normal)
        registerButton?.titleLabel?.font = UIFont.systemFontOfSize(14)
        registerButton?.backgroundColor = UIColor.whiteColor()
        registerButton?.layer.masksToBounds = true
        registerButton?.layer.cornerRadius = 2
        registerButton?.layer.borderWidth = 1
        registerButton?.layer.borderColor = UIColor.init(rgb: 0xff3838).CGColor
        
        self.view.addSubview(registerButton!)
        
        loginButton!.snp_makeConstraints { (make) -> Void in
            make.right.equalTo(-40)
            make.top.equalTo(passwordField.snp_bottom).offset(50)
            make.height.equalTo(35)
            make.width.equalTo((SCREEN_WIDTH-90)/2)
        }
        
        registerButton!.snp_makeConstraints { (make) -> Void in
            make.left.equalTo(40)
            make.top.equalTo((loginButton?.snp_top)!)
            make.width.equalTo((loginButton?.snp_width)!)
            make.height.equalTo((loginButton?.snp_height)!)
        }
        
        
        forgetButton.setTitle("忘记密码?", forState: .Normal)
        forgetButton.setTitleColor(UIColor.init(rgb: 0xff3838), forState: .Normal)
        forgetButton.titleLabel?.font = UIFont.systemFontOfSize(14)
        forgetButton.backgroundColor = UIColor.clearColor()
        forgetButton.titleLabel?.textAlignment = .Right
        self.view.addSubview(forgetButton)
        forgetButton.snp_makeConstraints { (make) -> Void in
            make.right.equalTo(-40)
            make.top.equalTo(loginButton!.snp_bottom).offset(10)
            make.height.equalTo(35)
        }
        
            }
    
    func initControlEvent() {
//        RAC(loginButton,"enabled") <= RACSignal.combineLatest([self.usernameField.rac_textSignal(),self.passwordField.rac_textSignal()], reduce: { () -> AnyObject! in
//            return self.usernameField.text!.characters.count == 11 && self.passwordField.text!.characters.count >= 6
//        })
        
        registerButton!.rac_signalForControlEvents(UIControlEvents.TouchUpInside).subscribeNext { _ in
            let vc = RegisterViewController()
            self.pushToNextController(vc)
        }
        
        forgetButton.rac_signalForControlEvents(UIControlEvents.TouchUpInside).subscribeNext { _ in
            let vc = FindPasswordViewController()
            self.pushToNextController(vc)
        }
        
        loginButton!.rac_signalForControlEvents(UIControlEvents.TouchUpInside).subscribeNext { _ in
            if !ConfirmMobileNumber.isPhoneNumber(self.usernameField.text!){
                self.showFailHUDWithText("请输入正确的手机号码!")
                return
            }
            if !(self.passwordField.text?.characters.count >= 6 && self.passwordField.text?.characters.count <= 16) {
                self.showFailHUDWithText("请输入6-16位密码")
                return
            }
            self.startMBProgressHUD()
            NetWorkingManager.sharedManager.Login(self.usernameField.text!, password: self.passwordField.text!, completion: { (retObject, error) in
                self.stopMBProgressHUD()
                if error == nil {
                    let dic = retObject?.valueForKey("data") as! NSDictionary
                    UserModel.sharedUserModel.setUserModel(dic)
                    UserModel.sharedUserModel.savaUserModel()
                    NSNotificationCenter.defaultCenter().postNotificationName(LoginStateUpdateNotification, object: nil)
                    self.navigationController?.popToRootViewControllerAnimated(true)
                    JPUSHService.setAlias(String(UserModel.sharedUserModel.uid!), callbackSelector: nil, object: nil)
                }
                else {
                    self.showFailHUDWithText(error!.localizedDescription)
                }
            })
        }
        
        registerButton!.rac_signalForControlEvents(UIControlEvents.TouchUpInside).subscribeNext { _ in
            let vc = RegisterViewController()
            self.navigationController?.popToViewController(vc, animated: true)
        }

    }
    
}
