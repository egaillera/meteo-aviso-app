//
//  MeteoAvisoAPI.swift
//  MAviso
//
//  Created by Enrique Garcia Illera on 17/08/2020.
//  Copyright © 2020 Enrique Garcia Illera. All rights reserved.
//

import Foundation
import Combine
import UIKit

// Global variable with the device ID
let globalDeviceId = UIDevice.current.identifierForVendor?.uuidString

enum MeteoAvisoAPI {
    
    static let agent = Agent()
    static let iOSapiKey = "1234567890"
    
#if targetEnvironment(simulator)
    static let base = URL(string:"http://localhost:9090/")! // Local Docker environment, set up in Info.plist
#else
    static let base = URL(string:"https://meteoaviso.garciaillera.com:9090")! // Production environment
#endif
    
    
    static func last_measurements() -> AnyPublisher<[Measurement],Error> {
        print("File: \(#file), Function: \(#function), line: \(#line)")
        
        var request = URLRequest(url:base.appendingPathComponent("last_measurements"))
        request.setValue(iOSapiKey, forHTTPHeaderField: "Authorization")
        print("Request: \(request)")
        
        return agent.run(request)
            .map(\.value)
            .eraseToAnyPublisher()
    }
    
    static func get_rules() -> AnyPublisher<[String:ConfigData],Error> {
        print("File: \(#file), Function: \(#function), line: \(#line)")
        
        var request = URLRequest(url:base.appendingPathComponent("get_rules/\(globalDeviceId!)"))
        request.setValue(iOSapiKey, forHTTPHeaderField: "Authorization")
        print("Request: \(request)")
        
        return agent.run(request)
            .map(\.value)
            .eraseToAnyPublisher()
    }
    
    static func send_token(userEmail:String,tokenStr:String) -> AnyPublisher<TokenResult,Error> {
        print("File: \(#file), Function: \(#function), line: \(#line)")
        
        var request = URLRequest(url:base.appendingPathComponent("token"))
        request.httpMethod = "POST"
        let postString = "emailaddress=\(userEmail)&token=\(tokenStr)&deviceid=\(globalDeviceId!)"
        request.setValue("application/x-www-form-urlencoded; charset=utf-8", forHTTPHeaderField: "Content-Type")
        request.setValue(iOSapiKey, forHTTPHeaderField: "Authorization")
        request.httpBody = postString.data(using: String.Encoding.utf8)
        print("Request: \(request)")
        
        return agent.run(request)
            .map(\.value)
            .eraseToAnyPublisher()
    }
    
    static func save_rules(stationCode:String,stationRules:[Rule]) -> AnyPublisher<RuleResult, Error> {
        print("File: \(#file), Function: \(#function), line: \(#line)")
        
        var dataToSend:[String:Any] = [:]
        dataToSend["device_id"] = globalDeviceId
        dataToSend["station"] = stationCode
        dataToSend["rules"] = stationRules
        let jsonData = try? JSONSerialization.data(withJSONObject: dataToSend, options: .prettyPrinted)
        
        var request = URLRequest(url:base.appendingPathComponent("save_rules"))
        request.httpMethod = "POST"
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonData
        
        print("Request: \(request)")
        
        return agent.run(request)
            .map(\.value)
            .eraseToAnyPublisher()
        
    }
    
}



