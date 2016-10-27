//
//  UserViewController.swift
//  HappyHome
//
//  Created by kaka on 16/10/1.
//  Copyright © 2016年 kaka. All rights reserved.
//

import UIKit

class UserViewController: BaseViewController,UITableViewDataSource,UITableViewDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
    let titleArr = NSArray.init(objects: NSArray.init(objects: "PK记录","昨日PK","我的练习"),NSArray.init(objects: "意见反馈","系统消息","PK规则","评委规则","FAQ/常见问题"),NSArray.init(objects: "关于我们","账户管理"))
    let imgArr = NSArray.init(objects: NSArray.init(objects: "PK记录","昨日PK","我的练习"),NSArray.init(objects: "意见反馈","系统消息","PK规则","评委规则","FAQ"),NSArray.init(objects: "关于我们","账户管理"))
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.initfaceView()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.navigationController!.navigationBarHidden = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func initfaceView(){
        
        let heardeView = UserHeardeView()
        heardeView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 180 * SCREEN_SCALE)
        heardeView.loginButton!.rac_signalForControlEvents(UIControlEvents.TouchUpInside).subscribeNext { _ in
            let vc = LoginViewController()
            self.pushToNextController(vc)
        }
        
        heardeView.registerButton!.rac_signalForControlEvents(UIControlEvents.TouchUpInside).subscribeNext { _ in
            let vc = RegisterViewController()
            self.pushToNextController(vc)
        }

        heardeView.userHeadButton!.rac_signalForControlEvents(UIControlEvents.TouchUpInside).subscribeNext { _ in
            //上传头像
            let actionSheet = UIAlertController(title: "上传头像", message: nil, preferredStyle: .ActionSheet)
            let cancelBtn = UIAlertAction(title: "取消", style: .Cancel, handler: nil)
            
            
            let takePhotos = UIAlertAction(title: "拍照", style: .Destructive, handler: {
                (action: UIAlertAction) -> Void in
                //判断是否能进行拍照，可以的话打开相机
                if UIImagePickerController.isSourceTypeAvailable(.Camera) {
                    let picker = UIImagePickerController()
                    picker.sourceType = .Camera
                    picker.delegate = self
                    picker.allowsEditing = true
                    self.presentViewController(picker, animated: true, completion: nil)
                    
                }
                else
                {
                    print("模拟其中无法打开照相机,请在真机中使用");
                }
                
            })
            let selectPhotos = UIAlertAction(title: "相册选取", style: .Default, handler: {
                (action:UIAlertAction)
                -> Void in
                //调用相册功能，打开相册
                let picker = UIImagePickerController()
                picker.sourceType = .PhotoLibrary
                picker.delegate = self
                picker.allowsEditing = true
                self.presentViewController(picker, animated: true, completion: nil)
                
            })
            actionSheet.addAction(cancelBtn)
            actionSheet.addAction(takePhotos)
            actionSheet.addAction(selectPhotos)
            self.presentViewController(actionSheet, animated: true, completion: nil)
            
        }
        
        let tableView = UITableView.init()
        tableView.dataSource = self
        tableView.delegate = self
        self.view.addSubview(tableView)
        tableView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGH-tabBar_height)
        tableView.tableHeaderView = heardeView
    }
    
    //MARK: UITableViewDataSource
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return titleArr.count
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let arr = titleArr.objectAtIndex(section)
        return arr.count
    }
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == 2 {
            return 1
        }
        return 10
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let identifir = "UITableViewCellUserIdentifir"
        var cell = tableView.dequeueReusableCellWithIdentifier(identifir)
        if cell == nil {
            cell = UITableViewCell.init(style: .Default, reuseIdentifier: identifir)
            cell?.accessoryType = .DisclosureIndicator
            cell?.selectionStyle = .None
            cell?.textLabel?.font = UIFont.systemFontOfSize(16)
            cell?.textLabel?.textColor = UIColor.init(rgb: 0x282828)
        }
        let titleArr_secton = titleArr.objectAtIndex(indexPath.section)
        let imgArr_secton = imgArr.objectAtIndex(indexPath.section)
        
        cell?.textLabel?.text = titleArr_secton.objectAtIndex(indexPath.row) as? String
        cell?.imageView?.image = UIImage.init(named: imgArr_secton.objectAtIndex(indexPath.row) as! String)
        return cell!
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if !UserModel.sharedUserModel.isLogin {
            self.pushLoginController()
            return
        }
        if indexPath.section == 0 {
            if indexPath.row == 0 {
                let vc = PKHistoryViewController()
                self.pushToNextController(vc)
            }
            else if indexPath.row == 1 {
                let vc = YesterdayPKViewController()
                self.pushToNextController(vc)
            }
            else if indexPath.row == 2 {
                let vc = MyTrainingRecordViewController()
                self.pushToNextController(vc)
            }
        }
        else if indexPath.section == 1 {
            if indexPath.row == 0 {
                let vc = FeedbackViewController()
                self.pushToNextController(vc)
            }
            else if indexPath.row == 1 {
                
            }
            else if indexPath.row == 2 {
                let vc = UserTextDetailViewController()
                vc.textImageName = "PK规则_detail"
                self.pushToNextController(vc, withVCTitle: "PK规则")
            }
            else if indexPath.row == 3 {
                let vc = UserTextDetailViewController()
                vc.textImageName = "评论规则_detail"
                self.pushToNextController(vc, withVCTitle: "评论规则")
            }
            else if indexPath.row == 4 {
                let vc = UserTextDetailViewController()
                vc.textImageName = "FQA_detail"
                self.pushToNextController(vc, withVCTitle: "FQA")
            }
        }
        else if indexPath.section == 2 {
            if indexPath.row == 0 {
                let vc = AboutUsViewController()
                self.pushToNextController(vc)
            }
            else {
                let vc = AccountManageViewController()
                self.pushToNextController(vc)
            }
            
        }
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        self.dismissViewControllerAnimated(true, completion: { () -> Void in
            
        })
    }
    
    func fixOrientation(aImage: UIImage) -> UIImage { //处理头像图片角度问题
        // No-op if the orientation is already correct
        if aImage.imageOrientation == .Up {
            return aImage
        }
        // We need to calculate the proper transformation to make the image upright.
        // We do it in 2 steps: Rotate if Left/Right/Down, and then flip if Mirrored.
        var transform: CGAffineTransform = CGAffineTransformIdentity
        switch aImage.imageOrientation {
        case .Down, .DownMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, aImage.size.height)
            transform = CGAffineTransformRotate(transform, CGFloat(M_PI))
        case .Left, .LeftMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, 0)
            transform = CGAffineTransformRotate(transform, CGFloat(M_PI_2))
        case .Right, .RightMirrored:
            transform = CGAffineTransformTranslate(transform, 0, aImage.size.height)
            transform = CGAffineTransformRotate(transform, CGFloat(-M_PI_2))
        default:
            break
        }
        switch aImage.imageOrientation {
        case .UpMirrored, .DownMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, 0)
            transform = CGAffineTransformScale(transform, -1, 1)
        case .LeftMirrored, .RightMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.height, 0)
            transform = CGAffineTransformScale(transform, -1, 1)
        default:
            break
        }
        
        let ctx: CGContextRef = CGBitmapContextCreate(nil, Int(aImage.size.width), Int(aImage.size.height), CGImageGetBitsPerComponent(aImage.CGImage!), 0, CGImageGetColorSpace(aImage.CGImage!)!, CGImageGetBitmapInfo(aImage.CGImage!).rawValue)!
        CGContextConcatCTM(ctx, transform)
        switch aImage.imageOrientation {
        case .Left, .LeftMirrored, .Right, .RightMirrored:
            // Grr...
            CGContextDrawImage(ctx, CGRectMake(0, 0, aImage.size.height, aImage.size.width), aImage.CGImage!)
        default:
            CGContextDrawImage(ctx, CGRectMake(0, 0, aImage.size.width, aImage.size.height), aImage.CGImage!)
        }
        // And now we just create a new UIImage from the drawing context
        let cgimg: CGImageRef = CGBitmapContextCreateImage(ctx)!
        let img: UIImage = UIImage(CGImage: cgimg)
        return img
    }
    
    //MARK: imagePickerController代理
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        self.dismissViewControllerAnimated(true, completion: { () -> Void in
            
        })
        //修正图片的位置
        let image = fixOrientation((info[UIImagePickerControllerOriginalImage] as! UIImage))
        //先把图片转成NSData
        let data = UIImageJPEGRepresentation(image, 0.5)
        //图片保存的路径
        //这里将图片放在沙盒的documents文件夹中
        //Home目录
        let homeDirectory = NSHomeDirectory()
        let documentPath = homeDirectory + "/Documents"
        //文件管理器
        let fileManager: NSFileManager = NSFileManager.defaultManager()
        
        let urls = fileManager.URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
        let documentDirectory = urls[0] as NSURL
        let fileURL = documentDirectory.URLByAppendingPathComponent("/image.png")
        
        //把刚刚图片转换的data对象拷贝至沙盒中 并保存为image.png
        do {
            try fileManager.removeItemAtURL(fileURL!)
            try fileManager.createDirectoryAtPath(documentPath, withIntermediateDirectories: true, attributes: nil)
        }
        catch _ {
            
        }
        fileManager.createFileAtPath(documentPath.stringByAppendingString("/image.png"), contents: data, attributes: nil)
        
        self.startMBProgressHUD()
        //发送请求上传头像的网络请求
        NetWorkingManager.sharedManager.uploadHead(fileURL!) { (retObject, error) in
            self.stopMBProgressHUD()
            if error == nil {
                let dic = retObject?.valueForKey("data") as! NSDictionary
                UserModel.sharedUserModel.setUserModel(dic)
                UserModel.sharedUserModel.savaUserModel()
                NSNotificationCenter.defaultCenter().postNotificationName(LoginStateUpdateNotification, object: nil)
//                self.navigationController?.popToRootViewControllerAnimated(true)
            }
            else {
                self.showFailHUDWithText(error!.localizedDescription)
            }
        }
    }
    
}
