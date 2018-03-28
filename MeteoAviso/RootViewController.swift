//
//  RootViewController.swift
//  MeteoAviso
//
//  Created by egi on 24/2/18.
//  Copyright © 2018 egaillera. All rights reserved.
//

import UIKit
import CoreLocation


class RootViewController: UIViewController,CLLocationManagerDelegate {
    
    @IBOutlet var myScrollView : UIScrollView!
    @IBOutlet var myContentView : GradientView!
    
    let myServer = MeteoServer()
    var measurement:Measurement?
    
    let locationManager = CLLocationManager()
    
    @IBOutlet var stationName : UILabel!
    @IBOutlet var date : UILabel!
    @IBOutlet var temp : UILabel!
    @IBOutlet var rainfall : UILabel!
    
    var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action:
            #selector(RootViewController.handleRefresh(_:)),
                                 for: UIControlEvents.valueChanged)
        refreshControl.tintColor = UIColor.red
        
        return refreshControl
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        myScrollView.refreshControl = self.refreshControl
        //myScrollView.contentSize = CGSize(width:myContentView.frame.width, height:myContentView.frame.height)
        
        // TODO: make them depending on time (night, day)
        myContentView.firstColor = UIColor(red:0.04, green:0.53, blue:0.68, alpha:1.0)
        myContentView.secondColor = UIColor(red:0.49, green:0.86, blue:0.98, alpha:1.0)
        
        self.locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyKilometer // You can change the location accuracy here.
            //locationManager.startUpdatingLocation()
        }
        
        //addGradientToView(view: myContentView)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        locationManager.requestLocation()
        
    }
    
    override func viewDidLayoutSubviews() {
        // Do something when rotates
        
        
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
            
            self.refreshControl.endRefreshing()
        }
        
    }
    
    // The location is ready,so now we can get the closest measurement
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("Function: \(#function), line: \(#line)")
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        
        myServer.getClosestMeasurement(self, lat: Float(locValue.latitude), lon: Float(locValue.longitude))
        
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
        print("Function: \(#function), line: \(#line)")
        
        // Asking for a new location will trigger the call to MeteoServer
        locationManager.requestLocation()
        
    }

    
}
