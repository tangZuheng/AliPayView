//
//  CountdownView.swift
//  HappyHome
//
//  Created by kaka on 16/10/5.
//  Copyright © 2016年 kaka. All rights reserved.
//

import UIKit
import LTMorphingLabel

typealias CountdownViewStopBlock = (UIView:CountdownView)->Void

class CountdownView: UIView {
    
    var time:Int!
    var timer:NSTimer!
    let timeLabel = LTMorphingLabel()
    
    var stopBlock:CountdownViewStopBlock?

    func show(time:Int, andBlock:CountdownViewStopBlock) -> Void {
        self.time = time
        self.stopBlock = andBlock
        
        UIApplication.sharedApplication().delegate!.window!!.addSubview(self)
        UIView.animateWithDuration(0.25, animations: {
            self.initfaceView()
            }) { (finished) in
                if finished {
                    // 启用计时器，控制每秒执行一次tickDown方法
                    self.timer = NSTimer.scheduledTimerWithTimeInterval(1,target:self,selector:#selector(CountdownView.tickDown),userInfo:nil,repeats:true)
                }
                
        }
    }
    
    func stop() -> Void {
        UIView.animateWithDuration(0.25, animations: {
//            self.initfaceView()
        }) { (finished) in
            if finished {
                self.removeFromSuperview()
                self.stopBlock!(UIView: self)
            }
            
        }
    }
    
    func initfaceView() {
        self.backgroundColor = UIColor.clearColor()
        self.snp_makeConstraints { (make) in
            make.size.equalToSuperview()
            make.center.equalToSuperview()
        }
        
        let back = UIView.init()
//        back.frame = self.frame
        back.backgroundColor = UIColor.blackColor()
        back.alpha = 0.6
        self.addSubview(back)
        back.snp_makeConstraints { (make) in
            make.size.equalToSuperview()
            make.center.equalToSuperview()
        }
        
        timeLabel.text = String(time)
        timeLabel.font = UIFont.systemFontOfSize(60)
        timeLabel.textAlignment = .Center
        timeLabel.textColor = UIColor.whiteColor()
        timeLabel.morphingEffect = .Anvil
        self.addSubview(timeLabel)
        
        timeLabel.snp_makeConstraints { (make) in
            make.size.equalToSuperview()
            make.center.equalToSuperview()
        }
    }
    
    /**
     *计时器每秒触发事件
     **/
    func tickDown()
    {
        time = time!-1
        if time == 0 {
            timeLabel.text = "开始"
        }
        else if time < 0 {
            self.timer.invalidate()
            self.stop()
        }
        else {
            timeLabel.text = String(time)
        }
    }

}
