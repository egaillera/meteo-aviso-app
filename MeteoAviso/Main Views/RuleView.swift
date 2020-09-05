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
    @ObservedObject var rulesList:RulesList
    @State var editRule = false
   
    var body: some View {
         VStack() {
            HStack {
                Text(self.rulesList.rulesDict[self.stationCode]!.station_name)
                    .padding()
                    .font(.system(size: 18, weight: .heavy, design: .default))
                Spacer()
                Button(action: {self.editRule = true}) {
                    Text("Edit")
                    }.padding()
                 .sheet(isPresented: $editRule) {
                    EditRuleView(stationCode: self.stationCode,rulesList:self.rulesList)
                }
            }
            HStack {
                Text("Precipitación mayor que ").padding()
                Spacer()
                Text("\(self.rulesList.getRuleThresholds(stationCode:self.stationCode,dimension: "rainfall",quantifier: ">")) l.").padding()
            }
            HStack {
                Text("Temperatura mayor que ").padding()
                Spacer()
                Text("\(self.rulesList.getRuleThresholds(stationCode:self.stationCode,dimension: "current_temp",quantifier: ">")) ºC").padding()
            }
            HStack {
                Text("Temperatura menor que ").padding()
                Spacer()
                Text("\(self.rulesList.getRuleThresholds(stationCode:self.stationCode,dimension: "current_temp",quantifier: "<")) ºC").padding()
            }
        }.frame(width:400,height: 200)
    }
    
}

#if DEBUG
struct RuleView_Previews: PreviewProvider {
    static var previews: some View {
        return RuleView(stationCode:"Alicante",rulesList:RulesList(stationCode:"Alicante"))
    }
}
#endif
