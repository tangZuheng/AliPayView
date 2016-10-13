//
//  SelectKindViewController.swift
//  HappyHome
//
//  Created by kaka on 16/10/11.
//  Copyright © 2016年 kaka. All rights reserved.
//

import UIKit
import MJRefresh
import HandyJSON

class SelectKindViewController: BaseViewController,UITableViewDataSource,UITableViewDelegate {
    
    let tableView = UITableView.init()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.initfaceView()
    }
    
    deinit {
        BeanUtils.setPropertysToNil(self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func initfaceView(){
        
        self.title = "选择分类"
        
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .None
        self.view.addSubview(tableView)
        tableView.snp_makeConstraints { (make) in
            make.width.equalToSuperview()
            make.centerX.equalToSuperview()
            make.top.equalTo(navBar_Fheight)
            make.bottom.equalToSuperview()
        }
        tableView.mj_header = MJRefreshNormalHeader.init(refreshingBlock: {
            self.initDataSouce()
        })
        
        if DistrictManageModel.sharedManager.districtArray.count == 0{
            tableView.mj_header.beginRefreshing()
        }
    }
    
    func initDataSouce(){
        NetWorkingManager.sharedManager.getIficationList { (retObject, error) in
            self.tableView.mj_header.endRefreshing()
            if retObject != nil {
                let arr = retObject?.objectForKey("data") as! NSArray
                let districtModelArr = NSMutableArray()
                for item in arr {
                    let model = JSONDeserializer<DistrictModel>.deserializeFrom(item as! NSDictionary)
                    districtModelArr.addObject(model!)
                }
                DistrictManageModel.sharedManager.districtArray = districtModelArr
                self.tableView.reloadData()
            }
            else {
                self.showFailHUDWithText(error!.localizedDescription)
            }
        }
    }
    
    //MARK: UITableViewDataSource
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return DistrictManageModel.sharedManager.districtArray.count
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == DistrictManageModel.sharedManager.districtArray.count - 1 {
            return 1
        }
        return 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let identifir = "UITableViewCellUserIdentifir"
        var cell = tableView.dequeueReusableCellWithIdentifier(identifir)
        if cell == nil {
            cell = UITableViewCell.init(style: .Default, reuseIdentifier: identifir)
            cell?.accessoryType = .DisclosureIndicator
            cell?.selectionStyle = .None
        }
        let model = DistrictManageModel.sharedManager.districtArray.objectAtIndex(indexPath.section) as! DistrictModel
        cell?.textLabel?.text = model.name
        return cell!
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let model = DistrictManageModel.sharedManager.districtArray.objectAtIndex(indexPath.section) as! DistrictModel
        DistrictManageModel.sharedManager.selectDistrict = model
        self.navigationController?.popViewControllerAnimated(true)
    }

}
