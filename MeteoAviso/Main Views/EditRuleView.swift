//
//  EditRuleView.swift
//  MAviso
//
//  Created by Enrique Garcia Illera on 14/06/2020.
//  Copyright © 2020 Enrique Garcia Illera. All rights reserved.
//

import SwiftUI

struct EditRuleView: View {
    
    var stationCode:String
    @ObservedObject var rulesList:RulesList
    
    @State var maxRainTh:Float
    @State var maxTempTh:Float
    @State var minTempTh:Float
    
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        VStack {
            VStack {
                Text("Editar reglas para \(self.rulesList.rulesDict[self.stationCode]!.station_name)").padding()
                Text("Codigo estación: \(stationCode)").padding()
            }.padding()
            Spacer()
            HStack {
                Text("Umbral de lluvia: \(maxRainTh)")
                Slider(value:$maxRainTh,in:0...200,step: 1.0)
            }.padding()
            HStack {
                Text("Umbral de temperatura maxima: \(maxTempTh)")
                Slider(value:$maxTempTh,in:-50...50,step: 1.0)
            }.padding()
            HStack {
                Text("Umbral de tempratura minima: \(minTempTh)")
                Slider(value:$minTempTh,in:-50...50,step: 1.0)
            }.padding()
            Spacer()
            HStack {
                Button(action: {self.saveRules()}) {Text("Guardar")}.padding()
                Button(action: {self.presentationMode.wrappedValue.dismiss()}) {Text("Cancelar")}.padding()
            }
            Spacer()
        }
    }
    
    // Modify the rules in the rulesList object according to the information in the view
    func saveRules() {
        print("File: \(#file), Function: \(#function), line: \(#line)")
        
        // Empty the existing rules
        self.rulesList.rulesDict[self.stationCode]!.rules = []
        
        // Add new rules to the rulesList object
        rulesList.rulesDict[self.stationCode]!.rules.append(Rule(["dimension":"rainfall","quantifier":">","value":maxRainTh,"offset":Float(0)]))
        rulesList.rulesDict[self.stationCode]!.rules.append(Rule(["dimension":"current_temp","quantifier":">","value":maxTempTh,"offset":Float(0)]))
        rulesList.rulesDict[self.stationCode]!.rules.append(Rule(["dimension":"current_temp","quantifier":"<","value":minTempTh,"offset":Float(0)]))
        
        // Tell the object to save itself to the server for this station
        /*
            TODO: what happens if the save operation fails? Looks like the
            the RuleListView is not updated fron the server: it shows the current
            rulesList object
        */
        self.rulesList.save_rules(station_code: stationCode)
        
        self.presentationMode.wrappedValue.dismiss()
    }
}

struct EditRuleView_Previews: PreviewProvider {
    static var previews: some View {
        EditRuleView(stationCode: "0852X", rulesList:RulesList(stationCode:"Alicante"),maxRainTh: 0, maxTempTh: 0, minTempTh: 0)
    }
}
