//
//  StationSearchViewController.swift
//  MeteoAviso
//
//  Created by egi on 31/3/18.
//  Copyright © 2018 egaillera. All rights reserved.
//

import UIKit

class StationSearchViewController: UITableViewController  {
    
    var stationsList : [Station]?
    
    override func viewDidLoad() {
        print("File: \(#file), Function: \(#function), line: \(#line)")
        super.viewDidLoad()
        
        self.getStationsList()
    }
    
    func extractJsonStations(_ data:Data) -> [Station] {
        print("File: \(#file), Function: \(#function), line: \(#line)")
        
        let json:Any?
        var stList : [Station] = []
        
        do {
            json = try JSONSerialization.jsonObject(with: data, options: [])
        }
        catch {
            print("Serialization failed")
            return stList
        }
        if let object = json as? [String: Any] {
            // json is a dictionary
            print("JSON is a dictionary")
            print(object)
        } else if let object = json as? [Any] {
            print("JSON is an array")
            for station_data in object {
                stList.append(Station(station_data as! Dictionary<String, AnyObject>))
            }
            print(stList)
        } else {
            print("JSON is invalid")
        }
        
        return stList
        
    }
    
    func getStationsList() {
        
        print("File: \(#file), Function: \(#function), line: \(#line)")
        
        let url:URL = URL(string: MeteoServer.serverURL + "stations")!
        let session = URLSession.shared
        
        let request = NSMutableURLRequest(url: url)
        request.httpMethod = "GET"
        request.cachePolicy = NSURLRequest.CachePolicy.reloadIgnoringCacheData
        
        let task = session.dataTask(with: request as URLRequest, completionHandler: {
            (data, response, error) in
            
            guard let _:Data = data, let _:URLResponse = response  , error == nil else {
                return
            }
            self.stationsList = self.extractJsonStations(data!)
            DispatchQueue.main.async {
                print("Reloading data")
                self.tableView.reloadData()
            }
        })
        
        task.resume()
    }
    
    // MARK: - Table View
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (stationsList == nil) {
            return 0
        }
        else {
            return stationsList!.count
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LabelCell", for: indexPath)
        
        if (stationsList == nil) {
            cell.textLabel?.text = "Cargando ..."
        }
        else {
            cell.textLabel?.text = stationsList![indexPath.row].name
        }
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let theStationView = segue.destination as! StationViewController
        theStationView.stationCode = stationsList![tableView.indexPathForSelectedRow!.row].code
    }
    
    
}
