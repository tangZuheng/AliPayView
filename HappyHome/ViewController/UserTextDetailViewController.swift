//
//  UserTextDetailViewController.swift
//  HappyHome
//
//  Created by kaka on 16/10/20.
//  Copyright © 2016年 kaka. All rights reserved.
//

import UIKit

class UserTextDetailViewController: BaseViewController {
    
    var textImageName:String!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.initfaceView()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.navigationController!.navigationBarHidden = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func initfaceView(){
        let scrollView = UIScrollView.init()
//        scrollView.bounces = false
        self.view.addSubview(scrollView)
        scrollView.snp_makeConstraints { (make) in
            make.width.equalToSuperview()
            make.centerX.equalToSuperview()
            make.top.equalTo(navBar_Fheight)
            make.bottom.equalToSuperview()
        }
        
        let img = UIImageView()
        img.image = UIImage.init(named: textImageName)
        img.contentMode = .ScaleToFill
        scrollView.addSubview(img)
        img.snp_makeConstraints { (make) in
            make.width.equalToSuperview()
            make.centerX.equalToSuperview()
            make.top.equalTo(0)
            make.height.equalTo(img.image!.size.height/(img.image!.size.width/SCREEN_WIDTH))
//            make.bottom.equalToSuperview()
        }
        scrollView.contentSize = CGSizeMake(SCREEN_WIDTH, img.image!.size.height/(img.image!.size.width/SCREEN_WIDTH))
    }
    
}
