//
//  OtpVerify.swift
//  PCEX
//
//  Created by CHHAGAN on 3/12/19.
//  Copyright © 2019 Chhagan SIngh. All rights reserved.
//

import UIKit
import Foundation
import Alamofire
import NotificationBannerSwift
import SwiftyJSON


class OtpVerify: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var txtOtp: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var txtConfirmPassword: UITextField!
    
    @IBOutlet weak var lblOtpSentTo: UILabel!
    @IBOutlet weak var viewPassword: UIView!
    @IBOutlet weak var btnVeriFY: UIButton!
    @IBOutlet weak var btnResend: UIButton!
    @IBOutlet weak var btnSubmit: UIButton!
    
    var secretKey: String!
    var message: String!
    var fastSecretKey: String!
    var name:String!
    var country:String!
    var phone:Int!
    var pincode:Int!
    var email:String!
    var countryCode:Int!
    var role:Int!
    var subBrokerCode:String!
    var city:String!
    var password:String = ""
    var allData:[String:AnyObject]!

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        lblOtpSentTo.text = message
        
        viewPassword.isHidden = true
        
        if #available(iOS 11.0, *) {
            viewPassword.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner,.layerMaxXMaxYCorner,.layerMinXMaxYCorner]
        } else {
           viewPassword.roundedAllCorner()
        }
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
        
    }

    @IBAction func btnResendAction(_ sender: Any) {
        
        Api.request(endpoint: .re_sendOtp(name: self.name, email: self.email, country: country, phone: phone, role: role, city: city, pincode: pincode, countryCode: countryCode, subbrokerCode:subBrokerCode), completionHandler:{ (JSON) in
            
            print("*&$*",JSON)
            
            if(JSON["status"]==200)
            {
                self.message = JSON["message"].stringValue
                self.secretKey = JSON["secretKey"].stringValue
               self.fastSecretKey = JSON["fastSecretKey"].stringValue
            }
            else
            {
                let alert = UIAlertController(title: "PCEX", message: JSON["message"].stringValue, preferredStyle: UIAlertController.Style.alert)
                
                // add an action (button)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                
                // show the alert
                self.present(alert, animated: true, completion: nil)
                return
            }
        })
    }
    
    @IBAction func btnVerifyAction(_ sender: Any) {
        if((txtOtp.text?.isEmpty)! || txtOtp.text == "")
        {
            let alert = UIAlertController(title: "PCEX", message: "OTP field must be filled", preferredStyle: UIAlertController.Style.alert)
            
            // add an action (button)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            
            // show the alert
            self.present(alert, animated: true, completion: nil)
            return
        }
        else
        {
            Api.request(endpoint:.verifyRegisterOtp(name: name, email: email, country: country, phone: phone, role: role, city: city, pincode: pincode, countryCode: countryCode, subbrokerCode: subBrokerCode, secretKey: secretKey, fastSecretKey: fastSecretKey, otp: txtOtp.text!), completionHandler: { (JSON) in
                print("JSOn",JSON)
                
                if(JSON["status"]==200)
                {
                    self.showAnimate()
                }
                else
                {
                    let alert = UIAlertController(title: "PCEX", message: JSON["message"].stringValue, preferredStyle: UIAlertController.Style.alert)
                    
                    // add an action (button)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                    
                    // show the alert
                    self.present(alert, animated: true, completion: nil)
                    return
                }
                
            })
        }
    }
    
    @IBAction func btnSubmit(_ sender: Any) {
        
        if((txtPassword.text?.isEmpty)! || txtPassword.text == "" || txtPassword.text! != txtConfirmPassword.text!)
        {
            let alert = UIAlertController(title: "PCEX", message: "Password field must be filled and password must be equal to confirm password.", preferredStyle: UIAlertController.Style.alert)
            
            // add an action (button)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            
            // show the alert
            self.present(alert, animated: true, completion: nil)
            return
        }
        else
        {
        Api.request(endpoint: .userRegisterRequest(name: name, email: email, country: country, phone: phone, role: role, city: city, pincode: pincode, countryCode: countryCode, subbrokerCode: subBrokerCode, secretKey: secretKey, fastSecretKey: fastSecretKey, otp: txtOtp.text!,password: txtPassword.text!), completionHandler: { (JSON) in
            print("JSOn",JSON)
            
            if(JSON["status"]==200)
            {
                self.removeAnimate()
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let controller = storyboard.instantiateViewController(withIdentifier: "Login")
                self.navigationController?.popToViewController(controller, animated: true)
                
               // self.navigationController?.popToRootViewController(animated: true);
            
            }
            else
            {
                let alert = UIAlertController(title: "PCEX", message: JSON["message"].stringValue, preferredStyle: UIAlertController.Style.alert)
                
                // add an action (button)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                
                // show the alert
                self.present(alert, animated: true, completion: nil)
                return
            }
            
        })
        }
    }
    
    
    func showAnimate()
    {

        
        self.viewPassword.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        self.viewPassword.alpha = 0.0
        self.viewPassword.isHidden = false
        
        UIView.animate(withDuration: 0.6, animations: {
            
            self.viewPassword.alpha = 1.0
            self.viewPassword.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        })
    }
    
    func removeAnimate()
    {

        UIView.animate(withDuration: 0.6, animations: {
            self.viewPassword.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
            self.viewPassword.alpha = 0.0
        }, completion: {(finished : Bool) in
            if(finished)
            {
                self.viewPassword.isHidden = true
            }
        })
    }
    
    
}
