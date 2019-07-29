//
//  SubBrokerDetails.swift
//  PCEX2
//
//  Created by Himanshu Jha on 29/07/19.
//  Copyright © 2019 Panaesha Capital pvt. ltd. All rights reserved.
//

import UIKit

class SubBrokerDetails: UIViewController {

   
    @IBOutlet weak var subBrokerName: UILabel!
    
    @IBOutlet weak var subBrokerEmail: UILabel!
    
    @IBOutlet weak var subBrokerCode: UILabel!
    
    @IBAction func switchSubBrokerBtn(_ sender: Any) {
        performSegue(withIdentifier: "sub_broker_edit_details", sender: self )
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        subBrokerName.textColor! = UIColor.lightGray
        subBrokerEmail.textColor! = UIColor.lightGray
        subBrokerName.text! = APP_Defaults.value(forKey: "userName") as! String
        subBrokerEmail.text = "abcd@gmail.com"
        

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
