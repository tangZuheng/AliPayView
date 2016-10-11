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
    func HTTPWithUrl(method: String,url:URLStringConvertible,parameters:[String: AnyObject],background:Bool,completion:(retObject: JSON, error: NSError?)->()) {
        
        print("--------------------------------------------------\n发送参数%@\n%@\n--------------------------------------------------",url,parameters)
        if method == HTTP_METHOD_GET {
            Alamofire.request(.GET, url, parameters: parameters).responseData
                {
                    response in
//                    print(response.result.error) // HTTP URL response
//                    print(response.data)     // server data
//                    print(response.result)   // result of response serialization
                    
                    if response.result.error == nil {
                        completion(retObject: nil,error: response.result.error!)
                        print("--------------------------------------------------\n出现错误%@\n%@\n--------------------------------------------------",url,response.result.error!)
                    }
                    else {
                        let json = JSON(data: response.data!)
                        completion(retObject: json,error: nil)
                        print("--------------------------------------------------\n返回结果%@\n%@\n--------------------------------------------------",url,json)
                    }
            }
        }
        else {
            
        }
    }
    
    //获取分类列表
    func getIficationList(completion:(retObject: JSON, error: NSError?)->()) {
        self.HTTPWithUrl(HTTP_METHOD_GET, url: ification_List_url, parameters: nil, background: false) { (retObject, error) in
            completion(retObject: retObject,error: error)
        }
    }
    
    //获取景点列表
    func getScenceList(id:Int,completion:(retObject: JSON, error: NSError?)->()) {
        let parameters = [
            "id": id
        ]
        self.HTTPWithUrl(HTTP_METHOD_GET, url: scence_List_url, parameters: parameters, background: false) { (retObject, error) in
            completion(retObject: retObject,error: error)
        }
    }
    
    func upload() {
        let fileURL = NSBundle.mainBundle().URLForResource("07102016223331", withExtension: "caf")
        
        Alamofire.upload(.POST, "http://192.168.1.6:8080/TravelApp/upload/add", file: fileURL!)
            .progress { bytesWritten, totalBytesWritten, totalBytesExpectedToWrite in
                print(totalBytesWritten)
                
                // This closure is NOT called on the main queue for performance
                // reasons. To update your ui, dispatch to the main queue.
                dispatch_async(dispatch_get_main_queue()) {
                    print("Total bytes written on main queue: \(totalBytesWritten)")
                }
            }
            .responseJSON { response in
                debugPrint(response)
        }
    }
    
    func upload(fileURL:NSURL) {
//        headers:["Content-Type":"multipart/form-data"]
        Alamofire.upload(
            .POST,
            "http://192.168.1.6:8080/TravelApp/pk/upload",
            multipartFormData: { multipartFormData in
                multipartFormData.appendBodyPart(fileURL: fileURL, name: "Filedata")
//                multipartFormData.appendBodyPart(fileURL: fileURL2!, name: "file2")
            },
            encodingCompletion: { encodingResult in
                switch encodingResult {
                case .Success(let upload, _, _):
                    upload.responseJSON { response in
                        debugPrint(response)
                    }
                case .Failure(let encodingError):
                    print(encodingError)
                }
            }
        )
        
        
//        Alamofire.upload(.POST, "http://192.168.1.6:8080/TravelApp/pk/upload", file: fileURL  )
//            .progress { bytesWritten, totalBytesWritten, totalBytesExpectedToWrite in
//                print(totalBytesWritten)
//                
//                // This closure is NOT called on the main queue for performance
//                // reasons. To update your ui, dispatch to the main queue.
//                dispatch_async(dispatch_get_main_queue()) {
//                    print("Total bytes written on main queue: \(totalBytesWritten)")
//                }
//            }
//            .responseJSON { response in
//                debugPrint(response)
//        }
    }
    
}



