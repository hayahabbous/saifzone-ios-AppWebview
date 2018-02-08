//
//  EntryController.swift
//  SAIF Zone
//
//  Created by macbook pro on 1/15/18.
//  Copyright © 2018 mai malash. All rights reserved.
//

import UIKit
import WebKit
import SystemConfiguration
import LocalAuthentication

class ViewController : UIViewController, WKNavigationDelegate{
    
    @IBOutlet weak var uiView: UIView!
    @IBOutlet weak var landingWebView: WKWebView!
    var isLoading : Bool = false
    // var Url : String = "http://saif-zone.com/en/m/Pages/default.aspx"
    @IBAction func onBackClick(_ sender: Any) {
        gotoLoginPage()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: Selector(("touchStatusBar")), name:NSNotification.Name(rawValue: "statusBarTappedNotification"), object: nil)
        landingWebView.navigationDelegate = self
        uiView.isHidden = true
        UserDefaults.standard.set("http://saif-zone.com/en/m/Pages/default.aspx", forKey: "URL")
        // createStatusBar()
        
        NotificationCenter.default.addObserver(self, selector: Selector(("reloadData:")), name: NSNotification.Name(rawValue: "reloadView"), object: nil)
        
        
    }
    func reloadData(notification : NSNotification)
    {
        if notification.object != nil
        {
            if notification.object as! String != ""
            {
                UserDefaults.standard.set(notification.object as! String,forKey: "URL")
                print(notification.object ?? "")
            }
            
        }
        
    }
    override func viewDidAppear(_ animated: Bool) {
        getData()
        
    }
    
    func getData() {
        guard Utilities().isInternetAvailable() == true else{
            Utilities().showAlert(message: "Please check internet connetion", isRefresh : true,actionMessage : "Refresh", controller: self)
            return
        }
        print("****** Get Data ******")
        let urlOther :String = UserDefaults.standard.object(forKey: "URL") as! String
        let url : URL = URL(string : urlOther)!
        let request = URLRequest(url: url)
        landingWebView.load(request)
    }
    
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        let clickedUrl : String = (navigationAction.request.mainDocumentURL?.absoluteString)!
        print("**CLICKED URL*\(clickedUrl)")
        guard Utilities().isInternetAvailable() == true else{
            Utilities().showAlert(message: "Please check internet connetion", isRefresh : true,actionMessage : "Refresh", controller: self)
            decisionHandler(WKNavigationActionPolicy.cancel)
            return
        }
        
        if clickedUrl.contains("Login.aspx") || clickedUrl == "http://mportal.saif-zone.com/"
        {
            print("**LOGIN CLICKED*\(clickedUrl)")
            decisionHandler(WKNavigationActionPolicy.cancel)
            let secure = UserDefaults.standard.object(forKey: "secure") ?? "false"
            let autoLogin = UserDefaults.standard.object(forKey: "autoLogin")  ?? "false"
            
            
            if secure as! String == "true" && autoLogin as! String == "true"{
                authenticationWithTouchID()
            }else if autoLogin as! String == "true"{
                tryForLogin()
            }else{
                gotoLoginPage()
            }
            return
        }else  if clickedUrl.contains("logout.aspx") {
            UserDefaults.standard.set("false", forKey: "secure")
            UserDefaults.standard.set("false", forKey: "autoLogin")
            UserDefaults.standard.removeObject(forKey: "userName")
            UserDefaults.standard.removeObject(forKey: "password")
            UserDefaults.standard.removeObject(forKey: "userType")
            UserDefaults.standard.removeObject(forKey: "tokenType")
            UserDefaults.standard.set("http://saif-zone.com/en/m/Pages/default.aspx", forKey: "URL")
            getData()
        }
        
        
        
        decisionHandler(WKNavigationActionPolicy.allow)
        
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        print("Finished navigating to url \(String(describing: webView.url))");
        let clickedUrl : String = (webView.url?.absoluteString)!
        if(clickedUrl.contains("pdf") || clickedUrl.contains("RegisterNewUser.aspx") || clickedUrl.contains("ForgotPassword.aspx")){
            uiView.isHidden = false
            
        }else{
            uiView.isHidden = true
            
        }
    }
    
    
    
}

extension ViewController {
    
