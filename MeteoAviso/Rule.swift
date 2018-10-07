//
//  Rule.swift
//  MeteoAviso
//
//  Created by egi on 7/10/18.
//  Copyright © 2018 egaillera. All rights reserved.
//

import Foundation

struct Rule:CustomStringConvertible {
    var dimension:String
    var quantifier:String
    var value:Float
    
    init(_ dictionary:[String:Any]) {
        
        self.dimension = dictionary["dimension"] as! String
        self.quantifier = dictionary["quantifier"] as! String
        self.value = dictionary["value"] as! Float
    }
    
    var description: String {
        return "{dimension:\(self.dimension),quantifier:\(self.quantifier),value:\(self.value)}"
    }
}
