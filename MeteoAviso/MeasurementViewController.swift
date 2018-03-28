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
            locationManager.desiredAccuracy = kCLLocationAccuracyKilometer // You can change the location accuracy here.
            //locationManager.startUpdatingLocation()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        locationManager.requestLocation()
        
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
        guard let _: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        
        //myServer.getClosestMeasurement(self, lat: Float(locValue.latitude), lon: Float(locValue.longitude))
        
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
    
 
    
}

