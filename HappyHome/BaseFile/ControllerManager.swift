//
//  ControllerManager.swift
//  HappyHome
//
//  Created by kaka on 16/10/1.
//  Copyright © 2016年 kaka. All rights reserved.
//

import UIKit

class ControllerManager: NSObject {
    private var _rootViewController:MainTabBarController?
    var rootViewController:MainTabBarController?
    {
        get{
            if self._rootViewController == nil {
                self._rootViewController = MainTabBarController()
//                self._rootViewController?.popoverPresentationController
            }
            return self._rootViewController
        }
    }
    
    private static var manage:ControllerManager?
    private static var onceToken:dispatch_once_t?
    
    static func sharedManager() ->ControllerManager {
        
        struct Static {
            static var onceToken : dispatch_once_t = 0
            static var instance : ControllerManager?
        }
        dispatch_once(&Static.onceToken) {
            Static.instance = ControllerManager()
        }
        return Static.instance!
    }
}
