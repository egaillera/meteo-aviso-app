//
//  MeasurementViewController.swift
//  MeteoAviso
//
//  Created by egi on 31/3/17.
//  Copyright © 2017 egaillera. All rights reserved.
//

import UIKit
import CoreLocation


class MeasurementViewController: UIViewController, CLLocationManagerDelegate {
    
    let myServer = MeteoServer()
    var measurement:Measurement?
    
    let locationManager = CLLocationManager()
    var locationIsSet = false
    
    @IBOutlet var stationName : UILabel!
    @IBOutlet var date : UILabel!
    @IBOutlet var temp : UILabel!
    @IBOutlet var rainfall : UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest // You can change the locaiton accuary here.
            locationManager.startUpdatingLocation()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MeteoServer will call this when the measurement is
    // ready to be shown
    func sendMeasurement(_ measurement:Measurement?) {
        print("Function: \(#function), line: \(#line)")
        
        DispatchQueue.main.async {
            self.stationName.text = measurement!.name
            self.date.text = measurement!.date_created
            self.temp.text = "\(measurement!.current_temp)"
            self.rainfall.text = "\(measurement!.rainfall)"
            self.view.setNeedsDisplay()
        }
        
    }
    
    // The location is ready,so now we can get the closest measurement
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("Function: \(#function), line: \(#line)")
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        
        // We need the location only one time
        if !self.locationIsSet {
            
            self.locationIsSet = true
            
            // MeteoServer class will call back when the measurement is ready
            myServer.getClosestMeasurement(self, lat: Float(locValue.latitude), lon: Float(locValue.longitude))
        }
    }
    
 
    
}

