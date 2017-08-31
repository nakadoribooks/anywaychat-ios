//
//  UI.swift
//  inquiry
//
//  Created by 河瀬悠 on 2017/08/30.
//  Copyright © 2016年 vikana inc. All rights reserved.
//

import UIKit

func colorFromHex(rgbValue:UInt32)->UIColor{
    return AloeColor.fromHex(rgbValue)
}

func windowWidth()->CGFloat{
    return AloeDevice.windowWidth()
}

func windowHeight()->CGFloat{
    return AloeDevice.windowHeight()
}

func windowFrame()->CGRect{
    return AloeDevice.windowFrame()
}


class UI: NSObject {
    
    // MARK: color
    
    static let clearColor = UIColor.clear
    static let whiteColor = colorFromHex(rgbValue: 0xffffff)
    static let textColor = colorFromHex(rgbValue: 0x4a4a4a)
    static let primaryColor = colorFromHex(rgbValue: 0x00d1b2)
    static let infoColor = colorFromHex(rgbValue: 0x3273dc)
    static let successColor = colorFromHex(rgbValue: 0x23d160)
    static let warningColor = colorFromHex(rgbValue: 0xffdd57)
    static let dangerColor = colorFromHex(rgbValue: 0xff3860)
    static let greyColor = colorFromHex(rgbValue: 0x95a5a6)
    static let lightGreyColor = colorFromHex(rgbValue: 0xf5f5f5)
    static let accentColor = dangerColor
    
    // MARK: size
    static let margin:CGFloat = 10.0
    static let marginTite:CGFloat = 5.0
    static let buttonRadius:CGFloat = 3
    
    // MARK: font
    
    static let buttonFontSize:CGFloat = 16
    static let labelFontSize:CGFloat = 14
    
    static func font(size:CGFloat)->UIFont{
        if let f = UIFont(name: ".SFUIDisplay-Regular", size: size){
            return f
        }
        
        return UIFont.systemFont(ofSize: size)
    }
    
    static func monoScapeFont(size:CGFloat)->UIFont{
        return UIFont.monospacedDigitSystemFont(ofSize: size, weight: UIFontWeightMedium)
    }
    
    static func lightMonoScapeFont(size:CGFloat)->UIFont{
        return UIFont.monospacedDigitSystemFont(ofSize: size, weight: UIFontWeightLight)
    }
    
    
    static func mediumFont(size:CGFloat)->UIFont{
        if let f = UIFont(name: ".SFUIDisplay-Medium", size: size){
            return f
        }
        
        if #available(iOS 8.2, *) {
            return UIFont.systemFont(ofSize: size, weight: UIFontWeightMedium)
        } else {
            return UIFont.systemFont(ofSize: size)
        }
    }
    
    static func boldFont(size:CGFloat)->UIFont{
        
        if let f = UIFont(name: ".SFUIDisplay-Bold", size: size){
            return f
        }
        
        if #available(iOS 8.2, *) {
            return UIFont.systemFont(ofSize: size, weight: UIFontWeightBold)
        } else {
            return UIFont.systemFont(ofSize: size)
        }
    }
    
    static func semiBoldFont(size:CGFloat)->UIFont{
        
        if let f = UIFont(name: ".SFUIDisplay-Semibold", size: size){
            return f
        }
        
        if #available(iOS 8.2, *) {
            return UIFont.systemFont(ofSize: size, weight: UIFontWeightSemibold)
        } else {
            return UIFont.systemFont(ofSize: size)
        }
    }
    
    static func lightFont(size:CGFloat)->UIFont{
        
        if let f = UIFont(name: ".SFUIDisplay-Light", size: size){
            return f
        }
        
        if #available(iOS 8.2, *) {
            return UIFont.systemFont(ofSize: size, weight: UIFontWeightLight)
        } else {
            return UIFont.systemFont(ofSize: size)
        }
    }
    
    static func ultraLightFont(size:CGFloat)->UIFont{
        
        if let f = UIFont(name: ".SFUIDisplay-Ultralight", size: size){
            return f
        }
        
        if #available(iOS 8.2, *) {
            return UIFont.systemFont(ofSize: size, weight: UIFontWeightUltraLight)
        } else {
            return UIFont.systemFont(ofSize: size)
        }
    }
    
    // MARK: overlay
    
    static func createButtonOverlay(currentView:UIView)->UIView{
        
        let overlay = UIView()
        let frame = circledRect(frame: currentView.frame)
        overlay.frame = frame
        overlay.transform = CGAffineTransform(scaleX: 0, y: 0)
        overlay.isUserInteractionEnabled = false
        overlay.layer.cornerRadius = frame.size.height / 2
        overlay.clipsToBounds = true
        
        return overlay
    }
    
    static func circledRect(frame:CGRect)->CGRect{
        let r:CGFloat = sqrt(pow(frame.width, 2) + pow(frame.height, 2)) / 2.0
        let size:CGFloat = r*2
        
        return CGRect(x: (frame.size.width-size)/2, y: (frame.size.height-size)/2, width: size, height: size)
    }
    
    static func banglaFont(size:CGFloat)->UIFont{
        
        if let f = UIFont(name: "KohinoorBangla-Regular", size: size){
            print("find bangla")
            return f
        }
        
        print("not found bangla")
        
        if #available(iOS 8.2, *) {
            return UIFont.systemFont(ofSize: size, weight: UIFontWeightSemibold)
        } else {
            return UIFont.systemFont(ofSize: size)
        }
    }
    
}

