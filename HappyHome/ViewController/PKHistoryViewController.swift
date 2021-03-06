//
//  PKHistoryViewController.swift
//  HappyHome
//
//  Created by kaka on 16/10/9.
//  Copyright © 2016年 kaka. All rights reserved.
//

import UIKit
import MJRefresh
import HandyJSON

class PKHistoryViewController: BaseViewController,UITableViewDataSource,UITableViewDelegate {

    var dataArr = NSMutableArray()
    
    let tableView = UITableView.init()
    
    let fiveStarButton = UIButton()
    let myTopButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.initfaceView()
        self.initControlEvent()
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
        
        self.title = "PK记录"
        
        let editButton = UIBarButtonItem.init(title: "昨日PK", style: .Plain, target: self, action: #selector(PKHistoryViewController.YesterdayPKButtonClick))
        editButton.setTitleTextAttributes([NSForegroundColorAttributeName: colorForNavigationBarTitle(),NSFontAttributeName:UIFont.systemFontOfSize(14)], forState: .Normal)
        self.navigationItem.rightBarButtonItem =  editButton
        
        let headLabel = UILabel()
        headLabel.text = "亲，请于有效期内更新PK，可别让辛苦白费了"
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
        
        
        tableView.dataSource = self
        tableView.delegate = self
        self.view.addSubview(tableView)
        tableView.rowHeight = 50 * SCREEN_SCALE
        tableView.separatorInset = UIEdgeInsetsMake(0, 50*SCREEN_SCALE + 5, 0, 0)
        tableView.snp_makeConstraints { (make) in
            make.width.equalToSuperview()
            make.centerX.equalToSuperview()
            make.top.equalTo(headLabel.snp_bottom)
            make.bottom.equalToSuperview().offset(-40)
        }
        tableView.mj_header = MJRefreshNormalHeader.init(refreshingBlock: {
            self.initDataSouce()
        })
        tableView.mj_header.beginRefreshing()
        
        
        let footerView = UIView()
        footerView.backgroundColor = UIColor.init(rgb: 0xff3838)
        self.view .addSubview(footerView)
        footerView.snp_makeConstraints { (make) in
            make.height.equalTo(40)
            make.width.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        fiveStarButton.setTitle("五星记录", forState: .Normal)
        fiveStarButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        fiveStarButton.titleLabel?.font = UIFont.systemFontOfSize(14)
        footerView.addSubview(fiveStarButton)
        fiveStarButton.snp_makeConstraints { (make) in
            make.width.equalTo(SCREEN_WIDTH/2)
            make.centerY.equalToSuperview()
            make.left.equalToSuperview()
        }
        
        myTopButton.setTitle("我的TOP10", forState: .Normal)
        myTopButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        myTopButton.titleLabel?.font = UIFont.systemFontOfSize(14)
        footerView.addSubview(myTopButton)
        myTopButton.snp_makeConstraints { (make) in
            make.width.equalTo(SCREEN_WIDTH/2)
            make.centerY.equalToSuperview()
            make.right.equalToSuperview()
        }
        
        let line = UIView()
        line.backgroundColor = UIColor.whiteColor()
        footerView.addSubview(line)
        line.snp_makeConstraints { (make) in
            make.height.equalTo(25)
            make.width.equalTo(1)
            make.center.equalToSuperview()
        }
        
    }
    
    //所有事件
    func initControlEvent(){
        fiveStarButton.rac_signalForControlEvents(UIControlEvents.TouchUpInside).subscribeNext { _ in
            let vc = FiveStarViewController()
            self.pushToNextController(vc)
        }
        
        myTopButton.rac_signalForControlEvents(UIControlEvents.TouchUpInside).subscribeNext { _ in
            let vc = MyTopViewController()
            self.pushToNextController(vc)
        }

    }
    
    
    func initDataSouce(){
        NetWorkingManager.sharedManager.getRecordList { (retObject, error) in
            self.tableView.mj_header.endRefreshing()
            if error == nil {
                self.dataArr.removeAllObjects()
                if retObject?.objectForKey("data")! is NSArray
                {
                    let arr = retObject?.objectForKey("data")! as! NSArray
                    for item in arr {
                        let model = JSONDeserializer<PKHistoryModel>.deserializeFrom(item as! NSDictionary)
                        self.dataArr.addObject(model!)
                    }
//                    self.tableView.reloadData()
                }
                self.tableView.reloadData()
                self.tableView.tableViewDisplayWitMsg("暂时没有PK记录，赶紧去PK吧~~~", rowCount: self.dataArr.count)
            }
            else {
                self.showFailHUDWithText(error!.localizedDescription)
            }
        }
    }
    
    //MARK: 事件
    //昨日PK
    func YesterdayPKButtonClick() {
        let vc = YesterdayPKViewController()
        self.pushToNextController(vc)
    }
    
    //MARK: UITableViewDataSource
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArr.count
    }
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let identifir = "PKHistoryCellIdentifir"
        var cell:PKHistoryCell? = tableView.dequeueReusableCellWithIdentifier(identifir) as? PKHistoryCell
        if cell == nil {
            cell = PKHistoryCell.init(style: .Default, reuseIdentifier: identifir)
            cell?.selectionStyle = .None
        }
        cell?.setModel(dataArr.objectAtIndex(indexPath.row) as! PKHistoryModel)
        return cell!
    }

}
