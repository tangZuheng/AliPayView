//
//  ScenicCollectionView.swift
//  HappyHome
//
//  Created by kaka on 16/10/11.
//  Copyright © 2016年 kaka. All rights reserved.
//

import UIKit
import MJRefresh
import HandyJSON
import ReactiveCocoa

class ScenicCollectionView: UIView,UICollectionViewDataSource {
    
    let dataArr = NSMutableArray()
    
    static let sharedManager = ScenicCollectionView.init(frame: CGRectMake(0, navBar_Fheight, SCREEN_SIZE.width, SCREEN_SIZE.height - navBar_Fheight - tabBar_height))

    var collectionView:UICollectionView!
    
    private override init(frame: CGRect) {
        super.init(frame: frame)
        self.initfaceView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initfaceView(){
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .Vertical
        flowLayout.minimumLineSpacing = 5
        flowLayout.minimumInteritemSpacing = 5
        flowLayout.itemSize = CGSizeMake((SCREEN_SIZE.width - 10)/3, (SCREEN_SIZE.width - 10)/3 + 30)
        
        collectionView = UICollectionView.init(frame: CGRectMake(0, 0, SCREEN_SIZE.width, self.frame.size.height), collectionViewLayout: flowLayout)
        collectionView.backgroundColor = UIColor.whiteColor()
        collectionView.dataSource = self
//        collectionView.delegate = self
        collectionView.registerClass(SpotsCollectionViewCell.classForCoder(), forCellWithReuseIdentifier: "SpotsCollectionViewCellIdentifier")
        collectionView.backgroundColor = colorForBackground()
        self.addSubview(collectionView)
        
        collectionView.mj_header = MJRefreshNormalHeader.init(refreshingBlock: {
            self.initDataSouce()
        })
        collectionView.mj_header.beginRefreshing()
        
        NSNotificationCenter.defaultCenter().rac_addObserverForName(UpdateDistrictNotification, object: nil).subscribeNext { _ in
            self.dataArr.removeAllObjects()
            self.collectionView.mj_header.beginRefreshing()
        }
        
        NSNotificationCenter.defaultCenter().rac_addObserverForName(UpdateLanguageNotification, object: nil).subscribeNext { _ in
            self.dataArr.removeAllObjects()
            self.collectionView.mj_header.beginRefreshing()
        }
    }
    
    func initDataSouce(){
        NetWorkingManager.sharedManager.getScenceList((DistrictManageModel.sharedManager.selectDistrict?.id)!) { (retObject, error) in
            self.collectionView.mj_header.endRefreshing()
            if error == nil {
                self.collectionView.mj_header.endRefreshing()
                let arr = retObject?.objectForKey("data")!.objectForKey("beans") as! NSArray
                self.dataArr.removeAllObjects()
                for item in arr {
                    let model = JSONDeserializer<ScenceModel>.deserializeFrom(item as! NSDictionary)
                    self.dataArr.addObject(model!)
                }

                self.collectionView.reloadData()
            }
            else {
                ZCMBProgressHUD.showResultHUDWithResult(false, andText: error!.localizedDescription , toView: self.collectionView)
            }
        }
    }
    
    //MARK: UICollectionViewDataSource
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataArr.count
//        return 10
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let identifier = "SpotsCollectionViewCellIdentifier"
        let cell:SpotsCollectionViewCell = collectionView.dequeueReusableCellWithReuseIdentifier(identifier, forIndexPath: indexPath) as! SpotsCollectionViewCell
        cell.setModel(dataArr.objectAtIndex(indexPath.row))
        return cell
    }
}
