//
//  PKHistoryCell.swift
//  HappyHome
//
//  Created by kaka on 16/10/9.
//  Copyright © 2016年 kaka. All rights reserved.
//

import UIKit

class PKHistoryCell: UITableViewCell {

    let iconView = UIImageView()
    let nameLabel = UILabel()
    
    let starView = StarView()
    
    let remainingTimeLabel = myUILabel()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.initfaceView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initfaceView() {
        //
        iconView.image = UIImage.init(named: "defaultImg")
        self.contentView.addSubview(iconView)
        
        //        self.imageView?.image = UIImage.init(named: "defaultImg")
        iconView.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(5)
            make.left.equalTo(5)
            make.bottom.equalTo(-5)
            make.width.equalTo(iconView.snp_height)
        }
        
        nameLabel.font = UIFont.systemFontOfSize(12)
        nameLabel.textColor = UIColor.init(rgb: 0x666666)
        self.contentView.addSubview(nameLabel)
        nameLabel.snp_makeConstraints { (make) in
            make.top.equalTo(10)
            make.left.equalTo(iconView.snp_right).offset(10)
            make.width.equalTo(200)
            make.height.equalTo(15)
        }
        
        let starLabel = UILabel()
        starLabel.font = UIFont.systemFontOfSize(10)
        starLabel.textColor = UIColor.init(rgb: 0x999999)
        starLabel.text = "星级"
        self.contentView.addSubview(starLabel)
        starLabel.snp_makeConstraints { (make) in
            make.bottom.equalTo(-8)
            make.left.equalTo(iconView.snp_right).offset(10)
            make.width.equalTo(25)
            make.height.equalTo(10)
        }
        
        
        self.contentView.addSubview(starView)
        starView.height = 10
        starView.snp_makeConstraints { (make) in
            make.bottom.equalTo(-8)
            make.left.equalTo(starLabel.snp_right).offset(10)
            make.width.equalTo(80)
            make.height.equalTo(10)
        }
        
        remainingTimeLabel.text = "有效期:1天"
        remainingTimeLabel.font = UIFont.systemFontOfSize(12)
        remainingTimeLabel.textColor = UIColor.init(rgb: 0x999999)
        remainingTimeLabel.textAlignment = .Right
        self.contentView.addSubview(remainingTimeLabel)
        remainingTimeLabel.snp_makeConstraints { (make) in
            make.width.equalTo(100)
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().offset(-10)
        }
        
    }
    
    func setModel(model:PKHistoryModel) -> Void {
        
        iconView.sd_setImageWithURL(NSURL.init(string: model.picture!), placeholderImage: placeholderImage)
        nameLabel.text = model.sname
        
        starView.starNumber = model.level!
        
        remainingTimeLabel.text = "有效期:" + String(model.day!) + "天"
    }

}
