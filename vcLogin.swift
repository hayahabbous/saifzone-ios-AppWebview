//
//  vcLogin.swift
//  SaifZone
//
//  Created by mai malash on 1/25/16.
//  Copyright © 2016 mai malash. All rights reserved.
//

import UIKit
import Foundation


class vcLogin: UIViewController ,UITextFieldDelegate, UIScrollViewDelegate{
    
    @IBOutlet weak var txtUserName: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var btnhome: UIButton!
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var pickerUi: UITextField!
    @IBOutlet weak var checkBox: UICheckBox!
    @IBOutlet weak var _btnLogin: UIButton!
    
    let userPicker = UIPickerView()
    let pickerTool = UIToolbar()
    let dataSource : [String] = ["Investor","Employee"]
    let urlSource : [String] = ["GetValue","GetStaffValue"]
    let tokenSource : [String] = ["mPortal","hr"]
    
    
    var selectedUserType : Int = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        _btnLogin.imageView!.contentMode = UIViewContentMode.scaleAspectFit
        txtUserName.delegate = self
        txtPassword.delegate = self
        scrollView.delegate = self
        // Do any additional setup after loading the view.
        let loginInfo : NSDictionary = helper.LoadData()
        if let dict  : NSDictionary = loginInfo {
            //loading values
            if dict["UserName"] != nil && dict["Password"] != nil  {
                if dict["UserName"] as! String != "" && dict["Password"] as! String != "" {
                    DispatchQueue.main.async(execute: {
                        //            self.txtUserName.text = dict["UserName"]  as? String
                        //            self.txtPassword.text = dict["Password"] as? String
                    })
                }
            }
        }
        else {
            print("WARNING: Couldn't create dictionary from SettingLst.plist! Default values will be used!")
        }
        checkBox.isChecked = true
        
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 27, height: 27))
        imageView.image = UIImage(named: "down_arrow")
        pickerUi.rightView = imageView
        pickerUi.rightViewMode = .always
        scrollView.isDirectionalLockEnabled = true
        
        initPickerView()
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.x != 0 {
            scrollView.contentOffset.x = 0
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)),
                                               name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide),
                                               name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    @objc func keyboardWillHide() {
        self.view.frame.origin.y = 0
    }
    
    @objc func keyboardWillChange(notification: NSNotification) {
        
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            self.view.frame.origin.y = -keyboardSize.height/2
            
        }
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        NotificationCenter.default.removeObserver(self,
                                                  name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
        NotificationCenter.default.removeObserver(self,
                                                  name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    func initPickerView(){
        
        userPicker.delegate = self
        userPicker.dataSource = self
        userPicker.backgroundColor = UIColor.white
        userPicker.selectRow(0, inComponent: 0, animated: false)
        pickerUi.inputView = userPicker
        selectedUserType = 0;
        pickerUi.text = dataSource[userPicker.selectedRow(inComponent: 0)]
        initToolbar()
        
    }
    func initToolbar(){
        pickerTool.sizeToFit()
        let doneButton = UIBarButtonItem(title: "DONE", style: .plain, target: self, action: #selector(vcLogin.dismissKeyboard))
        pickerTool.setItems([doneButton], animated: false)
        pickerTool.tintColor = UIColor.white
        pickerTool.barTintColor = UIColor(red:0.78, green:0.20, blue:0.15, alpha: 1)
        pickerTool.isUserInteractionEnabled = true
        pickerUi.inputAccessoryView = pickerTool
    }
    @objc func dismissKeyboard() {
        pickerUi.endEditing(true)
    }
    override func viewDidLayoutSubviews() {
        
        txtUserName.layer.cornerRadius = 8.0
        txtUserName.layer.masksToBounds = true
        txtUserName.layer.borderColor = UIColor(red:0.75, green:0.75, blue:0.75, alpha:1.0).cgColor
        txtUserName.layer.borderWidth = 1.0
        
        txtPassword.layer.cornerRadius = 8.0
        txtPassword.layer.masksToBounds = true
        txtPassword.layer.borderColor = UIColor(red:0.75, green:0.75, blue:0.75, alpha:1.0).cgColor
        txtPassword.layer.borderWidth = 1.0
        
        
        
    }
    
    @IBAction func btnHome(_ sender: AnyObject) {
        UserDefaults.standard.set("http://saif-zone.com/en/m/Pages/default.aspx", forKey: "URL")
        dismiss(animated: true, completion: nil)
        
        
    }
    @IBAction func btnLogin(_ sender: UIButton) {
        
        if(checkBox.isChecked){
            UserDefaults.standard.set("true", forKey: "secure")
        }else{
            UserDefaults.standard.set("false", forKey: "secure")
        }
        let defaults = UserDefaults.standard
        var name : String = "123/1"
        if let str : String = defaults.string(forKey: "deviceID")
        {
            name = str + "/1"
        }
        
        
        guard self.txtPassword.text != "" &&  self.txtUserName.text  != "" else{
            Utilities().showAlert(message: "Please enter username and password", isRefresh : false,actionMessage : "OK", controller: self)
            return
        }
        
        guard Utilities().isInternetAvailable() == true else{
            Utilities().showAlert(message: "Please check internet connetion", isRefresh : false,actionMessage : "OK", controller: self)
            return
        }
        // let url : String = "http://dev.saif-zone.com/_vti_bin/SharePoint.WCFService.Sample/Services/SampleService.svc/Auth(" + txtUserName.text! + "," + txtPassword.text! + "," + name + ")"
        
        
        //let url :String = "http://devdpa.saif-zone.com/authenticate/GetValue/" + txtUserName.text! + "/" + txtPassword.text! + "/" + name
        let url :String =  "http://ws.saif-zone.com:7777/authenticate/\(urlSource[selectedUserType])/" + txtUserName.text! + "/" + txtPassword.text! + "/" + name
        print("Login URL : \(url)")
        
        let loginUrl = URL(string: url)
        var getRequest = URLRequest(url: loginUrl!, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 30.0)
        getRequest.httpMethod = "GET"
        getRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        getRequest.setValue("application/json", forHTTPHeaderField: "Accept")
        
        
        URLSession.shared.dataTask(with: getRequest, completionHandler: { (data, response, error) in
            do
                
            {                guard data != nil else{
                DispatchQueue.main.async(execute: {
                    let alertController = UIAlertController(title: "Login Failed", message:
                        "Please check that userName and password are correct", preferredStyle: UIAlertControllerStyle.alert)
                    alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default,handler: nil))
                    
                    self.present(alertController, animated: true, completion: nil)
                    
                })
                return
                }
                
                let jsonResult :NSDictionary! = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as! NSDictionary
                
                if (jsonResult != nil) {
                    // process jsonResult
                    
                    if jsonResult!.value(forKey: "AuthResult")  as! String != "NOTAUTHORIZED"
                    {
                        self.SaveLoginInfo()
                        DispatchQueue.main.async(execute: {
                            
                            
                            // vc.Url = "http://dev.saif-zone.com/en/m/Pages/ConsumeToken.aspx?TokenID=" + (jsonResult!.valueForKey("AuthResult")  as! String)
                            // UserDefaults.standard.set("http://devdpm.saif-zone.com/ConsumeToken.aspx?TokenID=" + (jsonResult!.value(forKey: "AuthResult")  as! String), forKey: "URL")
                            
                            UserDefaults.standard.set(self.urlSource[self.selectedUserType], forKey: "userType")
                            UserDefaults.standard.set(self.tokenSource[self.selectedUserType], forKey: "tokenType")
                            UserDefaults.standard.set("http://\(self.tokenSource[self.selectedUserType]).saif-zone.com/ConsumeToken.aspx?TokenID=" + (jsonResult!.value(forKey: "AuthResult")  as! String), forKey: "URL")
                            self.dismiss(animated: true, completion: nil)
                            
                        })
                        
                    }
                    else
                    {
                        DispatchQueue.main.async(execute: {
                            let alertController = UIAlertController(title: "Login Failed", message:
                                "Please check that userName and password are correct", preferredStyle: UIAlertControllerStyle.alert)
                            alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default,handler: nil))
                            
                            self.present(alertController, animated: true, completion: nil)
                            
                        })
                        
                    }
                } else {
                    print("No Data")
                    // couldn't load JSON, look at error
                }
                
            }
            catch
            {
                print("######",error)
                
            }
        }).resume()
        
        
    }
    
    func SaveLoginInfo()
    {
        
        UserDefaults.standard.set(txtUserName.text, forKey: "userName")
        UserDefaults.standard.set(txtPassword.text, forKey: "password")
        UserDefaults.standard.set("true", forKey: "autoLogin")
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
                print("Bundle lstSetting.plist file is --> \(resultDictionary?.description)")
                do {
                    try fileManager.copyItem(atPath: bundlePath, toPath: Path)
                }
                catch {
                    print("error")
                }//(bundlePath, toPath: Path)
                print("copy")
            } else {
                print("SettingLst.plist not found. Please, make sure it is part of the bundle.")
            }
        } else {
            print("SettingLst.plist already exits at path.")
            // use this to delete file from documents directory
            //fileManager.removeItemAtPath(path, error: nil)
        }
        
        let dict: NSMutableDictionary = ["XInitializerItem": "DoNotEverChangeMe"]
        //saving values
        dict.setObject(txtUserName.text!, forKey: "UserName" as NSCopying)
        dict.setObject(txtPassword.text!, forKey: "Password" as NSCopying)
        
        
        dict.write(toFile: Path, atomically: false)
        let resultDictionary = NSMutableDictionary(contentsOfFile: Path)
        print("Saved SettingLst file is --> \(resultDictionary?.description)")
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        
        if textField == txtUserName
        {
            txtUserName.layer.cornerRadius = 8.0
            txtUserName.layer.masksToBounds = true
            txtUserName.layer.borderColor = UIColor(red:0.04, green:0.16, blue:0.81, alpha:1.0).cgColor
            txtUserName.layer.borderWidth = 1.0
            
        }
        else if textField == txtPassword
        {
            txtUserName.layer.borderColor = UIColor(red:0.04, green:0.16, blue:0.81, alpha:1.0).cgColor
        }
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @IBAction func btnRegistrationManual(_ sender: AnyObject) {
        guard Utilities().isInternetAvailable() == true else{
            Utilities().showAlert(message: "Please check internet connetion", isRefresh : false,actionMessage : "OK", controller: self)
            return
        }
        UserDefaults.standard.set("https://www.saif-zone.com/en/Services/Documents/OnlineRegistrationProcess.pdf", forKey: "URL")
        
        dismiss(animated: true, completion: nil)
        
        
    }
    @IBAction func btnRegisterNewUser(_ sender: AnyObject) {
        guard Utilities().isInternetAvailable() == true else{
            Utilities().showAlert(message: "Please check internet connetion", isRefresh : false,actionMessage : "OK", controller: self)
            return
        }
        UserDefaults.standard.set("http://www.saif-zone.com/en/m/Pages/RegisterNewUser.aspx", forKey: "URL")
        
        dismiss(animated: true, completion: nil)
        
    }
    @IBAction func btnForgetPassword(_ sender: AnyObject) {
        guard Utilities().isInternetAvailable() == true else{
            Utilities().showAlert(message: "Please check internet connetion", isRefresh : false,actionMessage : "OK", controller: self)
            return
        }
        
        UserDefaults.standard.set( "http://www.saif-zone.com/en/m/Pages/ForgotPassword.aspx", forKey: "URL")
        
        
        dismiss(animated: true, completion: nil)
        
        
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
extension vcLogin : UIPickerViewDelegate,UIPickerViewDataSource{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return dataSource.count
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedUserType = row
        pickerUi.text = dataSource[row]
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return dataSource[row]
    }
    //    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
    //
    //    }
    
    
}














