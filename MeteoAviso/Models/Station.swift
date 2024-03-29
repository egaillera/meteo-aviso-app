//
//  Station.swift
//  MeteoAviso
//
//  Created by egi on 31/3/18.
//  Copyright © 2018 egaillera. All rights reserved.
//

import Foundation

struct Station:CustomStringConvertible,Codable {
    var name:String
    var lat:Float
    var lon:Float
    var code:String
    var prov:Int
    
    init(_ dictionary:[String:Any]) {
        
        self.name = Station.replaceHtmlCodesInName(dictionary["name"] as! String)
        self.lat = dictionary["lat"] as! Float
        self.lon = dictionary["lon"] as! Float
        self.code = dictionary["code"] as! String
        self.prov = dictionary["prov"] as! Int
    }
    
    var description: String {
        return "Station \(self.name) with code \(self.code)"
    }
    
    static func replaceHtmlCodesInName(_ name:String) -> String {
        
        var replaced : String
        let htmlCodes = ["&#243;":"ó","&#233;":"é","&#250;":"ú","&#225;":"á","&#237;":"í",
                         "&#231;":"ç","&#241;":"ñ","&#224;":"à","&#232;":"è",
                         "&#242;":"ò","&#200;":"È","&#210;":"Ò","&#211;":"Ó","&#193;":"Á",
                         "&#192;":"À","&#183;":"·","&#170;":"ª","&#252;":"ü","&#218;":"Ú",
                         "&#205;":"Í","&#186;":"º","&#38;#180;":"'"]
        
        replaced = name
        
        for (code,clear) in htmlCodes {
            replaced = replaced.replacingOccurrences(of: code, with: clear)
        }
        
        return replaced
    }
}

