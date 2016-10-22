//
//  DistrictManageModel.swift
//  HappyHome
//
//  Created by kaka on 16/10/10.
//  Copyright © 2016年 kaka. All rights reserved.
//

import UIKit

class DistrictManageModel: NSObject {
    
    static let sharedManager = DistrictManageModel()
    
    var districtArray:NSMutableArray = NSMutableArray()
    
    private var _selectDistrict:DistrictModel?
    
    private override init() {
        
    }
    
    var selectDistrict:DistrictModel?
        {
        get {
            if self._selectDistrict == nil {
                self._selectDistrict = DistrictModel.init()
                self._selectDistrict?.id = 1
                self._selectDistrict?.name = "通用"
            }
            return self._selectDistrict
        }
        set {
            self._selectDistrict = newValue
            NSNotificationCenter.defaultCenter().postNotificationName(UpdateDistrictNotification, object: nil)
        }
        
    }
}

