//
//  vcMenu.swift
//  SaifZone
//
//  Created by mai malash on 8/17/15.
//  Copyright (c) 2015 mai malash. All rights reserved.
//

import UIKit

class vcMenu: UIViewController  , UITableViewDelegate , UITableViewDataSource {
 var MenuArray: [String] = []
  
    @IBOutlet weak var tbMenuBar: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tbMenuBar.delegate = self
        self.tbMenuBar.dataSource = self
        //self.tbMenuBar.allowsSelection = false
        self.tbMenuBar.separatorStyle = .none
        self.tbMenuBar.frame = self.view.bounds
        //MenuArray.append("Contact Us")
         MenuArray.append("Location")
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
  
    
     func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }
    
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return MenuArray.count
    }
    
    
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "menuCell", for: indexPath) 
    cell.textLabel?.text = MenuArray[(indexPath as NSIndexPath).row]
    // Configure the cell...
    
    return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.checkInternet(false, completionHandler:
            {(internet:Bool) -> Void in
                if (internet)
                {
                    let centerViewController = self.storyboard?.instantiateViewController(withIdentifier: "SaifZoneMap") as! vcMap
                    _ = UINavigationController(rootViewController: centerViewController)
                    let MyappDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
                    MyappDelegate.centerContainer!.centerViewController = centerViewController
                    MyappDelegate.centerContainer?.toggle(MMDrawerSide.left, animated: true, completion: nil)

                }
                
        })
        
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
