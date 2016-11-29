
//
//  SetViewController.swift
//  iOSHeadPhone
//
//  Created by EDF on 16/11/23.
//  Copyright © 2016年 EDF. All rights reserved.
//

import UIKit

class SetViewController: UIViewController {

    @IBOutlet weak var 软件版本: UILabel!
    @IBOutlet weak var 官网: UIView!
    
    @IBOutlet weak var 固件版本信息: UIButton!
    @IBOutlet weak var 关于我们: UIButton!

    @IBAction func 关于我们点击(sender: AnyObject) {
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        let localVersion = NSBundle.mainBundle().objectForInfoDictionaryKey("CFBundleShortVersionString") as! String
        let localStr_appversion = NSLocalizedString("appVersion", comment: "") + "V\(localVersion)"
        软件版本.text = localStr_appversion;
        
        let localStr_headphoneVersion = NSLocalizedString("headPhoneVersion", comment: "")
        固件版本信息.setTitle(localStr_headphoneVersion, forState: .Normal)
        
        let localStr_aboutUs = NSLocalizedString("aboutUs", comment: "")
        关于我们.setTitle(localStr_aboutUs, forState: .Normal)

        
        let localStr_set = NSLocalizedString("set", comment: "")

        self.navigationItem.title = localStr_set
        self.navigationController!.interactivePopGestureRecognizer!.enabled = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func backBtn(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
        
    }

    @IBAction func 官网点击(sender: AnyObject) {
        UIApplication.sharedApplication().openURL(NSURL(string: "http://www.edifier.com")!)
        
    }
   
    


    
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
