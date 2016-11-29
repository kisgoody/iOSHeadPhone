//
//  YMLoadingView.swift
//  YMB
//
//  Created by shiji on 15-4-3.
//  Copyright (c) 2015年 shiji. All rights reserved.
//

import Foundation
import UIKit


// 屏幕大小
let kFrameSize:CGSize = UIScreen.mainScreen().bounds.size

class YMLoadingView: UIView {
    
    
    var loadingLab:UILabel!
    var mask:UIControl!
    
    var timer:NSTimer!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.alpha = 1
        self.opaque = false
        self.layer.masksToBounds = true;
        self.layer.cornerRadius = 10;
        self.layer.borderColor = UIColor.grayColor().CGColor;
        self.backgroundColor = UIColor.clearColor()
        
        
        let point:CGPoint  = self.center
        self.frame = CGRectMake(point.x-50, point.y-50, 100, 100)
        
        let tmpView = UIView(frame: CGRectMake(0, 0, 100, 100))
        tmpView.backgroundColor = UIColor.blackColor()
        tmpView.alpha = 0.8
        tmpView.layer.masksToBounds = true;
        tmpView.layer.cornerRadius = 10;
        self.addSubview(tmpView)
        //
        let activityIndicator:UIActivityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.WhiteLarge)
        activityIndicator.hidesWhenStopped = true
        activityIndicator.hidden = true
        activityIndicator.startAnimating()
        activityIndicator.center = CGPointMake(50, 50)
        self.addSubview(activityIndicator)
        
        loadingLab = UILabel(frame: CGRectMake(0, 70, 100, 20));
        loadingLab.backgroundColor = UIColor.clearColor();
        loadingLab.textAlignment = NSTextAlignment.Center
        loadingLab.textColor = UIColor.whiteColor()
        loadingLab.font = UIFont.systemFontOfSize(15);
        self.addSubview(loadingLab)
        
        // 添加超时定时器
        timer = NSTimer(timeInterval: 30, target: self, selector: "timerDeadLine", userInfo: nil, repeats: false)
        
    }
    
    class func shareInstance()->YMLoadingView{
        struct YMSingleton{
            static var predicate:dispatch_once_t = 0
            static var instance:YMLoadingView? = nil
        }
        dispatch_once(&YMSingleton.predicate,{
            YMSingleton.instance=YMLoadingView(frame: CGRectZero)
            }
        )
        return YMSingleton.instance!
    }
    
    func showTitle(title:String) {
        loadingLab.text = title;
    }
    
    
    func showInView(view:UIView) {
        if mask==nil {
            mask = UIControl(frame: UIScreen.mainScreen().bounds)
            mask.backgroundColor = UIColor.clearColor()
            mask.addSubview(self)
            UIApplication.sharedApplication().keyWindow?.addSubview(mask)
            self.center = view.center
            mask.alpha = 1
        }
        mask.hidden = false
        // 添加定时器
        if timer != nil {
            NSRunLoop.mainRunLoop().addTimer(timer, forMode: NSRunLoopCommonModes)
        }
    }
    
    func timerDeadLine(){
        self.hideView()
        makeToast("请求超时")
    }
    
    func hideView() {
        if NSThread.currentThread().isMainThread{
            self.removeView()
        }
        else {
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.removeView()
            })

        }
    }
    
    func removeView(){
        if mask != nil {
//            UIView.beginAnimations("animation", context: nil)
//            UIView.setAnimationDuration(0.2)
//            UIView.setAnimationDelegate(self)
//            UIView.setAnimationDidStopSelector("stopAnimation")
//            UIView.setAnimationDelay(0.1)
//            self.transform = CGAffineTransformConcat(CGAffineTransformIdentity, CGAffineTransformMakeScale(0.5, 0.5))
//            UIView.commitAnimations()
//            self.stopAnimation()
            mask.hidden = true
            timer.invalidate()
        }
    }
    
    func stopAnimation(){
        if mask != nil {
            mask.removeFromSuperview()
            mask = nil
        }
    }
    
    ///////////////////////
    func makeToast(strTitle: String) {
//        NSThread.sleepForTimeInterval(0.4)
        if NSThread.currentThread().isMainThread{
            _ = ToastClass(text: strTitle)
        }
        else {
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                _ = ToastClass(text: strTitle)
            })
        }
        
    }
    
    class func showNetIndicator(){
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
    }
    
    class func hidenNetIndicator(){
        UIApplication.sharedApplication().networkActivityIndicatorVisible = false
    }
//    func showTextOnMainThread(strTitle:String) {
//        var toastClass:ToastClass = ToastClass(text: strTitle)
//    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        fatalError("init(coder:) has not been implemented")
    }
}

// 显示toast
class ToastClass:NSObject {
    
    var toastSetting:ToastSettingClass!
    var frameMarginSize:CGFloat! = 10
    var frameSize:CGSize = CGSizeMake(kFrameSize.width-40, 60)
    var view:UIView!
    init(text:String) {
        super.init()
        toastSetting = ToastSettingClass()
        let textFont = toastSetting.textFont
        let size:CGSize = self.sizeWithString(text, font: UIFont.systemFontOfSize(textFont))
        
        let label:UILabel = UILabel (frame: CGRectMake(0, 0, size.width, size.height))
        label.text = text
        label.font = UIFont.systemFontOfSize(textFont)
        label.numberOfLines = 0;
        label.textColor = UIColor.whiteColor()
        
        let window:UIWindow = UIApplication.sharedApplication().keyWindow!
//        if (window.rootViewController!){
//            var currentViewCtrl:UIViewController = window.rootViewController!
//        }
        
        
        let v:UIButton = UIButton(frame:CGRectMake(0, 0, size.width + frameMarginSize*2, size.height + frameMarginSize))
        label.center = CGPointMake(v.frame.size.width / 2, v.frame.size.height / 2);
        v.addSubview(label)
        
        v.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.7)
        v.layer.cornerRadius = 5
        var point:CGPoint = CGPointMake(window.frame.size.width/2, window.frame.size.height*2/3);
        point = CGPointMake(point.x , point.y);
        v.center = point
        
        window.addSubview(v)
        view = v
        
        v.addTarget(self, action: "hideToast", forControlEvents: UIControlEvents.TouchDown)
        let timer:NSTimer = NSTimer(timeInterval: 5, target: self, selector: "hideToast", userInfo: nil, repeats: false)
        NSRunLoop.mainRunLoop().addTimer(timer, forMode: NSDefaultRunLoopMode)
    }
    
    func sizeWithString(string:NSString, font:UIFont)->CGSize {
        let dic:NSDictionary = NSDictionary(object: font, forKey: NSFontAttributeName)
        let options = NSStringDrawingOptions.TruncatesLastVisibleLine
        let rect:CGRect = string.boundingRectWithSize(frameSize, options:options, attributes: dic as? [String : AnyObject], context: nil)
        return rect.size
    }
    
    func hideToast(){
        UIView.animateWithDuration(0.2, animations: {
            () -> ()in
            self.view.alpha = 0
            }, completion: {
                (Boolean) -> ()in
                self.view.removeFromSuperview()
        })
        
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class ToastSettingClass:NSObject {
    
    var textFont:CGFloat!
    var duration:CGFloat!
    var position:iToastGravity!
    override init(){
        super.init()
        textFont = 13
        duration = 2
        position = iToastGravity.Center
    }
}


// 枚举类型
enum iToastGravity:Int{
    case Top = 1000001
    case Bottom
    case Center
    func typeName() -> String {
        return "iToastGravity"
    }
}

