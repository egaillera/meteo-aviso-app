//
//  StationViewController.swift
//  MeteoAviso
//
//  Created by egi on 29/3/18.
//  Copyright © 2018 egaillera. All rights reserved.
//

import UIKit

class StationViewController : UIViewController {
    
    @IBOutlet var myScrollView : UIScrollView!
    @IBOutlet var myContentView : GradientView!
    
    var measurement:Measurement?
    var stationCode = "2117D"
    
    @IBOutlet var stationName : UILabel!
    @IBOutlet var date : UILabel!
    @IBOutlet var temp : UILabel!
    @IBOutlet var rainfall : UILabel!
    
    var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action:
            #selector(StationViewController.handleRefresh(_:)),
                                 for: UIControlEvents.valueChanged)
        refreshControl.tintColor = UIColor.red
        
        return refreshControl
    }()
    
    override func viewDidLoad() {
        print("File: \(#file), Function: \(#function), line: \(#line)")
        super.viewDidLoad()
        
        myScrollView.refreshControl = self.refreshControl
        
        myContentView.firstColor = UIColor(red:0.04, green:0.53, blue:0.68, alpha:1.0)
        myContentView.secondColor = UIColor(red:0.49, green:0.86, blue:0.98, alpha:1.0)
        myContentView.isHorizontal = false
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print("File: \(#file), Function: \(#function), line: \(#line)")
        self.refreshDataFromServer()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
        print("File: \(#file), Function: \(#function), line: \(#line)")
        self.refreshDataFromServer()
    }
    
    func extractJsonMeasurement(_ data:Data) -> Measurement? {
        print("File: \(#file), Function: \(#function), line: \(#line)")
        
        let json:Any?
        var measurement:Measurement?
        
        do {
            json = try JSONSerialization.jsonObject(with: data, options: [])
        }
        catch {
            return nil
        }
        if let object = json as? [String: Any] {
            // json is a dictionary
            print(object)
            measurement = Measurement(object)
        } else if let object = json as? [Any] {
            // json is an array
            print(object)
        } else {
            print("JSON is invalid")
        }
        
        return measurement
    }
    
    func displayNewMeasurement(_ measurement:Measurement?) {
        print("File: \(#file), Function: \(#function), line: \(#line)")
        
        DispatchQueue.main.async {
            self.stationName.text = measurement!.name
            self.date.text = measurement!.date_created
            self.temp.text = "\(measurement!.current_temp)"
            self.rainfall.text = "\(measurement!.rainfall)"
            self.view.setNeedsDisplay()
            
            self.refreshControl.endRefreshing()
        }
    }
    
    func refreshDataFromServer() {
        
        print("File: \(#file), Function: \(#function), line: \(#line)")
        print("Requested latest measurement from \(stationCode)")
        
        let url:URL = URL(string: MeteoServer.serverURL + "last_measurement/\(stationCode)")!
        let session = URLSession.shared
        
        let request = NSMutableURLRequest(url: url)
        request.httpMethod = "GET"
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
    
}
