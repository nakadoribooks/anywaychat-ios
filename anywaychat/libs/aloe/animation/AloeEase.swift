//
//  AloeEase.swift
//  Pods
//
//  Created by kawase yu on 2015/09/16.
//
//

import Foundation
import UIKit

public enum AloeEase {
    case none
    , Ease
    , inQuad , outQuad , inOutQuad
    , inCubic , outCubic , inOutCubic
    , inQuart, outQuart, inOutQuart
    , inQuint, outQuint, inOutQuint
    , inSine, outSine, inOutSine
    , inExpo, outExpo, inOutExpo
    , inCirc, outCirc, inOutCirc
    , inElastic, outElastic, inOutElastic
    , inBack, outBack, inOutBack
    , inBounce, outBounce, inOutBounce
    
    static let list = [none
        , Ease
        , inQuad , outQuad , inOutQuad
        , inCubic , outCubic , inOutCubic
        , inQuart, outQuart, inOutQuart
        , inQuint, outQuint, inOutQuint
        , inSine, outSine, inOutSine
        , inExpo, outExpo, inOutExpo
        , inCirc, outCirc, inOutCirc
        , inElastic, outElastic, inOutElastic
        , inBack, outBack, inOutBack
        , inBounce, outBounce, inOutBounce]
    
    func name()->String{
        switch(self){
        case .none: return "None"
        case .Ease: return "Ease"
        case .inQuad: return "InQuad"
        case .outQuad: return "OutQuad"
        case .inOutQuad: return "InOutQuad"
        case .inCubic: return "InCubic"
        case .outCubic: return "OutCubic"
        case .inOutCubic: return "InOutCubic"
        case .inQuart: return "InQuart"
        case .outQuart: return "OutQuart"
        case .inOutQuart: return "InOutQuart"
        case .inQuint: return "InQuint"
        case .outQuint: return "OutQuint"
        case .inOutQuint: return "InOutQuint"
        case .inSine: return "InSine"
        case .outSine: return "OutSine"
        case .inOutSine: return "InOutSine"
        case .inExpo: return "InExpo"
        case .outExpo: return "OutExpo"
        case .inOutExpo: return "InOutExpo"
        case .inCirc: return "InCirc"
        case .outCirc: return "OutCirc"
        case .inOutCirc: return "InOutCirc"
        case .inElastic: return "InElastic"
        case .outElastic: return "OutElastic"
        case .inOutElastic: return "InOutElastic"
        case .inBack: return "InBack"
        case .outBack: return "OutBack"
        case .inOutBack: return "InOutBack"
        case .inBounce: return "InBounce"
        case .outBounce: return "OutBounce"
        case .inOutBounce: return "InOutBounce"
        }
    }
    
    public func calc(_ val:CGFloat)->CGFloat{
        
        let t:Double = Double(val)
        let b:Double = 0
        let c:Double = 1.0
        let d:Double = 1.0
        
        switch(self){
        case .none: return CGFloat(easeNone(t, b: b, c: c, d: d))
        case .Ease: return CGFloat(ease(t, b: b, c: c, d: d))
        case .inQuad: return CGFloat(easeInQuad(t, b: b, c: c, d: d))
        case .outQuad: return CGFloat(easeOutQuad(t, b: b, c: c, d: d))
        case .inOutQuad: return CGFloat(easeInOutQuad(t, b: b, c: c, d: d))
        case .inCubic: return CGFloat(easeInCubic(t, b: b, c: c, d: d))
        case .outCubic: return CGFloat(easeOutCubic(t, b: b, c: c, d: d))
        case .inOutCubic: return CGFloat(easeInOutCubic(t, b: b, c: c, d: d))
        case .inQuart: return CGFloat(easeInQuart(t, b: b, c: c, d: d))
        case .outQuart: return CGFloat(easeOutQuart(t, b: b, c: c, d: d))
        case .inOutQuart: return CGFloat(easeInOutQuart(t, b: b, c: c, d: d))
        case .inQuint: return CGFloat(easeInQuint(t, b: b, c: c, d: d))
        case .outQuint: return CGFloat(easeOutQuint(t, b: b, c: c, d: d))
        case .inOutQuint: return CGFloat(easeInOutQuint(t, b: b, c: c, d: d))
        case .inSine: return CGFloat(easeInSine(t, b: b, c: c, d: d))
        case .outSine: return CGFloat(easeOutSine(t, b: b, c: c, d: d))
        case .inOutSine: return CGFloat(easeInOutSine(t, b: b, c: c, d: d))
        case .inExpo: return CGFloat(easeInExpo(t, b: b, c: c, d: d))
        case .outExpo: return CGFloat(easeOutExpo(t, b: b, c: c, d: d))
        case .inOutExpo: return CGFloat(easeInOutExpo(t, b: b, c: c, d: d))
        case .inCirc: return CGFloat(easeInCirc(t, b: b, c: c, d: d))
        case .outCirc: return CGFloat(easeOutCirc(t, b: b, c: c, d: d))
        case .inOutCirc: return CGFloat(easeInOutCirc(t, b: b, c: c, d: d))
        case .inElastic: return CGFloat(easeInElastic(t, b: b, c: c, d: d))
        case .outElastic: return CGFloat(easeOutElastic(t, b: b, c: c, d: d))
        case .inOutElastic: return CGFloat(easeInOutElastic(t, b: b, c: c, d: d))
        case .inBack: return CGFloat(easeInBack(t, b: b, c: c, d: d))
        case .outBack: return CGFloat(easeOutBack(t, b: b, c: c, d: d))
        case .inOutBack: return CGFloat(easeInOutBack(t, b: b, c: c, d: d))
        case .inBounce: return CGFloat(easeInBounce(t, b: b, c: c, d: d))
        case .outBounce: return CGFloat(easeOutBounce(t, b: b, c: c, d: d))
        case .inOutBounce: return CGFloat(easeInOutBounce(t, b: b, c: c, d: d))
        }
    }
    
