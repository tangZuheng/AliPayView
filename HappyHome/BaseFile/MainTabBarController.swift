//
//  MainTabBarController.swift
//  HappyHome
//
//  Created by kaka on 16/10/1.
//  Copyright © 2016年 kaka. All rights reserved.
//

import UIKit

class MainTabBarController: UITabBarController,UIGestureRecognizerDelegate {
    
    var viewControllersArr:NSMutableArray?
    
    let vcTitles = NSArray.init(array:["听听", "练习", "PK", "评委","我的"])
    let vcImages = NSArray.init(array:["听听.png", "练习.png", "PK.png", "评委.png","我的.png"])
    let vcSelectedImages = NSArray.init(array:["听听-亮.png", "练习-亮.png", "PK-亮.png", "评委-亮.png","我的-亮.png"])
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.initializeDataSource()
        self.initializeAppearance()
        
//        for item in self.tabBar.items! {
//            item.imageInsets = UIEdgeInsetsMake(-2, 0, 2, 0)
//        }
//        UITabBarItem.appearance().setTitleTextAttributes([NSForegroundColorAttributeName : RGB(108, G: 108, B: 108)], forState: .Normal)
//        UITabBarItem.appearance().setTitleTextAttributes([NSFontAttributeName : UIFont.systemFontOfSize(9)], forState: .Normal)
//        UITabBarItem.appearance().setTitleTextAttributes([NSForegroundColorAttributeName : RGB(237, G: 46, B: 46)], forState: .Selected)
//        UITabBarItem.appearance().setTitleTextAttributes([NSFontAttributeName : UIFont.systemFontOfSize(9)], forState: .Selected)
//     
//        let vcImages = NSArray.init(array:["听听.png", "练习.png", "PK.png", "评委.png","我的.png"]);
//        let vcSelectedImages = NSArray.init(array:["听听-亮.png", "练习-亮.png", "PK-亮.png", "评委-亮.png","我的-亮.png"]);
        
        var count:Int = 0;
        let items = self.tabBar.items
        for item in items! as [UITabBarItem] {
            var image:UIImage = UIImage(named: self.vcImages[count] as! String)!
            var selectedimage:UIImage = UIImage(named: self.vcSelectedImages[count] as! String)!;
            image = image.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal);
            selectedimage = selectedimage.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal);
            item.selectedImage = selectedimage;
            item.image = image;
            count = count + 1
        }
        
    }
    
    override func shouldAutorotate() -> Bool {
        return false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func initializeDataSource() {
        self.viewControllersArr = NSMutableArray()
        let controllersTitles = NSArray.init(array: ["HappyHome.ListenViewController","HappyHome.TrainingViewController","HappyHome.PKViewController","HappyHome.JudgeViewController","HappyHome.UserViewController"])
        for i in 0...vcImages.count-1 {
            
            let classType: AnyObject.Type=NSClassFromString(controllersTitles.objectAtIndex(i) as! String)!
            let nsobjectype : UIViewController.Type = classType as! UIViewController.Type
            let viewController: UIViewController = nsobjectype.init()
            
            let navvc = self .navigationControllerWithRootVC(viewController,title:vcTitles.objectAtIndex(i) as! String, img:vcImages.objectAtIndex(i) as! String , selImg: vcSelectedImages.objectAtIndex(i) as! String)
            self.viewControllersArr?.addObject(navvc)
            
        }
        
    }
    
    func initializeAppearance() {
        self.tabBar.tintColor = colorForTabBar()
        
        let viewControllers:Array<UIViewController> = NSArray.init(array: self.viewControllersArr!) as! Array<UIViewController>
        self.setViewControllers(viewControllers, animated: false)
    }
    
    func navigationControllerWithRootVC(rootVC:UIViewController,title:String,img:String,selImg:String) -> UINavigationController {
        rootVC.tabBarItem.title = title
        rootVC.tabBarItem.image = UIImage.init(named: img)
        rootVC.tabBarItem.selectedImage = UIImage.init(named: selImg)
        let navvc = UINavigationController.init(rootViewController: rootVC)
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
        navvc.interactivePopGestureRecognizer!.enabled = true
        return navvc
    }
}
