//
//  SwitchSubBroker.swift
//  PCEX2
//
//  Created by Himanshu Jha on 29/07/19.
//  Copyright © 2019 Panaesha Capital pvt. ltd. All rights reserved.
//

import UIKit

class SwitchSubBroker: UIViewController {
    
    @IBAction func enterSubBokerCode(_ sender: Any) {
        performSegue(withIdentifier: "newSubBrokerDetails", sender: self)
    }
    
    @IBAction func assignedByBroker(_ sender: Any) {
        performSegue(withIdentifier: "assignedByBroker", sender: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
