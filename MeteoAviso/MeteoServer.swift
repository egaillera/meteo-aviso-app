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
    
    let serverURL = "http://meteoaviso.cloudapp.net:9090/" as String
    //let serverURL = "http://localhost:5000/" as String
    let deviceId = UIDevice.current.identifierForVendor?.uuidString //TODO: check if it's nil
    
    var lastMeasurement:Measurement? = nil
    
    func sendToken(userEmail:String, tokenStr: String){
        
        print("eMail Address = \(userEmail)")
        print("DEVICE TOKEN = \(tokenStr)")
        print("Device ID = \(deviceId!)") // To identify uniquely this device
        
        let request = NSMutableURLRequest(url: NSURL(string: serverURL + "token")! as URL)
        request.httpMethod = "POST"
        let postString = "emailaddress=\(userEmail)&token=\(tokenStr)&deviceid=\(deviceId!)"
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
    
    func getClosestMeasurement(_ controller:MeasurementViewController, lat:Float, lon:Float) {
        
        print("Requested closest measurement to lat=\(lat), lon=\(lon)")
        
        let url:URL = URL(string: serverURL + "closest_measurement?lat=\(lat)&lon=\(lon)")!
        let session = URLSession.shared
        
        let request = NSMutableURLRequest(url: url)
        request.httpMethod = "GET"
        request.cachePolicy = NSURLRequest.CachePolicy.reloadIgnoringCacheData
        
        let task = session.dataTask(with: request as URLRequest, completionHandler: {
            (data, response, error) in
            
            guard let _:Data = data, let _:URLResponse = response  , error == nil else {
                return
            }
            controller.sendMeasurement(self.extractJsonMeasurement(data!))
        })
        
        task.resume()
    }
    
    func extractJsonMeasurement(_ data:Data) -> Measurement? {
        print("Closest Measurement Received")
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
            measurement = Measurement(object)
        } else if let object = json as? [Any] {
            // json is an array
            print(object)
        } else {
            print("JSON is invalid")
        }
        
        return measurement
    }

}
        
    
    


