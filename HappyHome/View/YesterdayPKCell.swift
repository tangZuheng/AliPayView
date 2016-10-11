//
//  YesterdayPKCell.swift
//  HappyHome
//
//  Created by kaka on 16/10/9.
//  Copyright © 2016年 kaka. All rights reserved.
//

import UIKit

class YesterdayPKCell: UITableViewCell {

    let iconView = UIImageView()
    let nameLabel = UILabel()
    let updateTimeLabel = myUILabel()
    
    let leftHeadImg = UIImageView()
    let rightHeadImg = UIImageView()
    let leftIcon = UIImageView()
    let rightIcon = UIImageView()
    
    
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
        
        
        updateTimeLabel.font = UIFont.systemFontOfSize(10)
        updateTimeLabel.textColor = UIColor.init(rgb: 0x999999)
        self.contentView.addSubview(updateTimeLabel)
        updateTimeLabel.verticalAlignment = VerticalAlignmentBottom
        updateTimeLabel.snp_makeConstraints { (make) in
            make.bottom.equalTo(-8)
            make.left.equalTo(iconView.snp_right).offset(10)
            make.width.equalTo(100)
            make.height.equalTo(10)
        }
        
        rightHeadImg.image = UIImage.init(named: "user_head")
        self.contentView.addSubview(rightHeadImg)
        rightHeadImg.snp_makeConstraints { (make) -> Void in
            make.centerY.equalToSuperview()
            make.right.equalTo(-10)
            make.height.width.equalTo(30*SCREEN_SCALE)
        }
        
        rightIcon.image = UIImage.init(named: "yesterdayPK_win")
        self.contentView.addSubview(rightIcon)
        rightIcon.snp_makeConstraints { (make) -> Void in
            make.centerX.equalTo(rightHeadImg.snp_left)
            make.centerY.equalTo(rightHeadImg.snp_top)
        }

        
        let vsImg = UIImageView()
        vsImg.image = UIImage.init(named: "yesterdayPK_VS")
        self.contentView.addSubview(vsImg)
        vsImg.snp_makeConstraints { (make) -> Void in
            make.centerY.equalToSuperview()
            make.right.equalTo(rightHeadImg.snp_left).offset(-10)
        }
        
        leftHeadImg.image = UIImage.init(named: "user_head")
        self.contentView.addSubview(leftHeadImg)
        leftHeadImg.snp_makeConstraints { (make) -> Void in
            make.centerY.equalToSuperview()
            make.right.equalTo(vsImg.snp_left).offset(-10)
            make.height.width.equalTo(30*SCREEN_SCALE)
        }
        
        leftIcon.image = UIImage.init(named: "yesterdayPK_pin")
        self.contentView.addSubview(leftIcon)
        leftIcon.snp_makeConstraints { (make) -> Void in
            make.centerX.equalTo(leftHeadImg.snp_left)
            make.centerY.equalTo(leftHeadImg.snp_top)
        }
    }
    
    func setModel(model:RecordObject) -> Void {
        
        iconView.image = UIImage.init(named: model.img)
        
        let nameText = NSMutableAttributedString.init(string: model.spotsName+"  "+model.explainName)
        nameText.addAttributes([NSForegroundColorAttributeName : UIColor.init(rgb: 0x282828)], range: NSMakeRange(0, model.spotsName.characters.count))
        nameText.addAttributes([NSFontAttributeName : UIFont.systemFontOfSize(14)], range: NSMakeRange(0, model.spotsName.characters.count))
        nameLabel.attributedText = nameText;
        
        let dfmatter = NSDateFormatter()
        dfmatter.dateFormat="yyyy.MM.dd hh:mm:ss"
        updateTimeLabel.text = dfmatter.stringFromDate(model.updateTime!)
        
    }

}
