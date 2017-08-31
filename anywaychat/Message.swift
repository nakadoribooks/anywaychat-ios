//
//  Message.swift
//  anywaychat
//
//  Created by 河瀬悠 on 2017/08/30.
//  Copyright © 2017年 nakadoribooks. All rights reserved.
//

import UIKit
import FirebaseDatabase

class Message: NSObject {

    private let snapshot:DataSnapshot
    
    init(snapshot:DataSnapshot){
        self.snapshot = snapshot
        super.init()
    }
    
    var key:String{
        return snapshot.key
    }
    
    var userId:String{
        if let val = snapshot.childSnapshot(forPath: "userId").value as? String{
            return val
        }
        
        return ""
    }
    
    var message:String{
        if let val = snapshot.childSnapshot(forPath: "message").value as? String{
            return val
        }
        
        return ""
    }
    
    var userName:String{
        if let val = snapshot.childSnapshot(forPath: "userName").value as? String{
            return val
        }
        
        return ""
    }
    
    var createdAt:Date{
        if let val = snapshot.childSnapshot(forPath: "createdAt").value as? Int{
            return Date(timeIntervalSince1970: TimeInterval(val/1000))
        }
        
        return Date()
    }
    
    var platform:PlatformType{
        if let val = snapshot.childSnapshot(forPath: "platform").value as? String{
            return PlatformType.withVal(val: val)
        }
        
        return .ios
    }
    
    
    func isMymessage()->Bool{
        return self.userId == Global.userId
    }
    
}
