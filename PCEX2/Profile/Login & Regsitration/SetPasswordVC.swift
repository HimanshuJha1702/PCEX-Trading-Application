//
//  SetPasswordVC.swift
//  PCEX2
//
//  Created by RAHUL BANSAL on 4/27/19.
//  Copyright © 2019 Panaesha Capital pvt. ltd. All rights reserved.
//

import UIKit

import Foundation
import Alamofire
import NotificationBannerSwift
import SwiftyJSON

class SetPasswordVC: UIViewController,UITextFieldDelegate {
    @IBOutlet weak var txtOtp: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var txtConfirmPassword: UITextField!
    
    @IBOutlet weak var lblOtpSentTo: UILabel!
    @IBOutlet weak var viewPassword: UIImageView!
    @IBOutlet weak var btnVeriFY: UIButton!
    @IBOutlet weak var btnResend: UIButton!
    @IBOutlet weak var btnSubmit: UIButton!
    
    @IBOutlet weak var btnCancel: UIButton!
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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        lblOtpSentTo.text = message
        
        viewPassword.isHidden = true
    }


    override func viewWillAppear(_ animated: Bool) {
        
        self.navigationController?.navigationBar.isHidden = true
    }
    
    @IBAction func btnResendAction(_ sender: Any) {
    }
    
    @IBAction func btnVerifyAction(_ sender: Any) {
        if((txtOtp.text?.isEmpty)! || txtOtp.text == "")
        {
            
        }
        else
        {
            Api.request(endpoint:.verifyRegisterOtp(name: name, email: email, country: country, phone: phone, role: role, city: city, pincode: pincode, countryCode: countryCode, subbrokerCode: subBrokerCode, secretKey: secretKey, fastSecretKey: fastSecretKey, otp: txtOtp.text!)) { (JSON) in
                print("JSOn",JSON)
                
                if(JSON["status"]==200)
                {
                    self.showAnimate()
                }
            }
        }
    }
    
    @IBAction func btnSubmit(_ sender: Any) {
        
    }
    
    @IBAction func btnCancel(_ sender: Any) {
    self.navigationController?.popViewController(animated: true)
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
