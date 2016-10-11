//
//  MyTrainingRecordViewController.swift
//  HappyHome
//
//  Created by kaka on 16/10/6.
//  Copyright © 2016年 kaka. All rights reserved.
//

import UIKit

class MyTrainingRecordViewController: BaseViewController,UITableViewDataSource,UITableViewDelegate {
    
    let dataArr = SQLiteManage.sharedManager.searchRecord()
    
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
        
        self.title = "我的练习"
        
        let editButton = UIBarButtonItem.init(title: "清空记录", style: .Plain, target: self, action: nil)
        self.navigationItem.rightBarButtonItem =  editButton
        
        let tableView = UITableView.init()
        tableView.dataSource = self
        tableView.delegate = self
        self.view.addSubview(tableView)
        tableView.rowHeight = 50 * SCREEN_SCALE
//        tableView.frame = CGRectMake(0, navBar_Fheight+10, SCREEN_WIDTH, SCREEN_HEIGH - navBar_Fheight - 10)
        tableView.separatorInset = UIEdgeInsetsMake(0, 50*SCREEN_SCALE + 5, 0, 0)
        tableView.snp_makeConstraints { (make) in
            make.width.equalToSuperview()
            make.centerX.equalToSuperview()
            make.top.equalTo(navBar_Fheight+10)
            make.bottom.equalToSuperview()
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
        let identifir = "MyTrainingRecordCellIdentifir"
        var cell:MyTrainingRecordCell? = tableView.dequeueReusableCellWithIdentifier(identifir) as? MyTrainingRecordCell
        if cell == nil {
            cell = MyTrainingRecordCell.init(style: .Default, reuseIdentifier: identifir)
            cell?.selectionStyle = .None
        }
        cell?.setModel(dataArr.objectAtIndex(indexPath.row) as! RecordObject)
        return cell!
    }

}
