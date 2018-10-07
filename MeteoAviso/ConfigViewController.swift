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
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func displayRules(rules:[String:[Rule]]?) {
        print("File: \(#file), Function: \(#function), line: \(#line)")
        
        if rules != nil {
            
            for (stationName,rulesArray) in (rules)! {
                let sr = StationRules()
                sr.stationName.text = stationName
                
                // Default values
                sr.rainfallThreshold.text = String("-")
                sr.tempMaxThreshold.text = String("-")
                sr.tempMinThreshold.text = String("-")
                
                for r in rulesArray {
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
        
        let removedSubviews = stackView.arrangedSubviews.reduce([]) { (allSubviews, subview) -> [UIView] in
            stackView.removeArrangedSubview(subview)
            return allSubviews + [subview]
        }
                
        // Remove the views from self
        removedSubviews.forEach({ $0.removeFromSuperview() })
        
    }
    
    func extractRulesFromJSON(_ data:Data) -> [String:[Rule]]? {
        print("File: \(#file), Function: \(#function), line: \(#line)")
        
        let json:Any?
        var rulesDict = [String:[Rule]]()
        
        do {
            json = try JSONSerialization.jsonObject(with: data, options: [])
        }
        catch {
            print("Serialization failed")
            return nil
        }
        if let object = json as? [String: Any] {
            print("JSON is a dictionary")
            for (stationName,rulesArray) in object {
                rulesDict[stationName] = []
                for r in rulesArray as! [Any] {
                    let new_rule = Rule(r as! Dictionary<String, AnyObject>)
                    rulesDict[stationName]?.append(new_rule)
                }
            }
            return rulesDict
        } else if let object = json as? [Any] {
            print("JSON is an array")
            print(object)
            return nil
        } else {
            print("JSON is invalid")
            return nil
        }
        
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
            let dbRules = self.extractRulesFromJSON(data!)

            DispatchQueue.main.async {
                self.displayRules(rules: dbRules)
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
