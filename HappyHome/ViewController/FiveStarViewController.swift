//
//  FiveStarViewController.swift
//  HappyHome
//
//  Created by kaka on 16/10/9.
//  Copyright © 2016年 kaka. All rights reserved.
//

import UIKit

class FiveStarViewController: BaseViewController,UITableViewDataSource,UITableViewDelegate {

    let dataArr = SQLiteManage.sharedManager.searchRecord()
    
    let fiveStarButton = UIButton()
    let myTopButton = UIButton()
    
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
        
        self.title = "五星记录"
        
        let tableView = UITableView.init()
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
        let identifir = "FiveStarCellCellIdentifir"
        var cell:FiveStarCellCell? = tableView.dequeueReusableCellWithIdentifier(identifir) as? FiveStarCellCell
        if cell == nil {
            cell = FiveStarCellCell.init(style: .Default, reuseIdentifier: identifir)
            cell?.selectionStyle = .None
        }
        cell?.setModel(dataArr.objectAtIndex(indexPath.row) as! RecordObject)
        return cell!
    }

}
