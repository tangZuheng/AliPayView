
//
//  url_swift.swift
//  1919sendImmediately
//
//  Created by kaka on 16/9/12.
//  Copyright © 2016年 kaka. All rights reserved.
//

import Foundation

let baseUrl = "http://112.74.27.239:8080/TravelApp/"
//let baseUrl = "http://192.168.1.4:8080/TravelApp/"


//分类列表接口
let ification_List_url = baseUrl + "classification/list"

//景点列表接口
let scence_List_url = baseUrl + "scence/list"

//讲解点列表接口
let scencePoint_List_url = baseUrl + "point/list"

//分配讲解点
let pk_check_List_url = baseUrl + "pk/check"

//上传录音
let pk_upload_List_url = baseUrl + "pk/upload"

//评分分配录音
let judge_index_url = baseUrl + "judge/index"

//评分结果
let judge_result_url = baseUrl + "judge/result"

//登录
let login_url = baseUrl + "login/submit"

//获取讲解点top5
let scencePoint_top_url = baseUrl + "top/rank"


//PK历史
let pk_record_List_url = baseUrl + "pk/record"

//昨日PK
let pk_yesterday_List_url = baseUrl + "pk/ypk"

//五星记录
let pk_fiverecord_List_url = baseUrl + "pk/fiverecord"

//我的top5
let pk_mytop_List_url = baseUrl + "pk/mytop"

//发送验证码
let register_send_url = baseUrl + "login/send"

//注册
let register_url = baseUrl + "login/register"

//上传头像
let login_upheader_url = baseUrl + "login/upheader"

//修改密码
let login_modify_url = baseUrl + "login/modify"

