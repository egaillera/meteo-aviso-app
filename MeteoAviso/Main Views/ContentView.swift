//
//  ContentView.swift
//  MAviso
//
//  Created by Enrique Garcia Illera on 19/04/2020.
//  Copyright © 2020 Enrique Garcia Illera. All rights reserved.
//

import SwiftUI
import MapKit

struct ContentView: View {
    @EnvironmentObject var msList: MesasurementsList
    
    // Observable object that tells the location
    @ObservedObject var lm = LocationManager()
    
    // To navigate to the list of rules
    //@State private var navigateToRules = false
    //@ObservedObject var rulesList = RulesList()
    
    // To control Activity Indicator
    @State var indicatorIsShowing = true
    
    // To navigate to a station view
    @State var stationSelected = ""
    @State var measurementToDisplay = Measurement()
    
    var body: some View {
        print("File: \(#file), Function: \(#function), line: \(#line)")
        
        return NavigationView {
             content
                .navigationBarTitle("Mapa de estaciones", displayMode: .inline)
                .background(NavigationConfigurator { nc in
                // To configure appearance of NavigationBarTitle
                    nc.navigationBar.barTintColor = UIColor(red: 0.03, green: 0.10, blue: 0.32,                                             alpha: 0.0)
                    nc.navigationBar.titleTextAttributes = [.foregroundColor : UIColor.white,
                                                            .font: UIFont(name: "Arial", size: 28.0) as Any]
                })
            
        }.navigationViewStyle(StackNavigationViewStyle()) //NavigationView
    }
    
    private var content: some View {
        
        // Use Group to return different view types
        Group {
            if (self.msList.isDataLoading == false) {
                
                  VStack(alignment: .center) {
                    // Force navigation to StationView when some
                    // station has been selected in MapView
                    if self.stationSelected != "" {
                        NavigationLink(destination:StationView(measurementToDisplay: self.$measurementToDisplay,
                            stationSelected: self.$stationSelected),
                            isActive: .constant(true)) {
                                EmptyView()
                        }
                    }
                    
                    self.map_view
                    Banner()
                    
                }//VStack
            }
            else {
                 Spinner(isAnimating: true, style: .large)
            }
        }
        
    }
    
    private var map_buttons: some View {
        // Buttons row with actions
        HStack() {
            /*if self.navigateToRules {
                NavigationLink(destination:RulesListView(),
                               isActive: .constant(true)) {
                    EmptyView()
                    }
            }*/
            
            Button(action: {self.msList.getMeasurementsFromServer()}) {
                Image("RefreshButton")
                    .renderingMode(.original)
                }
            
            NavigationLink(destination:RulesListView()) {
                Image("ConfigButton")
                    .renderingMode(.original)
            }
            
            Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/) {
                Image("SearchButton")
                    .renderingMode(.original)
            }
        }.padding()  //HStack buttons
    }
    
    private var map_view: some View {
        
        // Covers all the screen and includes a map and 
        // the buttons inside the map
        ZStack(alignment: .topTrailing) {
            
            // View with the map
            MapView(measurementToDisplay: self.$measurementToDisplay,
                    stationSelected:self.$stationSelected,
                    lat: self.lm.location?.coordinate.latitude ?? 41.4,
                    lon: self.lm.location?.coordinate.longitude ?? -3.7)
                .edgesIgnoringSafeArea(.bottom)
                // When the map appears, we deselect any station
                .onAppear(perform: {self.stationSelected = ""})
                .alert(isPresented: self.$msList.commError) {
                    Alert(title: Text("Error de comunicaciones con servidor"))
                    }
            
            // View with the buttons inside the map
            map_buttons
            
        } //Zstack
    }
}

#if DEBUG
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environmentObject(MesasurementsList())
    }
}
#endif
