//
//  StarView.swift
//  HappyHome
//
//  Created by kaka on 16/10/9.
//  Copyright © 2016年 kaka. All rights reserved.
//

import UIKit

class StarView: UIView {
    
    var height:CGFloat!
    
    var starNumber: Int = 1{
        didSet {
            self.showStar()
        }
    }
    
    private func showStar() {
        for view in self.subviews {
            view .removeFromSuperview()
        }
        for i in 0...starNumber-1 {
            let starView = UIImageView.init(image:UIImage.init(named: "user_star"))
            self.addSubview(starView)
            starView.snp_makeConstraints { (make) in
                make.height.width.equalTo(height)
                make.top.equalTo(0)
                make.left.equalTo(CGFloat(i)*(height+5))
            }
            
        }
    }

}