    func authenticationWithTouchID() {
        let localAuthenticationContext = LAContext()
        localAuthenticationContext.localizedFallbackTitle = "Use Passcode"
        
        var authError: NSError?
        let reasonString = "To access the secure data"
        
        if localAuthenticationContext.canEvaluatePolicy(.deviceOwnerAuthentication, error: &authError) {
            
            localAuthenticationContext.evaluatePolicy(.deviceOwnerAuthentication, localizedReason: reasonString) { success, evaluateError in
                
                if success {
                    print("SUCCESS")
                    //TODO: User authenticated successfully, take appropriate action
                    self.tryForLogin()
                } else {
                    //TODO: User did not authenticate successfully, look at error and take appropriate action
                    guard let error = evaluateError else {
                        return
                    }
                    print("**************"+self.evaluateAuthenticationPolicyMessageForLA(errorCode: error._code))
                    
                    //TODO: If you have choosen the 'Fallback authentication mechanism selected' (LAError.userFallback). Handle gracefully
                    
                }
            }
        } else {
            
            guard let error = authError else {
                return
            }
            //TODO: Show appropriate alert if biometry/TouchID/FaceID is lockout or not enrolled
            print(self.evaluateAuthenticationPolicyMessageForLA(errorCode: error.code))
            self.tryForLogin()

        }
    }
    
    func gotoLoginPage(){
        let  story : UIStoryboard = UIStoryboard(name:"Main" , bundle: nil)
        let vc : vcLogin = story.instantiateViewController(withIdentifier: "Login") as! vcLogin
        
        self.present(vc,animated : true , completion: nil)
    }
    func tryForLogin() {
        let defaults = UserDefaults.standard
        var name : String = "123/1"
        if let str : String = defaults.string(forKey: "deviceID")
        {
            name = str + "/1"
        }
        
        
        
        // let url : String = "http://dev.saif-zone.com/_vti_bin/SharePoint.WCFService.Sample/Services/SampleService.svc/Auth(" + txtUserName.text! + "," + txtPassword.text! + "," + name + ")"
        
        let url :String = "http://ws.saif-zone.com:7777/authenticate/\(UserDefaults.standard.object(forKey: "userType") as! String)/\(UserDefaults.standard.object(forKey: "userName")  as! String)/\(UserDefaults.standard.object(forKey: "password")  as! String)/\(name)"
        // let url :String =  "http://ws.saif-zone.com:7777/authenticate/GetValue/" + txtUserName.text! + "/" + txtPassword.text! + "/" + name
        print("*****LOGIN URL*****\(url)")
        
        let loginUrl = URL(string: url)
        var getRequest = URLRequest(url: loginUrl!, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 30.0)
        getRequest.httpMethod = "GET"
        getRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        getRequest.setValue("application/json", forHTTPHeaderField: "Accept")
       
        URLSession.shared.dataTask(with: getRequest, completionHandler: { (data, response, error) in
            do
            
                        {
                            guard data != nil else{
                            return
                            }
            
                            let jsonResult :NSDictionary! = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as! NSDictionary
            
                            if (jsonResult != nil) {
                                // process jsonResult
            
                                if jsonResult!.value(forKey: "AuthResult")  as! String != "NOTAUTHORIZED"
                                {
                                    print("AUTO LOGIN SUCCESS")
                                    DispatchQueue.main.async(execute: {
            
                                        // vc.Url = "http://dev.saif-zone.com/en/m/Pages/ConsumeToken.aspx?TokenID=" + (jsonResult!.valueForKey("AuthResult")  as! String)
                                        // UserDefaults.standard.set("http://devdpm.saif-zone.com/ConsumeToken.aspx?TokenID=" + (jsonResult!.value(forKey: "AuthResult")  as! String), forKey: "URL")
            
                                        //                            self.Url = "http://devdpm.saif-zone.com/ConsumeToken.aspx?TokenID=" + (jsonResult!.value(forKey: "AuthResult")  as! String)
                                        // self.MainFunc()
                                        UserDefaults.standard.set("http://\(UserDefaults.standard.object(forKey: "tokenType") as! String).saif-zone.com/ConsumeToken.aspx?TokenID=" + (jsonResult!.value(forKey: "AuthResult")  as! String),forKey: "URL")
                                        self.getData()
            
                                    })
            
                                }
                                else
                                {
                                    DispatchQueue.main.async(execute: {
                                        self.gotoLoginPage()
                                    })
            
                                }
                            } else {
                                print("No Data")
                                // couldn't load JSON, look at error
                            }
            
                        }
                        catch
                        {
                            print(error)
            
                        }
            }).resume()
        
//        let request : NSMutableURLRequest = NSMutableURLRequest()
//        request.url = URL(string: url)
//
//
//        NSURLConnection.sendAsynchronousRequest(request as URLRequest, queue: OperationQueue(), completionHandler:{ (response:URLResponse?, data: Data?, error: Error?) -> Void in
//            var _: AutoreleasingUnsafeMutablePointer<NSError?>? = nil
//
//            do
//
//            {
//                guard data != nil else{
//                return
//                }
//
//                let jsonResult :NSDictionary! = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as! NSDictionary
//
//                if (jsonResult != nil) {
//                    // process jsonResult
//
//                    if jsonResult!.value(forKey: "AuthResult")  as! String != "NOTAUTHORIZED"
//                    {
//                        print("AUTO LOGIN SUCCESS")
//                        DispatchQueue.main.async(execute: {
//
//                            // vc.Url = "http://dev.saif-zone.com/en/m/Pages/ConsumeToken.aspx?TokenID=" + (jsonResult!.valueForKey("AuthResult")  as! String)
//                            // UserDefaults.standard.set("http://devdpm.saif-zone.com/ConsumeToken.aspx?TokenID=" + (jsonResult!.value(forKey: "AuthResult")  as! String), forKey: "URL")
//
//                            //                            self.Url = "http://devdpm.saif-zone.com/ConsumeToken.aspx?TokenID=" + (jsonResult!.value(forKey: "AuthResult")  as! String)
//                            // self.MainFunc()
//                            UserDefaults.standard.set("http://\(UserDefaults.standard.object(forKey: "tokenType") as! String).saif-zone.com/ConsumeToken.aspx?TokenID=" + (jsonResult!.value(forKey: "AuthResult")  as! String),forKey: "URL")
//                            self.getData()
//
//                        })
//
//                    }
//                    else
//                    {
//                        DispatchQueue.main.async(execute: {
//                            self.gotoLoginPage()
//                        })
//
//                    }
//                } else {
//                    print("No Data")
//                    // couldn't load JSON, look at error
//                }
//
//            }
//            catch
//            {
//                print(error)
//
//            }
//
//
//        })
        
    }
    
