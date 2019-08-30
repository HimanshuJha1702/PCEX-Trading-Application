//
//  SubBrokerAssignByBroker.swift
//  PCEX2
//
//  Created by Himanshu Jha on 20/08/19.
//  Copyright © 2019 Panaesha Capital pvt. ltd. All rights reserved.
//

import UIKit
import Foundation
import IQDropDownTextField
import NotificationBannerSwift

class SubBrokerAssignByBroker: UIViewController {

    @IBOutlet weak var reason: IQDropDownTextField!
    @IBOutlet weak var remark: UITextField!
    
    @IBAction func submitBtn(_ sender: UIButton) {
        if(remark.text!.isEmpty)
        {
            let banner = StatusBarNotificationBanner(title: "Please fill all fields first", style: .danger)
            banner.dismiss()
            banner.show()
        }
        else if(remark.text!.characters.count < 10){
            //show warning that the length of remarks should be at least 10 characters
            let alert = UIAlertController(title: "Warning!", message: "Remarks can't be less than 10 characters", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        else{
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
                let input =  NSNull() as Any;
                Api.request(endpoint: .createSwitchRequest(comments: remark.text!, parentCode: input, reason: role)) { (JSON) in
                    if (JSON["status"] == 200)
                    {
                        print("success!")
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
    func callMeToGetBack(){
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func cancelBtn(_ sender: UIButton) {
        callMeToGetBack();
    }
    
    @IBAction func backBtn(_ sender: UIButton) {
        callMeToGetBack();
    }
    
    override func viewDidLoad() {
       //self.remark.delegate = self
        print("cool, this page is working!")
        
        reason.isOptionalDropDown = false
        reason.itemList = ["Sub-Broker not active", "Not satisfied with the Sub Broker", "Other issues"]
        self.hideKeyboard()
        
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
}


//extension SubBrokerDetailsEdit : UITextFieldDelegate {
//    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//        textField.resignFirstResponder()
//        return true
//    }
//}


