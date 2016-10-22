//
//  UserModel.swift
//  HappyHome
//
//  Created by kaka on 16/10/12.
//  Copyright © 2016年 kaka. All rights reserved.
//

import UIKit
import HandyJSON

class UserModel: HandyJSON {
    
    static var sharedUserModel:UserModel {
        get {
            return UserModel.shareSingle()
        }
    }
    
    class private func shareSingle()->UserModel{
        struct Singleton{
            static var onceToken : dispatch_once_t = 0
            static var single:UserModel?
        }
        dispatch_once(&Singleton.onceToken,{
            Singleton.single=UserModel()
            Singleton.single!.getSQLUserModel()
            }
        )
        return Singleton.single!
    }
    
    var selectLanguage:Int!                     //1为中文,2为英语
    
    var englishTestNumber:Int! = 0              //英语测试次数
    
    var isLogin:Bool = false                    //是否登录
    
    var uid:Int! = 2                            //用户id
    
    var username:String?                        //用户名
    
    var nickname:String?                        //用户昵称
    
    var picture:String?                        //用户头像
    
    
    required init() {}
    
    internal func savaUserModel(){
        SQLiteManage.sharedManager.updateUser(UserModel.sharedUserModel)
    }
    
    //加载应用后，从数据库获取状态
    func getSQLUserModel() {
        let model = SQLiteManage.sharedManager.getUser()
        if model != nil {
            self.isLogin = (model?.isLogin)!
            self.uid = model?.uid
            self.username = model?.username
            self.nickname = model?.nickname
            self.picture = model?.picture
            self.englishTestNumber = model?.englishTestNumber
        }
    }
    
    func setUserModel(dic:NSDictionary?){
        if dic != nil {
            self.isLogin = true
            self.uid = dic?.valueForKey("uid") as! Int
            self.username = dic?.valueForKey("username") as? String
            self.nickname = dic?.valueForKey("nickname") as? String
            self.picture = dic?.valueForKey("picture") as? String
        }
    }
    
    func setUserModel(object:AnyObject?){
        let dic = object as! Dictionary<String,AnyObject>
        let model = JSONDeserializer<UserModel>.deserializeFrom(dic)
        if model != nil {
            self.isLogin = true
            self.uid = model?.uid
            self.username = model?.username
            self.nickname = model?.nickname
            self.picture = model?.picture
        }
        
    }
}
