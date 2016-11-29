//
//  Logo.swift
//  CRD42L42-MFi-Demo
//
//  Created by EDF on 16/11/15.
//  Copyright © 2016年 Cirrus Logic, Inc. All rights reserved.
//

import Foundation

class Logo: NSObject {

    static let start = Logo()
    var url : NSURL?
    var data: NSMutableData?
    
    
    override init() {
        super.init()
//        if !DEBUG {return}
        var sp = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .AllDomainsMask, true)
        if sp.count > 0{
         url = NSURL(fileURLWithPath: "\(sp[0])/data.txt")
            print("url: \(url)")
//            read()
            self.data = NSMutableData()
           
        }
    }
    
    func save(var strLog: String){
//        if !DEBUG {return}
        strLog = "\n\(strLog)"
        data!.appendData(NSData(data: strLog.dataUsingEncoding(NSUTF8StringEncoding)!))
        data!.writeToFile(url!.path!, atomically: true)
    
    }
    
    func read() -> NSString{
//        if !DEBUG {return ""}
        var result: NSString = ""
        do{
        result = try NSString(contentsOfURL: url!, encoding: NSUTF8StringEncoding)
        print("logo:>>>>>>>\n\(result)\n<<<<<<<<<")
        }catch let error as NSError{
        print("error:\(error)")
        }
        return result
    }
    

}
