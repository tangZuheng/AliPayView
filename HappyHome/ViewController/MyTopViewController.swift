//
//  MyTopViewController.swift
//  HappyHome
//
//  Created by kaka on 16/10/10.
//  Copyright © 2016年 kaka. All rights reserved.
//

import UIKit
import MJRefresh
import HandyJSON

class MyTopViewController: BaseViewController,UITableViewDataSource,UITableViewDelegate {

    var dataArr = NSMutableArray()
    
    let headLabel = UILabel()
    let tableView = UITableView.init()
    
    var historytopfive:Int! = 0
    
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
        
        
        headLabel.text = "历史记录:0"
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
            make.bottom.equalToSuperview()
        }
        
        tableView.mj_header = MJRefreshNormalHeader.init(refreshingBlock: {
            self.initDataSouce()
        })
        tableView.mj_header.beginRefreshing()
    }
    
    func initDataSouce(){
        NetWorkingManager.sharedManager.getMytopList { (retObject, error) in
            self.tableView.mj_header.endRefreshing()
            if error == nil {
                if !(retObject?.objectForKey("data")! is NSNull)
                {
                    if !(retObject?.objectForKey("data")!.objectForKey("historytopfive")! is NSNull)
                    {
                        self.historytopfive = retObject?.objectForKey("data")!.objectForKey("historytopfive")! as! Int
                        self.headLabel.text = "历史记录:" + String(self.historytopfive)
                    }
                    
                    
                    if retObject?.objectForKey("data")!.objectForKey("MyTopBeans")! is NSArray
                    {
                        let arr = retObject?.objectForKey("data")!.objectForKey("MyTopBeans")! as! NSArray
                        self.dataArr.removeAllObjects()
                        for item in arr {
                            let model = JSONDeserializer<MyTopModel>.deserializeFrom(item as! NSDictionary)
                            self.dataArr.addObject(model!)
                        }
                        self.tableView.reloadData()
                        
                    }
                }
                self.tableView.tableViewDisplayWitMsg("暂时没有TOP5记录，赶紧去PK吧~~~", rowCount: self.dataArr.count)
            }
            else {
                self.showFailHUDWithText(error!.localizedDescription)
            }
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
        cell?.setModel(dataArr.objectAtIndex(indexPath.row) as! MyTopModel)
        return cell!
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let model = dataArr.objectAtIndex(indexPath.row) as! MyTopModel
        let vc = ListenDetailViewController()
        vc.pid = model.pid
        
        if UserModel.sharedUserModel.selectLanguage == 1 {
            vc.pname = model.pname
        }
        else {
            vc.pname = model.penglishname
        }
//        vc.pname = model.pname
        vc.ppicture = model.ppicture
        self.pushToNextController(vc)
    }
}
