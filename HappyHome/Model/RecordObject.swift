//
//  RecordObject.swift
//  HappyHome
//
//  Created by kaka on 16/10/6.
//  Copyright © 2016年 kaka. All rights reserved.
//

import UIKit

class RecordObject: NSObject {
    var recordUrl:NSURL?
    var img:String = ""
    var spotsName:String = ""
    var explainName:String = ""
    var updateTime:NSDate?
    var recordLength:NSTimeInterval?
    
    init(recordUrl:NSURL,img:String,spotsName:String,explainName:String,updateTime:NSDate,recordLength:NSTimeInterval) {
        self.recordUrl = recordUrl
        self.img = img
        self.spotsName = spotsName
        self.explainName = explainName
        self.updateTime = updateTime
        self.recordLength = recordLength
    }
    
}
