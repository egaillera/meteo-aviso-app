//
//  MeteoServer.swift
//  MeteoAviso
//
//  Created by egi on 21/1/18.
//  Copyright © 2018 egaillera. All rights reserved.
//

import Foundation
import UIKit

class MeteoServer {
    
    //static let serverURL = "http://meteoaviso.cloudapp.net:9090/" as String //To work with real server
    //static let serverURL = "http://meteoaviso.ddns.net:9090/" as String //To work with real server
    static let serverURL = "http://meteoaviso.garciaillera.com:9090/" as String //To work with real server
    //static let serverURL = "http://localhost:5000/" as String // To work with local server
    //static let serverURL = "http://mac-509457.local:9090/" as String // To work with Docker local server
    
    static var globalDeviceId = UIDevice.current.identifierForVendor?.uuidString //TODO: check if it's nil
    static var globalUserEmail = "fake@fakemail.com"
    
    var lastMeasurement:Measurement? = nil
    
    // Send notification token to the server
    func sendToken(userEmail:String, tokenStr: String) {
        print("Function: \(#function), line: \(#line)")
        
        print("eMail Address = \(userEmail)")
        print("DEVICE TOKEN = \(tokenStr)")
        print("Device ID = \(MeteoServer.globalDeviceId!)") // To identify uniquely this device
        
        let request = NSMutableURLRequest(url: NSURL(string: MeteoServer.serverURL + "token")! as URL)
        request.httpMethod = "POST"
        let postString = "emailaddress=\(userEmail)&token=\(tokenStr)&deviceid=\(MeteoServer.globalDeviceId!)"
        request.setValue("application/x-www-form-urlencoded; charset=utf-8", forHTTPHeaderField: "Content-Type")
        request.httpBody = postString.data(using: String.Encoding.utf8)
        
        let task = URLSession.shared.dataTask(with: request as URLRequest) { data, response, error in
            guard error == nil && data != nil else {     // check for fundamental networking error
                print("error=\(String(describing: error))")
                return
            }
            do {
                if let responseJSON = try JSONSerialization.jsonObject(with: data!) as? [String:AnyObject]{
                    print(responseJSON)
                    let response1 = responseJSON["status"]! as! Int
            
                    //Check response from the sever
                    if response1 == 200
                    {
                        OperationQueue.main.addOperation {
                            //API call Successful and can perform other operations
                            print("Notif token sent")
                        }
                    }
                    else
                    {
                        OperationQueue.main.addOperation {
                            //API call failed and perform other operations
                            print("Notif token not sent")
                        }
                    }
                }
            }
            catch {
                print("Error -> \(error)")
            }
        }
        
        task.resume()
    }
    
}
        
    
    


