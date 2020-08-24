//
//  MesasurementsList.swift
//  MAviso
//
//  Description: this class will hold all the measurements coming from server
//               Together with the measuremnts, it will publish some flags
//               so other views in the app could know if the data:
//                - is available (filled)
//                - has been showed in the map (showed)
//                - there has been a communication error with server (commError)
//                - if we are in process of downloding the data from server (isDataLoading)
//               For now, this class will be instantiated in the SceneDelegate, just
//               after the app starts.
//
//  Created by Enrique Garcia Illera on 25/04/2020.
//  Copyright © 2020 Enrique Garcia Illera. All rights reserved.
//

import Foundation
import Combine

class MesasurementsList: NSObject, ObservableObject {
    
    @Published var msArray:[Measurement] = []
    
    @Published var filled:Bool = false
    @Published var showed:Bool = false
    @Published var commError:Bool = false
    @Published var isDataLoading:Bool = false
    
    var sub: Cancellable? = nil

    override init() {
      super.init()
    }
    
    func getMeasurementsFromServer() {
        print("File: \(#file), Function: \(#function), line: \(#line)")
        
        self.isDataLoading = true
        
        self.sub = MeteoAvisoAPI.last_measurements()
            /*.print()*/
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
                print("Received data: \($0.prefix(5)) ...") // Show only first stations
                self.msArray = $0
                self.filled = true // There's data in the structure
                self.isDataLoading = false
                self.showed = false // New data not already showed
                }
            )
        
    }

}
