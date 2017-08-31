//
//  AloeEventUtil.swift
//  Pods
//
//  Created by kawase yu on 2015/09/16.
//
//

import UIKit

open class AloeEvent: NSObject {
    
    
    open class func addGlobalEventListener(_ target:AnyObject, selector:Selector, name:String){
        NotificationCenter.default.addObserver(target, selector: selector, name: NSNotification.Name(rawValue: name), object: nil)
    }
    
    open class func dispatchGlobalEvent(_ name:String){
        let notification:Notification = Notification(name: Notification.Name(rawValue: name), object: nil)
        NotificationCenter.default.post(notification)
    }
    
    open class func removeGlobalEventListener(_ target:AnyObject){
        NotificationCenter.default.removeObserver(target)
    }
    
}
