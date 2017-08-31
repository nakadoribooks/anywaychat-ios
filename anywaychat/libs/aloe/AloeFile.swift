//
//  AloeFile.swift
//  Pods
//
//  Created by kawase yu on 2015/09/24.
//
//

import UIKit

open class AloeFile: NSObject {

    fileprivate class func documentDir()->String{
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        return paths[0]
    }
    
    open class func saveDocumentFile(_ fileName:String, data:Data)->Bool{
        let path = documentDir() + "/" + fileName
        print(path)
        let success = (try? data.write(to: URL(fileURLWithPath: path), options: [.atomic])) != nil
        
        return success
    }
    
    open class func loadDocumentFile(_ fileName:String)->Data?{
        let path = documentDir() + "/" + fileName
        let data = try? Data(contentsOf: URL(fileURLWithPath: path))
        
        return data
    }
    
}
