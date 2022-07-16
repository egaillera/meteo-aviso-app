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
            VStack {
                Text("\(measurementToDisplay.name)")
                    .frame(maxWidth:.infinity,alignment: .center)
                    .font(.largeTitle)
                Text("\(measurementToDisplay.date_created)")
                    .frame(maxWidth:.infinity,alignment: .center)
                    .font(.title)
                }
            
            .background(Color(.red))
            
            Text("\(measurementToDisplay.current_temp)º")
            .font(.system(size: 80, weight: .light, design: .default))
            .frame(maxWidth:.infinity, minHeight:400,alignment: .center)
            .background(Color(.yellow))
            
            HStack {
                Text("Precipitacion : \(measurementToDisplay.rainfall) litros")
                    .padding()
                    .background(Color(.green))
                Text("Humedad : \(measurementToDisplay.current_hum) %")
                    .padding()
                    .background(Color(.gray))
                
                
            }
          Spacer()
        }
        .background(Color(.blue))
        .ignoresSafeArea(edges:[.bottom])
        
    }
    
}


struct StationView_Previews: PreviewProvider {
    
    static var previews: some View {
        StationView(measurementToDisplay: .constant(Measurement()))
        
    }
}
