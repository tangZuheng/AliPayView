//
//  SQLiteManage.swift
//  HappyHome
//
//  Created by kaka on 16/10/5.
//  Copyright © 2016年 kaka. All rights reserved.
//

import UIKit
import SQLite

class SQLiteManage: NSObject {
    
    static let sharedManager = SQLiteManage()
    
    override init()
    {
        super.init()
        
        self.createTable()
    }
    
    // 文件路径
    let path = NSSearchPathForDirectoriesInDomains(
        .DocumentDirectory, .UserDomainMask, true
        ).first!
    
    // 数据库文件
    var db: Connection? ;
    
    // 获取链接（不存在文件，则自动创建）
    private func getConnection() ->Int
    {
        do{
            db =  try Connection("\(path)/HappyHomeDB.sqlite")
            
        }catch _{
            return 0;
        }
        return 1;
    }
    
    // 创建表
    private func createTable()
    {
        print("\(path)")
        
        createTable_Record()
    }
    
    // 创建 练习录音表
    private func createTable_Record(){
        getConnection();
        let record = Table("record")
        let id = Expression<Int64>("id")
        let recordUrl = Expression<String?>("recordUrl")
        let img = Expression<String?>("img")
        let spotsName = Expression<String?>("spotsName")
        let explainName = Expression<String?>("explainName")
        let recordLength = Expression<NSTimeInterval?>("recordLength")
        let updateTime = Expression<NSDate?>("time")
        do
        {
            try db!.run(record.create(ifNotExists: true) { t in     // CREATE TABLE "record" (
                t.column(id, primaryKey: true) //     "id" INTEGER PRIMARY KEY NOT NULL,
                t.column(recordUrl, unique: false)
                t.column(img, unique: false)
                t.column(spotsName, unique: false)
                t.column(explainName, unique: false)
                t.column(recordLength, unique: false)
                t.column(updateTime, unique: false)
                })
            
        }catch _{
            
        }
    }
    
    
    func insertRecord(recordUrlVal:String,imgVal:String,spotsNameVal:String,explainNameVal:String,recordLengthVal:NSTimeInterval) -> Bool {
        let record = Table("record")
        let recordUrl = Expression<String?>("recordUrl")
        let img = Expression<String?>("img")
        let spotsName = Expression<String?>("spotsName")
        let explainName = Expression<String?>("explainName")
        let recordLength = Expression<NSTimeInterval?>("recordLength")
        let updateTime = Expression<NSDate?>("time")
        
        let now = NSDate()
        let insert = record.insert( recordUrl <- recordUrlVal, img <- imgVal, spotsName <- spotsNameVal,explainName <- explainNameVal, recordLength <- recordLengthVal,updateTime <- now)
        do
        {
            let id = try db!.run(insert)
//            print(id)
            return true
        }
        catch let error as NSError{
//            print(error)
            return false
        }
    }
    func searchRecord() -> NSArray{
        let record = Table("record")
        let recordUrl = Expression<String?>("recordUrl")
        let img = Expression<String?>("img")
        let spotsName = Expression<String?>("spotsName")
        let explainName = Expression<String?>("explainName")
        let recordLength = Expression<NSTimeInterval?>("recordLength")
        let updateTime = Expression<NSDate?>("time")
        let arr = NSMutableArray()
        
        let fileManager = NSFileManager.defaultManager()
        let urls = fileManager.URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
        let documentDirectory = urls[0] as NSURL
        do {
            for recordValue in try db!.prepare(record) {
//                print(recordValue)
                let recordUrlVal = documentDirectory.URLByAppendingPathComponent(recordValue.get(recordUrl)!)
                let model = RecordObject.init(recordUrl: recordUrlVal!, img: recordValue.get(img)!, spotsName: recordValue.get(spotsName)!, explainName: recordValue.get(explainName)!, updateTime: recordValue.get(updateTime)!,recordLength: recordValue.get(recordLength)!)
                arr.addObject(model)
            }
            return arr
        }
        catch _{
            return arr
        }
    }
    
    func searchRecord(page:Int,pageSize:Int) {
        do {
            let sqlStr = "SELECT * FROM record limit " + String(pageSize) + " offset " + String(pageSize*(page-1))
            for _ in try db!.prepare(sqlStr) {
//                print(row)

            }
        }
        catch _{
            
        }
        
    }
    func deleteALLRecord() {
        let record = Table("record")
        let delete = record.delete()
        do
        {
            let id = try db!.run(delete)
//            print(id)
//            return true
        }
        catch let error as NSError{
//            print(error)
//            return false
        }
    }
}

