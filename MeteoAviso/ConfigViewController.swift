//
//  ConfigViewController.swift
//  MeteoAviso
//
//  Created by egi on 13/9/18.
//  Copyright © 2018 egaillera. All rights reserved.
//

import UIKit

class ConfigViewController: UIViewController, ModalHandlerDelegate {

    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    // For each button, we need to know the code of the station and the
    // name of the station, so the value is an array of two strings
    var buttonNameDict = [Int:[String]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        getRulesFromServer()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    
    }
    
    @objc func editAction(sender: UIButton) {
        print("File: \(#file), Function: \(#function), line: \(#line)")
        
        print("Edit for station: \(String(describing: buttonNameDict[sender.tag]![0]))")
        
        print("Creating new EditRuleController")
        let editRuleController:EditRuleViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "EditRuleViewController") as! EditRuleViewController
        
        editRuleController.stationCode = buttonNameDict[sender.tag]![0]
        editRuleController.stName = buttonNameDict[sender.tag]![1]
        editRuleController.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        editRuleController.delegate = self
        print("Code assigned to EditViewController: \(editRuleController.stationCode)")
        
        self.present(editRuleController, animated: true, completion: nil)
    }
    
    func modalDismissed() {
        print("File: \(#file), Function: \(#function), line: \(#line)")
        self.removeRules()
        self.getRulesFromServer()
    }
    
    func displayRules(rules:[String:ConfigData]?) {
        print("File: \(#file), Function: \(#function), line: \(#line)")
        
        var buttonIndex = 100
        
        if rules != nil {
            
            for (stationCode,configData) in (rules)! {
                
                // Create view with the station rules and add its name
                let sr = StationRules()
                sr.stationName.text = Station.replaceHtmlCodesInName(configData.station_name)
                
                // Add a tag to each button to identify later which button
                // has been pressed. Add the station_name as well, to pass it
                // when editing the rule
                sr.editButton.tag = buttonIndex
                buttonNameDict[buttonIndex] = [stationCode,configData.station_name]
                //buttonNameDict[buttonIndex] = configData.station_name
                sr.editButton.addTarget(self, action: #selector(editAction), for: UIControlEvents.touchUpInside)
                
                buttonIndex += 1
                
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
        
        // Empty dict with the edit buttons info
        buttonNameDict.removeAll()
        
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
        
        let url:URL = URL(string: MeteoServer.serverURL + "get_rules/" + MeteoServer.globalDeviceId!)!
        let session = URLSession.shared
        
        let request = NSMutableURLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue(MeteoServer.iOSapiKey, forHTTPHeaderField: "Authorization")
        request.cachePolicy = NSURLRequest.CachePolicy.reloadIgnoringCacheData
        
        EZLoadingActivity.show("Cargando reglas ...",disableUI: true)
        let task = session.dataTask(with: request as URLRequest, completionHandler: {
            (data, response, error) in
            
            guard let _:Data = data, let _:URLResponse = response  , error == nil else {
                print("error=\(String(describing: error))")
                MeteoServer.treatServerError(currentView: self)
                return
            }
            
            // Get list of rules
            let dbConfig = self.extractRulesFromJSON(data!)

            DispatchQueue.main.async {
                self.displayRules(rules: dbConfig)
                EZLoadingActivity.hide(true,animated: true)
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
