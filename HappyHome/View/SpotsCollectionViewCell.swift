//
//  SpotsCollectionViewCell.swift
//  HappyHome
//
//  Created by kaka on 16/10/4.
//  Copyright © 2016年 kaka. All rights reserved.
//

import UIKit
import SDWebImage

class SpotsCollectionViewCell: UICollectionViewCell {
    var img:UIImageView?
    var name:UILabel?
    
//    var model:AnyObject?
//    {
//        set {
//            self.model = newValue
//            if ((self.model?.isKindOfClass(ScenceModel)) != nil) {
//                let smodel = self.model as! ScenceModel
//                name?.text = smodel.pname
//            }
//        }
//        get {
//            return self.model
//        }
//    }
    
    
    override init(frame: CGRect)  {
        super.init(frame: frame)
        self .initfaceView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        BeanUtils.setPropertysToNil(self)
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
//        name?.text = "测试"
        name?.font = UIFont.systemFontOfSize(14)
        name?.textColor = UIColor.init(rgb: 0x282828)
        self.contentView.addSubview(name!)
        name!.snp_makeConstraints { (make) -> Void in
            make.centerX.equalTo(self)
            make.height.equalTo(20)
            make.bottom.equalTo(-5)
        }
    }
    
    func setModel(model:AnyObject) {
        if (model.isKindOfClass(ScenceModel)) {
            let smodel = model as! ScenceModel
            img?.sd_setImageWithURL(NSURL.init(string: smodel.picture!), placeholderImage: placeholderImage!)
            if UserModel.sharedUserModel.selectLanguage == 1 {
                name?.text = smodel.sname
            }
            else {
                name?.text = smodel.senglishname
            }
            
        }
        else if (model.isKindOfClass(ScencePointModel)) {
            let pmodel = model as! ScencePointModel
            img?.sd_setImageWithURL(NSURL.init(string: pmodel.ppicture!), placeholderImage: placeholderImage!)
            if UserModel.sharedUserModel.selectLanguage == 1 {
                name?.text = pmodel.pname
            }
            else {
                name?.text = pmodel.penglishname
            }

            
        }
    }
}
