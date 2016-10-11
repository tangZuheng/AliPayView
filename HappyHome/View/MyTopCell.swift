//
//  MyTopCell.swift
//  HappyHome
//
//  Created by kaka on 16/10/10.
//  Copyright © 2016年 kaka. All rights reserved.
//

import UIKit

class MyTopCell: UITableViewCell {

    let iconView = UIImageView()
    let nameLabel = UILabel()
    let updateTimeLabel = myUILabel()
    let recore_lengthLabel = UILabel()
    
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
        
        let record_timeIcon = UIImageView()
        record_timeIcon.image = UIImage.init(named: "record_time")
        self.contentView.addSubview(record_timeIcon)
        record_timeIcon.snp_makeConstraints { (make) in
            make.bottom.equalTo(-8)
            make.left.equalTo(self.updateTimeLabel.snp_right).offset(10)
        }
        
        recore_lengthLabel.font = UIFont.systemFontOfSize(10)
        recore_lengthLabel.textColor = UIColor.init(rgb: 0x999999)
        self.contentView.addSubview(recore_lengthLabel)
        recore_lengthLabel.snp_makeConstraints { (make) in
            make.bottom.equalTo(-8)
            make.left.equalTo(record_timeIcon.snp_right).offset(10)
            make.width.equalTo(40)
            make.height.equalTo(10)
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
        
        
        let recordLengthDate = NSDate(timeIntervalSince1970: model.recordLength!)
        //        let dformatter = NSDateFormatter()
        dfmatter.dateFormat = "mm:ss"
        recore_lengthLabel.text = dfmatter.stringFromDate(recordLengthDate)

    }
}
