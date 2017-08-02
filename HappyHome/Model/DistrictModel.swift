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
    var picture:String?=""        //图片
    
    required init() {}
}

class ScencePointModel: HandyJSON {
    //讲解点
    var sid:Int?                //景点ID
    var pid:Int?                //ID
    var pname:String?            //名称
    var penglishname:String?    //英文名称
    var ppicture:String?=""         //图片
    
    required init() {}
}

class SoundModel: HandyJSON {
    //录音
    var soundid:Int?                //ID
    var sid:Int?                    //景点ID
    var pid:Int?                    //景点ID
    var uid:Int?                    //用户ID
    var pksounid:Int?                //对手ID
    var soundname:String?            //录音播放地址
    var soundtime:NSTimeInterval?    //录音时长
    
    var userheader:String?=""        //头像
    
    required init() {}
}

class ScencePointTopModel: HandyJSON {
    //讲解点排行榜
    var rank:Int?                       //排名
    var nickname:String?                //昵称
    var header:String?                  //头像
    var soundname:String?               //录音播放地址
    var soundtime:NSTimeInterval?       //录音时长
    
    required init() {}
}

class PKHistoryModel: HandyJSON {
    //PK历史
    var sname:String?                   //景点名称
    var senglishname:String?            //景点英文名称
    var picture:String?=""              //图片
    var pktime:NSTimeInterval?          //pk时间
    var day:Int?                        //5星记录累计时间
    var level:Int?                      //等级
    
    required init() {}
}

class YesterdayPKModel: HandyJSON {
    //昨日PK
    var soundid:Int?
    var pksoundid:Int?
    var sname:String?                   //景点名称
    var senglishname:String?            //景点英文名称
    var pname:String?                   //讲解点名称
    var penglishname:String?            //讲解点英文名称
    var ppicture:String?=""             //图片
    var pktime:NSTimeInterval?          //pk时间
    var pkresult:Int?                    //PK结果(1是评委打分胜，2是无pk对手胜，3是对手被举报胜，4为无评委双方胜，10为平手，11为输)',
    var header:String?=""               //头像
    var pkheader:String?=""             //对手头像
    var nickname:String?=""             //昵称
    var pknickname:String?=""           //对手昵称
    var soundname:String?=""            //录音地址
    var pksoundname:String?=""          //对手录音地址
    var soundtime:NSTimeInterval?       //录音时长
    var pksoundtime:NSTimeInterval?      //对手录音时长
    
    required init() {}
}

class MyTopModel: HandyJSON {
    //我的TOP5
    var pid:Int?                        //讲解点ID
    var sname:String?                   //景点名称
    var senglishname:String?            //景点英文名称
    var pname:String?                   //讲解点名称
    var penglishname:String?            //讲解点英文名称
    var ppicture:String?=""             //图片
    var pktime:NSTimeInterval?          //pk时间
    var toplevel:Int?                   //排名
    var soundtime:NSTimeInterval?       //录音时长
    
    required init() {}
}

class FiverecordModel: HandyJSON {
    //我的TOP5
    var sname:String?                   //景点名称
    var senglishname:String?            //景点英文名称
    var picture:String?=""              //图片
    var pktime:NSTimeInterval?          //pk时间
    var day:Int?                        //5星记录累计时间
    
    required init() {}
}


class MessageModel: HandyJSON {
    //我的消息
    var smid:Int?                       //id
    var title:String?                   //标题
    var smcontent:String?=""            //内容
    var submittime:NSTimeInterval?      //时间
    
    required init() {}
}

class EnglishTestModel: HandyJSON {
    //我的消息
    var testid:Int?                     //id
    var tureanswer:Int?                 //正确答案序号
    var questionurl:String?             //听力地址
    var answers:NSArray?                //答案列表
    
    required init() {}
}
