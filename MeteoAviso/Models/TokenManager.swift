//
//  TokenManager.swift
//  MeteoAviso
//
//  Created by Enrique Garcia Illera on 25/08/2020.
//  Copyright © 2020 Enrique Garcia Illera. All rights reserved.
//

import Foundation
import Combine

// Struct to get the answer of the send token operation
struct TokenResult:Codable {
    var token:String
    var status:Int
}

class TokenManager:NSObject {
    
    var sub: Cancellable? = nil
    
     func sendToken(userEmail:String,tokenStr:String) {
        print("File: \(#file), Function: \(#function), line: \(#line)")
      
        self.sub = MeteoAvisoAPI.send_token(userEmail: userEmail, tokenStr: tokenStr)
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
                        print("received the error: ", anError)
                        break
                }
            },
          receiveValue: {
            print("Received answer with code: \($0.status) ...")
            }
        )
        
    }
    
}
