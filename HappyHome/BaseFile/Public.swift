//
//  Public.swift
//  1919sendImmediately_S
//
//  Created by kaka on 16/9/12.
//  Copyright © 2016年 kaka. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation
import ReactiveCocoa
import Alamofire
import SnapKit


/**< size define */
//let root = (ControllerManager.sharedManager().rootViewController?.viewControllersArr?.firstObject as! UIViewController).navigationController?.navigationBar.frame

let navBar_height = CGRectGetMaxY(((ControllerManager.sharedManager().rootViewController?.viewControllersArr?.firstObject as! UIViewController).navigationController?.navigationBar.bounds)!)                    // 纯导航栏高度
let staBar_height = UIApplication.sharedApplication().statusBarFrame.size.height        // 状态栏高度
let navBar_Fheight:CGFloat = 64                     //导航栏+状态栏高度
let tabBar_height:CGFloat = 49 //TABBAR高度

let  SCREEN_SIZE = UIScreen.mainScreen().bounds

let  SCREEN_WIDTH = UIScreen.mainScreen().bounds.width

let  SCREEN_HEIGH = UIScreen.mainScreen().bounds.height

let  SCREEN_SCALE = UIScreen.mainScreen().bounds.width/320

func RGB(R:CGFloat, G:CGFloat, B:CGFloat) -> UIColor {
    return UIColor(red: R / 255.0, green: G / 255.0, blue: B / 255.0, alpha: 1)
}

func RGB(hexValue:UInt) -> UIColor {
    return UIColor(red: ((CGFloat)((hexValue & 0xFF0000) >> 16))/255.0, green: ((CGFloat)((hexValue & 0xFF00) >> 8))/255.0, blue: ((CGFloat)(hexValue & 0xFF))/255.0, alpha: 1)
}

func colorForNavigationBar() -> UIColor {
    return RGB(0x33363d)
}

func colorForNavigationBarTitle() -> UIColor {
    return RGB(0x282828)
}

func colorForBackground() -> UIColor {
    return RGB(0xf5f5f5)
}

func colorForTabBar() -> UIColor {
    return RGB(0xff3838)
}


func createImageWithColor(color: UIColor) -> UIImage
{
    let rect = CGRectMake(0.0, 0.0, 1.0, 1.0)
    UIGraphicsBeginImageContext(rect.size)
    let context = UIGraphicsGetCurrentContext()
    CGContextSetFillColorWithColor(context!, color.CGColor)
    CGContextFillRect(context!, rect)
    let theImage = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    return theImage!
}

extension UIColor {
    convenience init(rgb: UInt) {
        self.init(
            red: CGFloat((rgb & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgb & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgb & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
}
