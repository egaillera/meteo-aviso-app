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
        self.coordinate = CLLocationCoordinate2D(latitude:CLLocationDegrees(measurement.lat),
                                                longitude:CLLocationDegrees(measurement.lon))
    }
    
    var title: String? {
        return Station.replaceHtmlCodesInName(measurement.name)
    }
    
    var subtitle: String? {
        return String(format:"%.1f ºC",measurement.current_temp)
    }
    
    // To set marker color, depending on rainfall
    var markerTintColor: UIColor  {
        if measurement.rainfall > 0 {
            return .cyan
        }
        else {
            return .green
        }
    }
    
    // To mark the station as an AEMET or a Meteoclimatic one
    var markerStationType: String {
        if (measurement.code.prefix(2) == "ES") && (measurement.code.count > 18) {
            return "M"
        }
        else {
            return "A"
        }
    }
}
