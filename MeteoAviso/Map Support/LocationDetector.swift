//
//  LocationDetector.swift
//  MAviso
//
//  Created by Enrique Garcia Illera on 22/08/2020.
//  Copyright © 2020 Enrique Garcia Illera. All rights reserved.
//

import CoreLocation

class LocationDetector : NSObject,CLLocationManagerDelegate {
    
    let manager = CLLocationManager()
    var location : CLLocation?
    
    override init() {
        print("File: \(#file), Function: \(#function), line: \(#line)")
        super.init()
        self.manager.delegate = self
        self.manager.requestWhenInUseAuthorization()
        self.manager.requestLocation()
        self.location = nil
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            print("Found user's location: \(location)")
        }
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Failed to find user's location: \(error.localizedDescription)")
    }
    
}
