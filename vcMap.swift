//
//  vcMap.swift
//  SaifZone
//
//  Created by mai malash on 8/17/15.
//  Copyright (c) 2015 mai malash. All rights reserved.
//

import UIKit
import MapKit
//import CoreLocation
class vcMap: UIViewController { //,CLLocationManagerDelegate  {

    @IBOutlet weak var SaifZoneMap: MKMapView!
   // var LocationManager = CLLocationManager()
    let LocationDistance : CLLocationDistance = 100
    
    var mutableData:NSMutableData  = NSMutableData()
    var currentElementName:NSString = ""
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
       
     /*   let saifZoneLocation = CLLocationCoordinate2DMake(25.332775, 55.483096)
        let mapSpan = MKCoordinateSpanMake(0.05, 0.05)
        let mapRegion = MKCoordinateRegionMake(saifZoneLocation,mapSpan)
        self.SaifZoneMap.setRegion(mapRegion, animated: true)
        
       
        let objLocationAddress = LocationAddress(title: "SAIF ZONE المنطقة الحرة بمطار الشارقة الدولي",
            locationName: "SAIF ZONE",
            discipline: "Sharjah United Arab Emirates",
            coordinate: CLLocationCoordinate2D(latitude: 25.332775, longitude: 55.483096))
       
        self.SaifZoneMap.addAnnotation(objLocationAddress)
     
        /*LocationManager.delegate = self
        
        LocationManager.desiredAccuracy = kCLLocationAccuracyBest
        LocationManager.requestWhenInUseAuthorization()
        LocationManager.startUpdatingLocation()*/*/
        let soapMessage =  "Genesis1"
        let soapLenth = String(soapMessage.characters.count)
        let theUrlString = "http://devdp.saif-zone.com/authenticate.svc"
        let theURL = URL(string: theUrlString)
        let mutableR = NSMutableURLRequest(url: theURL!)
        mutableR.addValue("text/xml; charset=utf-8", forHTTPHeaderField: "Content-Type")
        mutableR.addValue("text/html; charset=utf-8", forHTTPHeaderField: "Content-Type")
        mutableR.addValue(soapLenth, forHTTPHeaderField: "Content-Length")
        mutableR.httpMethod = "POST"
        mutableR.httpBody = soapMessage.data(using: String.Encoding.utf8)
        
      /*  let manager = AFHTTPRequestOperation(request: mutableR)
        manager.setCompletionBlockWithSuccess({ (operation : AFHTTPRequestOperation, responseObject : AnyObject) -> Void in
            
            var dictionaryData = NSDictionary()
            do
            {
                dictionaryData = try XMLReader.dictionaryForXMLData(responseObject as! NSData)
                let mainDict = dictionaryData.objectForKey("soap:Envelope")!.objectForKey("soap:Body")!.objectForKey("GetVersesResponse")!.objectForKey("GetVersesResult")   ?? NSDictionary()
                
                if mainDict.count > 0{
                    
                    let mainD = NSDictionary(dictionary: mainDict as! [NSObject : AnyObject])
                    self.performSegueWithIdentifier("details", sender: mainD)
                }
                else{
                    
                    UIAlertView(title: "BooksDetailsq", message: "Oops! No data found.", delegate: nil, cancelButtonTitle: "OK").show()
                }
            }
            catch
            {
                print("Your Dictionary value nil")
            }
            
            print(dictionaryData)
            
            
            }, failure: { (operation : AFHTTPRequestOperation, error : NSError) -> Void in
                
                print(error, terminator: "")
        })
        
        manager.start()*/
        
    }
        
        
        
    
    
       @IBOutlet weak var lbl: UILabel!
    @IBAction func btnBackFromMap(_ sender: AnyObject) {
        let centerViewController = self.storyboard?.instantiateViewController(withIdentifier: "MainView") as! ViewController
        _ = UINavigationController(rootViewController: centerViewController)
        let MyappDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
        MyappDelegate.centerContainer!.centerViewController = centerViewController
               

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
   /* func locationManager(manager: CLLocationManager!, didFailWithError error: NSError!) {
        println("error")
    }
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        LocationManager.stopUpdatingLocation()
        var saifZoneLocation = CLLocationCoordinate2DMake(25.333783 ,55.483833)
        var mapSpan = MKCoordinateSpanMake(0.05, 0.05)
        var mapRegion = MKCoordinateRegionMake(saifZoneLocation,mapSpan)
        self.SaifZoneMap.setRegion(mapRegion, animated: true)
    }*/
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
