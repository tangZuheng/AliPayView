//
//  UserHeardeView.swift
//  HappyHome
//
//  Created by kaka on 16/10/6.
//  Copyright © 2016年 kaka. All rights reserved.
//

import UIKit

class UserHeardeView: UIView {
    
    var userHeadButton:UIButton?
    var homeButton:UIButton?
    var loginButton:UIButton?
    var registerButton:UIButton?
    
    var nicknameLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.initfaceView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initfaceView() {
        let back = UIImageView.init()
        back.image = UIImage.init(named: "user_back")
        self.addSubview(back)
        back.snp_makeConstraints { (make) -> Void in
            make.edges.equalTo(self).inset(UIEdgeInsetsMake(0, 0, 0, 0))
        }
        
        userHeadButton = UIButton()
        userHeadButton?.setBackgroundImage(placeholderHead, forState: .Normal)
        userHeadButton?.layer.masksToBounds = true
        userHeadButton?.layer.cornerRadius = (70*SCREEN_SCALE)/2
        //背景边框
        userHeadButton?.layer.borderWidth = 2
        userHeadButton?.layer.borderColor = UIColor.whiteColor().CGColor
//        userHeadButton?.contentMode = .ScaleAspectFit
        self.addSubview(userHeadButton!)
        userHeadButton!.snp_makeConstraints { (make) -> Void in
            make.centerX.equalToSuperview()
            make.top.equalTo(40*SCREEN_SCALE)
            make.width.height.equalTo(70*SCREEN_SCALE)
        }
        
        homeButton = UIButton()
        homeButton!.setImage(UIImage.init(named: "home"), forState: .Normal)
        self.addSubview(homeButton!)
        homeButton!.snp_makeConstraints { (make) -> Void in
            make.top.equalTo((userHeadButton?.snp_top)!)
            make.right.equalTo((userHeadButton?.snp_right)!).offset(20)
        }
        
        loginButton = UIButton()
        loginButton?.setTitle("登录", forState: .Normal)
        loginButton?.setTitleColor(UIColor.init(rgb: 0x282828), forState: .Normal)
        loginButton?.titleLabel?.font = UIFont.systemFontOfSize(14)
        loginButton?.backgroundColor = UIColor.whiteColor()
        loginButton?.layer.masksToBounds = true
        loginButton?.layer.cornerRadius = 2

        self.addSubview(loginButton!)
        loginButton!.snp_makeConstraints { (make) -> Void in
            make.left.equalTo(50)
            make.bottom.equalTo(-20)
            make.width.equalTo(105*SCREEN_SCALE)
            make.height.equalTo(30*SCREEN_SCALE)
        }
        
        registerButton = UIButton()
        registerButton?.setTitle("注册", forState: .Normal)
        registerButton?.setTitleColor(UIColor.init(rgb: 0x282828), forState: .Normal)
        registerButton?.titleLabel?.font = UIFont.systemFontOfSize(14)
        registerButton?.backgroundColor = UIColor.whiteColor()
        registerButton?.layer.masksToBounds = true
        registerButton?.layer.cornerRadius = 2
        
        self.addSubview(registerButton!)
        registerButton!.snp_makeConstraints { (make) -> Void in
            make.right.equalTo(-50)
            make.bottom.equalTo(-20)
            make.width.equalTo((loginButton?.snp_width)!)
            make.height.equalTo((loginButton?.snp_height)!)
        }
        
        nicknameLabel.textColor = UIColor.whiteColor()
        nicknameLabel.font = UIFont.systemFontOfSize(14);
        nicknameLabel.textAlignment = .Center
        self.addSubview(nicknameLabel)
        nicknameLabel.snp_makeConstraints { (make) -> Void in
            make.top.equalTo((userHeadButton?.snp_bottom)!).offset(20)
            make.left.equalTo(20)
            make.centerX.equalToSuperview()
        }
        
        
        self.updateLoginState()
        
        NSNotificationCenter.defaultCenter().rac_addObserverForName(LoginStateUpdateNotification, object: nil).subscribeNext {
            notificationCenter in
            self.updateLoginState()
        }
    }
    
    func updateLoginState() {
        if UserModel.sharedUserModel.isLogin {
            loginButton?.hidden = true
            registerButton?.hidden = true
            nicknameLabel.hidden = false
            nicknameLabel.text = UserModel.sharedUserModel.nickname
            userHeadButton?.sd_setImageWithURL(NSURL.init(string: UserModel.sharedUserModel.picture!), forState: .Normal, placeholderImage: placeholderHead)
        }
        else {
            loginButton?.hidden = false
            registerButton?.hidden = false
            nicknameLabel.hidden = true
            userHeadButton?.setBackgroundImage(placeholderHead, forState: .Normal)
        }
    }
}
