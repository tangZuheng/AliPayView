//
//  ListenViewController.swift
//  HappyHome
//
//  Created by kaka on 16/10/1.
//  Copyright © 2016年 kaka. All rights reserved.
//

import UIKit

class ListenViewController: BaseViewController,UICollectionViewDelegate {

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
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
        BeanUtils.setPropertysToNil(self)
    }
    
    func initfaceView(){
        self.title = "听听"
        
        #if DEBUG
        //测试用
        let editButton = UIBarButtonItem.init(title: "修改uid", style: .Plain, target: self, action: #selector(ListenViewController.updateUid))
        editButton.setTitleTextAttributes([NSForegroundColorAttributeName: colorForNavigationBarTitle(),NSFontAttributeName:UIFont.systemFontOfSize(14)], forState: .Normal)
        self.navigationItem.leftBarButtonItem =  editButton
        #endif
        
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
    func selectKindButtonClick() {
        let vc = SelectKindViewController()
        self.pushToNextController(vc)
    }
    
    func updateUid(){
        
        let view = UIAlertView.init(title: "修改Uid", message: "", delegate: nil, cancelButtonTitle: "确定", otherButtonTitles: "取消")
        view.alertViewStyle = .PlainTextInput
        
        let nameField = view.textFieldAtIndex(0)
//        UITextField *nameField = [view textFieldAtIndex:0];
        nameField?.text = String(UserModel.sharedUserModel.uid)
        
        view.rac_buttonClickedSignal().subscribeNext({ (indexNumber) in
            if indexNumber as! Int == 0 {
                UserModel.sharedUserModel.uid =  Int.init((nameField?.text)!)
            }
            else {
                
            }
        })
        
        view.show()
        
        
    }
    
    //MARK: UICollectionViewDelegate
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let vc = ListenListViewController()
        vc.model = ScenicCollectionView.sharedManager.dataArr.objectAtIndex(indexPath.row) as! ScenceModel
        self.pushToNextController(vc)
    }
    
    

}
