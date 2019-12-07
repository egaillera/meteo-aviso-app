//
//  Rule.swift
//  MeteoAviso
//
//  Created by egi on 7/10/18.
//  Copyright © 2018 egaillera. All rights reserved.
//

import Foundation

// Definition of a notification rule
struct Rule:CustomStringConvertible,Codable {
    var dimension:String
    var quantifier:String
    var value:Float
    var offset:Float
    
    init(_ dictionary:[String:Any]) {
        
        self.dimension = dictionary["dimension"] as! String
        self.quantifier = dictionary["quantifier"] as! String
        self.value = dictionary["value"] as! Float
        self.offset = dictionary["offset"] as! Float
    }
    
    var description: String {
        return "{dimension:\(self.dimension),quantifier:\(self.quantifier),value:\(self.value),offset:\(self.offset)}"
    }
}

// To keep the notification rules linked to one station,
// together with the station name
struct ConfigData:Codable {
    var rules:[Rule]
    var station_name:String
}
