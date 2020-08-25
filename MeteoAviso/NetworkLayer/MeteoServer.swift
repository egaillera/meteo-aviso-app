//
//  MeteoServer.swift
//  MAviso
//
//  Created by Enrique Garcia Illera on 19/04/2020.
//  Copyright © 2020 Enrique Garcia Illera. All rights reserved.
//

import Foundation
import UIKit

import Security
/*
class MeteoServer {
    
    //static let serverURL = "http://meteoaviso.cloudapp.net:9090/" as String //To work MS real server
    //static let serverURL = "http://meteoaviso.ddns.net:9090/" as String //To work with real server
    
#if targetEnvironment(simulator)
    static let serverURL = "http://localhost:9090/" as String // To work with Docker local server
#else
    static let serverURL = "https://meteoaviso.garciaillera.com:9090/" //To work with real server
#endif
    
    static var globalDeviceId = UIDevice.current.identifierForVendor?.uuidString //TODO: check if it's nil
    static var globalUserEmail = "fake@fakemail.com"
    
    //static var iOSapiKey = "TWV0ZW9Bdmlzb2lPU0NsaWVudAo="
    static var iOSapiKey = "1234567890"

    
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
        request.setValue(MeteoServer.iOSapiKey, forHTTPHeaderField: "Authorization")
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
    
    static func treatServerError(currentView:UIViewController) {
        print("File: \(#file), Function: \(#function), line: \(#line)")
        
        let alert = UIAlertController(title: "ERROR", message: "No se ha podido establecer conexión con el servidor de MeteoAviso", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        DispatchQueue.main.async {
            //EZLoadingActivity.hide(true,animated: true)
            currentView.present(alert, animated: true, completion: nil)
        }
    }
    
}
*/
