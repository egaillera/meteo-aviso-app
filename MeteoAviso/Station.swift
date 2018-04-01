//
//  Station.swift
//  MeteoAviso
//
//  Created by egi on 31/3/18.
//  Copyright © 2018 egaillera. All rights reserved.
//

import Foundation

struct Station:CustomStringConvertible {
    var name:String
    var lat:Float
    var lon:Float
    var code:String
    var province:Int
    
    init(_ dictionary:[String:Any]) {
        self.name = dictionary["name"] as! String
        self.lat = dictionary["lat"] as! Float
        self.lon = dictionary["lon"] as! Float
        self.code = dictionary["code"] as! String
        self.province = dictionary["prov"] as! Int
    }
    
    var description: String {
        return "Station \(self.name) with code \(self.code)"
    }
}

