//
//  NetWorkingManager.swift
//  1919sendImmediately_S
//
//  Created by kaka on 16/9/14.
//  Copyright © 2016年 kaka. All rights reserved.
//

import UIKit
import Alamofire
import ReactiveCocoa
import Result
//import SwiftyJSON

let HTTP_METHOD_GET   = "GET"
let HTTP_METHOD_POST  = "POST"

class NetWorkingManager: NSObject {
    
    static let sharedManager = NetWorkingManager()
    
    private override init() {
        
    }
    
    /*!
      @param method  请求方式
     *  @param url  接口URL
     *  @param parameters Http params
     *  @param background 是否是后台执行
      false 非后台执行 - 回调Block在主线程执行
      true 后台执行  - 回调Block在非主线程执行
     *  @param completion 回调Block
     */
    func HTTPWithUrl(method: String,url:URLStringConvertible,parameters:[String: AnyObject]?,background:Bool,completion:(retObject: NSDictionary?, error: NSError?)->()) {
        
        print("--------------------------------------------------\n发送参数%@\n%@\n--------------------------------------------------",url,parameters)
        if method == HTTP_METHOD_GET {
            Alamofire.request(.GET, url, parameters: parameters).responseData
                {
                    response in
                    if response.result.error != nil {
                        completion(retObject: nil,error: response.result.error!)
                        print("--------------------------------------------------\n出现错误%@\n%@\n--------------------------------------------------",url,response.result.error!)
                    }
                    else {
                        do {
                            let dic = try NSJSONSerialization.JSONObjectWithData(response.data!, options: .MutableLeaves) as? NSDictionary
                            if dic?.objectForKey("code") as! Int != 0 {
                                completion(retObject: dic ,error: nil)
                            }
                            else {
                                let error = NSError.init(domain: NSURLErrorDomain, code: NSURLErrorNetworkConnectionLost, userInfo: [NSLocalizedDescriptionKey:dic!.objectForKey("message")!])
                                completion(retObject: nil ,error: error)
                            }
                            print("--------------------------------------------------\n返回结果%@\n%@\n--------------------------------------------------",url,dic)

                        } catch {
                            let error = NSError.init(domain: NSURLErrorDomain, code: NSURLErrorNetworkConnectionLost, userInfo: [NSLocalizedDescriptionKey:"加载失败"])
                            completion(retObject: nil ,error: error)
                            print("--------------------------------------------------\n返回结果%@\n%@\n--------------------------------------------------",url,error)
                        }
                    }
            }
        }
        else {
            
        }
    }
    
    //上传文件
    func UploadWithUrl(url:URLStringConvertible,parameters:[String: AnyObject]?,fileURL:NSURL,background:Bool,completion:(retObject: NSDictionary?, error: NSError?)->()) {
        print("--------------------------------------------------\n发送参数%@\n%@\n--------------------------------------------------",url,parameters)
        Alamofire.upload(
            .POST,
            url,
            multipartFormData: { multipartFormData in
                multipartFormData.appendBodyPart(fileURL: fileURL, name: "Filedata")
                for (key, value) in parameters! {
                    multipartFormData.appendBodyPart(data: value.dataUsingEncoding(NSUTF8StringEncoding)!, name: key)
                }
            },
            encodingCompletion: { encodingResult in
                switch encodingResult {
                case .Success(let upload, _, _):
                    upload.responseJSON { response in
                        debugPrint(response)
                        if response.result.error != nil {
                            completion(retObject: nil,error: response.result.error!)
                            print("--------------------------------------------------\n出现错误%@\n%@\n--------------------------------------------------",pk_upload_List_url,response.result.error!)
                        }
                        else {
                            do {
                                let dic = try NSJSONSerialization.JSONObjectWithData(response.data!, options: .MutableLeaves) as? NSDictionary
                                if dic?.objectForKey("code") as! Int != 0 {
                                    completion(retObject: dic ,error: nil)
                                }
                                else {
                                    let error = NSError.init(domain: NSURLErrorDomain, code: NSURLErrorNetworkConnectionLost, userInfo: [NSLocalizedDescriptionKey:dic!.objectForKey("message")!])
                                    completion(retObject: nil ,error: error)
                                }
                                print("--------------------------------------------------\n返回结果%@\n%@\n--------------------------------------------------",pk_upload_List_url,dic)
                                
                            } catch {
                                let error = NSError.init(domain: NSURLErrorDomain, code: NSURLErrorNetworkConnectionLost, userInfo: [NSLocalizedDescriptionKey:"加载失败"])
                                completion(retObject: nil ,error: error)
                                print("--------------------------------------------------\n出现错误%@\n%@\n--------------------------------------------------",pk_upload_List_url,error)
                            }
                        }
                    }
                case .Failure(let encodingError):
                    print(encodingError)
                    let error = NSError.init(domain: NSURLErrorDomain, code: NSURLErrorNetworkConnectionLost, userInfo: [NSLocalizedDescriptionKey:"加载失败"])
                    completion(retObject: nil ,error: error)
                }
            }
        )

        
        
    }
    
