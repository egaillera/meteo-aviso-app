//
//  RuleView.swift
//  MAviso
//
//  Created by Enrique Garcia Illera on 10/05/2020.
//  Copyright © 2020 Enrique Garcia Illera. All rights reserved.
//

import SwiftUI

struct RuleView: View {
    
    var stationCode:String
    var ruleConfig:ConfigData
    
    @State var editRule = false
   
    var body: some View {
        print("File: \(#file), Function: \(#function), line: \(#line)")
        return VStack() {
            HStack {
                Text(ruleConfig.station_name)
                    .padding()
                    .font(.system(size: 18, weight: .heavy, design: .default))
                Spacer()
                Button(action: {self.editRule = true}) {
                    Text("Edit")
                }.padding()
                 .sheet(isPresented: $editRule,
                        onDismiss: {print("Get rules")}) {
                    EditRuleView(stationCode: self.stationCode,
                                 stationName: self.ruleConfig.station_name,
                                 maxRainTh: self.getRuleThresholds(dimension: "rainfall",
                                                                quantifier: ">"),
                                 maxTempTh: self.getRuleThresholds(dimension: "current_temp",quantifier: ">"),
                                 minTempTh: self.getRuleThresholds(dimension: "current_temp",quantifier: "<"))
                }
            }
            HStack {
                Text("Precipitación mayor que ").padding()
                Spacer()
                Text("\(getRuleThresholds(dimension: "rainfall",quantifier: ">")) l.").padding()
            }
            HStack {
                Text("Temperatura mayor que ").padding()
                Spacer()
                Text("\(getRuleThresholds(dimension: "current_temp",quantifier: ">")) ºC").padding()
            }
            HStack {
                Text("Temperatura menor que ").padding()
                Spacer()
                Text("\(getRuleThresholds(dimension: "current_temp",quantifier: "<")) ºC").padding()
            }
        }.frame(width:400,height: 200)
    }
    
    func getRuleThresholds(dimension:String, quantifier:String) -> Double {
        
        var dimensionValue:Double = -999
        
        for r in ruleConfig.rules {
            if (r.dimension == dimension && r.quantifier == quantifier) {
                dimensionValue =  Double(r.value)
            }
        }
        
        return dimensionValue
    }
}

#if DEBUG
struct RuleView_Previews: PreviewProvider {
    static var previews: some View {
        return RuleView(stationCode:"Alicante",ruleConfig:ConfigData(station_name: "Alicante"))
    }
}
#endif
