//
//  UserModel.m
//  1919sendImmediately
//
//  Created by kaka on 16/1/14.
//  Copyright © 2016年 kaka. All rights reserved.
//

#import "UserModel.h"

@implementation UserModel

+ (UserModel *)getUserModel {
    static dispatch_once_t once;
    static UserModel *userModel;
    dispatch_once(&once,^{
        userModel = [[self alloc]init];
        NSDictionary *dic = [userModel getUserModel];
        if (dic != nil) {
            [userModel setUserModel:dic];
        }
    });
    return userModel;
}

//保存用户信息
- (void)saveUserModel:(NSDictionary *)Dic
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:Dic forKey:@"UserModel"];
    [userDefaults synchronize];
}

//获取用户信息
- (NSDictionary *)getUserModel
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    return [userDefaults valueForKey:@"UserModel"];
}

//设置用户信息
- (void)setUserModel:(NSDictionary *)Dic
{
    _isLogin = YES;
    _appkey = @"123456";
//    _chmcu = @"90000032";
    _realName = [[Dic valueForKey:@"user"] valueForKey:@"realName"];
    _userName = [[Dic valueForKey:@"user"] valueForKey:@"userName"];
    _departId = [[Dic valueForKey:@"user"] valueForKey:@"departId"];
    _departName = [[Dic valueForKey:@"user"] valueForKey:@"departName"];
    _chmcu = _departId;
    _userCode = [self getOldUserName];
}

//保存上次用户的登录名
- (void)saveOldUserName:(NSString *)userName
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:userName forKey:@"oldUserName"];
    [userDefaults synchronize];
}

//获取上次用户的登录名
- (NSString *)getOldUserName
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    return [userDefaults valueForKey:@"oldUserName"];
}

@end
