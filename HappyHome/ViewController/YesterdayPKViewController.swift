//
//  YesterdayPKViewController.swift
//  HappyHome
//
//  Created by kaka on 16/10/9.
//  Copyright © 2016年 kaka. All rights reserved.
//

import UIKit
import MJRefresh
import HandyJSON

class YesterdayPKViewController: BaseViewController,UITableViewDataSource,UITableViewDelegate {

    var dataArr = NSMutableArray()
    
    let tableView = UITableView.init()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.initfaceView()
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
        
        self.title = "昨日PK"
        
        
        tableView.dataSource = self
        tableView.delegate = self
        self.view.addSubview(tableView)
        tableView.rowHeight = 50 * SCREEN_SCALE
        tableView.separatorInset = UIEdgeInsetsMake(0, 50*SCREEN_SCALE + 5, 0, 0)
        tableView.snp_makeConstraints { (make) in
            make.width.equalToSuperview()
            make.centerX.equalToSuperview()
            make.top.equalTo(navBar_Fheight+10)
            make.bottom.equalToSuperview()
        }
        tableView.mj_header = MJRefreshNormalHeader.init(refreshingBlock: {
            self.initDataSouce()
        })
        tableView.mj_header.beginRefreshing()
        
    }
    
    func initDataSouce(){
        NetWorkingManager.sharedManager.getYesterdayPKList { (retObject, error) in
            self.tableView.mj_header.endRefreshing()
            if error == nil {
                if retObject?.objectForKey("data")! is NSArray
                {
                    let arr = retObject?.objectForKey("data")! as! NSArray
                        self.dataArr.removeAllObjects()
                    for item in arr {
                        let model = JSONDeserializer<YesterdayPKModel>.deserializeFrom(item as! NSDictionary)
                        self.dataArr.addObject(model!)
                    }
                    self.tableView.reloadData()
                    
                }
                self.tableView.tableViewDisplayWitMsg("暂时没有昨日PK记录，赶紧去PK吧~~~", rowCount: self.dataArr.count)
            }
            else {
                self.showFailHUDWithText(error!.localizedDescription)
            }
        }
    }
    
    
    
    //MARK: UITableViewDataSource
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArr.count
    }
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let identifir = "YesterdayPKCellIdentifir"
        var cell:YesterdayPKCell? = tableView.dequeueReusableCellWithIdentifier(identifir) as? YesterdayPKCell
        if cell == nil {
            cell = YesterdayPKCell.init(style: .Default, reuseIdentifier: identifir)
            cell?.selectionStyle = .None
        }
        cell?.setModel(dataArr.objectAtIndex(indexPath.row) as! YesterdayPKModel)
        return cell!
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let vc = YesterdayPKDetailViewController()
        vc.model = dataArr.objectAtIndex(indexPath.row) as! YesterdayPKModel
        self.pushToNextController(vc)
    }

}
