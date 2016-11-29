//
//  ViewController.swift
//  iOSHeadPhone
//
//  Created by EDF on 16/11/22.
//  Copyright © 2016年 EDF. All rights reserved.
//

import UIKit

class ViewController: UIViewController,UIGestureRecognizerDelegate {

    @IBOutlet weak var connectView: UIStackView!
    @IBOutlet weak var disconnectView: UIStackView!
    @IBOutlet weak var disconnectInfo: UILabel!
    var isConnect: Bool = true
    @IBOutlet weak var setBtn: UIButton!
    var connecting: Bool = false
    var cacheButtn: UIButton?
    var cacheImage: UIView?
    var unselectedColor: UIColor?
    var arrays: [String]?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.start()
    }
    
    func start(){
        _ = CheckUpdate(_view: self)//监测新版本
        self.navigationController!.interactivePopGestureRecognizer!.delegate = self //设置滑动返回事件代理
        
        let disStr = NSLocalizedString("disconnectInfo", comment: "")
        disconnectInfo.text = disStr
        
        self.navigationItem.title = NSLocalizedString("voiceStyle", comment: "")//设置标题
        changeViewAnimation()//动画效果
        self.navigationController!.navigationBar.barStyle = UIBarStyle.Black
        clicks()//设置按钮点击事件
        readSet()//读取上一次设置的音效
        Logo.start.read()
    }

    
    func clicks(){
        arrays = [NSLocalizedString("styleDefault", comment: ""),NSLocalizedString("styleRock", comment: "")
            ,NSLocalizedString("styleJaze", comment: ""),NSLocalizedString("stylePop", comment: ""),NSLocalizedString("styleClassical", comment: "")]
        let countt = connectView.subviews[1].subviews.count
        print("count:\(countt)")
        var count: Int = 0
        for btn in connectView.subviews[1].subviews{
            let b = btn.subviews[0] as! UIButton
            btn.subviews[1].hidden = true
            b.addTarget(self, action: "点击事件:", forControlEvents: .TouchUpInside)
            b.setTitle(arrays![count] , forState: .Normal)
            b.tag = count
            count++
            if(count==1){
            unselectedColor = b.titleColorForState(.Normal)
            }
        }
    
    }
    func 点击事件(btn: UIButton){
        
//        updateButtonStatus(btn.tag)

        switch btn.tag {
        case 0:
            CLEADevice.shared().changeStyle(0x00)
        case 1:
            CLEADevice.shared().changeStyle(0x01)
        case 2:
            CLEADevice.shared().changeStyle(0x02)
        case 3:
            CLEADevice.shared().changeStyle(0x03)
        case 4:
            CLEADevice.shared().changeStyle(0x04)
        default:
            CLEADevice.shared().changeStyle(0x00)
        }
        
    }
    
    func updateButtonStatus(style: Int){
        
        if style > 4 {return}
        
        if cacheButtn != nil{
            cacheButtn?.selected = false
            cacheImage!.hidden = true
        }
        cacheButtn = connectView.subviews[1].subviews[style].subviews[0] as? UIButton
        cacheImage = connectView.subviews[1].subviews[style].subviews[1]
        cacheButtn?.selected = true
        cacheImage?.hidden = false
        saveStyle(style)//记录所选的音效
        
    }
    
    func saveStyle(key: Int){
        NSUserDefaults.standardUserDefaults().setObject(key, forKey: "voiceStyle")
        NSUserDefaults.standardUserDefaults().synchronize()
    }
    func readSet(){
    
        let value = NSUserDefaults.standardUserDefaults().valueForKey("voiceStyle")
//        print("value:\(value)")
        if value == nil{
            updateButtonStatus(0)
        }else{
        updateButtonStatus(value as! Int)
        }
//        updateButtonStatus(value == nil ? 0 : value)
        
    }
    
    func gestureRecognizerShouldBegin(gestureRecognizer: UIGestureRecognizer) -> Bool {//滑动返回事件
        if (self.navigationController!.viewControllers.count == 1){
            
            return false
            
            }else{

            return true
        }
    }
    
    func connectStatusChange(){
        disconnectView.hidden = isConnect
        connectView.hidden = !isConnect
        setBtn.hidden = !isConnect

    }
    func startViewAnimation(){
        self.connectStatusChange()
        if isConnect {
            self.viewAnimation(self.connectView,isBig: true)
        
        } else {
            self.viewAnimation(self.disconnectView,isBig: true)

        }
    
    }
    func changeViewAnimation(){
        if self.isConnect == connecting {
            return
        }
        isConnect = connecting
        self.connectStatusChange()
        if self.isConnect {
            self.viewAnimation(self.connectView,isBig: true)
            
        }else {
            self.viewAnimation(self.disconnectView,isBig: true)

        }
        

    
    }
    
    func viewAnimation(view: UIView, isBig: Bool){
    
        if isBig{
            view.layer.setAffineTransform(CGAffineTransformMakeScale(0, 0))
            UIView.beginAnimations(nil, context: nil)
            UIView.setAnimationDuration(0.8)
            view.layer.setAffineTransform(CGAffineTransformMakeScale(1.0, 1.0))

        
            UIView.commitAnimations()
        } else {
            view.layer.setAffineTransform(CGAffineTransformMakeScale(1.0, 1.0))
            UIView.beginAnimations(nil, context: nil)
            UIView.setAnimationDuration(0.8)
            view.layer.setAffineTransform(CGAffineTransformMakeScale(0, 0))
            
            UIView.commitAnimations()
        
        }

    
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
        
        let status = dev.getStatus()


        if status == CLEADevice.STATUS_NOT_CONNECTED ||
            status == CLEADevice.STATUS_NOT_RESPONDING {
                connecting = true
        } else {
            if dev.responeStyle < 5 {
//                YMLoadingView.shareInstance().makeToast("数据返回:\(dev.responeStyle)")
                updateButtonStatus(Int(dev.responeStyle))//更新按钮状态
            }
            connecting = true
        }
        self.changeViewAnimation()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
    }
   

}

