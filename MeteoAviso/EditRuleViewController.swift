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
        
        
        presentingViewController?.dismiss(animated: true, completion: nil)
    }
    @IBAction func rainfallStepperAction(_ sender: Any) {
        print("File: \(#file), Function: \(#function), line: \(#line)")
        let stepper = sender as! UIStepper
        rainfallThresholdLabel.text = "\(Int(stepper.value)) l."
    }
    @IBAction func tempMaxStepperAction(_ sender: Any) {
        print("File: \(#file), Function: \(#function), line: \(#line)")
        let stepper = sender as! UIStepper
        tempMaxThresholdLabel.text = "\(Int(stepper.value))ºC"
    }
    @IBAction func tempMinStepperAction(_ sender: Any) {
        print("File: \(#file), Function: \(#function), line: \(#line)")
        let stepper = sender as! UIStepper
        tempMinThresholdLabel.text = "\(Int(stepper.value))ºC"
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
                rainfallStepper.value = Double(rule.value)
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
    
    func createJSONData() -> [String:Any] {
        print("File: \(#file), Function: \(#function), line: \(#line)")
        
        var jsonData:[String:Any] = [:]
        var rules:[[String:Any]] = []
        
        jsonData["email"] = MeteoServer.globalUserEmail
        jsonData["station"] = self.stationCode
        
        //TODO: check what happens if a user doesn't change a default value. In that case
        // we shouldn't create the rule
        rules.append(["dimension":"rainfall","quantifier":">","value":Float(rainfallStepper.value)])
        rules.append(["dimension":"current_temp","quantifier":">","value":Float(tempMaxStepper.value)])
        rules.append(["dimension":"current_temp","quantifier":"<","value":Float(tempMinStepper.value)])
        
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
