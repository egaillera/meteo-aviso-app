//
//  ViewController.swift
//  MeteoAviso
//
//  Created by egi on 31/3/17.
//  Copyright © 2017 egaillera. All rights reserved.
//

import UIKit


class MeasurementViewController: UIViewController {
    
    let myServer = MeteoServer()
    var measurement:Measurement?
    
    @IBOutlet var stationName : UILabel!
    @IBOutlet var date : UILabel!
    @IBOutlet var temp : UILabel!
    @IBOutlet var rainfall : UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        print("Calling myServer.getClosestMeasurement")
        myServer.getClosestMeasurement(self, lat: 38.34, lon: -0.49)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func sendMeasurement(_ measurement:Measurement?) {
        print(measurement?.description)
        
        self.stationName.text = measurement!.name
        self.date.text = measurement!.date_created
        self.temp.text = "\(measurement!.current_temp)"
        self.rainfall.text = "\(measurement!.rainfall)"
        self.view.setNeedsDisplay()
        
    }
    
 
    
}