    //获取分类列表
    func getIficationList(completion:(retObject: NSDictionary?, error: NSError?)->()) {
        self.HTTPWithUrl(HTTP_METHOD_GET, url: ification_List_url, parameters: nil, background: false) { (retObject, error) in
            completion(retObject: retObject,error: error)
        }
    }
    
    //获取景点列表
    func getScenceList(id:Int,completion:(retObject: NSDictionary?, error: NSError?)->()) {
        let parameters:[String: AnyObject] = [
            "id": id,
            "language":UserModel.sharedUserModel.selectLanguage,
            "row":120
        ]
        self.HTTPWithUrl(HTTP_METHOD_GET, url: scence_List_url, parameters: parameters, background: false) { (retObject, error) in
            completion(retObject: retObject,error: error)
        }
    }
    
    //获取讲解点列表
    func getScencePointList(sid:Int,completion:(retObject: NSDictionary?, error: NSError?)->()) {
        let parameters:[String: AnyObject] = [
            "sid": sid,
            "row":120
        ]
        self.HTTPWithUrl(HTTP_METHOD_GET, url: scencePoint_List_url, parameters: parameters, background: false) { (retObject, error) in
            completion(retObject: retObject,error: error)
        }
    }
    
    //分配讲解点
    func checkPK(sid:Int,completion:(retObject: NSDictionary?, error: NSError?)->()) {
        let parameters:[String: AnyObject]  = [
            "sid": sid,
            "language":UserModel.sharedUserModel.selectLanguage,
            "uid":UserModel.sharedUserModel.uid
        ]
        self.HTTPWithUrl(HTTP_METHOD_GET, url: pk_check_List_url, parameters: parameters, background: false) { (retObject, error) in
            completion(retObject: retObject,error: error)
        }
    }
    
//    //上传录音
//    func uploadPK(sid:Int,pid:Int,presentTime:NSTimeInterval,fileURL:NSURL,completion:(retObject: NSDictionary?, error: NSError?)->()) {
//        let parameters:[String: AnyObject] = [
//            "sid":String(sid),
//            "pid":String(pid),
//            "language":String(UserModel.sharedUserModel.selectLanguage),
//            "uid":String(UserModel.sharedUserModel.uid),
//            "presentTime":String(presentTime)
//        ]
//        self .UploadWithUrl(pk_upload_List_url, parameters: parameters, fileURL: fileURL, background: false) { (retObject, error) in
//            completion(retObject: retObject,error: error)
//        }
//    }
//    
//    //上传录音
//    func uploadPK(uid:Int,sid:Int,pid:Int,language:Int,presentTime:NSTimeInterval,soundtime:NSTimeInterval,fileURL:NSURL,completion:(retObject: NSDictionary?, error: NSError?)->()) {
//        let parameters:[String: AnyObject] = [
//            "sid":String(sid),
//            "pid":String(pid),
//            "language":String(language),
//            "uid":String(uid),
//            "presentTime":String(presentTime),
//            "soundtime":String(soundtime)
//        ]
//        self .UploadWithUrl(pk_upload_List_url, parameters: parameters, fileURL: fileURL, background: false) { (retObject, error) in
//            completion(retObject: retObject,error: error)
//        }
//    }
    
