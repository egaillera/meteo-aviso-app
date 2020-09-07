//
//  RulesList.swift
//  MAviso
//
//  Created by Enrique Garcia Illera on 03/05/2020.
//  Copyright © 2020 Enrique Garcia Illera. All rights reserved.
//

import Foundation
import Combine

class RulesList: ObservableObject {
    
    // Dictionary to store rules:
    //  - key: station code
    //  - value: a ConfigData object, that is an array of rules and the station name
    @Published var rulesDict:[String:ConfigData] = ["":ConfigData()]
    
    // Variables to control loading data from server
    @Published var isDataLoading:Bool = false
    var commError:Bool = false
    var rulesLoaded = false
    
    var sub: Cancellable? = nil
    
    init() {
        print("File: \(#file), Function: \(#function), line: \(#line)")
    }
    
    init(stationCode:String) {
        rulesDict = [stationCode:ConfigData(station_name:stationCode)]
        rulesLoaded = true // To simulate a complet object
    }
    
    // Get all the rules from server and save then in self
    func getRulesFromServer() {
        
        print("File: \(#file), Function: \(#function), line: \(#line)")
              
        self.isDataLoading = true
        self.rulesLoaded = false
        self.commError = false
        
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
                    self.rulesLoaded = true
                    print("  All rules loaded!!")
            }
        )
    }
    
    // Get only the rules of a station, an updates self only with
    // the information about the station
    func getRulesFromServer(stationCode:String) {
        
        print("File: \(#file), Function: \(#function), line: \(#line)")
        print("    Getting rules for station \(stationCode)")
        
        self.isDataLoading = true
        self.rulesLoaded = false
        self.commError = false
        
        // Make sure the placeholder in the dict for the rules of
        // the specific station exists and it's empty
        self.rulesDict[stationCode] = ConfigData()
        
        self.sub = MeteoAvisoAPI.get_rules(stationCode: stationCode)
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
                    self.rulesDict[stationCode]!.rules = $0  // Can unwrap safely due to the previous placeholder
                    self.isDataLoading = false
                    self.rulesLoaded = true
                    print("Rules loaded for station \(stationCode)!!")
            }
        )
    }
    
    // Send to server the rules of one station to be saved
    func save_rules(station_code:String) {
        print("File: \(#file), Function: \(#function), line: \(#line)")
        
        var rulesInJson:[[String:Any]] = []
        
        if (rulesLoaded) {
            // Convert rules to [[String:Any]] to be converted later to JSON
            for r in rulesDict[station_code]!.rules {
                rulesInJson.append(["dimension":r.dimension,"quantifier":r.quantifier,"value":r.value,"offset":r.offset])
            }
        
            print("Sending rules to server")
            self.sub = MeteoAvisoAPI.save_rules(stationCode:station_code,stationRules:rulesInJson)
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
                            print("Error sending rules to server")
                            print("received the error: ", anError)
                            break
                    }
                },
              receiveValue: {
                print("saveRules(): received answer with code: \($0.status) ...")
                }
            )
        }
        
    }
    
    func getRuleThresholds(stationCode:String, dimension:String, quantifier:String) -> Double {
        
        var dimensionValue:Float = Float(Constants.rulesDefaultValue)
        
        for r in rulesDict[stationCode]!.rules {
            if (r.dimension == dimension && r.quantifier == quantifier) {
                dimensionValue =  Float(r.value)
            }
        }
        
        return Double(dimensionValue)
    }
}
