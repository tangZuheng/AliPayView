//
//  ListenDetailViewController.swift
//  HappyHome
//
//  Created by kaka on 16/10/8.
//  Copyright © 2016年 kaka. All rights reserved.
//

import UIKit
import HandyJSON

class ListenDetailViewController: BaseViewController,UITableViewDataSource,UITableViewDelegate {
    
    var pid:Int?
    var ppicture:String?
    var pname:String?
    
//    var model:ScenceModel!
//    var pointModel:ScencePointModel!
    
    var img:UIImageView?
    var name:UILabel?
    
    let dataArr = NSMutableArray()
    let tableView = UITableView.init()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.initfaceView()
        self.initDataSouce()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillDisappear(animated: Bool) {
        
        self.navigationController!.navigationBar.tintColor = colorForNavigationTint()
        self.navigationController!.navigationBar.barTintColor = UIColor.whiteColor()
        self.navigationController!.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: colorForNavigationBarTitle()]
        self.navigationController!.navigationBar.alpha = 1
        ZHAudioPlayer.sharedInstance().stopAudio()
        
        super.viewWillDisappear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func initfaceView(){
        self.title = "听听排行榜"
        
        self.navigationController!.navigationBar.tintColor = UIColor.whiteColor()
        self.navigationController!.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        self.navigationController!.navigationBar.barTintColor = UIColor.blackColor()
        self.navigationController!.navigationBar.alpha = 0.4
        
        
        
        
        tableView.dataSource = self
        tableView.delegate = self
        self.view.addSubview(tableView)
        tableView.rowHeight = 44
        tableView.tableHeaderView = self.getHeadeView()
//        tableView.scrollEnabled = false
        tableView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGH)
//        tableView.separatorInset = UIEdgeInsetsMake(0, 60, 0, 0)
        
//        collectionView.mj_header = MJRefreshNormalHeader.init(refreshingBlock: {
//            self.initDataSouce()
//        })
//        collectionView.mj_header.beginRefreshing()
        
        
    }
    
    func initDataSouce(){
        self.startMBProgressHUD()
        NetWorkingManager.sharedManager.getScencePointTopList(self.pid!) { (retObject, error) in
//            self.tableView.mj_header.endRefreshing()
            self.stopMBProgressHUD()
            if error == nil {
                
                if !(retObject?.objectForKey("data")! is NSNull)
                {
                    let arr = retObject?.objectForKey("data")! as! NSArray
                    self.dataArr.removeAllObjects()
                    for item in arr {
                        let model = JSONDeserializer<ScencePointTopModel>.deserializeFrom(item as! NSDictionary)
                        self.dataArr.addObject(model!)
                    }
                }
                self.tableView.reloadData()
                self.tableView.tableViewDisplayWitMsg("暂时没有排行榜数据，赶紧去PK吧~~~", rowCount: self.dataArr.count)
            }
            else {
                self.showFailHUDWithText(error!.localizedDescription)
            }
        }
    }
    
    func getHeadeView() -> UIView {
        let headView = UIView()
        headView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH + 10)
        self.view .addSubview(headView)
        
        img = UIImageView()
        img?.sd_setImageWithURL(NSURL.init(string: self.ppicture!), placeholderImage: placeholderImage!)
        
        //        img?.image = UIImage.init(named: "defaultImg")
        headView.addSubview(img!)
        img!.snp_makeConstraints { (make) -> Void in
            make.width.height.equalTo(SCREEN_WIDTH)
            make.top.equalTo(0)
        }
        
        let nameBack = UIView()
        nameBack.backgroundColor = UIColor.blackColor()
        nameBack.alpha = 0.3
        img?.addSubview(nameBack)
        nameBack.snp_makeConstraints { (make) in
            make.width.equalTo(img!)
            make.height.equalTo(35)
            make.bottom.equalTo(img!).offset(0)
        }
        
        name = UILabel()
        name?.textColor = UIColor.whiteColor()
        name?.text = self.pname
        headView.addSubview(name!)
        name!.snp_makeConstraints { (make) -> Void in
            make.left.equalTo(10)
            make.right.equalTo(10)
            make.height.equalTo(nameBack)
            make.bottom.equalTo(img!).offset(0)
        }
        return headView
    }
    
    //MARK: UITableViewDataSource
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataArr.count
    }
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let identifir = "ListenDetailCellIdentifir"
        var cell:ListenDetailCell? = tableView.dequeueReusableCellWithIdentifier(identifir) as? ListenDetailCell
        if cell == nil {
            cell = ListenDetailCell.init(style: .Default, reuseIdentifier: identifir)
            cell?.selectionStyle = .None
        }
//     cell?.imageView?.image = UIImage.init(named: "listen_"+String(indexPath.row+1))
        
        cell?.imageView?.image = ListenTopView.getListenTopImage(indexPath.row)
        cell?.setModel(dataArr.objectAtIndex(indexPath.row) as! ScencePointTopModel )
        return cell!
    }

}
