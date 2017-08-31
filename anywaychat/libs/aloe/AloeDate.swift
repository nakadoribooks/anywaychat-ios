//
//  AloeDate.swift
//  Pods
//
//  Created by kawase yu on 2015/09/17.
//
//

import UIKit


// @"yyyy'-'MM'-'dd'T'HH':'mm':'ss'Z'";

open class AloeDate: NSObject {

    fileprivate let df = DateFormatter()
    fileprivate let calender = Calendar(identifier: Calendar.Identifier.gregorian)
    private let dateDataLock = NSLock()
    
    open static let instance = AloeDate()
    override fileprivate init(){
        super.init()
    }
    
    open func stringFromDate(_ date:Date, format:String)->String{
        dateDataLock.lock()
        defer { dateDataLock.unlock() }  // unlock を保証
        
        df.dateFormat = format
        df.locale = Locale(identifier: "en_US_POSIX")
        return df.string(from: date)
    }
    
    open func dateFromString(_ str:String, format:String)->Date{
        
        dateDataLock.lock()
        defer { dateDataLock.unlock() }  // unlock を保証
        
        df.dateFormat = format
        
        if let date = df.date(from: str) as Date?{
            return date
        }
        
        return Date()
    }
    
    open func weekdayDayName(_ date:Date)->String{
        let index = weekIndex(date)
        return df.shortWeekdaySymbols[index-1]
    }
    
    open func weekIndex(_ date:Date)->Int{
        let comps: DateComponents = (calender as NSCalendar).components([.year, .weekOfMonth, .day, .hour, NSCalendar.Unit.weekday], from: date)
        
        return comps.weekday!
    }
    
    open func timestamp()->Int{
        return Int(Date().timeIntervalSince1970)
    }
    
    open func agoText(_ date:Date)->String{
                
        let sec = Int(Date().timeIntervalSince(date))
        
        if sec < 60{
            return String(sec) + "秒前"
        }else if sec < 60*60{
            return String(sec / 60) + "分前"
        }else if sec < 60*60*24{
            return String(sec / 60 / 60) + "時間前"
        }else {
            return stringFromDate(date, format: "MM/dd HH:mm")
//            return String(sec / 60 / 60 / 24) + "日前"
        }
    }
}
