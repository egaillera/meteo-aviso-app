//
//  RulesListView.swift
//  MAviso
//
//  Created by Enrique Garcia Illera on 03/05/2020.
//  Copyright © 2020 Enrique Garcia Illera. All rights reserved.
//

import SwiftUI

struct RulesListView: View {
    
    @ObservedObject var rulesList = RulesList()
    
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
                        RuleView(stationCode: key, rulesList: self.rulesList)
                      }
                  }
              }
            }
            }.onAppear(perform: {self.rulesList.getRulesFromServer()})
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

