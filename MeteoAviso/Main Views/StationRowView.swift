//
//  StationRowView.swift
//  MeteoAviso
//
//  Created by Enrique Garcia Illera on 27/09/2020.
//  Copyright © 2020 Enrique Garcia Illera. All rights reserved.
//

import SwiftUI

struct StationRowView: View {
    
    var measurement:Measurement
    
    var body: some View {
        HStack {
            Text(Station.replaceHtmlCodesInName(measurement.name)).foregroundColor(.black)
            Spacer()
            Text("\(String(measurement.current_temp)) ºC")
        }.padding()
            
    }
}

struct StationRowView_Previews: PreviewProvider {
    static var previews: some View {
        StationRowView(measurement: Measurement())
    }
}
