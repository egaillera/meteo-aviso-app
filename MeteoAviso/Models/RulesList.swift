//
//  RulesList.swift
//  MAviso
//
//  Created by Enrique Garcia Illera on 03/05/2020.
//  Copyright © 2020 Enrique Garcia Illera. All rights reserved.
//

import Foundation
import Combine

class RulesList : ObservableObject {
    
    // Dictionary to store rules:
    //  - key: station code
    //  - value: a ConfigData object, that is an array of rules and the station name
    @Published var rulesDict:[String:ConfigData] = ["":ConfigData()]
    
    // Variables to control loading data from server
    @Published var isDataLoading:Bool = false
    var commError:Bool = false
    
    var sub: Cancellable? = nil
    
     init() {
        print("File: \(#file), Function: \(#function), line: \(#line)")
        //getRulesFromServer()
    }
    
    func getRulesFromServer() {
        
        print("File: \(#file), Function: \(#function), line: \(#line)")
              
        self.isDataLoading = true
        
        self.sub = MeteoAvisoAPI.get_rules()
            .print()
            .sink(receiveCompletion: { completion in
                switch completion {
                        case .finished:
                            // no associated data, but you can react to knowing the
                            // request has been completed
                            break
                        case .failure(let anError):
                            // do what you want with the error details, presenting,
                            // logging, or hiding as appropriate
                            self.commError = true
                            self.isDataLoading = false
                            print("received the error: ", anError)
                            break
                    }
                },
                  receiveValue: {
                    print("Received data: \($0.prefix(1)) ...") // Show only first rule
                    self.rulesDict = $0
                    self.isDataLoading = false
            }
        )
    }
}
