//
//  ListenTopView.swift
//  HappyHome
//
//  Created by kaka on 16/11/19.
//  Copyright © 2016年 kaka. All rights reserved.
//

import UIKit

class ListenTopView: UIImageView {

    func getListenTopView(row:Int) -> UIImageView {
        
        var view:UIImageView?
        if row <= 2 {
            let img = UIImage.init(named: "listen_"+String(row+1))
            view = UIImageView.init(image: img)
        }
        else {
            view = UIImageView.init(frame: CGRectMake(0, 0, 15, 15))
            view!.backgroundColor = UIColor.init(rgb: 0xeeeeee)
            let label = UILabel.init()
            label.textColor = UIColor.init(rgb: 0x282828)
            view?.addSubview(label)
            label.snp_makeConstraints { (make) in
                make.edges.equalToSuperview().inset(UIEdgeInsetsMake(2, 2, 2, 2))
            }
            
        }
        
        return view!
    }
    
    class func getListenTopImage(row:Int) -> UIImage {
        if row <= 9 {
            let img = UIImage.init(named: "listen_"+String(row+1))
            return img!
        }
        else {
            let view = UIView.init(frame: CGRectMake(0, 0, 15, 15))
            view.backgroundColor = UIColor.init(rgb: 0xeeeeee)
            view.layer.masksToBounds = true
            view.layer.cornerRadius = 7.5
            
            let label = UILabel.init()
            label.textColor = UIColor.init(rgb: 0x282828)
            label.text = String(row+1)
            label.textAlignment = .Center
            label.font = UIFont.systemFontOfSize(9)
//            view.addSubview(label)
//            label.snp_makeConstraints { (make) in
//                make.edges.equalToSuperview().inset(UIEdgeInsetsMake(0, 0, 0, 0))
//            }
//            return self.getImageFromView(view)
            
            
            UIGraphicsBeginImageContext(view.bounds.size)
            view.layer.renderInContext(UIGraphicsGetCurrentContext()!)
//            view.drawRect(CGRectMake(0, 0, 15, 15))
            label.drawTextInRect(CGRectMake(0, 0, 15, 15))
            let image = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            return image!
            
            
        }
        
    }
    
//    
//    class func getListenTopImage(row:Int) -> UIImage {
//        if row <= 2 {
//            let img = UIImage.init(named: "listen_"+String(row+1))
//            return img!
//        }
//        else {
//            let view = UIView.init(frame: CGRectMake(0, 0, 15, 15))
//            view.backgroundColor = UIColor.init(rgb: 0xeeeeee)
//            view.layer.masksToBounds = true
//            view.layer.cornerRadius = 7.5
//            
//            let label = UILabel.init()
//            label.textColor = UIColor.init(rgb: 0x282828)
//            label.text = String(row+1)
//            label.font = UIFont.systemFontOfSize(6)
//            view.addSubview(label)
//            label.snp_makeConstraints { (make) in
//                make.edges.equalToSuperview().inset(UIEdgeInsetsMake(0, 0, 0, 0))
//            }
//            return self.getImageFromView(view)
//        }
//
//    }
    
    //把UIView 转换成图片
    class func getImageFromView(view:UIView) -> UIImage{
        UIGraphicsBeginImageContext(view.bounds.size)
        view.layer.renderInContext(UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
    
}
