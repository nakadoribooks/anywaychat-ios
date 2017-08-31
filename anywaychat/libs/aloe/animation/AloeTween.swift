//
//  AloeTween.swift
//  Pods
//
//  Created by kawase yu on 2015/09/16.
//
//

import UIKit

import Foundation
import QuartzCore

public typealias AloeTweenProgressCallback = (_ val:CGFloat)->()
public typealias AloeTweenCompleteCallback = ()->()

private var aloeTweenTimer:Timer?
private var tweenList:[AloeTween.AloeTweenObject] = []
private let lock:NSObject = NSObject()
private var hasTimer:Bool = false

open class AloeTween{
    
    // MARK: public
    
    // メイン
    open class func doTween(_ duration:Double, ease:AloeEase, progress:@escaping AloeTweenProgressCallback)->AloeTweenObject{
        self.rock()
        
        if(!hasTimer){
            hasTimer = true
            let fps:Double = 60.0;
            AloeThread.mainThread({ () -> () in
                aloeTweenTimer = Timer(timeInterval: 1.0/fps, target: self, selector: #selector(AloeTween.updateAnimations), userInfo: nil, repeats: true)
                RunLoop.current.add(aloeTweenTimer!, forMode: RunLoopMode.commonModes)
            })
        }
        
        let obj:AloeTweenObject = AloeTweenObject(duration: duration, ease: ease, progressCallback: progress)
        tweenList.append(obj)
        
        self.unRock()
        
        return obj
    }
    
    // ショートカット
    class func doTween(_ duration:Double, ease:AloeEase
        , progress:@escaping AloeTweenProgressCallback, complete:@escaping AloeTweenCompleteCallback)->AloeTweenObject{
            let obj:AloeTweenObject = AloeTween.doTween(duration, ease: ease, progress: progress)
            obj.completeCallback = complete
            return obj
    }
    
    // ショートカット
    class func doTween(_ duration:Double, startValue:Double, endValue:Double, ease:AloeEase, progress:@escaping AloeTweenProgressCallback)->AloeTweenObject{
        let obj:AloeTweenObject = self.doTween(duration, ease: ease, progress: progress)
        obj.startValue = startValue
        obj.endValue = endValue
        
        return obj
    }
    
    // ショートカット
    class func doTween(_ duration:Double, startValue:Double, endValue:Double, ease:AloeEase
        , progress:@escaping AloeTweenProgressCallback, complete:@escaping AloeTweenCompleteCallback)->AloeTweenObject{
            let obj:AloeTweenObject = self.doTween(duration, startValue: startValue, endValue: endValue, ease: ease, progress: progress)
            obj.completeCallback = complete
            
            return obj
    }
    
    open class func cancel(_ obj:AloeTweenObject){
        // removeAtがない
        self.rock()
        let to:Int = tweenList.count
        for index in 0..<to{
            if(obj == tweenList[index]){
                tweenList.remove(at: index)
                self.unRock()
                return
            }
        }
        self.unRock()
    }
    
    open class func cancelAll(){
        self.rock()
        tweenList = []
        self.unRock()
    }
    
    fileprivate class func rock(){
        objc_sync_enter(lock)
    }
    
    fileprivate class func unRock(){
        objc_sync_exit(lock)
    }
    
    // MARK: private
    
    // @objc つけないと呼べない。。
    @objc class func updateAnimations(){
        self.rock()
        let currentTime:Double = CACurrentMediaTime()
        var newList:[AloeTween.AloeTweenObject] = []
        for tweenObject in tweenList {
            tweenObject.next(currentTime)
            if(tweenObject.hasNext()){
                newList.append(tweenObject)
            }
        }
        tweenList = newList
        if(tweenList.count == 0){
            aloeTweenTimer!.invalidate()
            aloeTweenTimer = nil
            hasTimer = false
        }
        self.unRock()
    }
    
    open class AloeTweenObject:NSObject{
        
        fileprivate let duration:Double
        fileprivate let progressCallback:AloeTweenProgressCallback
        internal var completeCallback:AloeTweenCompleteCallback = { () -> () in
        }
        fileprivate let ease:AloeEase
        fileprivate var currentValue:Double
        fileprivate let startTime:Double
        internal var startValue:Double = 0.0
        internal var endValue:Double = 1.0
        fileprivate var isEnd:Bool = false
        
        internal init(duration:Double, ease:AloeEase, progressCallback:@escaping AloeTweenProgressCallback ){
            self.duration = duration
            self.progressCallback = progressCallback
            self.ease = ease
            currentValue = 0.0
            startTime = CACurrentMediaTime()
            super.init()
        }
        
        internal func next(_ currentTime:Double){
            let b:Double = startValue
            let c:Double = endValue - startValue
            let t:Double = currentTime - startTime;
            currentValue = ease.calc(t, b:b, c:c, d: duration)
            if(currentTime >= startTime + duration){
                currentValue = endValue
                isEnd = true
            }
            
            progressCallback(CGFloat(currentValue))
            if(isEnd){
                completeCallback()
            }
        }
        
        internal func hasNext()->Bool{
            return !isEnd
        }
        
        internal func getStartTime()->Double{
            return startTime
        }
        
        deinit{
            
        }
    }
}
