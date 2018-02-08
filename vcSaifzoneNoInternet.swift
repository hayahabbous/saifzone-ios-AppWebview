//
//  vcSaifzoneNoInternet.swift
//  SaifZone
//
//  Created by mai malash on 8/17/15.
//  Copyright (c) 2015 mai malash. All rights reserved.
//

import UIKit

class vcSaifzoneNoInternet: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func BtnRefresh(_ sender: AnyObject) {
       
       /* self.checkInternet(false, completionHandler:
            {(internet:Bool) -> Void in
                if (internet)
                {
                    let  story : UIStoryboard = UIStoryboard(name:"Main" , bundle: nil)
                    let vc : ViewController = story.instantiateViewControllerWithIdentifier("MainView") as! ViewController
                    
                    
                    
                    self.presentViewController(vc,animated : true , completion: nil)
                    
                 
                  /* //For drower
                    var centerViewController = self.storyboard?.instantiateViewControllerWithIdentifier("MainView") as! ViewController
                    var centerNavController = UINavigationController(rootViewController: centerViewController)
                    var MyappDelegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
                    MyappDelegate.centerContainer!.centerViewController = centerViewController*/
                   
                    
                }
                
        })*/
        
        if  Reachability.isConnectedToNetwork() {
            
            let  story : UIStoryboard = UIStoryboard(name:"Main" , bundle: nil)
            let vc : ViewController = story.instantiateViewController(withIdentifier: "MainView") as! ViewController
            
            
            
            self.present(vc,animated : true , completion: nil)
            

        }else{
            print("no-internet")
        }
        

    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func checkInternet(_ flag:Bool, completionHandler:@escaping (_ internet:Bool) -> Void)
    {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        let url = URL(string: "http://www.google.com/")
        let request = NSMutableURLRequest(url: url!)
        request.httpMethod = "HEAD"
        request.cachePolicy = NSURLRequest.CachePolicy.reloadIgnoringLocalAndRemoteCacheData
        request.timeoutInterval = 10.0
        
        NSURLConnection.sendAsynchronousRequest(request as URLRequest, queue:OperationQueue.main, completionHandler:
            {(response: URLResponse?, data: Data?, error: NSError?) -> Void in
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
                let rsp = response as! HTTPURLResponse?
                completionHandler(rsp?.statusCode == 200)
        } as! (URLResponse?, Data?, Error?) -> Void)
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
