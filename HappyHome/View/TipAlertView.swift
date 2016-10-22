//
//  TipAlertView.swift
//  HappyHome
//
//  Created by kaka on 16/10/21.
//  Copyright © 2016年 kaka. All rights reserved.
//

import UIKit
import CXAlertView

class TipAlertView: CXAlertView {
    
    var selectTitle:String! = ""
    private let btnArr = NSMutableArray()

    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    override init!(title: String!, contentView: UIView!, cancelButtonTitle: String!) {
        super.init(title: title, contentView: contentView, cancelButtonTitle: cancelButtonTitle)
        self.initfaceView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initfaceView(){
        self.viewBackgroundColor = UIColor.whiteColor()
        let view = UIView.init()
        view.frame = CGRectMake(0, 0, SCREEN_WIDTH, 140)
        
        let titleArr = NSArray.init(objects: "反党反社会","完全跑题","污蔑毁谤","庸俗色情")
        
        var top = 10.0
        for name in titleArr {
            let btn = UIButton.init()
            btn.setImage(UIImage.init(named: "select_no"), forState: .Normal)
            btn.setImage(UIImage.init(named: "select_yes"), forState: .Selected)
            btn.setTitle(name as? String, forState: .Normal)
            btn.setTitleColor(UIColor.init(rgb: 0x282828), forState: .Normal)
            btn.titleLabel?.font = UIFont.systemFontOfSize(14)
            
            btn.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0)
            btn.contentHorizontalAlignment = .Left
            view.addSubview(btn)
            btnArr.addObject(btn)
            btn.snp_makeConstraints { (make) in
                make.top.equalTo(top)
                make.left.equalTo(10)
                make.height.equalTo(20)
                make.width.equalTo(200)
            }
            btn.rac_signalForControlEvents(UIControlEvents.TouchUpInside).subscribeNext { _ in
                btn.selected = !btn.selected
                self.updateSelecestr()
            }
            top += 30
        }
        self.contentView = view
    }

    func updateSelecestr() {
        selectTitle = ""
        for button in btnArr {
            let btn = button as! UIButton
            if btn.selected {
                if selectTitle == "" {
                    selectTitle = (btn.titleLabel?.text)!
                }
                else {
                    selectTitle = selectTitle + ";" + (btn.titleLabel?.text)!
                }
                
            }
        }
    }
}
