//
//  SubBrokerDetailsEdit.swift
//  PCEX2
//
//  Created by Himanshu Jha on 09/08/19.
//  Copyright © 2019 Panaesha Capital pvt. ltd. All rights reserved.
//

import UIKit
import NotificationBannerSwift
import Foundation
import IQDropDownTextField

class SubBrokerDetailsEdit: UIViewController{
    

   
    @IBOutlet weak var reason: IQDropDownTextField!
    @IBOutlet weak var subBrokerCode: UITextField!
    @IBOutlet weak var remarkField: UITextField!
    
    
    @IBAction func submitBtn(_ sender: UIButton) {
        if(subBrokerCode.text!.isEmpty || remarkField.text!.isEmpty)
        {
            let banner = StatusBarNotificationBanner(title: "Please fill all fields first", style: .danger)
            banner.dismiss()
            banner.show()
        }
        else if(remarkField.text!.characters.count < 10){
            //show warning that the length of remarks should be at least 10 characters
            let alert = UIAlertController(title: "Warning!", message: "Remarks can't be less than 10 characters", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        else {
            var role: String
            
            if(reason.selectedItem == "Sub-Broker not active")
            {
                role = "Sub-Broker not active"
            }
            else if( reason.selectedItem == "Not satisfied with the Sub Broker")
            {
                role = "Not satisfied with the Sub Broker"
            }
            else if(reason.selectedItem == "Other issues")
            {
                role = "Other issues"
            }
            else {
                role = "null"
            }
            if(role != "null"){
                Api.request(endpoint: .createSwitchRequest(comments: remarkField.text!, parentCode: subBrokerCode.text!, reason: role)) { (JSON) in
                    if (JSON["status"] == 200)
                    {
                        //let messageToShow = HelperFunctions.jsonToString(value:   )
                        let alert = UIAlertController(title: "\(JSON["message"])", message: "", preferredStyle: UIAlertController.Style.alert)
                        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                        self.present(alert, animated: true, completion: nil)
                    }
                    else
                    {
                       
                        let alert = UIAlertController(title: "\(JSON["message"])", message: "", preferredStyle: UIAlertController.Style.alert)
                        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                        self.present(alert, animated: true, completion: nil)
                    }
                }
            }
            else {
                let banner = StatusBarNotificationBanner(title: "Reason not selected!", style: .danger)
                banner.dismiss()
                banner.show()
            }
        }
    }
    
    
    @IBAction func cancelBtn(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func backBtn(_sender: UIButton){
        self.navigationController?.popViewController(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Am I being used or not")
        //self.subBrokerCode.delegate = self as UITextFieldDelegate
        self.subBrokerCode.autocapitalizationType = .words // for auto-capitaliztion of sub broker codes
        //self.remarkField.delegate = self as UITextFieldDelegate
        reason.isOptionalDropDown = false
        reason.itemList = ["Sub-Broker not active", "Not satisfied with the Sub Broker", "Other issues"]
        self.hideKeyboard()
        // Do any additional setup after loading the view.
    }
    
}

//extension SubBrokerDetailsEdit : UITextFieldDelegate {
//    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//        textField.resignFirstResponder()
//        return true
//    }
//}

//
//
//func showAlert(for alert: String) {
//    let alertController = UIAlertController(title: nil, message: alert, preferredStyle: UIAlertController.Style.alert)
//    let alertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
//    alertController.addAction(alertAction)
//    present(alertController, animated: true, completion: nil)
//}
//    
