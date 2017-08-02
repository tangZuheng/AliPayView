//
//  MessageCell.swift
//  HappyHome
//
//  Created by kaka on 16/11/12.
//  Copyright © 2016年 kaka. All rights reserved.
//

import UIKit

class MessageCell: UITableViewCell {

    var backView :UIView?
    var titleLabel: UILabel?
    var timeLabel: UILabel?
    var contentLabel: UILabel?
    
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
        self.contentView.backgroundColor = UIColor.clearColor()
        self.backgroundColor = UIColor.clearColor()
        
        backView = UIView()
        backView?.backgroundColor = UIColor.whiteColor()
        backView!.layer.masksToBounds = true
        backView!.layer.cornerRadius = 5
        self.contentView.addSubview(backView!)
        backView!.snp_makeConstraints { (make) in
            make.edges.equalToSuperview().inset(UIEdgeInsetsMake(10, 10, 5, 10))
        }
        
        titleLabel = UILabel()
        titleLabel!.textColor = UIColor.init(rgb: 0x333333)
        titleLabel?.font = UIFont.systemFontOfSize(14)
        backView!.addSubview(titleLabel!)
        titleLabel!.snp_makeConstraints { (make) in
            make.top.equalTo(10)
            make.left.equalTo(10)
            make.width.equalTo(200)
            make.height.equalTo(20)
        }
        
        timeLabel = UILabel()
        timeLabel!.textColor = UIColor.init(rgb: 0x999999)
        timeLabel?.textAlignment = .Right
        timeLabel?.font = UIFont.systemFontOfSize(10)
        backView!.addSubview(timeLabel!)
        timeLabel!.snp_makeConstraints { (make) in
            make.top.equalTo(10)
            make.right.equalToSuperview().offset(-10)
            make.left.equalTo((titleLabel?.snp_right)!).offset(10)
            make.height.equalTo(20)
        }
        
        contentLabel = UILabel()
        contentLabel?.numberOfLines = 0
        contentLabel!.textColor = UIColor.init(rgb: 0x666666)
        contentLabel?.font = UIFont.systemFontOfSize(12)
        backView!.addSubview(contentLabel!)
        contentLabel!.snp_makeConstraints { (make) in
            make.top.equalTo((titleLabel?.snp_bottom)!).offset(10)
            make.left.equalTo(10)
            make.right.equalToSuperview().offset(-10)
            make.bottom.equalToSuperview().offset(-10)
        }
    }
    
    func setModel(model:MessageModel) -> Void {
        titleLabel?.text = model.title
        contentLabel?.text = model.smcontent
        
        let dfmatter = NSDateFormatter()
        dfmatter.dateFormat="yyyy.MM.dd HH:mm:ss"
        let zone:NSTimeZone? = NSTimeZone(name: "Asia/Chongqing")
        dfmatter.timeZone = zone
        let date = NSDate(timeIntervalSince1970: model.submittime!/1000)
        timeLabel!.text = dfmatter.stringFromDate(date)
    }
    
}