    //上传录音
    func uploadPK(model:PKRecordModel,completion:(retObject: NSDictionary?, error: NSError?)->()) {
        let parameters:[String: AnyObject] = [
            "sid":String(model.sid!),
            "pid":String(model.pid!),
            "language":String(model.language!),
            "uid":String(model.uid!),
            "presentTime":String(model.presentTime!),
            "soundtime":String(model.soundtime!)
        ]
//        let fileManager = NSFileManager.defaultManager()
//        let urls = fileManager.URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
//        let documentDirectory = urls[0] as NSURL
        
//        let fileURL = documentDirectory.URLByAppendingPathComponent(model.fileURL!)
        
        let fileManager = NSFileManager.defaultManager()
        let urls = fileManager.URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
        let documentDirectory = urls[0] as NSURL
        let fileURL = documentDirectory.URLByAppendingPathComponent(model.fileURL!)
        
        self .UploadWithUrl(pk_upload_List_url, parameters: parameters, fileURL: fileURL!, background: false) { (retObject, error) in
            completion(retObject: retObject,error: error)
        }
    }
    
    
    //评分分配录音
    func JudgeIndex(sid:Int,completion:(retObject: NSDictionary?, error: NSError?)->()) {
        let parameters:[String: AnyObject]  = [
            "sid": sid,
            "language":UserModel.sharedUserModel.selectLanguage,
            "uid":UserModel.sharedUserModel.uid
        ]
        self.HTTPWithUrl(HTTP_METHOD_GET, url: judge_index_url, parameters: parameters, background: false) { (retObject, error) in
            completion(retObject: retObject,error: error)
        }
    }
    
    //评分分配结果
    func JudgeResult(soundid:Int,pksoundid:Int, result:Int,completion:(retObject: NSDictionary?, error: NSError?)->()) {
        let parameters:[String: AnyObject]  = [
            "result": result,
            "soundid":soundid,
            "pksoundid":pksoundid,
            "uid":UserModel.sharedUserModel.uid
        ]
        self.HTTPWithUrl(HTTP_METHOD_GET, url: judge_result_url, parameters: parameters, background: false) { (retObject, error) in
            completion(retObject: retObject,error: error)
        }
    }
    
    //登录
    func Login(username:String,password:String,completion:(retObject: NSDictionary?, error: NSError?)->()) {
        let parameters:[String: AnyObject]  = [
            "username": username,
            "password":password,
        ]
        self.HTTPWithUrl(HTTP_METHOD_GET, url: login_url, parameters: parameters, background: false) { (retObject, error) in
            completion(retObject: retObject,error: error)
        }
    }
    
    //获取讲解点排行
    func getScencePointTopList(pid:Int,completion:(retObject: NSDictionary?, error: NSError?)->()) {
        let parameters:[String: AnyObject] = [
            "pid": pid,
            "language":UserModel.sharedUserModel.selectLanguage
        ]
        self.HTTPWithUrl(HTTP_METHOD_GET, url: scencePoint_top_url, parameters: parameters, background: false) { (retObject, error) in
            completion(retObject: retObject,error: error)
        }
    }
    
    //PK历史
    func getRecordList(completion:(retObject: NSDictionary?, error: NSError?)->()) {
        let parameters:[String: AnyObject] = [
            "uid": UserModel.sharedUserModel.uid,
            "language":UserModel.sharedUserModel.selectLanguage
        ]
        self.HTTPWithUrl(HTTP_METHOD_GET, url: pk_record_List_url, parameters: parameters, background: false) { (retObject, error) in
            completion(retObject: retObject,error: error)
        }
    }
    
    //昨日PK
    func getYesterdayPKList(completion:(retObject: NSDictionary?, error: NSError?)->()) {
        let parameters:[String: AnyObject] = [
            "uid": UserModel.sharedUserModel.uid,
            "language":UserModel.sharedUserModel.selectLanguage
        ]
        self.HTTPWithUrl(HTTP_METHOD_GET, url: pk_yesterday_List_url, parameters: parameters, background: false) { (retObject, error) in
            completion(retObject: retObject,error: error)
        }
    }
    //5星记录
    func getFiverecordList(completion:(retObject: NSDictionary?, error: NSError?)->()) {
        let parameters:[String: AnyObject] = [
            "uid": UserModel.sharedUserModel.uid,
            "language":UserModel.sharedUserModel.selectLanguage
        ]
        self.HTTPWithUrl(HTTP_METHOD_GET, url: pk_fiverecord_List_url, parameters: parameters, background: false) { (retObject, error) in
            completion(retObject: retObject,error: error)
        }
    }
    //my top5
    func getMytopList(completion:(retObject: NSDictionary?, error: NSError?)->()) {
        let parameters:[String: AnyObject] = [
            "uid": UserModel.sharedUserModel.uid,
            "language":UserModel.sharedUserModel.selectLanguage
        ]
        self.HTTPWithUrl(HTTP_METHOD_GET, url: pk_mytop_List_url, parameters: parameters, background: false) { (retObject, error) in
            completion(retObject: retObject,error: error)
        }
    }
    
