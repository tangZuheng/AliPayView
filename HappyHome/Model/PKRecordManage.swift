//
//  PKRecordManage.swift
//  HappyHome
//
//  Created by kaka on 16/10/13.
//  Copyright © 2016年 kaka. All rights reserved.
//

import UIKit
import HandyJSON

class PKRecordModel: HandyJSON {
    //存储PK记录
    var id:Int64?                       //数据库主键
    var uid:Int?                        //用户ID
    var sid:Int?                        //景点ID
    var pid:Int?                        //讲解点点ID
    var language:Int?                   //语言，1为中文，0为英语
    var presentTime:NSTimeInterval?     //分配讲解点时间
    var soundtime:NSTimeInterval?       //录音时长
    var fileURL:String?                 //文件地址
    
    required init() {}
    
    init(uid:Int,sid:Int,pid:Int,language:Int,presentTime:NSTimeInterval,soundtime:NSTimeInterval,fileURL:String) {
        self.uid = uid
        self.sid = sid
        self.pid = pid
        self.language = language
        self.presentTime = presentTime
        self.soundtime = soundtime
        self.fileURL = fileURL
    }
}


class PKRecordManage: NSObject {
    
    static let sharedManager = PKRecordManage()
    
    let globalQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
    
    var pk_record_arr:NSMutableArray = NSMutableArray()
    
    var isUplode:Bool! = false
    
    private override init() {
        
    }
    
    func start() {
        pk_record_arr = SQLiteManage.sharedManager.searchPKRecord()
        self.uplode()
    }
    
    func uplode() {
        if isUplode != true && pk_record_arr.count > 0{
            let model = pk_record_arr.firstObject as! PKRecordModel
            dispatch_async(globalQueue, {
                self.isUplode = true
                NetWorkingManager.sharedManager.uploadPK(model, completion: { (retObject, error) in
                    if error == nil {
                        SQLiteManage.sharedManager.deletePKRecord(model.id!)
                        self.pk_record_arr.removeObject(model)
                        let fileManager = NSFileManager.defaultManager()
                        let urls = fileManager.URLsForDirectory(.DocumentDirectory, inDomains:.UserDomainMask)
                        let documentDirectory = urls[0] as NSURL
                        let recordUrlVal = documentDirectory.URLByAppendingPathComponent(model.fileURL!)
                        do {
                            try fileManager.removeItemAtURL(recordUrlVal!)
                        }
                        catch _{
                        }
                    }
                    else {
                        self.pk_record_arr.removeObject(model)
                        self.pk_record_arr.addObject(model)
                    }
                    self.isUplode = false
                    self.uplode()
                })
            })
        }
    }
    
    func insertDataSql(model:PKRecordModel) {
        let newModel = SQLiteManage.sharedManager.insertPKRecord(model)
        pk_record_arr.addObject(newModel)
        self.uplode()
    }
}
