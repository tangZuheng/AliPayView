//
//  JudgeDetailViewController.swift
//  HappyHome
//
//  Created by kaka on 16/10/9.
//  Copyright © 2016年 kaka. All rights reserved.
//

import UIKit

class JudgeDetailViewController: BaseViewController {

    var img:UIImageView?
    var name:UILabel?
    
    var leftProgressView: CircleProgressView!
    var rightProgressView: CircleProgressView!
    
    let leftWinButton = UIButton()
    let centerWinButton = UIButton()
    let rightWinButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initfaceView()
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
        self.title = "测试"
        
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
        name?.text = "测试"
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
//            make.centerY.equalTo(leftProgressView)
        }
        
        leftProgressView = CircleProgressView()
        leftProgressView.backgroundColor = UIColor.clearColor()
        leftProgressView.trackWidth = 4
        leftProgressView.trackBackgroundColor = UIColor.init(rgb: 0x666666)
        leftProgressView.trackFillColor = UIColor.init(rgb: 0xe7e7e7)
//        leftProgressView.centerFillColor = UIColor.init(rgb: 0x232323)
        leftProgressView.centerImage = UIImage.init(named: "user_head")
        leftProgressView.progress = 0.4
        bottomView.addSubview(leftProgressView)
        leftProgressView.snp_makeConstraints { (make) in
            make.width.height.equalTo(75*SCREEN_SCALE)
            make.centerY.equalTo(vsImg).offset(5)
//            make.right.equalTo(vsImg.snp_left).offset(-10)
            make.left.equalTo(20)
        }
        
        let leftPlayButton = UIButton()
        leftPlayButton.setBackgroundImage(UIImage.init(named: "Judge_play"), forState: .Normal)
        leftProgressView.addSubview(leftPlayButton)
        leftPlayButton.snp_makeConstraints { (make) in
            make.edges.equalTo(leftProgressView).inset(UIEdgeInsetsMake(4, 4, 4, 4))
        }
        
        let leftTipButton = UIButton()
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
        //        leftProgressView.centerFillColor = UIColor.init(rgb: 0x232323)
        rightProgressView.centerImage = UIImage.init(named: "user_head")
        rightProgressView.progress = 0.4
        bottomView.addSubview(rightProgressView)
        rightProgressView.snp_makeConstraints { (make) in
            make.width.height.equalTo(75*SCREEN_SCALE)
            make.centerY.equalTo(vsImg).offset(5)
            make.right.equalTo(-20)
//            make.left.equalTo(vsImg.snp_right).offset(10)
        }
        
        let rightPlayButton = UIButton()
        rightPlayButton.setBackgroundImage(UIImage.init(named: "Judge_play"), forState: .Normal)
        rightProgressView.addSubview(rightPlayButton)
        rightPlayButton.snp_makeConstraints { (make) in
            make.edges.equalTo(rightProgressView).inset(UIEdgeInsetsMake(4, 4, 4, 4))
        }
        
        let rightTipButton = UIButton()
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
        
        let commitButton = UIButton()
        commitButton.setTitle("确定", forState: .Normal)
        commitButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        commitButton.titleLabel?.font = UIFont.systemFontOfSize(16)
        commitButton.backgroundColor = UIColor.init(rgb: 0xff3838)
        bottomView.addSubview(commitButton)
        commitButton.snp_makeConstraints { (make) in
            make.width.equalToSuperview()
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview()
            make.height.equalTo(40)
        }

    }
    
    //所有事件
    func initControlEvent(){
        leftWinButton.rac_signalForControlEvents(UIControlEvents.TouchUpInside).subscribeNext { _ in
            if !self.leftWinButton.selected
            {
                self.leftWinButton.selected = true
                self.centerWinButton.selected = false
                self.rightWinButton.selected = false
            }
        }
        
        centerWinButton.rac_signalForControlEvents(UIControlEvents.TouchUpInside).subscribeNext { _ in
            if !self.centerWinButton.selected
            {
                self.leftWinButton.selected = false
                self.centerWinButton.selected = true
                self.rightWinButton.selected = false
            }
        }
        
        rightWinButton.rac_signalForControlEvents(UIControlEvents.TouchUpInside).subscribeNext { _ in
            if !self.rightWinButton.selected
            {
                self.leftWinButton.selected = false
                self.centerWinButton.selected = false
                self.rightWinButton.selected = true
            }
        }
        
    }
}
