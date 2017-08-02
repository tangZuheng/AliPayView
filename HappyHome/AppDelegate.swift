//
//  AppDelegate.swift
//  HappyHome
//
//  Created by kaka on 16/9/29.
//  Copyright © 2016年 kaka. All rights reserved.
//

import UIKit
import SDWebImage

@UIApplicationMain

class AppDelegate: UIResponder, UIApplicationDelegate,JPUSHRegisterDelegate {

    var window: UIWindow?
    var rootVc: UINavigationController?


    func applicationDidFinishLaunching(application: UIApplication) {
        
    }
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject : AnyObject]?) -> Bool {
        self.window = UIWindow()
        self.window?.frame = UIScreen.mainScreen().bounds
        self.window?.backgroundColor = UIColor.whiteColor()
        //        self.window?.rootViewController = MainViewController()
        
        let main = MainViewController()
        let nav = UINavigationController.init(rootViewController: main)
        nav.navigationBarHidden = true
        self.window?.rootViewController = nav
        //        self.window.rootViewController = nav
        self.window?.makeKeyAndVisible()
        
        UMAnalyticsConfig.sharedInstance().appKey = "58160d924544cb7fc4002497"
        UMAnalyticsConfig.sharedInstance().channelId = "test"
        
        MobClick.startWithConfigure(UMAnalyticsConfig.sharedInstance())
        MobClick.setLogEnabled(true)
        
        self .registerJPush()
//        NetWorkingManager.sharedManager.configureAlamofireManager()

        return true
    }

    func applicationWillResignActive( application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
        
        ZHAudioPlayer.sharedInstance().stopAudio()
//        NSNotificationCenter.defaultCenter().postNotificationName(AVAudioSessionInterruptionNotification, object: AVAudioSession.sharedInstance())
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate( application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
        //注册 DeviceToken
        JPUSHService.registerDeviceToken(deviceToken)
        if UserModel.sharedUserModel.isLogin {
            JPUSHService.setAlias(String(UserModel.sharedUserModel.uid!), callbackSelector: nil, object: nil)
        }
    }
    
    @available(iOS 10.0, *)
    func jpushNotificationCenter(center: UNUserNotificationCenter!, willPresentNotification notification: UNNotification!, withCompletionHandler completionHandler: ((Int) -> Void)!) {
        // Required
        
        
        let userInfo = notification.request.content.userInfo
        
        let alert = userInfo["aps"]!["alert"] as! String
        let alertView = UIAlertView.init(title: nil, message: alert, delegate: nil, cancelButtonTitle: "确定")
        alertView.show()
        
        if notification.request.trigger is  UNPushNotificationTrigger{
            JPUSHService.handleRemoteNotification(userInfo)
        }
        
        
        completionHandler(Int(UNNotificationPresentationOptions.Alert.rawValue))
         // 需要执行这个方法，选择是否提醒用户，有Badge、Sound、Alert三种类型可以选择设置
    }
    
    @available(iOS 10.0, *)
    func jpushNotificationCenter(center: UNUserNotificationCenter!, didReceiveNotificationResponse response: UNNotificationResponse!, withCompletionHandler completionHandler: (() -> Void)!) {
        // Required
        let userInfo = response.notification.request.content.userInfo
        if response.notification.request.trigger is  UNPushNotificationTrigger{
            JPUSHService.handleRemoteNotification(userInfo)
        }
        completionHandler()  // 系统要求执行这个方法
    }
    
    func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject]) {
        let alert = userInfo["aps"]!["alert"] as! String
//        NSString *alert = [[userInfo objectForKey:@"aps"] objectForKey:@"alert"];
        
        if (application.applicationState == .Active) {
            
            let alertView = UIAlertView.init(title: nil, message: alert, delegate: nil, cancelButtonTitle: "确定")
            alertView.show()
        }
        JPUSHService.handleRemoteNotification(userInfo)
        
       

    }

    func _loadViewCoontroller() {
        let main = MainViewController()
        let nav = UINavigationController(rootViewController: main)
        self.rootVc = nav;
        self.window?.rootViewController = nav
    }
    
    func registerJPush() {
        //通知类型（这里将声音、消息、提醒角标都给加上）
        let userSettings = UIUserNotificationSettings(forTypes: [UIUserNotificationType.Alert,UIUserNotificationType.Sound],
                                                      categories: nil)
        if (app_systemVersion >= "10.0") {
            let entity = JPUSHRegisterEntity.init()
            entity.types = Int(userSettings.types.rawValue)
            JPUSHService.registerForRemoteNotificationConfig(entity, delegate: self)
        }
        else {
            //可以添加自定义categories
            JPUSHService.registerForRemoteNotificationTypes(userSettings.types.rawValue, categories: nil)
        }
        // 启动JPushSDK
        JPUSHService.setupWithOption(nil, appKey: "16b88b9522c0dc17d75908cf", channel: "App Store", apsForProduction: false)
        
    }
    
}

