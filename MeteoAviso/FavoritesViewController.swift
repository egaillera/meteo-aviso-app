//
//  FavoritesViewController.swift
//  MeteoAviso
//
//  Created by egi on 31/3/18.
//  Copyright © 2018 egaillera. All rights reserved.
//

import UIKit

class FavoritesViewController:UIViewController {
    
    @IBOutlet weak var emailLabel: UITextField!
    
    @IBAction func emailLabelAction(_ sender: Any) {
        let textField = sender as! UITextField
        
        MeteoServer.globalUserEmail = textField.text!
    }
    
    
    override func viewDidLoad() {
        print("File: \(#file), Function: \(#function), line: \(#line)")
        super.viewDidLoad()
        emailLabel.text = MeteoServer.globalUserEmail
    }
}
