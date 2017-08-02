//
//  EnglishTestCell.swift
//  HappyHome
//
//  Created by kaka on 16/11/12.
//  Copyright © 2016年 kaka. All rights reserved.
//

import UIKit

class EnglishTestCell: UITableViewCell {
    
    var backView :UIView?
    var englsihLabel: UILabel?

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
        
        englsihLabel = UILabel()
        englsihLabel!.numberOfLines = 0
        englsihLabel!.textColor = UIColor.init(rgb: 0x666666)
        backView!.addSubview(englsihLabel!)
        englsihLabel!.snp_makeConstraints { (make) in
            make.edges.equalToSuperview().inset(UIEdgeInsetsMake(10, 10, 10, 10))
        }
    }
}
