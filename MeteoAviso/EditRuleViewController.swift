//
//  EditRuleViewController.swift
//  MeteoAviso
//
//  Created by egi on 12/10/18.
//  Copyright © 2018 egaillera. All rights reserved.
//

import UIKit

protocol ModalHandlerDelegate: class {
    func modalDismissed()
}

class EditRuleViewController: UIViewController  {
    
    // Properties of the class
    var stationCode:String = "Codigo de estacion"
    var stName:String = "nombre de estacion"
    var changedRainfallThreshold = false
    var changedMaxTempThreshold = false
    var changedMinTempThreshold = false
    
    weak var delegate: ModalHandlerDelegate?
    
    // Outlets
    @IBOutlet weak var stationName: UILabel!
    @IBOutlet weak var rainfallThresholdLabel: UILabel!
    @IBOutlet weak var tempMaxThresholdLabel: UILabel!
    @IBOutlet weak var tempMinThresholdLabel: UILabel!
    @IBOutlet weak var rainfallStepper: UIStepper!
    @IBOutlet weak var tempMaxStepper: UIStepper!
    @IBOutlet weak var tempMinStepper: UIStepper!
    
    // Actions
    @IBAction func saveRule(_ sender: Any) {
        print("File: \(#file), Function: \(#function), line: \(#line)")
        
        let dataToSend = createJSONData()
        print(dataToSend)
        let jsonData = try? JSONSerialization.data(withJSONObject: dataToSend, options: .prettyPrinted)
        //TODO: check errors
        
        // create post request
        let url = URL(string: MeteoServer.serverURL + "save_rules")!
        var request = URLRequest(url: url)
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        
        // insert json data to the request
        request.httpBody = jsonData
        
        //TODO: check errors
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                print(error?.localizedDescription ?? "No data")
                return
            }
            let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
            if let responseJSON = responseJSON as? [String: Any] {
                print(responseJSON)
            }
        }
        task.resume()
        dismiss(animated: true) {
            self.delegate?.modalDismissed()
        }
    }
    
    @IBAction func cancelEdit(_ sender: Any) {
        print("File: \(#file), Function: \(#function), line: \(#line)")
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func removeRule(_ sender: Any) {
        print("File: \(#file), Function: \(#function), line: \(#line)")
        
        // create post request
        let url = URL(string: MeteoServer.serverURL + "delete_rules/" + MeteoServer.globalDeviceId! + "/" + stationCode)!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        //TODO: check errors
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                print(error?.localizedDescription ?? "No data")
                return
            }
            let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
            if let responseJSON = responseJSON as? [String: Any] {
                print(responseJSON)
            }
        }
        task.resume()
        
        dismiss(animated: true) {
            self.delegate?.modalDismissed()
        }
    }
    
    @IBAction func rainfallStepperAction(_ sender: Any) {
        print("File: \(#file), Function: \(#function), line: \(#line)")
        let stepper = sender as! UIStepper
        rainfallThresholdLabel.text = "\(Int(stepper.value)) l."
        changedRainfallThreshold = true
    }
    @IBAction func tempMaxStepperAction(_ sender: Any) {
        print("File: \(#file), Function: \(#function), line: \(#line)")
        let stepper = sender as! UIStepper
        tempMaxThresholdLabel.text = "\(Int(stepper.value))ºC"
        changedMaxTempThreshold = true
    }
    @IBAction func tempMinStepperAction(_ sender: Any) {
        print("File: \(#file), Function: \(#function), line: \(#line)")
        let stepper = sender as! UIStepper
        tempMinThresholdLabel.text = "\(Int(stepper.value))ºC"
        changedMinTempThreshold = true
    }
    
    
    override func viewDidLoad() {
        print("File: \(#file), Function: \(#function), line: \(#line)")
        super.viewDidLoad()
        
        print("Displaying rules for \(self.stationCode)")
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
                rainfallStepper.value = Double(rule.value)
            case "current_temp":
                if rule.quantifier == ">" {
                    tempMaxThresholdLabel.text = "\(Int(rule.value))ºC"
                    tempMaxStepper.value = Double(rule.value)
                }
                else {
                    tempMinThresholdLabel.text = "\(Int(rule.value))ºC"
                    tempMinStepper.value = Double(rule.value)
                }
            default:
                print("Unknown dimension")
            }
        }
        self.view.setNeedsDisplay()
    }
    
    func getRulesFromServer() {
        
        print("File: \(#file), Function: \(#function), line: \(#line)")
        print("Getting rules for station \(self.stationCode)")
    
        // Request notification rules from server
        let url:URL = URL(string: MeteoServer.serverURL + "get_rules/\(MeteoServer.globalDeviceId!)/\(self.stationCode)")!
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
    
    func createJSONData() -> [String:Any] {
        print("File: \(#file), Function: \(#function), line: \(#line)")
        
        var jsonData:[String:Any] = [:]
        var rules:[[String:Any]] = []
        
        jsonData["device_id"] = MeteoServer.globalDeviceId
        jsonData["station"] = self.stationCode
        
        // If user hasn't changed a default value, don't send a new rule with a default
        // value the user doesn't know
        if changedRainfallThreshold {
            rules.append(["dimension":"rainfall","quantifier":">","value":Float(rainfallStepper.value)])
        }
        if changedMaxTempThreshold {
            rules.append(["dimension":"current_temp","quantifier":">","value":Float(tempMaxStepper.value)])
        }
        if changedMinTempThreshold {
            rules.append(["dimension":"current_temp","quantifier":"<","value":Float(tempMinStepper.value)])
        }
        
        jsonData["rules"] = rules
        
        return jsonData
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
