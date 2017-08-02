//
//  EnglishTestManage.swift
//  HappyHome
//
//  Created by kaka on 16/11/12.
//  Copyright © 2016年 kaka. All rights reserved.
//

import UIKit

class EnglishTestManage: NSObject {
    var _englishTestNumber:Int! = 3
    var englishTestNumber:Int!                  //英语测试次数
    {
        get {
            if lastTime == nil {
                return 3
            }
            let dfmatter = NSDateFormatter()
            dfmatter.dateFormat="yyyy.MM.dd"
            let zone:NSTimeZone? = NSTimeZone(name: "Asia/Chongqing")
            dfmatter.timeZone = zone
            let lastTimeStr = dfmatter.stringFromDate(lastTime!)
            let todayStr = dfmatter.stringFromDate(NSDate())
            if lastTimeStr == todayStr {
                return _englishTestNumber
            }else {
                self._englishTestNumber = 3
                return _englishTestNumber
            }
        }
        set {
            self._englishTestNumber = newValue
        }
//        didSet{
//            self.savaEnglishTest()
//        }
    }
    var lastTime:NSDate?                        //上次测试时间
//    {
//        didSet{
//            self.savaEnglishTest()
//        }
//    }
    var lastPassTime:NSDate?                    //上次测试通过时间
//    {
//        didSet{
//            self.savaEnglishTest()
//        }
//    }
    var lastTestid:Int? = 0                     //上次测试的id
//    {
//        didSet{
//            self.savaEnglishTest()
//        }
//    }
    
    var isPass:Bool                             //是否通过测试
    {
        get {
            if lastPassTime == nil {
                return false
            }
            let dfmatter = NSDateFormatter()
            dfmatter.dateFormat="yyyy.MM.dd"
            let zone:NSTimeZone? = NSTimeZone(name: "Asia/Chongqing")
            dfmatter.timeZone = zone
            let lastPassTimeStr = dfmatter.stringFromDate(lastPassTime!)
            let todayStr = dfmatter.stringFromDate(NSDate())
            if lastPassTimeStr == todayStr {
                return true
            }
            return false
        }
        set {
            self.isPass = newValue
        }
    }
    
    class func shareSingle()->EnglishTestManage{
        struct Singleton{
            static var onceToken : dispatch_once_t = 0
            static var single:EnglishTestManage?
        }
        dispatch_once(&Singleton.onceToken,{
            Singleton.single = EnglishTestManage()
            Singleton.single!.getEnglishTest()
            }
        )
        return Singleton.single!
    }
    
    internal func savaEnglishTest(){
        SQLiteManage.sharedManager.updateEnglishTest(EnglishTestManage.shareSingle())
    }
    
    //加载应用后，从数据库获取状态
    func getEnglishTest() {
        let model = SQLiteManage.sharedManager.getEnglishTest()
        if model != nil {
            self.lastTime = (model?.lastTime)!
            self.lastPassTime = model?.lastPassTime
            self.englishTestNumber = model?.englishTestNumber
            self.lastTestid = model?.lastTestid
        }
        else {
            
        }
    }
    
}
