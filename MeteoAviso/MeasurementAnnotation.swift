//
//  MeasurementAnnotation.swift
//  MeteoAviso
//
//  Created by egi on 04/11/2018.
//  Copyright © 2018 egaillera. All rights reserved.
//

import Foundation
import MapKit

class MeasurementAnnotation: NSObject, MKAnnotation {
    var measurement:Measurement
    var coordinate: CLLocationCoordinate2D
    
    init(measurement:Measurement) {
        self.measurement = measurement
        self.coordinate = CLLocationCoordinate2D(latitude:CLLocationDegrees(41.1),longitude:CLLocationDegrees(1.1))
    }
    
    var title: String? {
        return measurement.name
    }
    
    var subtitle: String? {
        return String(measurement.current_temp)
    }
    
    
    
}
