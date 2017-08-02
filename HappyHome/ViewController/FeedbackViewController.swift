//
//  FeedbackViewController.swift
//  HappyHome
//
//  Created by kaka on 16/10/17.
//  Copyright © 2016年 kaka. All rights reserved.
//

import UIKit

class FeedbackViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.initfaceView()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.navigationController!.navigationBarHidden = false
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func initfaceView(){
        self.title = "意见反馈"
        
        let textView = UITextView.init()
        textView.backgroundColor = UIColor.whiteColor()
        textView.layer.masksToBounds = true
        textView.layer.cornerRadius = 2
        textView.layer.borderWidth = 0.5
        textView.layer.borderColor = UIColor.init(rgb: 0xe5e5e5).CGColor
        self.view.addSubview(textView)
        textView.snp_makeConstraints { (make) in
            make.top.equalTo(80)
            make.centerX.equalToSuperview()
            make.left.equalTo(10)
            make.height.equalTo(150)
        }
        
        let numberLabel = UILabel()
        numberLabel.text = "0/100"
        numberLabel.textAlignment = .Right
        numberLabel.font = UIFont.systemFontOfSize(12)
        numberLabel.textColor = UIColor.init(rgb: 0x000000)
        self.view.addSubview(numberLabel)
        numberLabel.snp_makeConstraints { (make) in
            make.height.equalTo(15)
            make.width.equalTo(80)
            make.bottom.equalTo(textView.snp_bottom).offset(-5)
            make.right.equalToSuperview().offset(-15)
        }
        
        
        let commitButton = UIButton()
        commitButton.setTitle("完成", forState: .Normal)
        commitButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        commitButton.backgroundColor = UIColor.init(rgb: 0xff3838)
        commitButton.titleLabel?.font = UIFont.systemFontOfSize(14)
        commitButton.layer.masksToBounds = true
        commitButton.layer.cornerRadius = 2
        self.view .addSubview(commitButton)
        commitButton.snp_makeConstraints { (make) in
            make.top.equalTo(textView.snp_bottom).offset(30)
            make.centerX.equalToSuperview()
            make.left.equalTo(10)
            make.height.equalTo(35)
        }
        
        textView.rac_textSignal().map { (object) -> AnyObject! in
            let str = object as! String
            return str.characters.count
            }.subscribeNext { (object) in
                let count = object as! Int
                if count >= 100 {
                    textView.editable = false
                }
                else {
                    textView.editable = true
                }
                numberLabel.text = String(object) + "/100"
        }
        
        commitButton.rac_signalForControlEvents(UIControlEvents.TouchUpInside).subscribeNext { _ in
            if textView.text?.characters.count == 0{
                self.showFailHUDWithText("亲，你还没有发表你的意见哦")
            }
            self.startMBProgressHUD()
            
            NetWorkingManager.sharedManager.SubmitSuggest(textView.text, completion: { (retObject, error) in
                self.stopMBProgressHUD()
                if error == nil {
                    ZCMBProgressHUD.showResultHUDWithResult(true, andText: "亲，我们已经收到你的意见，非常感谢你的反馈", toView: self.view, andSecond: 2, completionBlock: {
                        self.navigationController?.popViewControllerAnimated(true)
                    })
                }
                else {
                    self.showFailHUDWithText(error!.localizedDescription)
                }
            })
        }

    }
}
