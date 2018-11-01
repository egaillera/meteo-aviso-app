//
//  MapViewController.swift
//  MeteoAviso
//
//  Created by egi on 01/11/2018.
//  Copyright © 2018 egaillera. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController, CLLocationManagerDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    
    let locationManager = CLLocationManager()

    override func viewDidLoad() {
        print("File: \(#file), Function: \(#function), line: \(#line)")
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyKilometer
        }
        
        // Asking for the location will trigger the call locationManager,
        // that will provide the center coordinates for the map
        locationManager.requestLocation()
    }
    
    // The location is ready,so now we can center the map
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("File: \(#file), Function: \(#function), line: \(#line)")
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        
        print("Detected location: lat = \(locValue.latitude),lon = \(locValue.longitude)")
        let initialLocation = CLLocation(latitude: locValue.latitude, longitude: locValue.longitude)
        let regionRadius: CLLocationDistance = 25000
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(initialLocation.coordinate,
                                                                  regionRadius, regionRadius)
        mapView.setRegion(coordinateRegion, animated: true)
        mapView.showsUserLocation = true
        getStationsFromServer()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getStationsFromServer() {
        
        print("File: \(#file), Function: \(#function), line: \(#line)")
        
        let url:URL = URL(string: MeteoServer.serverURL + "stations")!
        let session = URLSession.shared
        var stationList:[Station]?
        
        let request = NSMutableURLRequest(url: url)
        request.httpMethod = "GET"
        request.cachePolicy = NSURLRequest.CachePolicy.reloadIgnoringCacheData
        
        let task = session.dataTask(with: request as URLRequest, completionHandler: {
            (data, response, error) in
            
            guard let _:Data = data, let _:URLResponse = response  , error == nil else {
                return
            }
            do {
                // Decode retrieved data with JSONDecoder
                stationList = try JSONDecoder().decode([Station].self, from: data!)
                print(stationList)
                
            } catch let jsonError {
                print(jsonError)
                stationList =  nil
            }
            
            DispatchQueue.main.async {
                var st_annotations:[StationAnnotation] = []
                if stationList != nil {
                    for station in stationList! {
                        st_annotations.append(StationAnnotation.init(station: station))
                    }
                }
                print("Adding stations to map")
                self.mapView.addAnnotations(st_annotations)
            }
        })
        
        task.resume()
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
