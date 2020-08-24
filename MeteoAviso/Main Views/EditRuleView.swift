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
    var stationName:String
    
    @State var maxRainTh:Double
    @State var maxTempTh:Double
    @State var minTempTh:Double
    
    var body: some View {
        print("File: \(#file), Function: \(#function), line: \(#line)")
        return VStack {
            Text("Editar reglas para \(stationName)")
            Text("Codigo estación: \(stationCode)")
            HStack {
                Text("Umbral de lluvia: \(maxRainTh)")
                Slider(value:$maxRainTh,in:0...200,step: 1.0)
            }
            HStack {
                Text("Umbral de temperatura maxima: \(maxTempTh)")
                Slider(value:$maxTempTh,in:-50...50,step: 1.0)
            }
            HStack {
                Text("Umbral de tempratura minima: \(minTempTh)")
                Slider(value:$minTempTh,in:-50...50,step: 1.0)
            }
        }
    }
}

struct EditRuleView_Previews: PreviewProvider {
    static var previews: some View {
        EditRuleView(stationCode: "0852X", stationName:"Alicante",maxRainTh: 0, maxTempTh: 0, minTempTh: 0)
    }
}