//
//  UpdateHeadPhoneViewController.swift
//  iOSHeadPhone
//
//  Created by EDF on 16/11/23.
//  Copyright © 2016年 EDF. All rights reserved.
//

import UIKit

class UpdateHeadPhoneViewController: UIViewController {

    @IBOutlet weak var 当前版本: UILabel!
    
    @IBOutlet weak var 进度: UILabel!
    @IBOutlet weak var 进度条: UIProgressView!
    @IBOutlet weak var 升级固件: UIButton!
    @IBOutlet weak var 最新版本: UILabel!
    var currentVersionStr: String?
    var newVersionStr: String?
    var updateStr: String?
        @IBAction func 点击升级固件(sender: AnyObject) {
            进度条.hidden = false
            进度.hidden = false
            升级固件.hidden = true
            CLEADevice.shared().updateFw()
        }
    @IBAction func 返回(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        currentVersionStr = NSLocalizedString("currentHeadPhoneVersion", comment: "")
        newVersionStr = NSLocalizedString("newHeadPhoneVersion", comment: "")
        updateStr = NSLocalizedString("updateHeadPhone", comment: "")

        升级固件.setTitle(updateStr, forState: .Normal)
        当前版本.text = currentVersionStr
        最新版本.text = newVersionStr
        进度.text = "0%"
        进度条.setProgress(0, animated: true)
        进度条.hidden = true
        进度.hidden = true
        Logo.start.read()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func clEAStatusChanged(notification: NSNotification) {
        log("CL EADevice status changed!", obj: self)
        updateStatus()
    }
    
    override func viewWillAppear(animated: Bool) {
        log(" Device view!", obj: self)
        UIApplication.sharedApplication().statusBarStyle = UIStatusBarStyle.LightContent
        let dev = CLEADevice.shared()
        if !dev.busy() {
            dev.updateDeviceStatus()
        }
        updateStatus()
        
        super.viewWillAppear(animated)
//        
        
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "clEAStatusChanged:", name: CLEADevice.HwStateChangedNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "clEAStatusChanged:", name: UIApplicationWillEnterForegroundNotification, object: nil)
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        log(" Device view!", obj: self)
        
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }

    private func updateStatus() {
        let dev = CLEADevice.shared()
        当前版本.text = currentVersionStr!+"V\(dev.fwRevision)"
        最新版本.text = newVersionStr!+"V\(dev.loadedFWVersion)"
        
        let status = dev.getStatus()
        var info = ""
        switch status {
        case CLEADevice.STATUS_NOT_CONNECTED:
            info = "Status: Not connected"
        case CLEADevice.STATUS_NOT_RESPONDING:
            log("Status: Not responding",obj: self)
            info = "Status: Not responding"
        case CLEADevice.STATUS_WAITING_RESPONSE:
            info = "Status: Requesting status..."
            //准备阶段1
        case CLEADevice.STATUS_FW_IS_RUNNING:
            info = "Status: FW v\(dev.fwVersion) is running"
//            准备阶段2
            当前版本.text = currentVersionStr!+"V\(dev.fwRevision)"
            最新版本.text = newVersionStr!+"V\(dev.loadedFWVersion)"
        

        case CLEADevice.STATUS_WAITING_FW_DATA:
            let bnum = Float(CLEADevice.shared().getFlashingBlkNum()-35)
            let count = Float(CLEADevice.shared().getFlashingTotoalCount()-35)
            let r2 = Float(String(format: "%.2f", bnum/count))
            进度条.setProgress(1-r2!, animated: true)
            进度.text = "\((1-r2!)*100)%"
            if(r2==0){
//                进度条.hidden = true
                进度.text = NSLocalizedString("updateOver", comment: "");
            }
            
            info = "Status: " + (bnum < 0 ?
                "No FW, waiting for FW blocks to flash" : "Flashing FW block \(1-r2!) bnum:\(bnum) count:\(count) r2:\(r2)")
//            YMLoadingView.shareInstance().showTitle("\(bnum)%")
//            Logo.start.save("\(bnum)%\n")
            
        case CLEADevice.STATUS_FAILED:
            let bnum = CLEADevice.shared().getFlashingBlkNum()
            info = "Status: " + (bnum < 0 ? "Failed" : "Flashing FW block \(bnum) failed")
        default:
            info = "**** Device internal error \(status)"
            
        }
//        Logo.start.save("\(info)\n")
        log(info,obj: self)
        
        if status == CLEADevice.STATUS_NOT_CONNECTED ||
            status == CLEADevice.STATUS_NOT_RESPONDING {
//                self.navigationController?.popViewControllerAnimated(true)
        } else {
            
        }
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
