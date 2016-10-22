//
//  AccountManageViewController.swift
//  HappyHome
//
//  Created by kaka on 16/10/17.
//  Copyright © 2016年 kaka. All rights reserved.
//

import UIKit

class AccountManageViewController: BaseViewController,UITableViewDataSource,UITableViewDelegate {

    let titleArr = NSArray.init(objects: NSArray.init(objects: "账户信息","用户昵称"),NSArray.init(objects: "修改密码","找回密码"),NSArray.init(objects: "退出账号"))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.initfaceView()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.navigationController!.navigationBarHidden = false
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func initfaceView(){
        
        self.title = "账户管理"

        let tableView = UITableView.init()
        tableView.dataSource = self
        tableView.delegate = self
        self.view.addSubview(tableView)
//        tableView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGH-tabBar_height)
//        tableView.tableHeaderView = heardeView
        tableView.snp_makeConstraints { (make) in
            make.width.equalToSuperview()
            make.centerX.equalToSuperview()
            make.top.equalTo(navBar_Fheight)
            make.bottom.equalToSuperview()
        }
    }
    
    //MARK: UITableViewDataSource
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return titleArr.count
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let arr = titleArr.objectAtIndex(section)
        return arr.count
    }
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == 2 {
            return 1
        }
        return 10
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let identifir = "UITableViewCellAccountManageIdentifir"
        var cell = tableView.dequeueReusableCellWithIdentifier(identifir)
        if cell == nil {
            cell = UITableViewCell.init(style: .Value1, reuseIdentifier: identifir)
            
            cell?.selectionStyle = .None
        }
        let titleArr_secton = titleArr.objectAtIndex(indexPath.section)
        cell?.textLabel?.text = titleArr_secton.objectAtIndex(indexPath.row) as? String
        cell?.textLabel?.font = UIFont.systemFontOfSize(14)
        if indexPath.section == 0 {
            cell?.accessoryType = .None
            cell?.textLabel?.textColor = UIColor.init(rgb: 0x282828)
            if indexPath.row == 0 {
                cell?.detailTextLabel?.text = UserModel.sharedUserModel.username
            }
            else {
                cell?.detailTextLabel?.text = UserModel.sharedUserModel.nickname
            }
        }
        else if indexPath.section == 1{
            cell?.accessoryType = .DisclosureIndicator
            cell?.detailTextLabel?.text = ""
            cell?.textLabel?.textColor = UIColor.init(rgb: 0x282828)
        }
        else {
            cell?.accessoryType = .None
            cell?.detailTextLabel?.text = ""
            cell?.textLabel?.textColor = UIColor.init(rgb: 0xff3838)
        }
        return cell!
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.section == 0 {
            
        }
        else if indexPath.section == 1 {
            
        }
        else {
            let view = UIAlertView.init(title: "", message: "亲，你确定需要退出系统？", delegate: nil, cancelButtonTitle: "确定", otherButtonTitles: "取消")
            view.rac_buttonClickedSignal().subscribeNext({ (indexNumber) in
                if indexNumber as! Int == 0 {
                    UserModel.sharedUserModel.isLogin = false
                    UserModel.sharedUserModel.savaUserModel()
                    NSNotificationCenter.defaultCenter().postNotificationName(LoginStateUpdateNotification, object: nil)
                    self.navigationController?.popViewControllerAnimated(true)
                }
            })
            view.show()
            
        }
    }

}
