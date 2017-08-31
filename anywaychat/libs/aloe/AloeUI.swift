//
//  AloeUI.swift
//  Pods
//
//  Created by kawase yu on 2016/03/17.
//
//

import UIKit

//let windowWidth = AloeDevice.windowWidth()
//let windowHeight = AloeDevice.windowHeight()

class AloeUI: NSObject {

    static func attributedText(_ text:String, lineHeight:CGFloat=1.1, kerning:CGFloat=0)->NSAttributedString{
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = lineHeight
        let attributedText = NSMutableAttributedString(string: text)
        
        let attributes = [
            NSParagraphStyleAttributeName:paragraphStyle
            , NSKernAttributeName: kerning
        ] as [String : Any]
        
        attributedText.addAttributes(attributes, range: NSMakeRange(0, attributedText.length))
        
        return NSAttributedString(attributedString: attributedText)
    }

    
}
