//
//  DistrictModel.swift
//  HappyHome
//
//  Created by kaka on 16/10/10.
//  Copyright © 2016年 kaka. All rights reserved.
//

import UIKit
import HandyJSON

class DistrictModel: HandyJSON {
    //分类
    var id:Int?
    var name:String?
    
    required init() {}
}

class ScenceModel: HandyJSON {
    //景点
    var id:Int?                 //分类ID
    var sid:Int?                //ID
    var sname:String?           //名称
    var senglishname:String?    //英文名称
    var spicture:String?        //图片
    
    required init() {}
}

class ScencePointModel: HandyJSON {
    //讲解点
    var sid:Int?                //景点ID
    var pid:Int?                //ID
    var pname:String?            //名称
    var penglishname:String?    //英文名称
    var picture:String?         //图片
    
    required init() {}
}
