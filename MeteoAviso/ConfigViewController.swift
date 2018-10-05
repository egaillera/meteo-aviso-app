//
//  ConfigViewController.swift
//  MeteoAviso
//
//  Created by egi on 13/9/18.
//  Copyright © 2018 egaillera. All rights reserved.
//

import UIKit

class ConfigViewController: UIViewController {

    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        displayRules()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func displayRules() {
        
        for var i in 1...25 {
            
            /* In csae we want to keep fixed height 
            let sr = StationRules()
            sr.translatesAutoresizingMaskIntoConstraints = false
            sr.heightAnchor.constraint(equalToConstant: 300).isActive = true */
            
            let sr = StationRules()
            //sr.stationName.text = "Prueba \(i)"
            stackView.addArrangedSubview(sr)
        }
        
        scrollView.contentSize.height = stackView.bounds.height
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
