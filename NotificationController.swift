//
//  NotificationController.swift
//  SAIF Zone
//
//  Created by macbook pro on 3/7/18.
//  Copyright © 2018 mai malash. All rights reserved.
//

import Foundation

import UIKit
import  WebKit
class NotificationController : UIViewController, WKNavigationDelegate{
    
    @IBOutlet weak var webView: WKWebView!
    @IBAction func onBackClick(_ sender: UIButton) {
        let  story : UIStoryboard = UIStoryboard(name:"Main" , bundle: nil)
        let vc : ViewController = story.instantiateViewController(withIdentifier: "MainView") as! ViewController
        
        self.present(vc,animated : true , completion: nil)
    }
    override func viewDidLoad() {
        webView.navigationDelegate = self

        var urlOther :String = UserDefaults.standard.object(forKey: "notificationURL") as! String
        guard  urlOther != nil else{
            return
        }
        if  urlOther.range(of:"http://") == nil{
            urlOther = "http://" + urlOther
        }
        let url : URL = URL(string : urlOther)!
        let request = URLRequest(url: url)
        webView.load(request)
    }
    
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        print("Error On Navigation")
        let alert = UIAlertController(title: "Alert", message: "Server not found!", preferredStyle: UIAlertControllerStyle.alert)
        
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: {(action:UIAlertAction!) in
            let  story : UIStoryboard = UIStoryboard(name:"Main" , bundle: nil)
            let vc : ViewController = story.instantiateViewController(withIdentifier: "MainView") as! ViewController
            
            self.present(vc,animated : true , completion: nil)
            
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
}
