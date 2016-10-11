//
//  PKViewController.swift
//  HappyHome
//
//  Created by kaka on 16/10/1.
//  Copyright © 2016年 kaka. All rights reserved.
//

import UIKit

class PKViewController: BaseViewController,UICollectionViewDelegate,UICollectionViewDataSource {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.initfaceView()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func initfaceView(){
        self.title = "PK"
        
        let editButton = UIBarButtonItem.init(title: "PK历史", style: .Plain, target: self, action: #selector(PKViewController.YesterdayPKButtonClick))
        self.navigationItem.leftBarButtonItem =  editButton
        
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .Vertical
        flowLayout.minimumLineSpacing = 5
        flowLayout.minimumInteritemSpacing = 5
        flowLayout.itemSize = CGSizeMake((SCREEN_SIZE.width - 10)/3, (SCREEN_SIZE.width - 10)/3 + 30)
        
        
        let collectionView = UICollectionView.init(frame: CGRectMake(0, navBar_Fheight, SCREEN_SIZE.width, SCREEN_SIZE.height - navBar_Fheight - tabBar_height), collectionViewLayout: flowLayout)
        collectionView.backgroundColor = UIColor.whiteColor()
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.registerClass(SpotsCollectionViewCell.classForCoder(), forCellWithReuseIdentifier: "SpotsCollectionViewCellIdentifier")
        collectionView.backgroundColor = colorForBackground()
        self.view.addSubview(collectionView)
        
    }
    
    //MARK: 事件
    //昨日PK
    func YesterdayPKButtonClick() {
        let vc = PKHistoryViewController()
        self.pushToNextController(vc)
    }
    
    //MARK: UICollectionViewDataSource
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let identifier = "SpotsCollectionViewCellIdentifier"
        let cell:SpotsCollectionViewCell = collectionView.dequeueReusableCellWithReuseIdentifier(identifier, forIndexPath: indexPath) as! SpotsCollectionViewCell
        return cell
    }
    
    //MARK: UICollectionViewDelegate
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let vc = PKDetailViewController()
        self.pushToNextController(vc)
    }


}
