//
//  MeteoAvisoAPI.swift
//  MAviso
//
//  Created by Enrique Garcia Illera on 17/08/2020.
//  Copyright © 2020 Enrique Garcia Illera. All rights reserved.
//

import Foundation
import Combine

enum MeteoAvisoAPI {
    static let agent = Agent()
#if targetEnvironment(simulator)
    static let base = URL(string:"http://localhost:9090/")! // Local Docker environment, set up in Info.plist
#else
    static let base = URL(string:"https://meteoaviso.garciaillera.com:9090")! // Production environment
#endif
    static let iOSapiKey = "1234567890"
    
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
        
        var request = URLRequest(url:base.appendingPathComponent("get_rules/\(MeteoServer.globalDeviceId!)"))
        request.setValue(iOSapiKey, forHTTPHeaderField: "Authorization")
        print("Request: \(request)")
        
        return agent.run(request)
            .map(\.value)
            .eraseToAnyPublisher()
    }
}