    func evaluatePolicyFailErrorMessageForLA(errorCode: Int) -> String {
        var message = ""
        if #available(iOS 11.0, macOS 10.13, *) {
            switch errorCode {
            case LAError.biometryNotAvailable.rawValue:
                message = "Authentication could not start because the device does not support biometric authentication."
                
            case LAError.biometryLockout.rawValue:
                message = "Authentication could not continue because the user has been locked out of biometric authentication, due to failing authentication too many times."
                
            case LAError.biometryNotEnrolled.rawValue:
                message = "Authentication could not start because the user has not enrolled in biometric authentication."
                
            default:
                message = "Did not find error code on LAError object"
            }
        } else {
            switch errorCode {
            case LAError.touchIDLockout.rawValue:
                message = "Too many failed attempts."
                
            case LAError.touchIDNotAvailable.rawValue:
                message = "TouchID is not available on the device"
                
            case LAError.touchIDNotEnrolled.rawValue:
                message = "TouchID is not enrolled on the device"
                
            default:
                message = "Did not find error code on LAError object"
            }
        }
        
        return message;
    }
    
    func evaluateAuthenticationPolicyMessageForLA(errorCode: Int) -> String {
        
        var message = ""
        
        switch errorCode {
            
        case LAError.authenticationFailed.rawValue:
            message = "The user failed to provide valid credentials"
            
        case LAError.appCancel.rawValue:
            message = "Authentication was cancelled by application"
            
        case LAError.invalidContext.rawValue:
            message = "The context is invalid"
            
        case LAError.notInteractive.rawValue:
            message = "Not interactive"
            
        case LAError.passcodeNotSet.rawValue:
            message = "Passcode is not set on the device"
            
        case LAError.systemCancel.rawValue:
            message = "Authentication was cancelled by the system"
            
        case LAError.userCancel.rawValue:
            message = "The user did cancel"
            
        case LAError.userFallback.rawValue:
            message = "The user chose to use the fallback"
            
        default:
            message = evaluatePolicyFailErrorMessageForLA(errorCode: errorCode)
        }
        
        return message
    }
}



