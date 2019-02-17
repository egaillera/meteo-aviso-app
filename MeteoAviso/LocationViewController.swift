//
//  LocationViewController.swift
//  MeteoAviso
//
//  Created by egi on 29/3/18.
//  Copyright © 2018 egaillera. All rights reserved.
//

import UIKit
import CoreLocation

class LocationViewController : StationViewController,CLLocationManagerDelegate {
    
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyKilometer
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print("File: \(#file), Function: \(#function), line: \(#line)")
        
        // Asking for the location will trigger the call locationManager, that will
        // call the server to get the closest measurement
        locationManager.requestLocation()
    }
    
    // The location is ready,so now we can get the closest measurement
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("File: \(#file), Function: \(#function), line: \(#line)")
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        
        self.getClosestMeasurement(lat: Float(locValue.latitude), lon: Float(locValue.longitude))
        
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
    
    func getClosestMeasurement(lat:Float, lon:Float) {
        print("File: \(#file), Function: \(#function), line: \(#line)")
        print("Requested closest measurement to lat=\(lat), lon=\(lon)")
        
        let url:URL = URL(string: MeteoServer.serverURL + "closest_measurement?lat=\(lat)&lon=\(lon)")!
        let session = URLSession.shared
        
        let request = NSMutableURLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue(MeteoServer.iOSapiKey, forHTTPHeaderField: "Authorization")
        request.cachePolicy = NSURLRequest.CachePolicy.reloadIgnoringCacheData
        
        let task = session.dataTask(with: request as URLRequest, completionHandler: {
            (data, response, error) in
            
            guard let _:Data = data, let _:URLResponse = response  , error == nil else {
                return
            }
            self.displayNewMeasurement(self.extractJsonMeasurement(data!))
        })
        
        task.resume()
    }
    
    @objc override func handleRefresh(_ refreshControl: UIRefreshControl) {
        print("File: \(#file), Function: \(#function), line: \(#line)")
        
        // Asking for a new location will trigger the call to MeteoServer
        locationManager.requestLocation()
    }
    
    
}
