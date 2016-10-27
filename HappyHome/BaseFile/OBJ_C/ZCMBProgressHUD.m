//
//  ZCMBProgressHUD.m
//  ZhongChouPingTai
//
//  Created by kaka on 16/5/5.
//  Copyright © 2016年 HuaYiSoftware. All rights reserved.
//

#import "ZCMBProgressHUD.h"
static MBProgressHUD *mbProgressHUD;

@implementation ZCMBProgressHUD

//开始加载MBProgressHUD
+ (void)startMBProgressHUD
{
    if (mbProgressHUD == nil) {
        mbProgressHUD = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].delegate.window animated:YES];
    }
    else {
        mbProgressHUD.hidden = NO;
    }
}

//结束加载MBProgressHUD
+ (void)stopMBProgressHUD
{
    if (mbProgressHUD != nil) {
        [MBProgressHUD hideHUDForView:[UIApplication sharedApplication].delegate.window animated:YES];
        mbProgressHUD = nil;
    }
    
}

//开始加载MBProgressHUD
+ (void)startMBProgressHUD:(UIView *)view
{
    if (mbProgressHUD == nil) {
        mbProgressHUD = [MBProgressHUD showHUDAddedTo:view animated:YES];
    }
    else {
        mbProgressHUD.hidden = NO;
    }
}

//结束加载MBProgressHUD
+ (void)stopMBProgressHUD:(UIView *)view
{
    if (mbProgressHUD != nil) {
        [MBProgressHUD hideHUDForView:view animated:YES];
        mbProgressHUD = nil;
    }
}

+ (void)showResultHUDWithResult:(BOOL)result andText:(NSString *)text toView:(UIView *)view;
{
    MBProgressHUD *HUD = [[MBProgressHUD alloc] initWithView:view];
    [view addSubview:HUD];
    if (result) {
        HUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"success_icon.png"]];
        HUD.detailsLabel.text = text;
    }
    else {
        HUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"failed_icon.png"]];
        HUD.detailsLabel.text = text;
    }
    
    HUD.mode = MBProgressHUDModeCustomView;
    
    [HUD showAnimated:YES];
    [HUD hideAnimated:YES afterDelay:1];
}

+ (void)showResultHUDWithResult:(BOOL)result andText:(NSString *)text toView:(UIView *)view andSecond:(int)second completionBlock:(completionBlock)completion
{
    MBProgressHUD *HUD = [[MBProgressHUD alloc] initWithView:view];
    [view addSubview:HUD];
    if (result) {
        HUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"success_icon.png"]];
        HUD.detailsLabel.text = text;
    }
    else {
        HUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"failed_icon.png"]];
        HUD.detailsLabel.text = text;
    }
    HUD.mode = MBProgressHUDModeCustomView;
    [HUD showAnimated:YES whileExecutingBlock:^{
        sleep(second);
    } completionBlock:^{
        [HUD removeFromSuperview];
        completion();
    }];
}


@end
