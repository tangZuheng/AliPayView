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


//定义一个结构体，存储认证相关信息
//struct IdentityAndTrust {
//    var identityRef:SecIdentity
//    var trust:SecTrust
//    var certArray:AnyObject
//}

class NetWorkingManager: NSObject {
    
    static let sharedManager = NetWorkingManager()
    
    private override init() {
        
    }
    
//    //获取客户端证书相关信息
//    func extractIdentity() -> IdentityAndTrust {
//        var identityAndTrust:IdentityAndTrust!
//        var securityError:OSStatus = errSecSuccess
//        
//        let path: String = NSBundle.mainBundle().pathForResource("mykey", ofType: "p12")!
//        let PKCS12Data = NSData(contentsOfFile:path)!
//        let key : NSString = kSecImportExportPassphrase as NSString
//        let options : NSDictionary = [key : "123456"] //客户端证书密码
//        //create variable for holding security information
//        //var privateKeyRef: SecKeyRef? = nil
//        
//        var items : CFArray?
//        
//        securityError = SecPKCS12Import(PKCS12Data, options, &items)
//        
//        if securityError == errSecSuccess {
//            let certItems:CFArray = items as CFArray!;
//            let certItemsArray:Array = certItems as Array
//            let dict:AnyObject? = certItemsArray.first;
//            if let certEntry:Dictionary = dict as? Dictionary<String, AnyObject> {
//                // grab the identity
//                let identityPointer:AnyObject? = certEntry["identity"];
//                let secIdentityRef:SecIdentity = identityPointer as! SecIdentity!
//                print("\(identityPointer)  :::: \(secIdentityRef)")
//                // grab the trust
//                let trustPointer:AnyObject? = certEntry["trust"]
//                let trustRef:SecTrust = trustPointer as! SecTrust
//                print("\(trustPointer)  :::: \(trustRef)")
//                // grab the cert
//                let chainPointer:AnyObject? = certEntry["chain"]
//                identityAndTrust = IdentityAndTrust(identityRef: secIdentityRef,
//                                                    trust: trustRef, certArray:  chainPointer!)
//            }
//        }
//        return identityAndTrust;
//    }
//    
//    // AppDelegate.swift
//    func configureAlamofireManager() {
//        let manager = Manager.sharedInstance
//        manager.delegate.sessionDidReceiveChallenge = { session, challenge in
//            //认证服务器证书
//            if challenge.protectionSpace.authenticationMethod
//                == NSURLAuthenticationMethodServerTrust {
//                print("服务端证书认证！")
//                let serverTrust:SecTrust = challenge.protectionSpace.serverTrust!
//                let certificate = SecTrustGetCertificateAtIndex(serverTrust, 0)!
//                let remoteCertificateData
//                    = CFBridgingRetain(SecCertificateCopyData(certificate))!
//                let cerPath = NSBundle.mainBundle().pathForResource("tomcat", ofType: "cer")!
//                let cerUrl = NSURL(fileURLWithPath:cerPath)
//                let localCertificateData = try! NSData(contentsOfURL: cerUrl)
//                
//                if (remoteCertificateData.isEqual(localCertificateData) == true) {
//                    
//                    let credential = NSURLCredential(trust: serverTrust)
//                    challenge.sender?.useCredential(credential, forAuthenticationChallenge: challenge)
//                    return (NSURLSessionAuthChallengeDisposition.UseCredential,
//                            NSURLCredential(trust: challenge.protectionSpace.serverTrust!))
//                    
//                } else {
//                    return (NSURLSessionAuthChallengeDisposition.CancelAuthenticationChallenge, nil)
//                }
//            }
//            //认证客户端证书
//            else if challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodClientCertificate {
//                print("客户端证书认证！")
//                //获取客户端证书相关信息
//                let identityAndTrust:IdentityAndTrust = self.extractIdentity();
//                let urlCredential:NSURLCredential = NSURLCredential.init(identity: identityAndTrust.identityRef, certificates: identityAndTrust.certArray as? [AnyObject], persistence: .ForSession)
//                return (NSURLSessionAuthChallengeDisposition.UseCredential, urlCredential);
//            }
//            // 其它情况（不接受认证）
//            else {
//                print("其它情况（不接受认证）")
//                return (NSURLSessionAuthChallengeDisposition.CancelAuthenticationChallenge, nil)
//            }
//            
//        }
//    }

    
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
            "soundid": soundid,
            "uid": UserModel.sharedUserModel.uid
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
    
    //获取英语测试题
    func GetEnglishTest(testid:Int,completion:(retObject: NSDictionary?, error: NSError?)->()) {
        let parameters:[String: AnyObject]  = [
            "testid": testid
        ]
        self.HTTPWithUrl(HTTP_METHOD_GET, url: englishtest_url, parameters: parameters, background: false) { (retObject, error) in
            completion(retObject: retObject,error: error)
        }
    }
    
    //获取消息列表
    func GetMessageList(page:Int,completion:(retObject: NSDictionary?, error: NSError?)->()) {
        let parameters:[String: AnyObject]  = [
            "uid":UserModel.sharedUserModel.uid,
//            "uid":8,
            "page":page
        ]
        self.HTTPWithUrl(HTTP_METHOD_GET, url: smessage_url, parameters: parameters, background: false) { (retObject, error) in
            completion(retObject: retObject,error: error)
        }
    }
    
    //清空消息列表
    func CleanMessageList(completion:(retObject: NSDictionary?, error: NSError?)->()) {
        let parameters:[String: AnyObject]  = [
            "uid":UserModel.sharedUserModel.uid
        ]
        self.HTTPWithUrl(HTTP_METHOD_GET, url: smessage_clean_url, parameters: parameters, background: false) { (retObject, error) in
            completion(retObject: retObject,error: error)
        }
    }
    
    //提交建议
    func SubmitSuggest(content:String,completion:(retObject: NSDictionary?, error: NSError?)->()) {
        let parameters:[String: AnyObject]  = [
            "uid":UserModel.sharedUserModel.uid,
            "content":content
        ]
        self.HTTPWithUrl(HTTP_METHOD_GET, url: submitSuggest_url, parameters: parameters, background: false) { (retObject, error) in
            completion(retObject: retObject,error: error)
        }
    }
 
    //修改昵称
    func UpdateNickname(nickname:String,completion:(retObject: NSDictionary?, error: NSError?)->()) {
        let parameters:[String: AnyObject]  = [
            "uid":UserModel.sharedUserModel.uid,
            "nickname":nickname
        ]
        self.HTTPWithUrl(HTTP_METHOD_GET, url: login_updateNickname_url, parameters: parameters, background: false) { (retObject, error) in
            completion(retObject: retObject,error: error)
        }
    }
}



