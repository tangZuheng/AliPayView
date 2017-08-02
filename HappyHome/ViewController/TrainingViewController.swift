//
//  TrainingViewController.swift
//  HappyHome
//
//  Created by kaka on 16/10/1.
//  Copyright © 2016年 kaka. All rights reserved.
//

import UIKit

class TrainingViewController: BaseViewController,UICollectionViewDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.initfaceView()
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
        self.title = "练习"

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
    
    //MARK: UICollectionViewDelegate
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let vc = TrainingDetailViewController()
        vc.model = ScenicCollectionView.sharedManager.dataArr.objectAtIndex(indexPath.row) as! ScenceModel
        self.pushToNextController(vc)
    }
    
}
