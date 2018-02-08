//
//  HelpperClass.swift
//  WS-Swift
//
//  Created by Qtoof App on 6/25/15.
//  Copyright (c) 2015 Apptrainers. All rights reserved.
//

import UIKit
import SystemConfiguration
class HelpperClass: NSObject {
   
    func isConnectedToNetwork() -> Bool {
        
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
                SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
            }
        }
        var flags = SCNetworkReachabilityFlags()
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability! as SCNetworkReachability, &flags) {
            return false
        }
        
        let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
        let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
        return (isReachable && !needsConnection)
    }
    func LoadData() -> NSDictionary {
        
        var myDict = NSDictionary()
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true) as NSArray
        let documentsDirectory = paths.object(at: 0) as! NSString
        let Path = documentsDirectory.appendingPathComponent("lstSetting.plist")
        
        
        // let path :NSString = documentsDirectory.stringByAppendingPathComponent("ettingLst.plist")
        
        let fileManager = FileManager.default
        //check if file exists
        if(!fileManager.fileExists(atPath: Path)) {
            // If it doesn't, copy it from the default file in the Bundle
            if let bundlePath = Bundle.main.path(forResource: "lstSetting", ofType: "plist") {
                let resultDictionary = NSMutableDictionary(contentsOfFile: bundlePath)
                print("Bundle lstSetting.plist file is --> \(String(describing: resultDictionary?.description))")
                do {
                    try fileManager.copyItem(atPath: bundlePath, toPath: Path)
                }
                catch {
                    print("error")
                }//(bundlePath, toPath: Path)
                print("copy")
            } else {
                print("lstSetting.plist not found. Please, make sure it is part of the bundle.")
            }
        } else {
            print("SettingLst.plist already exits at path.")
            // use this to delete file from documents directory
            //fileManager.removeItemAtPath(path, error: nil)
        }
        let resultDictionary = NSMutableDictionary(contentsOfFile: Path)
        print("Loaded SettingLst.plist file is --> \(String(describing: resultDictionary?.description))")
        myDict = NSDictionary(contentsOfFile: Path)!
        return myDict
      
    }

    //############################
    //#########MBProgressHUD######
    //############################
    func showProgress (_ text: String,view:UIView){
        let hud =  MBProgressHUD.showAdded(to: view, animated: true)
        hud?.labelText = text
    }
    
    func hideProgress(_ view:UIView){
        MBProgressHUD.hideAllHUDs(for: view, animated: true)
    }
    //############################
    //#########MBProgressHUD######
    //############################
    
}

var helper = HelpperClass()
