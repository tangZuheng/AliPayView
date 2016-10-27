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
//            make.width.equalTo(200)
            make.right.equalToSuperview()
            make.height.equalTo(15)
        }
        
        updateTimeLabel.font = UIFont.systemFontOfSize(10)
        updateTimeLabel.textColor = UIColor.init(rgb: 0x999999)
        self.contentView.addSubview(updateTimeLabel)
        updateTimeLabel.verticalAlignment = VerticalAlignmentBottom
        updateTimeLabel.snp_makeConstraints { (make) in
            make.bottom.equalTo(-8)
            make.left.equalTo(iconView.snp_right).offset(10)
            make.width.equalTo(60)
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
    
    func setModel(model:MyTopModel) -> Void {
        
        iconView.sd_setImageWithURL(NSURL.init(string: model.ppicture!), placeholderImage: placeholderImage)
        
        var sname = model.sname
        var pname = model.pname
        if UserModel.sharedUserModel.selectLanguage == 0 {
            sname = model.senglishname
            pname = model.penglishname
        }
        let nameText = NSMutableAttributedString.init(string: sname!+"  "+pname!)
        nameText.addAttributes([NSForegroundColorAttributeName : UIColor.init(rgb: 0x282828)], range: NSMakeRange(0, sname!.characters.count))
        nameText.addAttributes([NSFontAttributeName : UIFont.systemFontOfSize(14)], range: NSMakeRange(0, sname!.characters.count))
        nameLabel.attributedText = nameText
        
//        
//        let nameText = NSMutableAttributedString.init(string: model.sname!+"  "+model.pname!)
//        nameText.addAttributes([NSForegroundColorAttributeName : UIColor.init(rgb: 0x282828)], range: NSMakeRange(0, model.sname!.characters.count))
//        nameText.addAttributes([NSFontAttributeName : UIFont.systemFontOfSize(14)], range: NSMakeRange(0, model.sname!.characters.count))
//        nameLabel.attributedText = nameText;
        
        let dfmatter = NSDateFormatter()
        dfmatter.dateFormat="yyyy.MM.dd"
        let zone:NSTimeZone? = NSTimeZone(name: "Asia/Chongqing")
        dfmatter.timeZone = zone
        let date = NSDate(timeIntervalSince1970: model.pktime!/1000)
        updateTimeLabel.text = dfmatter.stringFromDate(date)
        
        let recordLengthDate = NSDate(timeIntervalSince1970: model.soundtime!)
        dfmatter.dateFormat = "mm:ss"
        recore_lengthLabel.text = dfmatter.stringFromDate(recordLengthDate)
        
        
//        let recordLengthDate = NSDate(timeIntervalSince1970: model.recordLength!)
//        //        let dformatter = NSDateFormatter()
//        dfmatter.dateFormat = "mm:ss"
//        recore_lengthLabel.text = dfmatter.stringFromDate(recordLengthDate)

    }
}
