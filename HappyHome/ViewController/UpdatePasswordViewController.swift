//
//  UpdatePasswordViewController.swift
//  HappyHome
//
//  Created by kaka on 16/10/26.
//  Copyright © 2016年 kaka. All rights reserved.
//

import UIKit

class UpdatePasswordViewController: BaseViewController {
    
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
        
        self.title = "修改密码"
        
        
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
        
        let new_passwordLeft = UIView()
        new_passwordLeft.snp_makeConstraints { (make) in
            make.height.equalTo(35)
            make.width.equalTo(30)
        }
        
        let new_passwordView = UIImageView.init(image: UIImage.init(named: "user_password"))
        new_passwordLeft.addSubview(new_passwordView)
        new_passwordView.snp_makeConstraints { (make) in
            make.center.equalToSuperview()
        }
        
        
        let newTwo_passwordLeft = UIView()
        newTwo_passwordLeft.snp_makeConstraints { (make) in
            make.height.equalTo(35)
            make.width.equalTo(30)
        }
        
        let newTwo_passwordView = UIImageView.init(image: UIImage.init(named: "user_password"))
        newTwo_passwordLeft.addSubview(newTwo_passwordView)
        newTwo_passwordView.snp_makeConstraints { (make) in
            make.center.equalToSuperview()
        }
        
        let passwordField = UITextField()
        passwordField.leftViewMode = .Always
        passwordField.leftView = passwordLeft
        passwordField.placeholder = "请输入旧密码"
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
            make.top.equalTo(90)
            make.centerX.equalTo(self.view)
            make.left.equalTo(40)
            make.height.equalTo(35)
        }
        
        let new_passwordField = UITextField()
        new_passwordField.leftViewMode = .Always
        new_passwordField.leftView = new_passwordLeft
        new_passwordField.placeholder = "请输入6-16位的新密码"
        new_passwordField.secureTextEntry = true
        new_passwordField.backgroundColor = UIColor.whiteColor()
        //        passwordField.borderStyle = .RoundedRect
        new_passwordField.font = UIFont.systemFontOfSize(14)
        new_passwordField.layer.masksToBounds = true
        new_passwordField.layer.cornerRadius = 2
        new_passwordField.layer.borderWidth = 0.5
        new_passwordField.layer.borderColor = UIColor.init(rgb: 0xe5e5e5).CGColor
        self.view.addSubview(new_passwordField)
        
        new_passwordField.snp_makeConstraints { (make) in
//            make.top.equalTo(90)
            make.top.equalTo(passwordField.snp_bottom).offset(15)
            make.centerX.equalTo(self.view)
            make.left.equalTo(40)
            make.height.equalTo(35)
        }
        
        let newTwo_passwordField = UITextField()
        newTwo_passwordField.leftViewMode = .Always
        newTwo_passwordField.leftView = newTwo_passwordLeft
        newTwo_passwordField.placeholder = "请重复输入新密码"
        newTwo_passwordField.secureTextEntry = true
        newTwo_passwordField.backgroundColor = UIColor.whiteColor()
        //        passwordField.borderStyle = .RoundedRect
        newTwo_passwordField.font = UIFont.systemFontOfSize(14)
        newTwo_passwordField.layer.masksToBounds = true
        newTwo_passwordField.layer.cornerRadius = 2
        newTwo_passwordField.layer.borderWidth = 0.5
        newTwo_passwordField.layer.borderColor = UIColor.init(rgb: 0xe5e5e5).CGColor
        self.view.addSubview(newTwo_passwordField)
        
        newTwo_passwordField.snp_makeConstraints { (make) in
//            make.top.equalTo(90)
            make.top.equalTo(new_passwordField.snp_bottom).offset(15)
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
            make.top.equalTo(newTwo_passwordField.snp_bottom).offset(50)
            make.height.equalTo(35)
            make.centerX.equalTo(self.view)
        }
        
        commitButton.rac_signalForControlEvents(UIControlEvents.TouchUpInside).subscribeNext { _ in
            if !(passwordField.text?.characters.count >= 6 && passwordField.text?.characters.count <= 16) {
                self.showFailHUDWithText("请输入6-16位密码")
                return
            }
            if !(new_passwordField.text?.characters.count >= 6 && new_passwordField.text?.characters.count <= 16) {
                self.showFailHUDWithText("请输入6-16位密码")
                return
            }
            if !(newTwo_passwordField.text?.characters.count >= 6 && newTwo_passwordField.text?.characters.count <= 16) {
                self.showFailHUDWithText("请输入6-16位密码")
                return
            }
            if new_passwordField.text != newTwo_passwordField.text {
                self.showFailHUDWithText("两次输入的密码不一致")
                return
            }
            
            self.startMBProgressHUD()
            NetWorkingManager.sharedManager.updetePassword(passwordField.text!, newpwd: new_passwordField.text!, completion: { (retObject, error) in
                self.stopMBProgressHUD()
                if error == nil {
                    ZCMBProgressHUD.showResultHUDWithResult(true, andText: retObject?.valueForKey("message") as! String, toView: self.view, andSecond: 2, completionBlock: {
                        self.navigationController?.popToRootViewControllerAnimated(true)
                    })
                }
                else {
                    self.showFailHUDWithText(error!.localizedDescription)
                }
            })
            
        }
        
    }

}
