//
//  MKMarkerMeasurementView.swift
//  MeteoAviso
//
//  Created by egi on 18/11/2018.
//  Copyright © 2018 egaillera. All rights reserved.
//

import Foundation
import MapKit

// Details about how a measurement marker should be seen
// in the map
class MarkerMeasurementView: MKMarkerAnnotationView {
    override var annotation: MKAnnotation? {
        willSet {
            
            guard let measurementAnnotation = newValue as? MeasurementAnnotation else { return }
            
            // Set callout position and elements
            canShowCallout = true
            calloutOffset = CGPoint(x: 0, y: 5)
            rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
            
            // Configure callout according to rainfall and station
            // type (AEMET or Meteoclimatic)
            markerTintColor = measurementAnnotation.markerTintColor
            glyphText = measurementAnnotation.markerStationType
        }
    }
}
