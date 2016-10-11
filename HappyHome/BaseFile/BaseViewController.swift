//
//  BaseViewController.swift
//  1919sendImmediately_S
//
//  Created by kaka on 16/9/12.
//  Copyright © 2016年 kaka. All rights reserved.
//

import UIKit
import SnapKit

class BaseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        UIApplication.sharedApplication().setStatusBarStyle(UIStatusBarStyle.LightContent, animated: true)
        
        self.navigationController!.navigationBar.tintColor = colorForNavigationBarTitle()
        self.navigationController!.navigationBar.barTintColor = UIColor.whiteColor()
        self.navigationController!.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: colorForNavigationBarTitle()]
        self.navigationController!.navigationBar.alpha = 1
        
        self.view.backgroundColor                            = colorForBackground()
        self.automaticallyAdjustsScrollViewInsets            = false
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //跳转到UIViewController
    func pushToNextController(nextVC:UIViewController) -> Void {
        let goback_item = UIBarButtonItem.init(title: "", style: .Plain, target: nil, action: nil)
        self.navigationItem.backBarButtonItem = goback_item
        nextVC.hidesBottomBarWhenPushed = true
        self.view.endEditing(true)
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
    
    func pushToNextController(nextVC:UIViewController,withVCTitle:String) -> Void {
        let goback_item = UIBarButtonItem.init(title: "", style: .Plain, target: nil, action: nil)
        self.navigationItem.backBarButtonItem = goback_item
        nextVC.title = title
        nextVC.hidesBottomBarWhenPushed = true
        self.view.endEditing(true)
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
   
    //开始加载MBProgressHUD
    func startMBProgressHUD() {
        ZCMBProgressHUD.startMBProgressHUD(self.navigationController?.view)
    }
    
    func stopMBProgressHUD() {
        ZCMBProgressHUD.stopMBProgressHUD(self.navigationController?.view)
    }
    
    func showResultHUDWithResult(result:Bool,text:String) {
        ZCMBProgressHUD.showResultHUDWithResult(result, andText: text, toView: self.navigationController?.view)
    }
}
