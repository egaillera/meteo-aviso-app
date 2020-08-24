//
//  LocationManager.swift
//  MAviso
//
//  Created by Enrique Garcia Illera on 25/04/2020.
//  Copyright © 2020 Enrique Garcia Illera. All rights reserved.
//

import Foundation
import CoreLocation
import Combine

class LocationManager: NSObject, ObservableObject {
  private let locationManager = CLLocationManager()
  let objectWillChange = PassthroughSubject<Void, Never>()

  @Published var status: CLAuthorizationStatus? {
    willSet { objectWillChange.send() }
  }

  @Published var location: CLLocation? {
    willSet {
        print("Location sent")
        objectWillChange.send()
    }
  }

  override init() {
    super.init()

    self.locationManager.delegate = self
    self.locationManager.desiredAccuracy = kCLLocationAccuracyThreeKilometers // to speed location process
    self.locationManager.requestWhenInUseAuthorization()
    
    // Use self.locationManager.startUpdatingLocation() instead
    // if a continous stream of locations is needed
    self.locationManager.requestLocation()
  }

  private func geocode() {
    //print("File: \(#file), Function: \(#function), line: \(#line)")
  }
}

extension LocationManager: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        self.status = status
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        self.location = location
        
        // In case something to do is needed
        //self.geocode()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Failed to find user's location: \(error.localizedDescription)")
    }
}
