//
//  SpotsCollectionViewCell.swift
//  HappyHome
//
//  Created by kaka on 16/10/4.
//  Copyright © 2016年 kaka. All rights reserved.
//

import UIKit

class SpotsCollectionViewCell: UICollectionViewCell {
    var img:UIImageView?
    var name:UILabel?
    
    override init(frame: CGRect)  {
        super.init(frame: frame)
        self .initfaceView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initfaceView()
    {
        self.contentView.backgroundColor = UIColor.whiteColor()
        
        img = UIImageView()
        img?.image = UIImage.init(named: "defaultImg")
        self.contentView.addSubview(img!)
        img!.snp_makeConstraints { (make) -> Void in
            make.edges.equalTo(self).inset(UIEdgeInsetsMake(0, 0, 30, 0))
        }
        
        name = UILabel()
        name?.text = "测试"
        name?.font = UIFont.systemFontOfSize(14)
        name?.textColor = UIColor.init(rgb: 0x282828)
        self.contentView.addSubview(name!)
        name!.snp_makeConstraints { (make) -> Void in
            make.centerX.equalTo(self)
            make.height.equalTo(20)
            make.bottom.equalTo(-5)
        }
    }
    
}
