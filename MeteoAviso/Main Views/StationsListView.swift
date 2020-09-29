//
//  StationsListView.swift
//  MeteoAviso
//
//  Created by Enrique Garcia Illera on 27/09/2020.
//  Copyright © 2020 Enrique Garcia Illera. All rights reserved.
//

import SwiftUI

struct StationsListView: View {
    
    @State private var filterBy: String = ""
    
    @EnvironmentObject var msList: MesasurementsList
    
    var body: some View {
        VStack {
            Text("")
            Text("Estaciones con observaciones")
                .font(.system(size: 24, weight: .heavy, design: .default))
                .onTapGesture(count: 1, perform: { // Hide keyboard if tapped
                UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
            })
            TextField("Filtra por nombre de estación",text:$filterBy)
                .textFieldStyle(StationSearchTextFieldStyle())
                .padding()
            List(self.msList.msArray.filter {self.filterBy.isEmpty ? true: $0.name.lowercased().contains(self.filterBy.lowercased())},
                 id:\.self) { ms in
                // Need to use .constant because in StationView we are using
                // a binding variable (it's needed to work with the MapView as well)
                NavigationLink(destination:StationView(measurementToDisplay:.constant(ms))) {StationRowView(measurement: ms)}
            }
        }
    }
}

public struct StationSearchTextFieldStyle : TextFieldStyle {
    public func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .padding(15) // Set the inner Text Field Padding
            //Give it some Aura style
            .background(RoundedRectangle(cornerRadius: 30).foregroundColor(Color(red: 220/255, green: 220/255, blue: 220/255)).opacity(0.4))
            .foregroundColor(.black)
    }
}

struct StationsListView_Previews: PreviewProvider {
    static var previews: some View {
        StationsListView().environmentObject(MesasurementsList())
    }
}
