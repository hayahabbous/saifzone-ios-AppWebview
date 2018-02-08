//
//  InternetChecking.swift
//  DH Meeting
//
//  Created by macbook pro on 12/24/17.
//  Copyright © 2017 Datacellme. All rights reserved.
//

import Foundation
import SystemConfiguration
class Utilities{
    let APPLE_LANGUAGE_KEY: String = "AppleLanguages"
    func isInternetAvailable() -> Bool
    {
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
                SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
            }
        }
        
        var flags = SCNetworkReachabilityFlags()
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) {
            return false
        }
        let isReachable = flags.contains(.reachable)
        let needsConnection = flags.contains(.connectionRequired)
        return (isReachable && !needsConnection)
    }
    
//    /// set @lang to be the first in Applelanguages list
//    class func setAppleLAnguageTo(lang: String) {
//        let userdef = UserDefaults.standard
//        userdef.setforKey: "AppleLanguage")
//        userdef.synchronize()
//    }
//
//    class func currentAppleLanguage()->String{
//        return  UserDefaults.standard.object(forKey: "appLan") ?? "NULL"
//    }
    
    /// get current Apple language
    class func currentAppleLanguage() -> String{
        let userdef = UserDefaults.standard
        let langArray = userdef.object(forKey: "AppleLanguages") as! NSArray
        let current = langArray.firstObject as! String
        return current
    }
    /// set @lang to be the first in Applelanguages list
    class func setAppleLAnguageTo(lang: String) {
        print("SET LANGUAGE CALLED",lang)
        let userdef = UserDefaults.standard
        userdef.set([lang,currentAppleLanguage()], forKey: "AppleLanguages")
        userdef.synchronize()
    }
    
    func showAlert(message : String, isRefresh : Bool,actionMessage : String, controller : UIViewController){
        let alert = UIAlertController(title: "Alert", message: message, preferredStyle: UIAlertControllerStyle.alert)
        
        alert.addAction(UIAlertAction(title: actionMessage, style: UIAlertActionStyle.default, handler: {(action:UIAlertAction!) in
            
            if isRefresh == true{
            controller.viewDidAppear(true)
            }
            
        }))
    
        controller.present(alert, animated: true, completion: nil)
    }
}
