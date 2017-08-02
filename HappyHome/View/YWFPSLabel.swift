//
//  YWFPSLabel.swift
//  HappyHome
//
//  Created by kaka on 16/11/20.
//  Copyright © 2016年 kaka. All rights reserved.
//

import UIKit

class YWFPSLabel: UILabel {

    private lazy var disPlayLink = CADisplayLink()
    private lazy var count: NSInteger = 0
    private lazy var lastTime: NSTimeInterval = 0
    private var fpsColor: UIColor = UIColor.grayColor()
    
    override init(frame: CGRect) {
        var yFrame = frame
        if yFrame.origin.x == 0 && yFrame.origin.y == 0 {
            yFrame = CGRect(x: UIScreen.mainScreen().bounds.width/2 - (55/2), y: 15, width: 55, height: 20)
        }
        super.init(frame: yFrame)
        layer.cornerRadius = 5
        clipsToBounds = true
        textAlignment = .Center
//        isUserInteractionEnabled = false
        backgroundColor = UIColor.whiteColor()
        alpha = 0.7
        font = UIFont.systemFontOfSize(12)
        
        disPlayLink = CADisplayLink(target: self, selector: #selector(tick))
        disPlayLink.addToRunLoop(NSRunLoop.mainRunLoop(), forMode: NSRunLoopCommonModes)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    deinit {
        disPlayLink.invalidate()
    }
    
    override func sizeThatFits(size: CGSize) -> CGSize {
        return CGSize( width: 55, height: 20)
    }
    
    func tick(link: CADisplayLink) {
        if lastTime == 0 {
            lastTime = link.timestamp
            return
        }
        count += 1
        let delta: NSTimeInterval = link.timestamp - lastTime
        if delta < 1 {
            return
        }
        
        lastTime = link.timestamp
        let fps = Double(count) / delta
        let fpsText = Int(round(fps))
        count = 0
        
        let attrMStr = NSMutableAttributedString(attributedString: NSAttributedString(string: "\(fpsText) FPS" ))
        if fps > 55.0{
            fpsColor = UIColor.grayColor()
        } else if(fps >= 50.0 && fps <= 55.0) {
            fpsColor = UIColor.yellowColor()
        } else {
            fpsColor = UIColor.redColor()
        }
        
        attrMStr.setAttributes([NSForegroundColorAttributeName:fpsColor], range: NSMakeRange(0, attrMStr.length - 3))
        attrMStr.setAttributes([NSForegroundColorAttributeName:UIColor.blueColor()], range: NSMakeRange(attrMStr.length - 3, 3))
        self.attributedText = attrMStr
    }

}
