//
//  BeanUtils.swift
//  HappyHome
//
//  Created by kaka on 16/10/12.
//  Copyright © 2016年 kaka. All rights reserved.
//

import UIKit

class BeanUtils: NSObject {
    
    //将所有属性设置为空(也能够将所有私有属性取出来)
    static func setPropertysToNil(object:AnyObject?){
        if object==nil {
            return
        }
        let count = UnsafeMutablePointer<UInt32>.alloc(0)
        let properties = class_copyPropertyList(object?.classForCoder, count)
        let countInt = Int(count[0])
        for i in 0...countInt-1 {
            let property = properties[i]
            let propertyName = String.init(UTF8String: property_getName(property))
            let propertyType = String.init(UTF8String: property_getAttributes(property))
            if self.getRealProperty(propertyType!) != nil && !self.propertyIsReadOnly(propertyType!){
                if  ((NSClassFromString(self.getRealProperty(propertyType!)!)?.isSubclassOfClass(NSObject.classForCoder())) != nil) {
                    object?.setValue(nil, forKey: propertyName!)
                }
            }
        }
    }
    
    // 获取真实的属性类型
    static func getRealProperty(property:String)->String?
    {
        let propertyStr = property as NSString
        if propertyStr.rangeOfString("\"").location != NSNotFound {
            let location = propertyStr.rangeOfString("\"").location + 1
            let length = propertyStr.rangeOfString(",").location - location - 1
            let str = propertyStr.substringWithRange(NSMakeRange(location, length))
            return str;
        }
        return nil
    }
    
    // 判断是否是只读属性
    static func propertyIsReadOnly(propertyType:String) -> Bool{
        let array = propertyType .componentsSeparatedByString(",")
        return array.contains("R")
    }
    
    

}
