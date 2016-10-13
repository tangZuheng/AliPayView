//
//  PKViewController.swift
//  HappyHome
//
//  Created by kaka on 16/10/1.
//  Copyright © 2016年 kaka. All rights reserved.
//

import UIKit

class PKViewController: BaseViewController,UICollectionViewDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.initfaceView()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        ScenicCollectionView.sharedManager.collectionView.delegate = self
        self.view.addSubview(ScenicCollectionView.sharedManager)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func initfaceView(){
        self.title = "PK"
        
        let editButton = UIBarButtonItem.init(title: "PK历史", style: .Plain, target: self, action: #selector(PKViewController.YesterdayPKButtonClick))
        editButton.setTitleTextAttributes([NSForegroundColorAttributeName: colorForNavigationBarTitle(),NSFontAttributeName:UIFont.systemFontOfSize(14)], forState: .Normal)
        self.navigationItem.leftBarButtonItem =  editButton

        let kingButton = UIButton()
        kingButton.frame = CGRectMake(0, 0, 100, 44)
        kingButton.setTitle(DistrictManageModel.sharedManager.selectDistrict?.name, forState: .Normal)
        kingButton.setImage(UIImage.init(named: "xiala"), forState: .Normal)
        kingButton.titleLabel?.font = UIFont.systemFontOfSize(14)
        kingButton.titleLabel!.textAlignment = .Center
        kingButton.setTitleColor(colorForNavigationBarTitle(), forState: .Normal)
        kingButton.titleEdgeInsets = UIEdgeInsetsMake(0, -kingButton.imageView!.image!.size.width-5, 0, kingButton.imageView!.image!.size.width)
        kingButton.imageEdgeInsets = UIEdgeInsetsMake(0, kingButton.titleLabel!.bounds.size.width-5, 0, -kingButton.titleLabel!.bounds.size.width)
        kingButton.contentHorizontalAlignment = .Right
        
        kingButton.rac_signalForControlEvents(UIControlEvents.TouchUpInside).subscribeNext { _ in
            let vc = SelectKindViewController()
            self.pushToNextController(vc)
        }
        let kingButtonItem = UIBarButtonItem.init(customView: kingButton)
        self.navigationItem.rightBarButtonItem =  kingButtonItem
        
        NSNotificationCenter.defaultCenter().rac_addObserverForName(UpdateDistrictNotification, object: nil).subscribeNext { _ in
            kingButton.setTitle(DistrictManageModel.sharedManager.selectDistrict?.name, forState: .Normal)
            kingButton.titleEdgeInsets = UIEdgeInsetsMake(0, -kingButton.imageView!.image!.size.width-5, 0, kingButton.imageView!.image!.size.width)
            kingButton.imageEdgeInsets = UIEdgeInsetsMake(0, kingButton.titleLabel!.bounds.size.width-5, 0, -kingButton.titleLabel!.bounds.size.width)
        }
    }
    
    //MARK: 事件
    //昨日PK
    func YesterdayPKButtonClick() {
        let vc = PKHistoryViewController()
        self.pushToNextController(vc)
    }
    
    //MARK: UICollectionViewDelegate
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let vc = PKDetailViewController()
        vc.model = ScenicCollectionView.sharedManager.dataArr.objectAtIndex(indexPath.row) as! ScenceModel
        self.pushToNextController(vc)
    }
}