    //发送验证码
    func registerSendCode(phonenumber:String,type:Int,completion:(retObject: NSDictionary?, error: NSError?)->()) {
        let parameters:[String: AnyObject] = [
            "phonenumber": phonenumber,
            "type":type
        ]
        self.HTTPWithUrl(HTTP_METHOD_GET, url: register_send_url, parameters: parameters, background: false) { (retObject, error) in
            completion(retObject: retObject,error: error)
        }
    }
    
    //注册
    func register(phonenumber:String,code:String,username:String,password:String,nickname:String,completion:(retObject: NSDictionary?, error: NSError?)->()) {
        let parameters:[String: AnyObject] = [
            "phonenumber": phonenumber,
            "code": code,
            "username": username,
            "password": password,
            "nickname": nickname
        ]
        self.HTTPWithUrl(HTTP_METHOD_GET, url: register_url, parameters: parameters, background: false) { (retObject, error) in
            completion(retObject: retObject,error: error)
        }
    }
    
    //上传头像
    func uploadHead(fileURL:NSURL,completion:(retObject: NSDictionary?, error: NSError?)->()) {
        let parameters:[String: AnyObject] = [
            "uid":String(UserModel.sharedUserModel.uid)
        ]
        self .UploadWithUrl(login_upheader_url, parameters: parameters, fileURL:  fileURL, background: false) { (retObject, error) in
            completion(retObject: retObject,error: error)
        }
    }
    
    //修改密码
    func updetePassword(oldpwd:String,newpwd:String,completion:(retObject: NSDictionary?, error: NSError?)->()) {
        let parameters:[String: AnyObject] = [
            "username":String(UserModel.sharedUserModel.username!),
            "oldpwd":oldpwd,
            "newpwd":newpwd
        ]
        self.HTTPWithUrl(HTTP_METHOD_GET, url: login_modify_url, parameters: parameters, background: false) { (retObject, error) in
            completion(retObject: retObject,error: error)
        }
    }
    
    //举报
    func JudgeReport(soundid:Int,pksoundid:Int, content:String,completion:(retObject: NSDictionary?, error: NSError?)->()) {
        let parameters:[String: AnyObject]  = [
            "content": content,
            "soundid":soundid,
            "pksoundid":pksoundid,
            "uid":UserModel.sharedUserModel.uid
        ]
        self.HTTPWithUrl(HTTP_METHOD_GET, url: report_url, parameters: parameters, background: false) { (retObject, error) in
            completion(retObject: retObject,error: error)
        }
    }
    
    //上述
    func JudgeReportAppeal(soundid:Int,completion:(retObject: NSDictionary?, error: NSError?)->()) {
        let parameters:[String: AnyObject]  = [
            "soundid": soundid
        ]
        self.HTTPWithUrl(HTTP_METHOD_GET, url: report_appeal_url, parameters: parameters, background: false) { (retObject, error) in
            completion(retObject: retObject,error: error)
        }
    }
    
    //忘记密码
    func LoginForgetPass(phonenumber:String,code:String,newpwd:String,completion:(retObject: NSDictionary?, error: NSError?)->()) {
        let parameters:[String: AnyObject]  = [
            "phonenumber": phonenumber,
            "code": code,
            "newpwd": newpwd
        ]
        self.HTTPWithUrl(HTTP_METHOD_GET, url: login_forget_url, parameters: parameters, background: false) { (retObject, error) in
            completion(retObject: retObject,error: error)
        }
    }
    
    
}



