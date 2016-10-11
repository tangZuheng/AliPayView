//
//  MyTopViewController.swift
//  HappyHome
//
//  Created by kaka on 16/10/10.
//  Copyright © 2016年 kaka. All rights reserved.
//

import UIKit

class MyTopViewController: BaseViewController,UITableViewDataSource,UITableViewDelegate {

    let dataArr = SQLiteManage.sharedManager.searchRecord()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.initfaceView()
//        self.initControlEvent()
    }
    
    override func viewWillAppear(animated: Bool) {
        self.navigationController!.navigationBarHidden = false
        super.viewDidAppear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func initfaceView(){
        
        self.title = "我的TOP5"
        
        let headLabel = UILabel()
        headLabel.text = "历史记录:5"
        headLabel.backgroundColor = UIColor.clearColor()
        headLabel.textColor = UIColor.init(rgb: 0x666666)
        headLabel.font = UIFont.systemFontOfSize(14)
        headLabel.textAlignment = .Center
        self.view.addSubview(headLabel)
        headLabel.snp_makeConstraints { (make) in
            make.height.equalTo(25*SCREEN_SCALE)
            make.width.equalToSuperview()
            make.centerX.equalToSuperview()
            make.top.equalTo(navBar_Fheight)
        }
        
        let tableView = UITableView.init()
        tableView.dataSource = self
        tableView.delegate = self
        self.view.addSubview(tableView)
        tableView.rowHeight = 50 * SCREEN_SCALE
        tableView.separatorInset = UIEdgeInsetsMake(0, 50*SCREEN_SCALE + 5, 0, 0)
        tableView.snp_makeConstraints { (make) in
            make.width.equalToSuperview()
            make.centerX.equalToSuperview()
            make.top.equalTo(headLabel.snp_bottom)
            make.bottom.equalToSuperview()
        }
    }
    
    //MARK: 事件
    
    //MARK: UITableViewDataSource
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArr.count
    }
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let identifir = "MyTopCellIdentifir"
        var cell:MyTopCell? = tableView.dequeueReusableCellWithIdentifier(identifir) as? MyTopCell
        if cell == nil {
            cell = MyTopCell.init(style: .Default, reuseIdentifier: identifir)
            cell?.accessoryType = .DisclosureIndicator
            cell?.selectionStyle = .None
        }
        cell?.setModel(dataArr.objectAtIndex(indexPath.row) as! RecordObject)
        return cell!
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let vc = ListenDetailViewController()
        self.pushToNextController(vc)
    }
}
