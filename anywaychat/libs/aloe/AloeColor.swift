//
//  AloeColorUtil.swift
//  Pods
//
//  Created by kawase yu on 2015/09/16.
//
//

import UIKit

open class AloeColor: NSObject {
   
    open class func fromHex(_ rgbValue:UInt32)->UIColor{
        let red = CGFloat((rgbValue & 0xFF0000) >> 16)/256.0
        let green = CGFloat((rgbValue & 0xFF00) >> 8)/256.0
        let blue = CGFloat(rgbValue & 0xFF)/256.0
        
        return UIColor(red:red, green:green, blue:blue, alpha:1.0)
    }
    
    open class func fromHexString(_ str:String)->UIColor{
        let colorScanner:Scanner = Scanner(string: str)
        var color:UInt32 = 0x0;
        colorScanner.scanHexInt32(&color)
        
        let r:CGFloat = CGFloat((color & 0xFF0000) >> 16) / 255.0
        let g:CGFloat = CGFloat((color & 0x00FF00) >> 8) / 255.0
        let b:CGFloat = CGFloat(color & 0x0000FF) / 255.0
        
        return UIColor(red:r, green:g, blue:b, alpha:1.0)
    }
    
}
