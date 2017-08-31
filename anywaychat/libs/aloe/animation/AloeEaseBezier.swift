//
//  AloeEaseBezier.swift
//  Pods
//
//  Created by kawase yu on 2016/06/11.
//
//

import UIKit

open class AloeEaseBezier: NSObject {
    
    fileprivate let p1:CGPoint
    fileprivate let p2:CGPoint
    
    public init(p1:CGPoint, p2:CGPoint){
        self.p1 = p1
        self.p2 = p2
        
        super.init()
    }
    
    open func calc(_ t:CGFloat)->CGFloat{
        return AloeEaseBezier.calc(Double(t), p1: p1, p2: p2)
    }
    
    open class func calc(_ t:Double, p1:CGPoint, p2:CGPoint)->CGFloat{
        let q1 = (t*t*t*3) + (t * t * -6) + (t*3)
        let q2 = (t * t * t * -3) + (t*t*3)
        let q3 = t*t*t;
        
        let qy = q1*Double(p1.y) + q2*Double(p2.y) + q3
        
        return CGFloat(qy)
    }
    
}
