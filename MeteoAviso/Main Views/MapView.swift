//
//  MapView.swift
//  MAviso

// Abstract:
// A view that hosts an `MKMapView`.
//
//  Created by Enrique Garcia Illera on 19/04/2020.
//  Copyright © 2020 Enrique Garcia Illera. All rights reserved.
//
import SwiftUI
import MapKit

struct MapView: UIViewRepresentable {
    @EnvironmentObject var msList: MesasurementsList
    @Binding var measurementToDisplay: Measurement
    @Binding var stationSelected: String
    
    
    var lat: Double
    var lon: Double
    
    
     func makeUIView(context: Context) -> MKMapView {
        print("File: \(#file), Function: \(#function), line: \(#line)")
        
        // Create map and set its delegate
        let mapView = MKMapView(frame:UIScreen.main.bounds)
        mapView.delegate = context.coordinator
        
        // Configure map: center, accuracy, ...
        let regionRadius: CLLocationDistance = 25000
        let initialLocation = CLLocation(latitude: self.lat, longitude: self.lon)
        let coordinateRegion = MKCoordinateRegion(center: initialLocation.coordinate,
                                                  latitudinalMeters: regionRadius,
                                                  longitudinalMeters: regionRadius)
        mapView.setRegion(coordinateRegion, animated: true)
        mapView.showsUserLocation = true
        
        // Register the marker view to be used by the map, instead of configuring
        // it in mapView:viewFor method
        mapView.register(MarkerMeasurementView.self,
                         forAnnotationViewWithReuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)
        
        return mapView
    }

    func updateUIView(_ uiView: MKMapView, context: Context) {
        //print("File: \(#file), Function: \(#function), line: \(#line)")
        var ms_annotations:[MeasurementAnnotation] = []
        
        // This funcion will be called when object MeasurementsList has been filled
        // with all the measurements. But we want to be sure we populate the map
        // only once, so we check the .filled and .showed flags.
        if self.msList.filled && !self.msList.showed {
            
            // Remove old annotations before adding new ones
            let old_annotations = uiView.annotations
            if old_annotations.count > 1 {
                print("Removing \(old_annotations.count) annotations")
                uiView.removeAnnotations(old_annotations)
            }
            
            for measurement in self.msList.msArray {
                ms_annotations.append(MeasurementAnnotation.init(measurement: measurement))
            }
            print("Adding measurements to map ...")
            uiView.addAnnotations(ms_annotations)
            self.msList.showed = true
        }
        
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, MKMapViewDelegate {
        var parent: MapView
        
        init(_ parent: MapView) {
            self.parent = parent
        }
        
        // Coordinator implements the functions to work as
        // delegate of the MkMapView instance inside this view
        func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView,
                     calloutAccessoryControlTapped control: UIControl) {
            print("File: \(#file), Function: \(#function), line: \(#line)")
            
            let annotationSelected = view.annotation as! MeasurementAnnotation
            print("Map button pressed for station: \(annotationSelected.measurement.name)")
            parent.stationSelected = annotationSelected.measurement.name
            parent.measurementToDisplay = annotationSelected.measurement
        }
        
    }
    
}

#if DEBUG
struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView(measurementToDisplay: .constant(Measurement()),stationSelected: .constant(""),
                lat: 41.4, lon: -3.6).environmentObject(MesasurementsList())
    }
}
#endif
