//
//  MainViewController.swift
//  HappyHome
//
//  Created by kaka on 16/10/1.
//  Copyright © 2016年 kaka. All rights reserved.
//

import UIKit
import CXAlertView

class MainViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.initfaceView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func initfaceView()
    {
        PKRecordManage.sharedManager.start()
        
        self.view.backgroundColor = colorForBackground()
        
        let backImg = UIImageView()
        backImg.image = UIImage.init(named: "首页背景")
        self.view.addSubview(backImg)
        backImg.snp_makeConstraints { (make) -> Void in
            make.size.equalToSuperview()
        }
        
        let englishBtn = UIButton()
        englishBtn.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        englishBtn.setImage(UIImage.init(named: "homepage_eng"), forState: .Normal)
        self.view .addSubview(englishBtn)
        englishBtn.snp_makeConstraints { (make) -> Void in
            make.bottom.equalTo(self.view).offset(-65)
            make.centerX.equalToSuperview()
        }
        
        let chinaBtn = UIButton()
        chinaBtn.setImage(UIImage.init(named: "homepage_china"), forState: .Normal)

        self.view .addSubview(chinaBtn)
        chinaBtn.snp_makeConstraints { (make) -> Void in
            make.bottom.equalTo(englishBtn.snp_top).offset(-15)
            make.centerX.equalToSuperview()
        }
        chinaBtn.rac_signalForControlEvents(UIControlEvents.TouchUpInside).subscribeNext { _ in
            UserModel.sharedUserModel.selectLanguage = 1
            self.presentViewController(ControllerManager.sharedManager().rootViewController!, animated: true, completion: {
                
            })
        }
        englishBtn.rac_signalForControlEvents(UIControlEvents.TouchUpInside).subscribeNext { _ in
            UserModel.sharedUserModel.selectLanguage = 2
            self.presentViewController(ControllerManager.sharedManager().rootViewController!, animated: true, completion: {
                
            })
        }
    }

}
