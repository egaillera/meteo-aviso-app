//
//  StationAnnotation.swift
//  MeteoAviso
//
//  Created by egi on 01/11/2018.
//  Copyright © 2018 egaillera. All rights reserved.
//

import Foundation
import MapKit

class StationAnnotation: NSObject, MKAnnotation {
    let title: String?
    let subtitle: String?
    let coordinate: CLLocationCoordinate2D
    
    init(station:Station) {
        self.title = station.name
        self.subtitle = "15ºC"
        self.coordinate = CLLocationCoordinate2D(latitude:CLLocationDegrees(station.lat),longitude:CLLocationDegrees(station.lon))
        
        super.init()
    }
    
    
}

