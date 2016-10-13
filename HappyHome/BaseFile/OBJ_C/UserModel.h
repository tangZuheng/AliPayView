//
//  UserModel.h
//  1919sendImmediately
//
//  Created by kaka on 16/1/14.
//  Copyright © 2016年 kaka. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserModel2 : NSObject

@property (nonatomic) BOOL isLogin;

@property (nonatomic,strong) NSString *appkey;

@property (nonatomic,strong) NSString *chmcu;

@property (nonatomic,strong) NSString *realName;//用户真实姓名

@property (nonatomic,strong) NSString *userName;//登陆工号

@property (nonatomic,strong) NSString *departId;//登陆人部门code

@property (nonatomic,strong) NSString *departName;//登陆人所在部门名称

@property (nonatomic,strong) NSString *userCode;


+ (UserModel2 *)getUserModel;
//保存用户信息
- (void)saveUserModel:(NSDictionary *)Dic;
//设置用户信息
- (void)setUserModel:(NSDictionary *)Dic;

//保存上次用户的登录名
- (void)saveOldUserName:(NSString *)userName;
//获取上次用户的登录名
- (NSString *)getOldUserName;

@end
