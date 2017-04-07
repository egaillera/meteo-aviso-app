//
//  ViewController.swift
//  meteo-aviso-app
//
//  Created by egi on 31/3/17.
//  Copyright © 2017 egaillera. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let url = URL(string: "http://meteoaviso.cloudapp.net:9090/stations")
        
        let task = URLSession.shared.dataTask(with: url!) {(data, response, error) in
            let myData = String(data: data!, encoding: String.Encoding.utf8)
            print(myData)
        }
        
        task.resume()
    
      
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

