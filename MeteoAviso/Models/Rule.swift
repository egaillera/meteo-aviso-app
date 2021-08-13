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
    
    enum RuleType {
        case Rain, MaxTemp, MinTemp
    }
    
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
        //print("File: \(#file), Function: \(#function), line: \(#line)")
        rules = []
        station_name = ""
    }
    
    // This initializer it's only used for the preview functionality
    init(station_name:String) {
        print("File: \(#file), Function: \(#function), line: \(#line)")
        
        self.rules = []
        self.station_name = station_name
        
        self.rules.append(Rule(["dimension":"rainfall","quantifier":">","value":5.0,"offset":0.0]))
        self.rules.append(Rule(["dimension":"current_temp","quantifier":">","value":20.0,"offset":0.0]))
        self.rules.append(Rule(["dimension":"current_temp","quantifier":"<","value":1.0,"offset":0.0]))

    }
    
}

// Struct to get the answer of the save rules operation
struct RuleResult:Codable {
    var rules:String
    var status:Int
}




