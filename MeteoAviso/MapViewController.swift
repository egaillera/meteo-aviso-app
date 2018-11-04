//
//  MapViewController.swift
//  MeteoAviso
//
//  Created by egi on 01/11/2018.
//  Copyright © 2018 egaillera. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate {
    
    @IBOutlet weak var mapView: MKMapView!

    override func viewDidLoad() {
        print("File: \(#file), Function: \(#function), line: \(#line)")
        super.viewDidLoad()
        mapView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        mapView.showsUserLocation = true
        getStationsFromServer()
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
    
    // MARK: - MKMapViewDelegate methods
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        let visibleRegion = MKCoordinateRegionMakeWithDistance(userLocation.coordinate, 25000, 25000)
        self.mapView.setRegion(self.mapView.regionThatFits(visibleRegion), animated: true)
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        if annotation is MKUserLocation { return nil }
        
        return nil
    }
    
}

