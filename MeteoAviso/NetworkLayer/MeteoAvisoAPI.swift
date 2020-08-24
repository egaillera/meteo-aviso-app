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
    static let base = URL(string:"http://mac-513527:9090")! // Local Docker environment, set up in Info.plist
    //static let base = URL(string:"https://meteoaviso.garciaillera.com:9090")! // Production environment
    static let iOSapiKey = "1234567890"
    
    static func last_measurements() -> AnyPublisher<[Measurement],Error> {
        
        var request = URLRequest(url:base.appendingPathComponent("last_measurements"))
        request.setValue(iOSapiKey, forHTTPHeaderField: "Authorization")
        
        return agent.run(request)
            .map(\.value)
            .eraseToAnyPublisher()
    }
    
    static func get_rules() -> AnyPublisher<[String:ConfigData],Error> {
        
        var request = URLRequest(url:base.appendingPathComponent("get_rules/\(MeteoServer.globalDeviceId!)"))
        request.setValue(iOSapiKey, forHTTPHeaderField: "Authorization")
        
        return agent.run(request)
            .map(\.value)
            .eraseToAnyPublisher()
    }
}



