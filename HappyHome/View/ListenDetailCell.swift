//
//  ListenDetailCell.swift
//  HappyHome
//
//  Created by kaka on 16/10/8.
//  Copyright © 2016年 kaka. All rights reserved.
//

import UIKit

class ListenDetailCell: UITableViewCell {
    
    let headView = UIImageView()
    let headName = UILabel()
    let recore_lengthLabel = UILabel()
    let playButton = UIButton()
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
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
        headView.image = UIImage.init(named: "user_head")
        self.contentView.addSubview(headView)
        headView.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(10)
            make.left.equalTo(self.imageView!.snp_right).offset(10)
            make.bottom.equalTo(-10)
            make.width.equalTo(headView.snp_height)
        }
        
        headName.text = "测试"
        headName.textColor = UIColor.init(rgb: 0x282828)
        headName.font = UIFont.systemFontOfSize(14)
        self.contentView.addSubview(headName)
        headName.snp_makeConstraints { (make) -> Void in
//            make.top.equalTo(10)
            make.left.equalTo(self.headView.snp_right).offset(10)
//            make.bottom.equalTo(-10)
            make.width.equalTo(100)
            make.centerY.equalToSuperview()
        }
        
        let record_timeIcon = UIImageView()
        record_timeIcon.image = UIImage.init(named: "record_time")
        self.contentView.addSubview(record_timeIcon)
        record_timeIcon.snp_makeConstraints { (make) in
//            make.bottom.equalTo(-8)
            make.centerY.equalToSuperview()
            make.left.equalTo(self.headName.snp_right).offset(10)
        }
        
        recore_lengthLabel.text = "03:00"
        recore_lengthLabel.font = UIFont.systemFontOfSize(10)
        recore_lengthLabel.textColor = UIColor.init(rgb: 0x999999)
        self.contentView.addSubview(recore_lengthLabel)
        recore_lengthLabel.snp_makeConstraints { (make) in
//            make.bottom.equalTo(-8)
            make.centerY.equalToSuperview()
            make.left.equalTo(record_timeIcon.snp_right).offset(10)
            make.width.equalTo(40)
//            make.height.equalTo(10)
        }
        
        playButton.setImage(UIImage.init(named: "user_play"), forState: .Normal)
        self.contentView.addSubview(playButton)
        playButton.snp_makeConstraints { (make) in
            make.right.equalTo(self.contentView.snp_right).offset(-10)
            make.centerY.equalToSuperview()
            make.height.width.equalTo(30)
        }
    }
}
