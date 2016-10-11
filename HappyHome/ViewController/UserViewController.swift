//
//  UserViewController.swift
//  HappyHome
//
//  Created by kaka on 16/10/1.
//  Copyright © 2016年 kaka. All rights reserved.
//

import UIKit

class UserViewController: BaseViewController,UITableViewDataSource,UITableViewDelegate {
    
    let titleArr = NSArray.init(objects: NSArray.init(objects: "PK记录","昨日PK","我的练习"),NSArray.init(objects: "意见反馈","系统消息","PK规则","评委规则"),NSArray.init(objects: "关于我们","账户管理"))
    let imgArr = NSArray.init(objects: NSArray.init(objects: "PK记录","昨日PK","我的练习"),NSArray.init(objects: "意见反馈","系统消息","PK规则","评委规则"),NSArray.init(objects: "关于我们","账户管理"))
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.initfaceView()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.navigationController!.navigationBarHidden = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func initfaceView(){
        
        let heardeView = UserHeardeView()
        heardeView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 180 * SCREEN_SCALE)
        heardeView.loginButton!.rac_signalForControlEvents(UIControlEvents.TouchUpInside).subscribeNext { _ in
            let vc = LoginViewController()
            self.pushToNextController(vc)
        }
        
        heardeView.registerButton!.rac_signalForControlEvents(UIControlEvents.TouchUpInside).subscribeNext { _ in
            let vc = RegisterViewController()
            self.pushToNextController(vc)
        }
        
        heardeView.registerButton!.rac_signalForControlEvents(UIControlEvents.TouchUpInside).subscribeNext { _ in
            
        }
        
        let tableView = UITableView.init()
        tableView.dataSource = self
        tableView.delegate = self
        self.view.addSubview(tableView)
        tableView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGH-tabBar_height)
        tableView.tableHeaderView = heardeView
//        tableView.snp_makeConstraints { (make) in
//            make.top.equalTo(0)
//            make.bottom.equalTo(tabBar_height)
//        }
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
        let identifir = "UITableViewCellUserIdentifir"
        var cell = tableView.dequeueReusableCellWithIdentifier(identifir)
        if cell == nil {
            cell = UITableViewCell.init(style: .Default, reuseIdentifier: identifir)
            cell?.accessoryType = .DisclosureIndicator
            cell?.selectionStyle = .None
        }
        let titleArr_secton = titleArr.objectAtIndex(indexPath.section)
        let imgArr_secton = imgArr.objectAtIndex(indexPath.section)
        
        cell?.textLabel?.text = titleArr_secton.objectAtIndex(indexPath.row) as? String
        cell?.imageView?.image = UIImage.init(named: imgArr_secton.objectAtIndex(indexPath.row) as! String)
        return cell!
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.section == 0 {
            if indexPath.row == 0 {
                let vc = PKHistoryViewController()
                self.pushToNextController(vc)
            }
            else if indexPath.row == 1 {
                let vc = YesterdayPKViewController()
                self.pushToNextController(vc)
            }
            else if indexPath.row == 2 {
                let vc = MyTrainingRecordViewController()
                self.pushToNextController(vc)
            }
        }
    }
}
