//
//  StationView.swift
//  MAviso
//
//  Created by Enrique Garcia Illera on 21/04/2020.
//  Copyright © 2020 Enrique Garcia Illera. All rights reserved.
//
/*
StationView(measurement: Measurement(["name":"Alicante",
                                      "lat":Float(40.4),
                                      "lon":Float(-3.7),
                                      "max_gust": Float(0.0),
                                      "date_created": "21/04/2020",
                                      "current_pres": Float(0.0),
                                      "rainfall": Float(2.2),
                                      "current_temp": Float(21.1),
                                      "wind_speed": Float(2.2),
                                      "wind_direction": Float(90),
                                      "current_hum":Float(50.0),
                                      "station":"C28"] as [String : Any]))*/

import SwiftUI

struct StationView: View {
    @Binding var measurementToDisplay: Measurement
    @ObservedObject var rulesForStation = RulesList()
    @State var editRule = false
    
    var body: some View {
        VStack() {
            HStack {
                Spacer()
                Button(action: {
                        self.editRule = true
                        self.rulesForStation.getRulesFromServer(stationCode:self.measurementToDisplay.code)}) {
                    Text("Edit")
                }.sheet(isPresented: $editRule) {
                    EditRuleView(stationCode: self.measurementToDisplay.code,rulesList:self.rulesForStation)
                }
            }.padding()
            Text(measurementToDisplay.name)
            Text("Temperatura: \(measurementToDisplay.current_temp) grados")
            Text("Precipitacion : \(measurementToDisplay.rainfall) litros")
            Text("Fecha: \(measurementToDisplay.date_created)")
        }
    }
}

struct StationView_Previews: PreviewProvider {
    
    static var previews: some View {
        StationView(measurementToDisplay: .constant(Measurement()))
        
    }
}
