//
//  AloeDeviceUtil.swift
//  Pods
//
//  Created by kawase yu on 2015/09/16.
//
//

import UIKit
import CoreTelephony

open class AloeDevice: NSObject {
    
    open class func is35Inch()->Bool{
        return (windowHeight() < 568)
    }
    
    open class func windowHeight()->CGFloat{
        return UIScreen.main.bounds.size.height
    }
    
    open class func windowWidth()->CGFloat{
        return UIScreen.main.bounds.size.width
    }
    
    open class func windowFrame()->CGRect{
        return UIScreen.main.bounds
    }
    
    open class func osVersion()->Float{
        return (UIDevice.current.systemVersion as NSString).floatValue
    }
    
    // 未満
    open class func lessThan(_ majorVersion:Int)->Bool{
        return (UIDevice.current.systemVersion as NSString).floatValue < Float(majorVersion)
    }
    
    // 以上
    open class func orMore(_ majorVersion:Int)->Bool{
        return (UIDevice.current.systemVersion as NSString).floatValue >= Float(majorVersion)
    }
    
    open class func isSimulator() -> Bool {
        return UIDevice.current.localizedModel == "iPhone Simulator" || UIDevice.current.localizedModel == "iPad Simulator"
    }
    
    open class func isForeignDevice()->Bool{
        if isSimulator(){
            return true
        }
        
        let netinfo = CTTelephonyNetworkInfo()
        let carrier = netinfo.subscriberCellularProvider
        
        if carrier == nil{
            return true
        }
        
        return carrier!.mobileCountryCode != "440"
    }
    
}
