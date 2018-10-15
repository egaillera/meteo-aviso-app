//
//  EditRuleViewController.swift
//  MeteoAviso
//
//  Created by egi on 12/10/18.
//  Copyright © 2018 egaillera. All rights reserved.
//

import UIKit

class EditRuleViewController: UIViewController  {
    
    // Outlets
    @IBOutlet weak var stationName: UILabel!
    @IBOutlet weak var rainfallThresholdLabel: UILabel!
    @IBOutlet weak var tempMaxThresholdLabel: UILabel!
    
    @IBOutlet weak var tempMinThresholdLabel: UILabel!
    // Actions
    @IBAction func saveRule(_ sender: Any) {
        print("File: \(#file), Function: \(#function), line: \(#line)")
        
        presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    // Properties of the class
    var stationCode:String = "Codigo de estacion"
    var stName:String = "nombre de estacion"
    
    override func viewDidLoad() {
        print("File: \(#file), Function: \(#function), line: \(#line)")
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.stationName.text = stName
        self.getRulesFromServer()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print("File: \(#file), Function: \(#function), line: \(#line)")
    }
    
    func displayStationRules(rules:[Rule]) {
        print("File: \(#file), Function: \(#function), line: \(#line)")
        print(rules)
        
        for rule in rules {
            switch rule.dimension {
            case "rainfall":
                rainfallThresholdLabel.text = "\(Int(rule.value)) l."
            case "current_temp":
                if rule.quantifier == ">" {
                    tempMaxThresholdLabel.text = "\(Int(rule.value))ºC"
                }
                else {
                    tempMinThresholdLabel.text = "\(Int(rule.value))ºC"
                }
            default:
                print("Unknown dimension")
            }
        }
        self.view.setNeedsDisplay()
    }
    
    func getRulesFromServer() {
        
        print("File: \(#file), Function: \(#function), line: \(#line)")
    
        // Request notification rules from server
        let url:URL = URL(string: MeteoServer.serverURL + "get_rules/\(stationCode)?email=\(MeteoServer.globalUserEmail)")!
        print(url.absoluteString)
        let session = URLSession.shared
        let request = NSMutableURLRequest(url: url)
        request.httpMethod = "GET"
        request.cachePolicy = NSURLRequest.CachePolicy.reloadIgnoringCacheData
        
        let task = session.dataTask(with: request as URLRequest, completionHandler: {
            (data, response, error) in
            
            guard let _:Data = data, let _:URLResponse = response  , error == nil else {
                return
            }
    
            var stationRules:[Rule]?
            do {
                // Decode retrived data with JSONDecoder and assign to a dict
                // with the station code as key, and ConfigData as value
                stationRules = try JSONDecoder().decode([Rule].self, from: data!)
                DispatchQueue.main.async {
                    self.displayStationRules(rules: stationRules!)
                }
            } catch let jsonError {
                print(jsonError)
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
