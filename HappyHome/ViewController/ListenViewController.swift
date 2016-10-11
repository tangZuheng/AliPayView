//
//  ListenViewController.swift
//  HappyHome
//
//  Created by kaka on 16/10/1.
//  Copyright © 2016年 kaka. All rights reserved.
//

import UIKit

class ListenViewController: BaseViewController,UICollectionViewDelegate,UICollectionViewDataSource {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.initfaceView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func initfaceView(){
        self.title = "听听"
        let kindButton = UIButton()
        kindButton.setImage(UIImage.init(named: "xaila"), forState: .Normal)
        
        ScenceManage.sharedManager.getScenceList()
        
//
//        _addressButton = [UIButton buttonWithType:UIButtonTypeCustom];
//        _addressButton.frame = CGRectMake(0, 0, 80, 44);
//        [_addressButton setImage:IMAGE_NAME(@"kinds_xiala_icon") forState:UIControlStateNormal];
//        [_addressButton setTitle:[DistrictManageModel shareInstance].selectDistrict.name forState:UIControlStateNormal];
//        _addressButton.titleLabel.textAlignment = NSTextAlignmentCenter;
//        _addressButton.titleLabel.font = [UIFont systemFontOfSize:14];
//        [_addressButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//        [_addressButton setBackgroundColor:[UIColor clearColor]];
//        [_addressButton setTitleEdgeInsets:UIEdgeInsetsMake(0, -_addressButton.imageView.image.size.width-5, 0, _addressButton.imageView.image.size.width)];
//        [_addressButton setImageEdgeInsets:UIEdgeInsetsMake(0, _addressButton.titleLabel.bounds.size.width + 10, 0, -_addressButton.titleLabel.bounds.size.width-5)];
//        [_addressButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
//        [_addressButton addTarget:self action:@selector(addressButtonClick:) forControlEvents:UIControlEventTouchUpInside];
//        
//        let address = UIBarButtonItem.init(customView: <#T##UIView#>)
//        UIBarButtonItem *address = [[UIBarButtonItem alloc] initWithCustomView:self.addressButton];
//        self.navigationItem.rightBarButtonItem = address;
//        [self.view addSubview:self.collectionView];
        
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
        let vc = ListenListViewController()
        self.pushToNextController(vc)
    }

}
