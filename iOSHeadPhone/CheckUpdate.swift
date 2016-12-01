//
//  CheckUpdate.swift
//  CRD42L42-MFi-Demo
//
//  Created by EDF on 16/11/1.
//  Copyright © 2016年 Cirrus Logic, Inc. All rights reserved.
//



import Foundation
import StoreKit

class CheckUpdate: NSObject,SKStoreProductViewControllerDelegate {
//    http://itunes.apple.com/cn/lookup?id=1065779983
//    http://itunes.apple.com/cn/lookup?id=1181257624
    let appId = "1181257624"
    var url: String
    var view: UIViewController
    
    
     init(_view: UIViewController){
//        url = "https://itunes.apple.com/cn/app/lifaair/id\(appId)";
        url = NSString(format: "https://itunes.apple.com/app/id%@", appId) as String
//        url = "https://itunes.apple.com/app/id\(appId)"
        self.view = _view
        super.init()
        self.checkUpdate();
//        self.openAppStore(url)
//        https://itunes.apple.com/cn/app/lifaair/id1065779983?mt=8
    }
    
    private func checkUpdate() {
        let path = NSString(format: "http://itunes.apple.com/cn/lookup?id=%@", appId) as String
        let url = NSURL(string: path)
        let request = NSMutableURLRequest(URL: url!, cachePolicy: NSURLRequestCachePolicy.ReloadIgnoringLocalAndRemoteCacheData, timeoutInterval: 10.0)
        request.HTTPMethod = "POST"
        let dataTask = NSURLSession.sharedSession().dataTaskWithRequest(request){ (data, response, error) -> Void in
            let receiveStatusDic = NSMutableDictionary()
            if data != nil {
                do {
                    let dic = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers)
                    if let resultCount = dic["resultCount"] as? NSNumber {
                        if resultCount.integerValue > 0 {
                            receiveStatusDic.setValue("1", forKey: "status")
                            if let arr = dic["results"] as? NSArray {
                                if let dict = arr.firstObject as? NSDictionary {
                                    if let version = dict["version"] as? String {
                                        receiveStatusDic.setValue(version, forKey: "version")
                                        NSUserDefaults.standardUserDefaults().setObject(version, forKey: "Version")
                                        NSUserDefaults.standardUserDefaults().synchronize()
                                    }
                                }
                            }
                        }
                    }
                }catch let error {
                    
                    log("checkUpdate -------- \(error)", obj: self)
                    receiveStatusDic.setValue("0", forKey: "status")
                }
            }else {
                receiveStatusDic.setValue("0", forKey: "status")            }
            self.performSelectorOnMainThread("checkUpdateWithData:", withObject: receiveStatusDic, waitUntilDone: false)
        }
        dataTask.resume()
    }
    
    @objc private func checkUpdateWithData(data: NSDictionary) {
        let status = data["status"] as? String
        let localVersion = NSBundle.mainBundle().objectForInfoDictionaryKey("CFBundleShortVersionString") as! String
        log("localVersion: \(localVersion)",obj: self)
        if status == "1" {
            let storeVersion = data["version"] as! String
//            log("storeversion: \(storeVersion)",obj: self)
            self.compareVersion(localVersion, storeVersion: storeVersion)
            return
        }
        if let storeVersion = NSUserDefaults.standardUserDefaults().objectForKey("Version") as? String {
            log("storeversion_status: \(storeVersion)",obj: self)
            self.compareVersion(localVersion, storeVersion: storeVersion)
        }
    }
    
    private func compareVersion(localVersion: String, storeVersion: String) {
        if localVersion != storeVersion{
            let title = NSLocalizedString("updateTitle", comment: "")
            let newVersion = NSLocalizedString("lastVersion", comment: "")
            let currentVersion = NSLocalizedString("currentVersion", comment: "")
            let pleaseUpdate = NSLocalizedString("pleaseUpdate", comment: "")
            let ignore = NSLocalizedString("ignore", comment: "")
            let update = NSLocalizedString("update", comment: "")
            
            let controller = UIAlertController(title: title, message: "\(newVersion)\(storeVersion)\n\(currentVersion)\(localVersion)\n\(pleaseUpdate)" , preferredStyle: .Alert)
            let cacleAction = UIAlertAction(title: ignore, style: .Cancel, handler: nil)
            let okAction = UIAlertAction(title: update, style: .Default, handler: { (obj: UIAlertAction) -> Void in
                self.openAppStore(self.url)
            })
            controller.addAction(cacleAction)
            controller.addAction(okAction)
            view.presentViewController(controller, animated: true, completion: nil)
            
        }
        
    }
    
    //************打开appstore*********
    
    func openAppStore(url: String){
//        if let number = url.rangeOfString("[0-9]{9}", options: NSStringCompareOptions.RegularExpressionSearch) {
//            let appId = url.substringWithRange(number)
//            let productView = SKStoreProductViewController()
//            productView.delegate = self
//            productView.loadProductWithParameters([SKStoreProductParameterITunesItemIdentifier : appId], completionBlock: { [weak self](result: Bool, error: NSError?) -> Void in
//                if !result {
//                    productView.dismissViewControllerAnimated(true, completion: nil)
//                    self?.openAppUrl(url)
//                }
//                })
//            view.presentViewController(productView, animated: true, completion: nil)
//        } else {
            openAppUrl(url)
//        }
    }
    
    private func openAppUrl(url: String) {
        let nativeURL = url.stringByReplacingOccurrencesOfString("https:", withString: "itms-apps:")
        if UIApplication.sharedApplication().canOpenURL(NSURL(string:nativeURL)!) {
            UIApplication.sharedApplication().openURL(NSURL(string:url)!)
        }
    }
    
    func productViewControllerDidFinish(viewController: SKStoreProductViewController) {
        viewController.dismissViewControllerAnimated(true, completion: nil)
    }

    
    
}