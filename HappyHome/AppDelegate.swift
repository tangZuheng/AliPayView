//
//  AppDelegate.swift
//  HappyHome
//
//  Created by kaka on 16/9/29.
//  Copyright © 2016年 kaka. All rights reserved.
//

import UIKit
//import UMMobClick

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var rootVc: UINavigationController?


    func applicationDidFinishLaunching(application: UIApplication) {
        
        self.window = UIWindow()
        self.window?.frame = UIScreen.mainScreen().bounds
        self.window?.backgroundColor = UIColor.whiteColor()
        self.window?.rootViewController = MainViewController()
        self.window?.makeKeyAndVisible()
        
        UMAnalyticsConfig.sharedInstance().appKey = "58160d924544cb7fc4002497"
        UMAnalyticsConfig.sharedInstance().channelId = "test"
        
        MobClick.startWithConfigure(UMAnalyticsConfig.sharedInstance())
        MobClick.setLogEnabled(true)
    }

    func applicationWillResignActive( application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
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

    func _loadViewCoontroller() {
        let main = MainViewController()
        let nav = UINavigationController(rootViewController: main)
        self.rootVc = nav;
        self.window?.rootViewController = nav
    }
}

