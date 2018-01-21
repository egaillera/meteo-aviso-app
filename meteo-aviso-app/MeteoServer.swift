//
//  MeteoServer.swift
//  meteo-aviso-app
//
//  Created by egi on 21/1/18.
//  Copyright © 2018 egaillera. All rights reserved.
//

import Foundation

class MeteoServer {
    
    let serverURL = "http://0.0.0.0:5000/token" as String
    
    func sendToken(userEmail:String, tokenStr: String){
        
        print("eMail Address = \(userEmail)")
        print("DEVICE TOKEN = \(tokenStr)")
        
        let request = NSMutableURLRequest(url: NSURL(string: serverURL)! as URL)
        request.httpMethod = "POST"
        let postString = "emailaddress=\(userEmail)&token=\(tokenStr)"
        request.setValue("application/x-www-form-urlencoded; charset=utf-8", forHTTPHeaderField: "Content-Type")
        request.httpBody = postString.data(using: String.Encoding.utf8)
        
        let task = URLSession.shared.dataTask(with: request as URLRequest) { data, response, error in
            guard error == nil && data != nil else {                                                          // check for fundamental networking error
                print("error=\(String(describing: error))")
                return
            }
            do {
                if let responseJSON = try JSONSerialization.jsonObject(with: data!) as? [String:AnyObject]{
                    print(responseJSON)
                    print(responseJSON["status"]!)
                
                    let response1 = responseJSON["status"]! as! Int
                    print(response1)
                    
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

