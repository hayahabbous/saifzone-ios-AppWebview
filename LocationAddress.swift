//
//  LocationAddress.swift
//  SaifZone
//
//  Created by mai malash on 8/18/15.
//  Copyright (c) 2015 mai malash. All rights reserved.
//

import UIKit
import MapKit

class LocationAddress: NSObject , MKAnnotation {
    let Locatitle: String
    let locationName: String
    let discipline: String
    let coordinate: CLLocationCoordinate2D
    
    init(title: String, locationName: String, discipline: String, coordinate: CLLocationCoordinate2D) {
        self.Locatitle = title
        self.locationName = locationName
        self.discipline = discipline
        self.coordinate = coordinate
        
        super.init()
    }
    
    /*var subtitle: String {
        return locationName
    }*/
}
   

