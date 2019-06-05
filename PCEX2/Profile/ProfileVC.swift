//
//  ProfileVC.swift
//  PCEX2
//
//  Created by RAHUL BANSAL on 4/3/19.
//  Copyright © 2019 Panaesha Capital pvt. ltd. All rights reserved.
//

import Foundation
import UIKit

class ProfileVC: UIViewController {
    
    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPhone: UITextField!
    
    
    
    override func viewDidLoad() {

        txtName.text! = APP_Defaults.value(forKey: "fullName") as! String
        txtEmail.text! = APP_Defaults.value(forKey: "email") as! String
        txtPhone.text! = APP_Defaults.value(forKey: "phone") as! String
        
        self.navigationController?.navigationBar.isHidden = true
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
       self.navigationController?.navigationBar.isHidden = true
    }
    
    @IBAction func btnBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnSubmit(_ sender: Any) {
    }
    
    
    @IBAction func btnChangePassword(_ sender: Any) {
        let change:PasswrdChange = PasswrdChange(nibName: "PasswrdChange", bundle: nil)
        self.navigationController?.pushViewController(change, animated: true)
    }
    
    @IBAction func btnNotifications(_ sender: Any) {
    }
    
    @IBAction func btnLangSelection(_ sender: Any) {
    }
    
}
