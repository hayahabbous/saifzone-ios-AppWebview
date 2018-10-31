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

class EntryController : UIViewController, WKNavigationDelegate, XMLParserDelegate{
    
    @IBOutlet weak var landingWebView: WKWebView!
    var isLoading : Bool = false
    var Url : String = "http://saif-zone.com/en/m/Pages/default.aspx"

    override func loadView() {
        let webConfiguration = WKWebViewConfiguration()
        landingWebView = WKWebView(frame: .zero, configuration: webConfiguration)
        landingWebView.navigationDelegate = self
        view = landingWebView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
 
    
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        let clickedUrl : String = (navigationAction.request.mainDocumentURL?.absoluteString)!
       
        if clickedUrl.contains("Login.aspx")
        {
            print("**DID LOAD is login true*\(clickedUrl)")
            decisionHandler(WKNavigationActionPolicy.cancel)
            let secure = UserDefaults.standard.object(forKey: "secure") ?? "false"
            let autoLogin = UserDefaults.standard.object(forKey: "autoLogin")  ?? "false"
            
            
            if secure as! String == "true" && autoLogin as! String == "true"{
                authenticationWithTouchID()
            }else{
                gotoLoginPage()
            }
        }
//        else if (clickedUrl == "http://dibba.dcxportal.com/login.aspx?LanguageId=2" && String(describing: signed) == "true") {
//
//            goForLogin()
//
//        }
//        else if clickedUrl == "http://dibba.dcxportal.com/login.aspx?LanguageId=1" {
//            let vc : UIViewController = self.storyboard?.instantiateViewController(withIdentifier: "SignID") as! SignIn
//
//            self.present(vc, animated: true, completion: nil)
//            decisionHandler(WKNavigationActionPolicy.cancel)
//            return
//        }else  if clickedUrl == "http://dibba.dcxportal.com/login.aspx?LanguageId=2" {
//
//            let vc : UIViewController = self.storyboard?.instantiateViewController(withIdentifier: "SignID") as! SignIn
//
//            self.present(vc, animated: true, completion: nil)
//            getData()
//            //            decisionHandler(WKNavigationActionPolicy.cancel)
//            //            return
//        }
//        else  if clickedUrl == "http://dibba.dcxportal.com/login.aspx" {
//            let vc : UIViewController = self.storyboard?.instantiateViewController(withIdentifier: "SignID") as! SignIn
//
//            self.present(vc, animated: true, completion: nil)
//            getData()
//            //            decisionHandler(WKNavigationActionPolicy.cancel)
//            //            return
//        }
//        else  if clickedUrl == "http://dibba.dcxportal.com/logout.aspx" {
//            UserDefaults.standard.set("false", forKey: "Signed_in")
//            UserDefaults.standard.removeObject(forKey: "ID")
//            UserDefaults.standard.removeObject(forKey: "Pass")
//            UserDefaults.standard.set("http://dibba.dcxportal.com/default.aspx", forKey: "URL")
//            getData()
//        }else  if ((clickedUrl.range(of: "FileID")) != nil) {
//            isLoading = true
//            UserDefaults.standard.set(clickedUrl, forKey: "file")
//            let vc : UIViewController = self.storyboard?.instantiateViewController(withIdentifier: "showData") as! ShowData
//            self.present(vc, animated: true, completion: nil)
//            decisionHandler(WKNavigationActionPolicy.cancel)
//            return
//        }
        
        decisionHandler(WKNavigationActionPolicy.allow)
        
    }
    func getData() {
        if Utilities().isInternetAvailable() == false{
            showAlert(message: "No internet connection")
            return
        }
        print("****** Get Data ******")
        let urlOther :String = UserDefaults.standard.object(forKey: "URL") as! String
        let url : URL = URL(string : urlOther)!
        let request = URLRequest(url: url)
        landingWebView.load(request)
    }
    
