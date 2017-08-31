//
//  AloeThreadUtil.swift
//  Pods
//
//  Created by kawase yu on 2015/09/16.
//
//

import UIKit

open class AloeThread: NSObject {
    
    open class func mainThread(_ proc: @escaping () -> ()) {
        DispatchQueue.main.async(execute: proc)
    }
    
    open class func subThread(_ proc: @escaping () -> ()) {
        DispatchQueue.global(qos: .default).async(execute: proc)
    }
    
    open class func wait(_ delay:CGFloat, proc: @escaping ()->()){
        subThread { () -> () in
            Thread.sleep(forTimeInterval: TimeInterval(delay))
            self.mainThread(proc)
        }
    }
   
    open class func sync(_ lock: AnyObject, proc: () -> ()) {
        objc_sync_enter(lock)
        proc()
        objc_sync_exit(lock)
    }
    
}
