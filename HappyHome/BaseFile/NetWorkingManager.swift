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
import SwiftyJSON

let HTTP_METHOD_GET   = "GET"
let HTTP_METHOD_POST  = "POST"

class NetWorkingManager: NSObject {
    
    static let sharedManager = NetWorkingManager()
    
    
    
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
                            if dic?.objectForKey("code") as! Int != 1 {
                                let error = NSError.init(domain: NSURLErrorDomain, code: NSURLErrorNetworkConnectionLost, userInfo: [NSLocalizedDescriptionKey:dic!.objectForKey("message")!])
                                completion(retObject: nil ,error: error)
                            }
                            else {
                                completion(retObject: dic ,error: nil)
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
                                if dic?.objectForKey("code") as! Int != 1 {
                                    let error = NSError.init(domain: NSURLErrorDomain, code: NSURLErrorNetworkConnectionLost, userInfo: [NSLocalizedDescriptionKey:dic!.objectForKey("message")!])
                                    completion(retObject: nil ,error: error)
                                }
                                else {
                                    completion(retObject: dic ,error: nil)
                                }
                                print("--------------------------------------------------\n返回结果%@\n%@\n--------------------------------------------------",pk_upload_List_url,dic)
                                
                            } catch {
                                let error = NSError.init(domain: NSURLErrorDomain, code: NSURLErrorNetworkConnectionLost, userInfo: [NSLocalizedDescriptionKey:"加载失败"])
                                completion(retObject: nil ,error: error)
                                print("--------------------------------------------------\n返回结果%@\n%@\n--------------------------------------------------",pk_upload_List_url,error)
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
    
    //上传录音
    func uploadPK(sid:Int,pid:Int,presentTime:NSTimeInterval,fileURL:NSURL,completion:(retObject: NSDictionary?, error: NSError?)->()) {
        let parameters:[String: AnyObject] = [
            "sid":String(sid),
            "pid":String(pid),
            "language":String(UserModel.sharedUserModel.selectLanguage),
            "uid":String(UserModel.sharedUserModel.uid),
            "presentTime":String(presentTime)
        ]
        self .UploadWithUrl(pk_upload_List_url, parameters: parameters, fileURL: fileURL, background: false) { (retObject, error) in
            completion(retObject: retObject,error: error)
        }
    }
    
}



