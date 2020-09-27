//
//  Measurement.swift
//  MeteoAviso
//
//  Created by egi on 17/2/18.
//  Copyright © 2018 egaillera. All rights reserved.
//

import Foundation

struct Measurement:CustomStringConvertible,Codable,Hashable {
    var name:String
    var lat:Float
    var lon:Float
    var max_gust:Float
    var date_created:String  // TODO: should be NSDAte?
    var current_pres:Float
    var rainfall:Float
    var current_temp:Float
    var wind_speed:Float
    var wind_direction:Float
    var current_hum:Float
    var code:String
    
    init(_ dictionary:[String:Any]) {
        self.name = Station.replaceHtmlCodesInName(dictionary["name"] as! String)
        self.lat = dictionary["lat"] as! Float
        self.lon = dictionary["lon"] as! Float
        self.max_gust = dictionary["max_gust"] as! Float
        self.date_created = dictionary["date_created"] as! String
        self.current_pres = dictionary["current_pres"] as! Float
        self.rainfall = dictionary["rainfall"] as! Float
        self.current_temp = dictionary["current_temp"] as! Float
        self.wind_speed = dictionary["wind_speed"] as! Float
        self.wind_direction = dictionary["wind_direction"] as! Float
        self.current_hum = dictionary["current_hum"] as! Float
        self.code = dictionary["station"] as! String
    }
    
    init() {
        self.name = "Estación de prueba"
        self.lat = 0.0
        self.lon = 0.0
        self.max_gust = 0.0
        self.date_created = ""
        self.current_pres = 0.0
        self.rainfall = 0.0
        self.current_temp = 0.0
        self.wind_speed = 0.0
        self.wind_direction = 0.0
        self.current_hum = 0.0
        self.code = ""
    }
    
    var description: String {
        return "Station \(self.name) at \(self.current_temp) degrees with \(self.rainfall) litres of rainfall"
    }
}
