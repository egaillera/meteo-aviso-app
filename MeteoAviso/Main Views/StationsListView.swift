//
//  StationsListView.swift
//  MeteoAviso
//
//  Created by Enrique Garcia Illera on 27/09/2020.
//  Copyright © 2020 Enrique Garcia Illera. All rights reserved.
//

import SwiftUI

struct StationsListView: View {
    
    @EnvironmentObject var msList: MesasurementsList
    
    var body: some View {
        VStack {
            Text("Estaciones con observaciones").font(.system(size: 24, weight: .heavy, design: .default))
            Text("")
            List(self.msList.msArray,id:\.self) { ms in
                // Need to use .constant because in StationView we are using
                // a binding variable (it's needed to work with the MapView as well)
                NavigationLink(destination:StationView(measurementToDisplay:.constant(ms))) {StationRowView(measurement: ms)}
            }
        }
    }
}

struct StationsListView_Previews: PreviewProvider {
    static var previews: some View {
        StationsListView().environmentObject(MesasurementsList())
    }
}
