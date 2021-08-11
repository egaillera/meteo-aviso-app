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
    
    @State var maxRainTh = Constants.rulesDefaultValue
    @State var maxTempTh = Constants.rulesDefaultValue
    @State var minTempTh = Constants.rulesDefaultValue
    
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        
        return Group {
            if (rulesList.rulesLoaded) {
                station_info
            }
            else {
                // Wait until rules are loaded from server
                Spinner(isAnimating: true, style: .large)
            }
        }.alert(isPresented: self.$rulesList.commError) {
            Alert(title: Text("Error de comunicaciones con servidor"))}
    }
    
    private var station_info: some View {
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
        }.onAppear(perform:{ // Set current values of the slider
            self.maxRainTh =
                self.rulesList.getValue(stationCode:self.stationCode,condition: Rule.RuleType.Rain)
            self.maxTempTh =
                self.rulesList.getValue(stationCode:self.stationCode,condition: Rule.RuleType.MaxTemp)
            self.minTempTh =
                self.rulesList.getValue(stationCode:self.stationCode,condition: Rule.RuleType.MinTemp)
        })
    }
    
    // Modify the rules in the rulesList object according to the information in the view
    // and persist object in the server
    func saveRules() {
        print("File: \(#file), Function: \(#function), line: \(#line)")
        
        // Empty the existing rules
        self.rulesList.rulesDict[self.stationCode]!.rules = []
        
        // Add the new rules to the rulesList object. Skip rules with default value
        if (maxRainTh != Constants.rulesDefaultValue) {
            rulesList.rulesDict[self.stationCode]!.rules.append(Rule(["dimension":"rainfall","quantifier":">","value":maxRainTh,"offset":0.0]))
        }
        if (maxTempTh != Constants.rulesDefaultValue) {
            rulesList.rulesDict[self.stationCode]!.rules.append(Rule(["dimension":"current_temp","quantifier":">","value":maxTempTh,"offset":0.0]))
        }
        if (minTempTh != Constants.rulesDefaultValue) {
            rulesList.rulesDict[self.stationCode]!.rules.append(Rule(["dimension":"current_temp","quantifier":"<","value":minTempTh,"offset":0.0]))
        }
        
        // Tell the object to save itself to the server with this station rules updated
        /*
            TODO: what happens if the save operation fails? Looks like the
            the RuleListView won't be updated from the server, but from the
            local RuleList object
        */
        self.rulesList.save_rules(station_code: stationCode)
        
        self.presentationMode.wrappedValue.dismiss()
    }
}

struct EditRuleView_Previews: PreviewProvider {
    static var previews: some View {
        EditRuleView(stationCode: "0852X", rulesList:RulesList(stationCode:"Alicante"),maxRainTh: Constants.rulesDefaultValue, maxTempTh: Constants.rulesDefaultValue, minTempTh: Constants.rulesDefaultValue)
    }
}
