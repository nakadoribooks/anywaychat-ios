//
//  AloeLocation.swift
//  Pods
//
//  Created by kawase yu on 2015/09/17.
//
//

import UIKit
import CoreLocation

open class AloeLocation: NSObject, CLLocationManagerDelegate {
    
    fileprivate let lm:CLLocationManager = CLLocationManager()
    fileprivate var locationCallback:((_ lat:Double, _ lng:Double)->())!
    fileprivate var locationFailCallback:((_ status:CLAuthorizationStatus)->())!
    fileprivate var loadedLocation:Bool = false
    
    open static let instance = AloeLocation()
    override fileprivate init(){
        super.init()
    }
    
    open func requestCurrentLocation(_ callback:@escaping (_ lat:Double, _ lng:Double)->(), fail:@escaping (_ status:CLAuthorizationStatus)->()){
        locationCallback = callback
        locationFailCallback = fail

        lm.delegate = self
        loadedLocation = false
        
        if lm.responds(to: #selector(CLLocationManager.requestWhenInUseAuthorization)) {
            let status = CLLocationManager.authorizationStatus()
            if status == CLAuthorizationStatus.authorizedWhenInUse{
                lm.startUpdatingLocation()
            }else{
                lm.requestWhenInUseAuthorization()
                print("requestWhenInUseAuthorization")
            }
        }else{
            lm.startUpdatingLocation()
        }
    }
    
    open func isAuthorizedDenied()->Bool{
        let status = CLLocationManager.authorizationStatus()
        return status == CLAuthorizationStatus.denied
    }
    
    open func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        print("didChangeAuthorizationStatus")
        
        if status == CLAuthorizationStatus.authorizedWhenInUse{
            lm.startUpdatingLocation()
        }else{
            locationFailCallback(status)
        }

    }
    
//    open func locationManager(_ manager: CLLocationManager, didUpdateToLocation newLocation: CLLocation, fromLocation oldLocation: CLLocation){
//        print("didUpdateToLocation")
//        
//        if loadedLocation{
//            return
//        }
//        
//        loadedLocation = true
//        lm.stopUpdatingLocation()
//        
//        locationCallback(lat: newLocation.coordinate.latitude, lng: newLocation.coordinate.longitude)
//    }
}
