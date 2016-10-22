//
//  ListenListViewController.swift
//  HappyHome
//
//  Created by kaka on 16/10/8.
//  Copyright © 2016年 kaka. All rights reserved.
//

import UIKit
import MJRefresh
import HandyJSON

class ListenListViewController: BaseViewController,UICollectionViewDelegate,UICollectionViewDataSource {
    
    var model:ScenceModel!
    
    let dataArr = NSMutableArray()
    
    var collectionView:UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.initfaceView()
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func initfaceView(){
        self.title = model.sname
        
        let flowLayout = UICollectionViewFlowLayout()
        
        flowLayout.scrollDirection = .Vertical
        flowLayout.minimumLineSpacing = 5
        flowLayout.minimumInteritemSpacing = 5
        flowLayout.itemSize = CGSizeMake((SCREEN_SIZE.width - 10)/3, (SCREEN_SIZE.width - 10)/3 + 30)
        
        collectionView = UICollectionView.init(frame: CGRectMake(0, navBar_Fheight, SCREEN_SIZE.width, SCREEN_SIZE.height - navBar_Fheight), collectionViewLayout: flowLayout)
        collectionView.backgroundColor = UIColor.whiteColor()
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.registerClass(SpotsCollectionViewCell.classForCoder(), forCellWithReuseIdentifier: "SpotsCollectionViewCellIdentifier")
        collectionView.backgroundColor = colorForBackground()
        self.view.addSubview(collectionView)
        
        collectionView.mj_header = MJRefreshNormalHeader.init(refreshingBlock: {
            self.initDataSouce()
        })
        collectionView.mj_header.beginRefreshing()
        
    }
    
    func initDataSouce(){
        NetWorkingManager.sharedManager.getScencePointList(model.sid!) { (retObject, error) in
            self.collectionView.mj_header.endRefreshing()
            if error == nil {
                self.collectionView.mj_header.endRefreshing()
                let arr = retObject?.objectForKey("data")!.objectForKey("beans") as! NSArray
                self.dataArr.removeAllObjects()
                for item in arr {
                    let model = JSONDeserializer<ScencePointModel>.deserializeFrom(item as! NSDictionary)
                    self.dataArr.addObject(model!)
                }
                
                self.collectionView.reloadData()
            }
            else {
                self.showFailHUDWithText(error!.localizedDescription)
            }
        }
    }
    
    
    //MARK: UICollectionViewDataSource
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataArr.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let identifier = "SpotsCollectionViewCellIdentifier"
        let cell:SpotsCollectionViewCell = collectionView.dequeueReusableCellWithReuseIdentifier(identifier, forIndexPath: indexPath) as! SpotsCollectionViewCell
        cell.setModel(dataArr.objectAtIndex(indexPath.row))
        return cell
    }
    
    //MARK: UICollectionViewDelegate
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let vc = ListenDetailViewController()
        let pointModel = dataArr.objectAtIndex(indexPath.row) as! ScencePointModel
        vc.pid = pointModel.pid
        vc.pname = pointModel.pname
        vc.ppicture = pointModel.ppicture
        self.pushToNextController(vc)
    }
}
