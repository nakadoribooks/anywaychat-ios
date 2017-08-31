//
//  AloeChain.swift
//  Pods
//
//  Created by kawase yu on 2015/09/16.
//
//

import UIKit

open class AloeChain: NSObject {
   
    fileprivate var commandList:[ChainCommand] = []
    fileprivate var total:Int = 0
    fileprivate var current:Int = 0
    
    open func add(_ duration:Double, ease:AloeEase, progress:@escaping AloeTweenProgressCallback)->AloeChain{
        commandList.append(ToCommand(duration: duration, ease: ease, progress: progress))
        return self
    }
    
    open func wait(_ delay:Double)->AloeChain{
        commandList.append(WaitCommand(delay:delay))
        return self
    }
    
    open func call(_ f:@escaping ()->())->AloeChain{
        commandList.append(FuncCommand(f:f))
        return self
    }
    
    open func execute(){
        total = commandList.count
        AloeThread.subThread { () -> () in
            self.executeRow()
        }
    }
    
    deinit{
        
    }
    
    fileprivate func executeRow(){
        // end
        if(total == current){
            return
        }
        let c:ChainCommand = commandList.remove(at: 0)
        c.setComplete_({ () -> () in
            self.current += 1
            self.executeRow()
        })
        c.execute()
    }
    
    // MARK: コマンド基底
    class ChainCommand:NSObject{
        
        var complete:AloeTweenChainCommandCallback = { () -> () in
            
        }
        
        typealias AloeTweenChainCommandCallback = ()->()
        override init(){
            super.init()
        }
        func onComplete(){
            AloeThread.subThread { () -> () in
                self.complete()
            }
        }
        func setComplete_(_ complete:@escaping AloeTweenChainCommandCallback){
            self.complete = complete
        }
        
        func execute(){}
        
        deinit{
            
        }
    }
    
    // MARK: Tween
    class ToCommand:ChainCommand{
        
        fileprivate let duration:Double
        fileprivate let ease:AloeEase
        fileprivate let progress:AloeTweenProgressCallback
        
        init(duration:Double, ease:AloeEase, progress:@escaping AloeTweenProgressCallback){
            self.duration = duration
            self.ease = ease
            self.progress = progress
            super.init()
        }
        
        override func execute() {
            _ = AloeTween.doTween(duration, ease: ease, progress: progress) { 
                self.onComplete()
            }
        }
    }
    
    // MARK: wait
    class WaitCommand:ChainCommand{
        
        fileprivate var delay:Double
        
        init(delay:Double){
            self.delay = delay
            super.init()
        }
        
        override func execute() {
            Thread.sleep(forTimeInterval: delay)
            self.onComplete()
        }
    }
    
    // MARK: func
    class FuncCommand:ChainCommand{
        
        fileprivate var f:()->()
        
        init(f:@escaping ()->()){
            self.f = f
            super.init()
        }
        
        override func execute() {
            AloeThread.mainThread { () -> () in
                self.f()
                AloeThread.subThread({ () -> () in
                    self.onComplete()
                })
            }
        }
    }
    
}
