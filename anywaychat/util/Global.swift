//
//  Global.swift
//  anywaychat
//
//  Created by 河瀬悠 on 2017/08/30.
//  Copyright © 2017年 nakadoribooks. All rights reserved.
//

import UIKit

enum PlatformType{
    case browser, ios, android;
    
    func val()->String{
        switch self {
        case .browser:
            return "browser"
        case .ios:
            return "ios"
        case .android:
            return "android"
        }
    }
    
    func name()->String{
        switch self {
        case .browser:
            return "Browser"
        case .ios:
            return "iOS"
        case .android:
            return "Android"
        }
    }
    
    static func withVal(val:String)->PlatformType{
        switch val {
        case PlatformType.browser.val():
            return .browser
        case PlatformType.ios.val():
            return .ios
        case PlatformType.android.val():
            return .android
        default:
            return .ios
        }
    }
}

extension String {
    static func getRandomStringWithLength(length: Int) -> String {
        
        let alphabet = "1234567890abcdefghijklmnopqrstuvwxyz"
        let upperBound = UInt32(alphabet.characters.count)
        
        return String((0..<length).map { _ -> Character in
            return alphabet[alphabet.index(alphabet.startIndex, offsetBy: Int(arc4random_uniform(upperBound)))]
        })
    }
}

class Global: NSObject {

    static let userId = String.getRandomStringWithLength(length: 8)
    static var timestampOffset:TimeInterval = 0
    static var currentChatId:String? = nil
    
    private static let randomNameList = ["太宰治","三島由紀夫","カフカ","田中角栄", "大塩平八郎", "土方巽", "アルベルト・アインシュタイン", "バラモス", "メタルスライム"]
    static let currentName = randomNameList[Int(arc4random_uniform(UInt32(randomNameList.count)))]
    
    static func agoText(_ date:Date)->String{
        
        let sec = Int(Date().timeIntervalSince(date)) //  - Int(Global.timestampOffset)
        
        if sec < 60{
            return String(sec) + "秒前"
        }else if sec < 60*60{
            return String(sec / 60) + "分前"
        }else if sec < 60*60*24{
            return String(sec / 60 / 60) + "時間前"
        }else {
            return String(sec / 60 / 60 / 24) + "日前"
        }
    }
}
