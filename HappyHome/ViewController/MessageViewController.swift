//
//  MessageViewController.swift
//  HappyHome
//
//  Created by kaka on 16/11/12.
//  Copyright © 2016年 kaka. All rights reserved.
//

import UIKit
import MJRefresh
import HandyJSON

class MessageViewController: BaseViewController,UITableViewDataSource,UITableViewDelegate {

    var page = 1
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
        self.title = "系统消息"
        
        tableView.dataSource = self
        tableView.delegate = self
        self.view.addSubview(tableView)
        tableView.estimatedRowHeight = 44
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.separatorStyle = .None
        tableView.backgroundColor = UIColor.clearColor()
        tableView.snp_makeConstraints { (make) in
            make.width.equalToSuperview()
            make.centerX.equalToSuperview()
            make.top.equalTo(navBar_Fheight)
            make.bottom.equalToSuperview()
        }
        
        let editButton = UIBarButtonItem.init(title: "清空记录", style: .Plain, target: self, action: #selector(MessageViewController.rightButtonClick))
        editButton.setTitleTextAttributes([NSForegroundColorAttributeName: colorForNavigationBarTitle(),NSFontAttributeName:UIFont.systemFontOfSize(14)], forState: .Normal)
        self.navigationItem.rightBarButtonItem =  editButton
        
        self.tableView.tableViewDisplayWitMsg("暂时没有系统消息~~~", rowCount: self.dataArr.count)
        
        tableView.mj_header = MJRefreshNormalHeader.init(refreshingBlock: {
            self.page = 1
            self.initDataSouce()
        })
        tableView.mj_footer = MJRefreshBackNormalFooter.init(refreshingBlock: {
            self.page += 1
            self.initDataSouce()
        })
        tableView.mj_header.beginRefreshing()
        
    }
    
    func initDataSouce(){
        NetWorkingManager.sharedManager.GetMessageList(self.page) { (retObject, error) in
            self.tableView.mj_header.endRefreshing()
            self.tableView.mj_footer.endRefreshing()
            if error == nil {
                if self.page == 1 {
                    self.dataArr.removeAllObjects()
                }
                if retObject?.objectForKey("data")!.objectForKey("beans")! is NSArray
                {
                    let arr = retObject?.objectForKey("data")!.objectForKey("beans")! as! NSArray
                    for item in arr {
                        let model = JSONDeserializer<MessageModel>.deserializeFrom(item as! NSDictionary)
                        self.dataArr.addObject(model!)
                    }
                }
                let totalPage = retObject?.objectForKey("data")!.objectForKey("total")! as! Int
                if totalPage <= self.page{
                    self.tableView.mj_footer.endRefreshingWithNoMoreData()
                }
                else {
                    self.tableView.mj_footer.resetNoMoreData()
                }
                self.tableView.reloadData()
                self.tableView.tableViewDisplayWitMsg("暂时没有系统消息~~~", rowCount: self.dataArr.count)
            }
            else {
                self.showFailHUDWithText(error!.localizedDescription)
            }
        }
    }
    
    func rightButtonClick() {
        let view = UIAlertView.init(title: "", message: "亲，你确定要删除吗？", delegate: nil, cancelButtonTitle: "确定",otherButtonTitles:"取消")
        view.rac_buttonClickedSignal().subscribeNext({ (indexNumber) in
            if indexNumber as! Int == 0 {
                self.startMBProgressHUD()
                NetWorkingManager.sharedManager.CleanMessageList({(retObject, error) in
                    self.stopMBProgressHUD()
                    if error == nil {
                        self.dataArr.removeAllObjects()
                        self.tableView.reloadData()
                        self.tableView.tableViewDisplayWitMsg("暂时没有系统消息~~~", rowCount: self.dataArr.count)
                    }
                    else {
                        self.showFailHUDWithText(error!.localizedDescription)
                    }
                })
            }
        })
        view.show()
    }
    
    //MARK: UITableViewDataSource
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArr.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let identifir = "MessageCellCellIdentifir"
        var cell:MessageCell? = tableView.dequeueReusableCellWithIdentifier(identifir) as? MessageCell
        if cell == nil {
            cell = MessageCell.init(style: .Default, reuseIdentifier: identifir)
            cell?.selectionStyle = .None
        }
        cell?.setModel(dataArr.objectAtIndex(indexPath.row) as! MessageModel)
        return cell!
    }
}