    override func viewDidAppear(_ animated: Bool) {
//        let signed = UserDefaults.standard.object(forKey: "Signed_in") ?? "false"
//        if String(describing : signed) == "true"
//        {
//            goForLogin()
//        }else{
            UserDefaults.standard.set(Url, forKey: "URL")
            getData()
        //}
    }
    func goForLogin() -> Void {
        
        if Utilities().isInternetAvailable() == false{
            showAlert(message: "No Internet connection")
            return
        }
        let requestString = "<?xml version='1.0' encoding='utf-8'?> <soap:Envelope xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' xmlns:xsd='http://www.w3.org/2001/XMLSchema' xmlns:soap='http://schemas.xmlsoap.org/soap/envelope/'><soap:Body><Authenticate xmlns='http://tempuri.org/'><UserName>\(UserDefaults.standard.object(forKey: "ID") ?? "NULL")</UserName><Password>\(UserDefaults.standard.object(forKey: "Pass") ?? "NULL")</Password><DeviceID>123456789034567898765434567</DeviceID><Platform>2</Platform></Authenticate></soap:Body></soap:Envelope>"
        
        print("*******~Go For Login********")
        
        let urlString = "http://dibba.dcxportal.com/Authenticate.asmx?op=Authenticate"
        let url = URL(string: urlString)
        //{setting SOAP Message …..}
        
        //Better use `URLRequest` than `NSMutableURLRequest`
        var theRequest = URLRequest(url: url!)
        //Use `utf8.count`, `characters.count` is not suitable for `Content-Length`...
        // let msgLength = requestString.utf8.count
        theRequest.addValue("text/xml", forHTTPHeaderField: "Content-Type")
        //When you set `httpBody` of a `URLRequest` with `Data`, `Content-Length` is automatically set.
        // theRequest.addValue(String(msgLength), forHTTPHeaderField: "Content-Length")
        theRequest.httpMethod = "POST"
        theRequest.httpBody = requestString.data(using: String.Encoding.utf8, allowLossyConversion: false)
        
        let session = URLSession.shared
        
        let task = session.dataTask(with: theRequest, completionHandler: { (data, response, error) in
            //Use conditional binding where you can
            
            if error == nil{
                //Do parsing here...
                let XMLparser = XMLParser(data: data!)
                XMLparser.delegate = self
                XMLparser.parse()
                XMLparser.shouldResolveExternalEntities = true
            }
            
        })
        
        task.resume()
        
    }
    
    private func parser(parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [NSObject : AnyObject]) {
        
        // Can see elements in the soap response being printed.
    }
    
    
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        
        if elementName == "AuthenticateResult" {
            //print(self.foundChare);
            
        }
        
        
        
    }
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        
        // This prints "Error"
        if string == "NOTAUTHORIZED"{
            
            UserDefaults.standard.set("false", forKey: "Signed_in")
            UserDefaults.standard.set("http://dibba.dcxportal.com/default.aspx", forKey: "URL")
            
            
        }else{
            
            let url : String = "http://dibba.dcxportal.com/ConsumeToken.aspx?TokenID="+string
            UserDefaults.standard.set(url, forKey: "URL")
            UserDefaults.standard.set("true", forKey: "Signed_in")
            DispatchQueue.main.async {
                self.getData()
            }
            
        }
    }
    
    func showAlert(message : String){
        let alert = UIAlertController(title: "Alert", message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Refresh", style: UIAlertActionStyle.default, handler: {(action:UIAlertAction!) in
            self.viewDidAppear(true)
            
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
}

extension EntryController {
    
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
                    
                    print(self.evaluateAuthenticationPolicyMessageForLA(errorCode: error._code))
                    
                    //TODO: If you have choosen the 'Fallback authentication mechanism selected' (LAError.userFallback). Handle gracefully
                    
                }
            }
        } else {
            
            guard let error = authError else {
                return
            }
            //TODO: Show appropriate alert if biometry/TouchID/FaceID is lockout or not enrolled
            print(self.evaluateAuthenticationPolicyMessageForLA(errorCode: error.code))
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
        let originalString = UserDefaults.standard.object(forKey: "password")  as! String
        var escapedString = originalString.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
        print(escapedString!)
        escapedString = escapedString?.replacingOccurrences(of: "%", with: "7m7m7m")
        escapedString = escapedString?.replacingOccurrences(of: "*", with: "8m8m8m")
        print(escapedString!)
        
        let url :String = "http://devdpa.saif-zone.com/authenticate/GetValue/\(UserDefaults.standard.object(forKey: "userName")  as! String)/\(escapedString!)/\(name)"
        // let url :String =  "http://ws.saif-zone.com:7777/authenticate/GetValue/" + txtUserName.text! + "/" + txtPassword.text! + "/" + name
        print("*****URL*****\(url)")
        let request : NSMutableURLRequest = NSMutableURLRequest()
        request.url = URL(string: url)
        
        
        NSURLConnection.sendAsynchronousRequest(request as URLRequest, queue: OperationQueue(), completionHandler:{ (response:URLResponse?, data: Data?, error: Error?) -> Void in
            var _: AutoreleasingUnsafeMutablePointer<NSError?>? = nil
            
            do
                
            {
                
                let jsonResult :NSDictionary! = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as! NSDictionary
                
                if (jsonResult != nil) {
                    // process jsonResult
                    
                    if jsonResult!.value(forKey: "AuthResult")  as! String != "NOTAUTHORIZED"
                    {
                        DispatchQueue.main.async(execute: {
                            
                            // vc.Url = "http://dev.saif-zone.com/en/m/Pages/ConsumeToken.aspx?TokenID=" + (jsonResult!.valueForKey("AuthResult")  as! String)
                            self.Url = "http://devdpm.saif-zone.com/ConsumeToken.aspx?TokenID=" + (jsonResult!.value(forKey: "AuthResult")  as! String)
                           // self.MainFunc()
                            //   vc.Url =  "http://mPortal.saif-zone.com/ConsumeToken.aspx?TokenID=" + (jsonResult!.valueForKey("AuthResult")  as! String)
                        })
                        
                    }
                    else
                    {
                        self.gotoLoginPage()
                        
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
            
            
        })
        
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


