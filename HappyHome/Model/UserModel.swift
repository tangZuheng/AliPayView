//
//  UserModel.swift
//  HappyHome
//
//  Created by kaka on 16/10/12.
//  Copyright © 2016年 kaka. All rights reserved.
//

import UIKit

class UserModel: NSObject {
    
    static let sharedUserModel = UserModel()
    
    var selectLanguage:Int! //1为中文,2为英语
    
    var uid:Int! = 1           //用户id
    
    
}
