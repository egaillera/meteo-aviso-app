//
//  MapViewController.swift
//  MeteoAviso
//
//  Created by egi on 01/11/2018.
//  Copyright © 2018 egaillera. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    
    @IBAction func refreshButton(_ sender: Any) {
        print("File: \(#file), Function: \(#function), line: \(#line)")
        
        let allAnnotations = self.mapView.annotations
        self.mapView.removeAnnotations(allAnnotations)
        getMeasurementsFromServer()
    }
    
    let locationManager = CLLocationManager()
    var locationDetected = false
    let activityIndicator = ActivityIndicatorUtils()
    
    var stCode:String = "" // Code of the selected station
    var measurementSelected:Measurement?

    override func viewDidLoad() {
        print("File: \(#file), Function: \(#function), line: \(#line)")
        super.viewDidLoad()
        mapView.delegate = self
        
        self.locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyKilometer
        }
        
        // Asking for the location will trigger a call to locationManager,
        // that will provide the center coordinates for the map
        locationManager.requestLocation()
        
        // Register the marker view to be used by the map, instead of configuring
        // it in mapView:viewFor method
        mapView.register(MarkerMeasurementView.self,
                         forAnnotationViewWithReuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        mapView.showsUserLocation = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getMeasurementsFromServer() {
        
        print("File: \(#file), Function: \(#function), line: \(#line)")
        
        let url:URL = URL(string: MeteoServer.serverURL + "last_measurements")!
        let session = URLSession.shared
        var msList:[Measurement]?
        
        let request = NSMutableURLRequest(url: url)
        request.httpMethod = "GET"
        request.cachePolicy = NSURLRequest.CachePolicy.reloadIgnoringCacheData
        
        print("Adding measurements to map ...")
        //self.activityIndicator.showActivityIndicator(uiView: self.view)
        EZLoadingActivity.show("Cargando observaciones ...",disableUI: true)
        
        let task = session.dataTask(with: request as URLRequest, completionHandler: {
            (data, response, error) in
            
            // Treat communication error
            guard let _:Data = data, let _:URLResponse = response  , error == nil else {
                print("error=\(String(describing: error))")
                MeteoServer.treatServerError(currentView: self)
                return
            }
            do {
                // Decode retrieved data with JSONDecoder
                msList = try JSONDecoder().decode([Measurement].self, from: data!)
                
            } catch let jsonError {
                print(jsonError)
                msList =  nil
            }
            
            // Add anotations to the map
            DispatchQueue.main.async {
                var ms_annotations:[MeasurementAnnotation] = []
                if msList != nil {
                    for measurement in msList! {
                        ms_annotations.append(MeasurementAnnotation.init(measurement: measurement))
                    }
                }
                self.mapView.addAnnotations(ms_annotations)
                //self.activityIndicator.hideActivityIndicator(uiView: self.view)
                EZLoadingActivity.hide(true,animated: true)
                print(".. added!!")
            }
        })
        
        task.resume()
    }
    
    // MARK: - locationManager delegete methods
    
    // The location is ready,so now we can center the map
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("File: \(#file), Function: \(#function), line: \(#line)")
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        
        print("Detected location: lat = \(locValue.latitude),lon = \(locValue.longitude)")
        
        // To avoid several calls to getMeasurementFromServer()
        if locationDetected == false {
            let initialLocation = CLLocation(latitude: locValue.latitude, longitude: locValue.longitude)
            let regionRadius: CLLocationDistance = 25000
            let coordinateRegion = MKCoordinateRegionMakeWithDistance(initialLocation.coordinate,
                                                                      regionRadius, regionRadius)
            mapView.setRegion(coordinateRegion, animated: true)
            mapView.showsUserLocation = true
            getMeasurementsFromServer()
            locationDetected = true
        }
        else {
            print("More than one call to locationManager(:didUpdateLocations)")
        }
        
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
    
 /*
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        if annotation is MKUserLocation { return nil }
        
        let identifier = "marker"
        
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
        if annotationView == nil {
            annotationView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
        } else {
            annotationView!.annotation = annotation
        }
        annotationView?.canShowCallout = true
        annotationView?.calloutOffset = CGPoint(x: 0, y: 5)
        annotationView?.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        annotationView?.tintColor = annotation.markTintColor as MeasurementAnnotation
        
        return annotationView
    } */
 
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView,
                 calloutAccessoryControlTapped control: UIControl) {
        print("File: \(#file), Function: \(#function), line: \(#line)")
        
        let annotationSelected = view.annotation as! MeasurementAnnotation
        measurementSelected = annotationSelected.measurement
        print("Map button pressed for station: %s",measurementSelected?.name)
        performSegue(withIdentifier: "FromMapToStationView", sender: nil)
    }
    
     // MARK: - segue methods
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print("File: \(#file), Function: \(#function), line: \(#line)")
        if segue.identifier == "FromMapToStationView" {
            print("Called FromMapToStationView segue")
            let theStationView = segue.destination as! StationViewController
            //theStationView.stationCode = stCode
            theStationView.measurement = measurementSelected
        }
    }

}

