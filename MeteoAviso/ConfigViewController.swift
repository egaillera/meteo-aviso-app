//
//  ConfigViewController.swift
//  MeteoAviso
//
//  Created by egi on 13/9/18.
//  Copyright © 2018 egaillera. All rights reserved.
//

import UIKit

class ConfigViewController: UIViewController {

    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        getRulesFromServer()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    
    }
    
    func displayRules(rules:[String:ConfigData]?) {
        print("File: \(#file), Function: \(#function), line: \(#line)")
        
        if rules != nil {
            
            for (_,configData) in (rules)! {
                let sr = StationRules()
                sr.stationName.text = Station.replaceHtmlCodesInName(configData.station_name)
                
                // Default values
                sr.rainfallThreshold.text = String("-")
                sr.tempMaxThreshold.text = String("-")
                sr.tempMinThreshold.text = String("-")
                
                for r in configData.rules {
                    if r.dimension == "rainfall" {
                        sr.rainfallThreshold.text = String(r.value)
                    }
                    else if (r.dimension == "current_temp" && r.quantifier == ">") {
                        sr.tempMaxThreshold.text = String(r.value)
                    }
                    else if (r.dimension == "current_temp" && r.quantifier == "<") {
                      sr.tempMinThreshold.text = String(r.value)
                    }
                }
                
                stackView.addArrangedSubview(sr)
            }
            scrollView.contentSize.height = stackView.bounds.height
        }
        else {
            print("ERROR getting rules from server")
        }
    }
    
    func removeRules() {
        print("File: \(#file), Function: \(#function), line: \(#line)")
        
        let removedSubviews = stackView.arrangedSubviews.reduce([]) { (allSubviews, subview) -> [UIView] in
            stackView.removeArrangedSubview(subview)
            return allSubviews + [subview]
        }
                
        // Remove the views from self
        removedSubviews.forEach({ $0.removeFromSuperview() })
        
    }
    
    func extractRulesFromJSON(_ data:Data) -> [String:ConfigData]? {
        print("File: \(#file), Function: \(#function), line: \(#line)")
        
        var stationConfigData:[String:ConfigData]?
        
        do {
            // Decode retrived data with JSONDecoder and assign to a dict
            // with the station code as key, and ConfigData as value
            stationConfigData = try JSONDecoder().decode([String:ConfigData].self, from: data)
            
        } catch let jsonError {
            print(jsonError)
            stationConfigData =  nil
        }
    return stationConfigData
    }
    
    func getRulesFromServer() {
        
        print("File: \(#file), Function: \(#function), line: \(#line)")
        
        let url:URL = URL(string: MeteoServer.serverURL + "get_rules?email=egaillera@gmail.com")!
        let session = URLSession.shared
        
        let request = NSMutableURLRequest(url: url)
        request.httpMethod = "GET"
        request.cachePolicy = NSURLRequest.CachePolicy.reloadIgnoringCacheData
        
        let task = session.dataTask(with: request as URLRequest, completionHandler: {
            (data, response, error) in
            
            guard let _:Data = data, let _:URLResponse = response  , error == nil else {
                return
            }
            
            // Get list of rules
            let dbConfig = self.extractRulesFromJSON(data!)

            DispatchQueue.main.async {
                self.displayRules(rules: dbConfig)
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