    func calc (_ t:Double, b:Double, c:Double, d:Double) -> Double {
        
        switch(self){
        case .none: return easeNone(t, b: b, c: c, d: d)
        case .Ease: return ease(t, b: b, c: c, d: d)
        case .inQuad: return easeInQuad(t, b: b, c: c, d: d)
        case .outQuad: return easeOutQuad(t, b: b, c: c, d: d)
        case .inOutQuad: return easeInOutQuad(t, b: b, c: c, d: d)
        case .inCubic: return easeInCubic(t, b: b, c: c, d: d)
        case .outCubic: return easeOutCubic(t, b: b, c: c, d: d)
        case .inOutCubic: return easeInOutCubic(t, b: b, c: c, d: d)
        case .inQuart: return easeInQuart(t, b: b, c: c, d: d)
        case .outQuart: return easeOutQuart(t, b: b, c: c, d: d)
        case .inOutQuart: return easeInOutQuart(t, b: b, c: c, d: d)
        case .inQuint: return easeInQuint(t, b: b, c: c, d: d)
        case .outQuint: return easeOutQuint(t, b: b, c: c, d: d)
        case .inOutQuint: return easeInOutQuint(t, b: b, c: c, d: d)
        case .inSine: return easeInSine(t, b: b, c: c, d: d)
        case .outSine: return easeOutSine(t, b: b, c: c, d: d)
        case .inOutSine: return easeInOutSine(t, b: b, c: c, d: d)
        case .inExpo: return easeInExpo(t, b: b, c: c, d: d)
        case .outExpo: return easeOutExpo(t, b: b, c: c, d: d)
        case .inOutExpo: return easeInOutExpo(t, b: b, c: c, d: d)
        case .inCirc: return easeInCirc(t, b: b, c: c, d: d)
        case .outCirc: return easeOutCirc(t, b: b, c: c, d: d)
        case .inOutCirc: return easeInOutCirc(t, b: b, c: c, d: d)
        case .inElastic: return easeInElastic(t, b: b, c: c, d: d)
        case .outElastic: return easeOutElastic(t, b: b, c: c, d: d)
        case .inOutElastic: return easeInOutElastic(t, b: b, c: c, d: d)
        case .inBack: return easeInBack(t, b: b, c: c, d: d)
        case .outBack: return easeOutBack(t, b: b, c: c, d: d)
        case .inOutBack: return easeInOutBack(t, b: b, c: c, d: d)
        case .inBounce: return easeInBounce(t, b: b, c: c, d: d)
        case .outBounce: return easeOutBounce(t, b: b, c: c, d: d)
        case .inOutBounce: return easeInOutBounce(t, b: b, c: c, d: d)
        }
    }
    
    fileprivate func ease(_ t:Double, b:Double, c:Double, d:Double)->Double{
//        .25,.1,.25,1
        let p1 = CGPoint(x: 0.25, y: 0.1)
        let p2 = CGPoint(x: 0.25, y: 1.0)
        
        let n = easeNone(t, b: b, c: c, d: d)
        
        return Double(AloeEaseBezier.calc(n, p1: p1, p2: p2))
    }
    
