//
//  AppDelegate.swift
//  SaifZone
//
//  Created by mai malash on 8/12/15.
//  Copyright (c) 2015 mai malash. All rights reserved.
//

import UIKit
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {
    
    var window: UIWindow?
    var  centerContainer : MMDrawerController?
    var kStatusBarTappedNotification : String = "statusBarTappedNotification"
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        application.applicationIconBadgeNumber = 0
        setCategories()
        UNUserNotificationCenter.current().delegate = self
        registerForPushNotifications()
        return true
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
        //        if (application.applicationState == UIApplicationState.background) {
        ////            NotificationCenter.default.post(name: Notification.Name(rawValue: "reloadView"), object: "http://dev.saif-zone.com/en/m/Pages/NotificationsList.aspx?DeviceId=" + self.strdeviceToken! )
        //
        //            let notificationName = Notification.Name("NotificationIdentifier")
        //
        //            // Register to receive notification
        //            //                    NotificationCenter.default.addObserver(self, selector: #selector(YourClassName.methodOfReceivedNotification), name: notificationName, object: nil)
        //            //
        //            // Post notification
        //            NotificationCenter.default.post(name: notificationName, object: "http://dev.saif-zone.com/en/m/Pages/NotificationsList.aspx?DeviceId=" + self.strdeviceToken!)
        //
        //            // Stop listening notification
        //            NotificationCenter.default.removeObserver(self, name: notificationName, object: nil)
        //        }else
        //
        //        {
        //            if let notification = userInfo["aps"] as? NSDictionary,
        //                let _ = notification["alert"] as? String {
        //               // var _ : String = ( notification["alert"] as? String)! +  (notification["url"] as? String)!
        //                let alertCtrl = UIAlertController(title: "SAIF ZONE", message: notification["alert"] as? String, preferredStyle: UIAlertControllerStyle.alert)
        //                let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel) {
        //                    UIAlertAction in
        //
        ////                    NotificationCenter.default.post(name: Notification.Name(rawValue: "reloadView"), object: "http://dev.saif-zone.com/en/m/Pages/NotificationsList.aspx?DeviceId=" + self.strdeviceToken! )
        ////
        //
        //                    // Define identifier
        //                    let notificationName = Notification.Name("NotificationIdentifier")
        //
        //                    // Register to receive notification
        ////                    NotificationCenter.default.addObserver(self, selector: #selector(YourClassName.methodOfReceivedNotification), name: notificationName, object: nil)
        ////
        //                    // Post notification
        //                    NotificationCenter.default.post(name: notificationName, object: "http://dev.saif-zone.com/en/m/Pages/NotificationsList.aspx?DeviceId=" + self.strdeviceToken!)
        //
        //                    // Stop listening notification
        //                    NotificationCenter.default.removeObserver(self, name: notificationName, object: nil)
        //                    alertCtrl.dismiss(animated: true, completion: nil)
        //
        //                }
        //                alertCtrl.addAction(okAction)
        //                // Find the presented VC...
        //                var presentedVC = self.window?.rootViewController
        //                while (presentedVC!.presentedViewController != nil)  {
        //                    presentedVC = presentedVC!.presentedViewController
        //                }
        //                presentedVC!.present(alertCtrl, animated: true, completion: nil)
        //
        //            }
        //        }
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches,with: event)
        //var location : CGPoint = event.allTouches().
        let touch = touches.first
        let point : CGPoint = touch!.location(in: self.window)
        let statusBarFrame : CGRect = UIApplication.shared.statusBarFrame
        if (statusBarFrame.contains(point)) {
            self.statusBarTouchedAction()
        }
        
    }
    var strdeviceToken : String!
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let tokenParts = deviceToken.map { data -> String in
            return String(format: "%02.2hhx", data)
        }
        strdeviceToken = tokenParts.joined()
        let defaults = UserDefaults.standard
        defaults.set(strdeviceToken, forKey: "deviceID")
        print("******\(strdeviceToken!)*******")
        
        
    }
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        
        print("Failed to register: \(error)")
        
        
    }
    
    func statusBarTouchedAction() {
        
        NotificationCenter.default.post(name: Notification.Name(rawValue: kStatusBarTappedNotification), object: nil)
    }
    
    
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    func registerForPushNotifications() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) {
            (granted, error) in
            print("Permission granted: \(granted)")
            guard granted else { return }
            self.getNotificationSettings()
        }
        
        
    }
    
    func getNotificationSettings() {
        UNUserNotificationCenter.current().getNotificationSettings { (settings) in
            print("Notification settings: \(settings)")
            guard settings.authorizationStatus == .authorized else { return }
            DispatchQueue.main.async(execute: {
                UIApplication.shared.registerForRemoteNotifications()
            })         }
    }
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler(.alert)
    }
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        print("handling notification")
        if let notification = response.notification.request.content.userInfo as? [String:AnyObject] {
            let url = parseRemoteNotification(notification: notification)
            guard url?.isEmpty == false else{
                return
            }
            UserDefaults.standard.set(url, forKey: "notificationURL")
            let  story : UIStoryboard = UIStoryboard(name:"Main" , bundle: nil)
            let vc : NotificationController = story.instantiateViewController(withIdentifier: "NotificationController") as! NotificationController
            window?.rootViewController = vc;
        }
        completionHandler()
    }
    
    private func parseRemoteNotification(notification:[String:AnyObject]) -> String? {
        
        if let aps = notification["aps"] as? [String:AnyObject] {
            let alert = aps["alert"] as? String
            let url = notification["URL"] as? String
            return url
        }
        
        return nil
    }
    // To work button , you need to add "category" key on the "notification" json within "aps" tag.
    func setCategories(){
        let snoozeAction = UNNotificationAction(
            identifier: "open.action",
            title: "Open",
            options: [])
        let pizzaCategory = UNNotificationCategory(
            identifier: "open.category",
            actions: [snoozeAction],
            intentIdentifiers: [],
            options: [])
        UNUserNotificationCenter.current().setNotificationCategories(
            [pizzaCategory])
    }
}

