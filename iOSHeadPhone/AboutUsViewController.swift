//
//  AboutUsViewController.swift
//  iOSHeadPhone
//
//  Created by EDF on 16/11/24.
//  Copyright © 2016年 EDF. All rights reserved.
//

import UIKit

class AboutUsViewController: UIViewController {

    @IBOutlet weak var 关于我们: UITextView!
    var timer: NSTimer?
    @IBAction func 返回(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.automaticallyAdjustsScrollViewInsets = false
        self.navigationItem.title = NSLocalizedString("aboutUs", comment: "")
        
        
//        dispatch_sync(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0)) { () -> Void in
//            let info =  NSLocalizedString("manbuzheInfo", comment: "")
//            dispatch_sync(dispatch_get_main_queue(), { () -> Void in
//                self.关于我们.text = info
//            })
//            
//        }
        timer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: "timerfunc", userInfo: nil, repeats: false)
        timer?.fire()
        
    }
    func timerfunc(){
        let info =  NSLocalizedString("manbuzheInfo", comment: "")
        self.关于我们.text = info
    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    deinit{
    timer?.invalidate()
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
