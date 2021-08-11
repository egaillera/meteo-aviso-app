//
//  RulesListView.swift
//  MAviso
//
//  Created by Enrique Garcia Illera on 03/05/2020.
//  Copyright © 2020 Enrique Garcia Illera. All rights reserved.
//

import SwiftUI

struct RulesListView: View {
    
    // Rules are loaded in this view, and then shared with
    // the child views
    @ObservedObject var rulesList = RulesList()
    
    // To avoid a suspected Apple bug calling onAppear multiple times
    @State var firstAppear: Bool = true
    
    var body: some View {
        print("File: \(#file), Function: \(#function), line: \(#line)")
        //rulesList.getRulesFromServer()
        
        return Group {
            
            if (self.rulesList.isDataLoading) {
                Spinner(isAnimating: true, style: .large)
            }
            else {
              VStack {
                  Text("Estaciones con reglas: ").font(.system(size: 24, weight: .heavy, design: .default))
                  Text("")
                  ScrollView(showsIndicators: false) {
                      ForEach(self.rulesList.rulesDict.keys.sorted(),id:\.self) { key in
                        // Full rulesList object is shared with the child view, but also the
                        // code of the station whose rules will be processed, so the child view
                        // will modify only the rules that belgons to this station
                        RuleView(stationCode: key, rulesList: self.rulesList)
                      }
                  }
              }
            }
        }.onAppear(perform: {
                    if !self.firstAppear { return }
                    self.firstAppear = false
                    print("Calling getRulesFromServer() from RulesListView.onAppear()")
                    self.rulesList.getRulesFromServer()})
            .alert(isPresented: self.$rulesList.commError) {
                Alert(title: Text("Error de comunicaciones con servidor"))
            }
    }
}

struct RulesListView_Previews: PreviewProvider {
    static var previews: some View {
        RulesListView(rulesList:RulesList())
    }
}

