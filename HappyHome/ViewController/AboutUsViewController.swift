//
//  AboutUsViewController.swift
//  HappyHome
//
//  Created by kaka on 16/10/17.
//  Copyright © 2016年 kaka. All rights reserved.
//

import UIKit

class AboutUsViewController: BaseViewController,UITableViewDataSource,UITableViewDelegate  {

    let titleArr = NSArray.init(objects: NSArray.init(objects: "PK规则","评委规则","FAQ/常见问题"),NSArray.init(objects: "联系邮箱","联系电话"))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initfaceView()
        // Do any additional setup after loading the view.
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
        self.title = "关于我们"
        
        let logoimg = UIImageView()
        logoimg.image = UIImage.init(named: "abountUsLogo")
        logoimg.layer.masksToBounds = true
        logoimg.layer.cornerRadius = 5
        self.view.addSubview(logoimg)
        logoimg.snp_makeConstraints { (make) -> Void in
            make.width.height.equalTo(60)
            make.top.equalTo(navBar_Fheight+60)
            make.centerX.equalToSuperview()
        }
        
        let version = UILabel()
        version.text = APP_VERSION
        version.font = UIFont.systemFontOfSize(14)
        version.textColor = UIColor.init(rgb: 0x282828)
        version.textAlignment = .Center
        self.view.addSubview(version)
        version.snp_makeConstraints { (make) -> Void in
//            make.width.height.equalTo(60)
            make.top.equalTo(logoimg.snp_bottom).offset(10)
            make.height.equalTo(20)
            make.width.equalTo(200)
            make.centerX.equalToSuperview()
        }
        
        let tableView = UITableView.init()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.scrollEnabled = false
//        tableView.rowHeight = 44
        self.view.addSubview(tableView)
        tableView.snp_makeConstraints { (make) in
            make.top.equalTo(version.snp_bottom).offset(50)
            make.height.equalTo(44*5 + 10)
            make.width.equalToSuperview()
            make.centerX.equalToSuperview()
        }
        
    }
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return titleArr.count
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let arr = titleArr.objectAtIndex(section)
        return arr.count
    }
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == 1 {
            return 1
        }
        return 10
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let identifir = "UITableViewCellAboutUsIdentifir"
        var cell = tableView.dequeueReusableCellWithIdentifier(identifir)
        if cell == nil {
            cell = UITableViewCell.init(style: .Value1, reuseIdentifier: identifir)
            cell?.accessoryType = .DisclosureIndicator
            cell?.selectionStyle = .None
            cell?.textLabel?.font = UIFont.systemFontOfSize(16)
            cell?.textLabel?.textColor = UIColor.init(rgb: 0x282828)
            cell?.detailTextLabel?.font = UIFont.systemFontOfSize(14)
        }
        let titleArr_secton = titleArr.objectAtIndex(indexPath.section)
        cell?.textLabel?.text = titleArr_secton.objectAtIndex(indexPath.row) as? String
        if indexPath.section == 1 {
            cell?.accessoryType = .None
            if indexPath.row == 0 {
                cell?.detailTextLabel?.text = "137100709@qq.com"
            }
            else {
                cell?.detailTextLabel?.text = "18980002447"
            }
        }
        else {
            cell?.detailTextLabel?.text = ""
        }
        return cell!
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.section == 0 {
            if indexPath.row == 0 {
                let vc = UserTextDetailViewController()
                vc.textImageName = "PK规则_detail"
                self.pushToNextController(vc, withVCTitle: "PK规则")
            }
            else if indexPath.row == 1 {
                let vc = UserTextDetailViewController()
                vc.textImageName = "评论规则_detail"
                self.pushToNextController(vc, withVCTitle: "评委规则")
            }
            else if indexPath.row == 2 {
                let vc = UserTextDetailViewController()
                vc.textImageName = "FQA_detail"
                self.pushToNextController(vc, withVCTitle: "FAQ")
            }
        }
        else if indexPath.section == 1 {
            
            
        }
    }
}
