//
//  Login.swift
//  PCEX
//
//  Created by CHHAGAN on 3/12/19.
//  Copyright © 2019 Chhagan SIngh. All rights reserved.
//

import UIKit
import Foundation
import KeychainAccess
import Alamofire
import NotificationBannerSwift
import IQKeyboardManagerSwift
import IQDropDownTextField
import SwiftyGif
import KRProgressHUD
import VBRRollingPit

class Login: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var headerHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var loginUserNameTxtFieldOutlet: UITextField!
    @IBOutlet weak var loginPassTxtFieldOutlet: UITextField!
    
    @IBOutlet weak var loginBtnOutet: UIButton!
    @IBOutlet weak var loginRegBtnOutlet: UIButton!
    
    var iconClick = true
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.loginPassTxtFieldOutlet.delegate = self
        self.loginUserNameTxtFieldOutlet.delegate = self
        self.hideKeyboard()
        
        //self.headerHeightConstraint.constant = GlobalVariables.NavHeight
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        navigationController?.setNavigationBarHidden(true, animated: animated)
        
        if Connectivity.isConnectedToInternet {
            print("Yes! internet is available.")
        }
        else
        {
            let banner = StatusBarNotificationBanner(title: "No Network Connection", style: .danger)
            banner.dismiss()
            banner.show()
        }
        self.clearLoginFieldValues()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
        

    }
    
    func clearLoginFieldValues()
    {
        self.loginPassTxtFieldOutlet.text = "Sidcash@98180"
        self.loginUserNameTxtFieldOutlet.text = "HimJha1439"
    }
    // MARK: - Custom functions
    
    func validLogin()
    {

                let mainStoryBoard = UIStoryboard(name: "Main", bundle: nil)
                let redViewController = mainStoryBoard.instantiateViewController(withIdentifier: "landingPage")
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                let navController = UINavigationController(rootViewController: redViewController)
                
                UIView.transition(with: self.view, duration: 0.3, options: .transitionFlipFromLeft, animations: {
                    
                    appDelegate.window?.rootViewController = navController
                    navController.navigationBar.isHidden = true
        })

    }

    
    
    // MARK: - Button Action
    
    @IBAction func loginBtnAction(_ sender: Any) {
        if(self.loginUserNameTxtFieldOutlet.text != "" && self.loginPassTxtFieldOutlet.text != "")
        {
            
            loginWthParameters()
            
//            let keychain = Keychain(service: "me.jobins.PCEX").synchronizable(true).accessibility(.whenUnlocked)
//            if keychain["user"]?.lowercased() == self.loginUserNameTxtFieldOutlet.text?.lowercased() && keychain["password"] == self.loginPassTxtFieldOutlet.text {
//                validLogin()
//            }else{
//                alert(title: "Error!", message: "Wrong username or password!", actionTitle: "Retry", cancelTitle: nil) { (confirmed) in
//                    self.loginPassTxtFieldOutlet.becomeFirstResponder()
//                }
//            }
        }
        else
        {
            if(self.loginUserNameTxtFieldOutlet.text == "" || self.loginUserNameTxtFieldOutlet.text!.isEmpty){
            alert(title: "Error!", message: "Please fill your username", actionTitle: "PCEX", cancelTitle: nil) { (confirmed) in
                self.loginUserNameTxtFieldOutlet.becomeFirstResponder()
                }
            }
            else if (self.loginPassTxtFieldOutlet.text == "" || self.loginPassTxtFieldOutlet.text!.isEmpty)
            {
                alert(title: "Error!", message: "Please fill your password", actionTitle: "PCEX", cancelTitle: nil) { (confirmed) in
                    self.loginPassTxtFieldOutlet.becomeFirstResponder()
                }
            }
        }
        
    }
    
    @IBAction func btnShowPassword(_ sender: Any) {
        
        if(iconClick == true) {
           loginPassTxtFieldOutlet.isSecureTextEntry = false
        } else {
            loginPassTxtFieldOutlet.isSecureTextEntry = true
        }
        
        iconClick = !iconClick
    }
    
    @IBAction func btnCancel(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func loginRegBtnAction(_ sender: Any) {
          
        // Safe Push VC
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier : "loginToRegSegue" )
        let navController = UINavigationController (rootViewController: controller)
        self.present(navController, animated: true, completion: nil)
//        let destViewController : Registration = self.storyboard!.instantiateViewController(withIdentifier: "loginToRegSegue") as! Registration
//        self.navigationController!.pushViewController(destViewController, animated: true)
    }
    
    // MARK: - View Delegates
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let textTag = textField.tag+1
        let nextResponder = textField.superview?.viewWithTag(textTag) as UIResponder?
        if(nextResponder != nil)
        {
            //textField.resignFirstResponder()
            nextResponder?.becomeFirstResponder()
        }
        else{
            // stop editing on pressing the done button on the last text field.
            
            self.view.endEditing(true)
        }
        return true
    }
    
    //https://pcex.io/api2/admin/login
    // MARK: - API Calls https://pcex.io/api1/admin/login
    func loginWthParameters()
    {
        print("1");
        KRProgressHUD.show(withMessage: "Loading...")
        
    
        
        Api.request(endpoint:Api.Endpoints.login(username: self.loginUserNameTxtFieldOutlet.text!, password: self.loginPassTxtFieldOutlet.text!)) { (JSON) in
           // print("****************",JSON)
            
            let userDetails = JSON["data"].dictionaryObject
            
          
            if((userDetails) != nil)
            {
                APP_Defaults.set(self.loginUserNameTxtFieldOutlet.text!, forKey: "userName")
                APP_Defaults.set(self.loginPassTxtFieldOutlet.text!, forKey: "password")
                
                
                APP_Defaults.set(userDetails!["userId"], forKey: "userId")
                APP_Defaults.set(userDetails!["fastSessionId"], forKey: "fastSessionId")
                APP_Defaults.set(userDetails!["sessionId"], forKey: "sessionId")

                
                for obj in userDetails!.keys {
                    let myObj = userDetails![obj]
                    if((myObj) != nil)
                    {
                        
                        if myObj is NSNull {
                            print("getting ",myObj!)
                        }
                        else
                        {
                            UserDefaults.standard.set(myObj, forKey: obj)
                        }
                        
                    }
                }
              
            }
            else
            {
                let message = JSON["message"].stringValue
                self.alert(title: "PCEX", message: message, actionTitle: nil, cancelTitle: "OK", success: nil)
                
                return
            }
       
            
//           let userDet = UserDetailsModal.init(userId: (userDetails!["userId"] as! Int),
//                                  userName: (userDetails!["userName"] as! String),
//                                  tncStatus: (userDetails!["tncStatus"] as! Int),
//                                  fullName: (userDetails!["fullName"] as! String),
//                                  role: (userDetails!["role"] as! Int),
//                                  phone: (userDetails!["phone"] as! String),
//                                  kycStatus: (userDetails!["kycStatus"] as! Int),
//                                  fastSessionId: (userDetails!["fastSessionId"] as! Int),
//                                  userCode: (userDetails!["userCode"] as! String),
//                                  sessionId: (userDetails!["sessionId"] as! String),
//                                  email: (userDetails!["email"] as! String),
//                                  userStatus: (userDetails!["userStatus"] as! Int),
//                                  parentId: (userDetails!["parentId"] as! Int))
//
//            let encodedData = NSKeyedArchiver.archivedData(withRootObject: userDet)
//            APP_Defaults.set(encodedData, forKey: "userDetails")
            APP_Defaults .synchronize()
   
            self.validLogin()
            
            APP_Defaults.set(true, forKey: "login")
            
        }
        
        
        
//        Alamofire.request("https://pcex.io//admin/login", method: .post, parameters: ["foo": "bar"],encoding: JSONEncoding.default, headers: nil).responseJSON {
//            response in
//            switch response.result {
//            case .success:
//                print(response)
//
//                break
//            case .failure(let error):
//
//                print(error)
//            }
//        }
    }
    
    

}



