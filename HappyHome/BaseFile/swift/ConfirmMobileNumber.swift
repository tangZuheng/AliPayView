//
//  ConfirmMobileNumber.swift
//  HappyHome
//
//  Created by kaka on 16/10/25.
//  Copyright © 2016年 kaka. All rights reserved.
//

import UIKit

class ConfirmMobileNumber: NSObject {
    static func isPhoneNumber(phone:String) -> Bool {
        if phone.characters.count == 11 {
            return true
        }
        return false
    }
}
