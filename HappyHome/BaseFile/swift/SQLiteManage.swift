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
    
    private override init()
    {
        super.init()
        
        self.createTable()
    }
    
    // 文件路径
    let path = NSSearchPathForDirectoriesInDomains(
        .DocumentDirectory, .UserDomainMask, true
        ).first!
    
    // 数据库文件
    var db: Connection?
    
    // 获取链接（不存在文件，则自动创建）
    private func getConnection() ->Int
    {
        do{
            db =  try Connection("\(path)/HappyHomeDB.sqlite")
            
        }catch _{
            return 0;
//            ZCMBProgressHUD.showResultHUDWithResult(true, andText: "数据库建立错误!")
        }
        return 1;
    }
    
    // 创建表
    private func createTable()
    {
        print("\(path)")
        createTable_Record()
        createTable_PKRecord()
        createTable_User()
        createTable_EnglishTest()
    }
    
    // 创建 用户表
    private func createTable_User(){
        getConnection();
        let user = Table("user")
        let id = Expression<Int64>("id")
        let isLogin = Expression<Bool>("isLogin")
        let uid = Expression<Int?>("uid")
        let username = Expression<String?>("username")
        let nickname = Expression<String?>("nickname")
        let picture = Expression<String?>("picture")
        let englishTestNumber = Expression<Int?>("englishTestNumber")
        do
        {
            try db!.run(user.create(ifNotExists: true) { t in     // CREATE TABLE "record" (
                t.column(id, primaryKey: true) //     "id" INTEGER PRIMARY KEY NOT NULL,
                t.column(isLogin, unique: false)
                t.column(uid, unique: false)
                t.column(username, unique: false)
                t.column(nickname, unique: false)
                t.column(picture, unique: false)
                t.column(englishTestNumber, unique: false)
                })
            
        }catch _{
//            ZCMBProgressHUD.showResultHUDWithResult(true, andText: "数据库建立错误!")
        }
    }
    
    
    // 创建 英语测试
    private func createTable_EnglishTest(){
        getConnection();
        let englishTest = Table("englishTest")
        let id = Expression<Int64>("id")
        let lastPassTime = Expression<NSDate?>("lastPassTime")
        let lastTime = Expression<NSDate?>("lastTime")
        let englishTestNumber = Expression<Int?>("englishTestNumber")
        let lastTestid = Expression<Int?>("lastTestid")
        
        do
        {
            try db!.run(englishTest.create(ifNotExists: true) { t in     // CREATE TABLE "record" (
                t.column(id, primaryKey: true) //     "id" INTEGER PRIMARY KEY NOT NULL,
                t.column(lastPassTime, unique: false)
                t.column(lastTime, unique: false)
                t.column(englishTestNumber, unique: false)
                t.column(lastTestid, unique: false)
                })
            
        }catch _{
        }
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
    
    // 创建PK记录表
    private func createTable_PKRecord(){
        getConnection();
        let pk_record = Table("pk_record")
        let id = Expression<Int64>("id")
        let uid = Expression<Int?>("uid")
        let sid = Expression<Int?>("sid")
        let pid = Expression<Int?>("pid")
        let language = Expression<Int?>("language")
        let presentTime = Expression<NSTimeInterval?>("presentTime")
        let soundtime = Expression<NSTimeInterval?>("soundtime")
        let fileURL = Expression<String?>("fileURL")
        do
        {
            try db!.run(pk_record.create(ifNotExists: true) { t in     // CREATE TABLE "record" (
                t.column(id, primaryKey: true) //     "id" INTEGER PRIMARY KEY NOT NULL,
                t.column(uid, unique: false)
                t.column(sid, unique: false)
                t.column(pid, unique: false)
                t.column(language, unique: false)
                t.column(presentTime, unique: false)
                t.column(soundtime, unique: false)
                t.column(fileURL, unique: false)
                })
            
        }catch _{
            
        }
    }
    
    //新增练习录音
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
            _ = try db!.run(insert)
//            print(id)
            return true
        }
        catch _ as NSError{
//            print(error)
            return false
        }
    }
    
    //新增PK记录
    func insertPKRecord(model:PKRecordModel) ->PKRecordModel {
        let pk_record = Table("pk_record")
//        let id = Expression<Int64>("id")
        let uid = Expression<Int?>("uid")
        let sid = Expression<Int?>("sid")
        let pid = Expression<Int?>("pid")
        let language = Expression<Int?>("language")
        let presentTime = Expression<NSTimeInterval?>("presentTime")
        let soundtime = Expression<NSTimeInterval?>("soundtime")
        let fileURL = Expression<String?>("fileURL")
        
        let insert = pk_record.insert( uid <- model.uid, sid <- model.sid, pid <- model.pid,language <- model.language, presentTime <- model.presentTime,soundtime <- model.soundtime,fileURL <- model.fileURL)
        do
        {
            let id = try db!.run(insert)
            model.id = id
            return model
        }
        catch _ as NSError{
            return model
        }
    }
    
    //查询练习记录
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

    //查询PK记录
    func searchPKRecord() -> NSMutableArray{
        let pk_record = Table("pk_record")
        let id = Expression<Int64>("id")
        let uid = Expression<Int?>("uid")
        let sid = Expression<Int?>("sid")
        let pid = Expression<Int?>("pid")
        let language = Expression<Int?>("language")
        let presentTime = Expression<NSTimeInterval?>("presentTime")
        let soundtime = Expression<NSTimeInterval?>("soundtime")
        let fileURL = Expression<String?>("fileURL")
        
        let arr = NSMutableArray()
        do {
            for recordValue in try db!.prepare(pk_record) {
                let model = PKRecordModel()
                model.id = recordValue.get(id)
                model.uid = recordValue.get(uid)
                model.sid = recordValue.get(sid)
                model.pid = recordValue.get(pid)
                model.language = recordValue.get(language)
                model.presentTime = recordValue.get(presentTime)
                model.soundtime = recordValue.get(soundtime)
                model.fileURL = recordValue.get(fileURL)
                arr.addObject(model)
            }
            return arr
        }
        catch _{
            return arr
        }
    }

    //分页查询练习记录
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
    
    //删除所有练习记录
    func deleteALLRecord() {
        let record = Table("record")
        let delete = record.delete()
        do
        {
            _ = try db!.run(delete)
//            print(id)
//            return true
        }
        catch _ as NSError{
//            print(error)
//            return false
        }
    }
    
    //删除PK记录
    func deletePKRecord(rowid:Int64) {
        let pk_record = Table("pk_record")
        let id = Expression<Int64>("id")
        let alice = pk_record.filter(id == rowid)
        do
        {
            _ = try db!.run(alice.delete())
        }
        catch _ as NSError{
        }
    }
    
    //更新登陆的用户信息
    func updateUser(userModel:UserModel) {
        let user = Table("user")
        let id = Expression<Int64>("id")
        let isLogin = Expression<Bool>("isLogin")
        let uid = Expression<Int>("uid")
        let username = Expression<String?>("username")
        let nickname = Expression<String?>("nickname")
        let picture = Expression<String?>("picture")
        let englishTestNumber = Expression<Int>("englishTestNumber")
        
        do {
            var rowid:Int64?
            
            for recordValue in try db!.prepare(user) {
                rowid = recordValue.get(id)
                break
            }
            if rowid == nil {
                let insert = user.insert( isLogin <- userModel.isLogin,uid <- userModel.uid, username <- userModel.username, nickname <- userModel.nickname,picture <- userModel.picture, englishTestNumber <- userModel.englishTestNumber)
                try rowid = db!.run(insert)
            }
            else {
                let alice = user.filter(id == rowid!)
                try db!.run(alice.update(isLogin <- userModel.isLogin,uid <- userModel.uid, username <- userModel.username, nickname <- userModel.nickname,picture <- userModel.picture, englishTestNumber <- userModel.englishTestNumber))
            }
        }
        catch _{
        }
    }
    
    //获取登陆的用户信息
    func getUser() -> UserModel?{
        let user = Table("user")
        let isLogin = Expression<Bool>("isLogin")
        let uid = Expression<Int?>("uid")
        let username = Expression<String?>("username")
        let nickname = Expression<String?>("nickname")
        let picture = Expression<String?>("picture")
        let englishTestNumber = Expression<Int?>("englishTestNumber")
        

        do {
            for recordValue in try db!.prepare(user) {
                let model = UserModel.init()
                model.isLogin = recordValue.get(isLogin)
                model.uid = recordValue.get(uid)!
                model.username = recordValue.get(username)!
                model.nickname = recordValue.get(nickname)!
                model.picture = recordValue.get(picture)!
                model.englishTestNumber = recordValue.get(englishTestNumber)!
                
                return model
            }
            return nil
        }
        catch _{
            return nil
        }
    }
    
    
    //更新英语测试的信息
    func updateEnglishTest(englishTestManage:EnglishTestManage) {
        let englishTest = Table("englishTest")
        let id = Expression<Int64>("id")
        let lastPassTime = Expression<NSDate?>("lastPassTime")
        let lastTime = Expression<NSDate?>("lastTime")
        let englishTestNumber = Expression<Int?>("englishTestNumber")
        let lastTestid = Expression<Int?>("lastTestid")
        
        do {
            var rowid:Int64?
            
            for recordValue in try db!.prepare(englishTest) {
                rowid = recordValue.get(id)
                break
            }
            if rowid == nil {
                let insert = englishTest.insert( lastPassTime <- englishTestManage.lastPassTime,lastTime <- englishTestManage.lastTime, englishTestNumber <- englishTestManage.englishTestNumber ,lastTestid <- englishTestManage.lastTestid)
                try rowid = db!.run(insert)
            }
            else {
                let alice = englishTest.filter(id == rowid!)
                try db!.run(alice.update(lastPassTime <- englishTestManage.lastPassTime,lastTime <- englishTestManage.lastTime,  englishTestNumber <- englishTestManage.englishTestNumber ,lastTestid <- englishTestManage.lastTestid))
            }
        }
        catch _{
        }
    }
    
    //获取英语测试的信息
    func getEnglishTest() -> EnglishTestManage?{
        let englishTest = Table("englishTest")
        let lastPassTime = Expression<NSDate?>("lastPassTime")
        let lastTime = Expression<NSDate?>("lastTime")
        let englishTestNumber = Expression<Int?>("englishTestNumber")
        let lastTestid = Expression<Int?>("lastTestid")
        
        do {
            for recordValue in try db!.prepare(englishTest) {
                let model = EnglishTestManage.init()
                model.lastPassTime = recordValue.get(lastPassTime)
                model.lastTime = recordValue.get(lastTime)!
                model.englishTestNumber = recordValue.get(englishTestNumber)!
                model.lastTestid = recordValue.get(lastTestid)!
                return model
            }
            return nil
        }
        catch _{
            return nil
        }
    }
    
    
}

