//
//  PasswrdChange.swift
//  PCEX2
//
//  Created by CHHAGAN SINGH on 5/29/19.
//  Copyright © 2019 Panaesha Capital pvt. ltd. All rights reserved.
//

import UIKit
import SwiftyJSON
import IQKeyboardManagerSwift
import NotificationBannerSwift
import Alamofire

class PasswrdChange: UIViewController {

    @IBOutlet weak var txtOldPassword: UITextField!
    
    @IBOutlet weak var txtNewPassword: UITextField!
    
    @IBOutlet weak var txtConfirmPassword: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func btnSubmit(_ sender: Any) {
        let res1 = txtNewPassword.text!.removeWhitespace()
        let res3 = txtOldPassword.text!.removeWhitespace()
        let res4 = txtConfirmPassword.text!.removeWhitespace()
        
        if(txtNewPassword.text!.isEmpty || txtOldPassword.text!.isEmpty ||  txtConfirmPassword.text!.isEmpty ||  res1.isEmpty || res3.isEmpty || res4.isEmpty)
        {
            let banner = StatusBarNotificationBanner(title: "Please fill all fields first.", style: .danger)
            banner.dismiss()
            banner.show()
        }
        else if(txtNewPassword.text! != txtConfirmPassword.text!)
        {
            let banner = StatusBarNotificationBanner(title: "New password and confirm password not matched.", style: .danger)
            banner.dismiss()
            banner.show()
        }
        else
        {
            Api.request(endpoint: .changePassword(currentPassword: txtOldPassword.text!, newPassword: txtNewPassword.text!)) { (JSON) in
                if (JSON["status"] == 200)
                {
                    
                    let banner = StatusBarNotificationBanner(title: "Password changed successfully.", style: .success)
                    banner.dismiss()
                    banner.show()
                }
                else
                {
                    let banner = StatusBarNotificationBanner(title: "Failed to update new password.", style: .warning)
                    banner.dismiss()
                    banner.show()
                }
                
     
            }
        }
    }
    
}
