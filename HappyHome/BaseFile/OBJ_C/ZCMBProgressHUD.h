//
//  ZCMBProgressHUD.h
//  ZhongChouPingTai
//
//  Created by kaka on 16/5/5.
//  Copyright © 2016年 HuaYiSoftware. All rights reserved.
//

#import <MBProgressHUD/MBProgressHUD.h>

typedef void (^completionBlock)(void);

@interface ZCMBProgressHUD : MBProgressHUD

//开始加载MBProgressHUD
+ (void)startMBProgressHUD;

//结束加载MBProgressHUD
+ (void)stopMBProgressHUD;

//开始加载MBProgressHUD
+ (void)startMBProgressHUD:(UIView *)view;

//结束加载MBProgressHUD
+ (void)stopMBProgressHUD:(UIView *)view;

+ (void)showResultHUDWithResult:(BOOL)result andText:(NSString *)text toView:(UIView *)view;

+ (void)showResultHUDWithResult:(BOOL)result andText:(NSString *)text toView:(UIView *)view andSecond:(int)second completionBlock:(completionBlock)completion;


@end
