//
//  Rule.swift
//  MAviso
//
//  Created by Enrique Garcia Illera on 03/05/2020.
//  Copyright © 2020 Enrique Garcia Illera. All rights reserved.
//

import Foundation

// Definition of a notification rule
struct Rule:CustomStringConvertible,Codable {
    var dimension:String
    var quantifier:String
    var value:Double
    var offset:Double
    
    init(_ dictionary:[String:Any]) {
        
        self.dimension = dictionary["dimension"] as! String
        self.quantifier = dictionary["quantifier"] as! String
        self.value = dictionary["value"] as! Double
        self.offset = dictionary["offset"] as! Double
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
    
    
    init() {
        print("File: \(#file), Function: \(#function), line: \(#line)")
        rules = []
        station_name = ""
    }
    
    init(station_name:String) {
        print("File: \(#file), Function: \(#function), line: \(#line)")
        //let rule = Rule(["dimension":dimension,"quantifier":quantifier,"value":value,"offset":0])
        rules = []
        //rules.append(rule)
        self.station_name = station_name
    }
}

// Struct to get the answer of the save rules operation
struct RuleResult:Codable {
    var rules:String
    var status:Int
}