    fileprivate func easeNone(_ t:Double, b:Double, c:Double, d:Double)->Double{
        return c*t/d + b
    }
    fileprivate func easeInQuad(_ t:Double, b:Double, c:Double, d:Double)->Double{
        let t:Double = t / d
        return c*t*t + b
    }
    fileprivate func easeOutQuad(_ t:Double, b:Double, c:Double, d:Double)->Double{
        let t:Double = t / d
        return (-c) * t * (t-2) + b
    }
    fileprivate func easeInOutQuad(_ t:Double, b:Double, c:Double, d:Double)->Double{
        var t:Double = t / (d/2)
        if (t < 1) {
            return c/2*t*t + b
        }
        t -= 1
        return -c/2 * (t*(t-2) - 1) + b
    }
    fileprivate func easeInCubic(_ t:Double, b:Double, c:Double, d:Double)->Double{
        let t:Double = t/d
        return c*t*t*t + b
    }
    fileprivate func easeOutCubic(_ t:Double, b:Double, c:Double, d:Double)->Double{
        let t:Double = t/d-1
        return c*(t*t*t + 1) + b
    }
    fileprivate func easeInOutCubic(_ t:Double, b:Double, c:Double, d:Double)->Double{
        var t:Double = t / (d/2)
        if (t < 1) {
            return c/2*t*t*t + b
        }
        
        t -= 2
        return c/2*(t*t*t + 2) + b
    }
    fileprivate func easeInQuart(_ t:Double, b:Double, c:Double, d:Double)->Double{
        let t:Double = t / d
        return c*t*t*t*t + b
    }
    fileprivate func easeOutQuart(_ t:Double, b:Double, c:Double, d:Double)->Double{
        let t:Double = t/d-1
        return -c * (t*t*t*t - 1) + b
    }
    fileprivate func easeInOutQuart(_ t:Double, b:Double, c:Double, d:Double)->Double{
        var t:Double = t / (d/2)
        if (t < 1) {
            return c/2*t*t*t*t + b
        }
        
        t-=2
        return -c/2 * (t*t*t*t - 2) + b
    }
    fileprivate func easeInQuint(_ t:Double, b:Double, c:Double, d:Double)->Double{
        let t:Double = t / d
        return c*t*t*t*t*t + b
    }
    fileprivate func easeOutQuint(_ t:Double, b:Double, c:Double, d:Double)->Double{
        let t:Double = t/d-1
        return c*(t*t*t*t*t + 1) + b
    }
    fileprivate func easeInOutQuint(_ t:Double, b:Double, c:Double, d:Double)->Double{
        var t:Double = t / (d/2)
        if(t < 1) {
            return c/2*t*t*t*t*t + b
        }
        t -= 2
        return c/2*(t*t*t*t*t + 2) + b
    }
    fileprivate func easeInSine(_ t:Double, b:Double, c:Double, d:Double)->Double{
        return -c * cos(t/d * (3.1419/2)) + c + b
    }
    fileprivate func easeOutSine(_ t:Double, b:Double, c:Double, d:Double)->Double{
        return c * sin(t/d * (3.1419/2)) + b
    }
    fileprivate func easeInOutSine(_ t:Double, b:Double, c:Double, d:Double)->Double{
        return -c/2 * (cos(3.1419*t/d) - 1) + b
    }
    fileprivate func easeInExpo(_ t:Double, b:Double, c:Double, d:Double)->Double{
        return (t==0) ? b : c * pow(2, 10 * (t/d - 1)) + b
    }
    fileprivate func easeOutExpo(_ t:Double, b:Double, c:Double, d:Double)->Double{
        return (t==d) ? b+c : c * (-pow(2, -10 * t/d) + 1) + b
    }
    fileprivate func easeInOutExpo(_ t:Double, b:Double, c:Double, d:Double)->Double{
        if (t==0){ return b }
        if (t==d){ return b+c }
        var t:Double = t / (d/2)
        if (t < 1){ return c/2 * pow(2, 10 * (t - 1)) + b }
        t = t - 1
        return c/2 * (-pow(2, -10 * t) + 2) + b
    }
    fileprivate func easeInCirc(_ t:Double, b:Double, c:Double, d:Double)->Double{
        let t:Double = t / d
        return -c * (sqrt(1 - t*t) - 1) + b
    }
    fileprivate func easeOutCirc(_ t:Double, b:Double, c:Double, d:Double)->Double{
        let t:Double = t/d-1
        return c * sqrt(1 - t*t) + b
    }
    fileprivate func easeInOutCirc(_ t:Double, b:Double, c:Double, d:Double)->Double{
        var t:Double = t / (d/2)
        if (t < 1) {
            return -c/2 * (sqrt(1 - t*t) - 1) + b
        }
        t-=2
        return c/2 * (sqrt(1 - t*t) + 1) + b
    }
    fileprivate func easeInElastic(_ t:Double, b:Double, c:Double, d:Double)->Double{
        var s:Double = 1.70158
        var p:Double = 0
        var a:Double = c
        if (t==0){
            return b
        }
        var t:Double = t / d
        if (t==1){
            return b+c
        }
        if (p == 0){
            p = d * 0.3
        }
        if (a < abs(c)) {
            a=c
            s=p/4
        }else{
            s = p/(2*3.1419) * asin (c/a)
        }
        t -= 1
        return -(a*pow(2,10*t) * sin( (t*d-s)*(2*3.1419)/p )) + b
    }
    fileprivate func easeOutElastic(_ t:Double, b:Double, c:Double, d:Double)->Double{
        var s:Double = 1.70158
        var p:Double = 0
        var a:Double = c
        
        if (t==0){
            return b
        }
        let t:Double = t / d
        if (t==1){
            return b+c
        }
        if (p == 0){
            p = d * 0.3
        }
        if (a < abs(c)) {
            a=c
            s=p/4
        }
        else{
            s = p/(2*3.1419) * asin (c/a)
        }
        return a*pow(2,-10*t) * sin( (t*d-s)*(2*3.1419)/p ) + c + b
    }
    fileprivate func easeInOutElastic(_ t:Double, b:Double, c:Double, d:Double)->Double{
        var s:Double = 1.70158
        var p:Double = 0
        var a:Double = c
        
        if (t==0){
            return b
        }
        var t:Double = t / (d/2)
        if (t==2){
            return b+c
        }
        if (p == 0){
            p = d*(0.3*1.5)
        }
        if (a < abs(c)) {
            a=c
            s=p/4
        }
        else{
            s = p/(2*3.1419) * asin (c/a)
        }
        if (t < 1) {
            t -= 1
            return -0.5*(a*pow(2,10*t) * sin( (t*d-s)*(2*3.1419)/p )) + b
        }
        t -= 1
        return a*pow(2,-10*t) * sin( (t*d-s)*(2*3.1419)/p )*0.5 + c + b
    }
    fileprivate func easeInBack(_ t:Double, b:Double, c:Double, d:Double)->Double{
        let s:Double = 1.70158
        let t:Double = t / d
        return c*t*t*((s+1)*t - s) + b
    }
    fileprivate func easeOutBack(_ t:Double, b:Double, c:Double, d:Double)->Double{
        let s:Double = 1.70158
        let t:Double = t/d-1
        return c*(t*t*((s+1)*t + s) + 1) + b
    }
    fileprivate func easeInOutBack(_ t:Double, b:Double, c:Double, d:Double)->Double{
        var s:Double = 1.70158
        let k:Double = 1.525
        var t:Double = t / (d/2)
        s = s * k
        if (t < 1) {
            return c/2*(t*t*((s+1)*t - s)) + b
        } else {
            t -= 2
            return c/2*(t*t*((s+1)*t + s) + 2) + b
        }
    }
    fileprivate func easeInBounce(_ t:Double, b:Double, c:Double, d:Double)->Double{
        return c - self.easeOutBounce(d-t, b:0, c:c, d:d) + b
    }
    fileprivate func easeOutBounce(_ t:Double, b:Double, c:Double, d:Double)->Double{
        let k:Double = 2.75
        var t:Double = t / d
        if (t < (1/k)) {
            return c*(7.5625*t*t) + b
        } else if (t < (2/k)) {
            t-=1.5/k
            return c*(7.5625*t*t + 0.75) + b
        } else if (t < (2.5/k)) {
            t-=2.25/k
            return c*(7.5625*t*t + 0.9375) + b
        } else {
            t-=2.625/k
            return c*(7.5625*t*t + 0.984375) + b
        }
    }
    fileprivate func easeInOutBounce(_ t:Double, b:Double, c:Double, d:Double)->Double{
        if (t < d*0.5){
            return self.easeOutBounce(t*2, b: 0, c: c, d: d) * 0.5 + b
        }
        return self.easeOutBounce(t*2-d, b:0, c:c, d:d) * 0.5 + c*0.5 + b
    }
}
