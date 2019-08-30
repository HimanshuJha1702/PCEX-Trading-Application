//
//  FirstVCViewController.swift
//  PCEX2
//
//  Created by Chhagan Singh on 22/06/19.
//  Copyright © 2019 Panaesha Capital pvt. ltd. All rights reserved.
//

import UIKit
import LocalAuthentication
class FirstVCViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("FirstVCViewController");
         DispatchQueue.main.async {
            self.authenticationWithTouchID()
        }
        self.If_LoginedUser()
    }
    
    func If_LoginedUser()
    {
        let username = APP_Defaults.value(forKey: "userName") as! String
        let password = APP_Defaults.value(forKey: "password") as! String
        
        
        Api.request(endpoint: .login(username: username, password: password), completionHandler: { (JSON) in
            
            print("****************",JSON)
            
            let userDetails = JSON["data"].dictionaryObject
            
            
            if((userDetails) != nil)
            {
                
                APP_Defaults.set(userDetails!["userId"], forKey: "userId")
                APP_Defaults.set(userDetails!["fastSessionId"], forKey: "fastSessionId")
                APP_Defaults.set(userDetails!["sessionId"], forKey: "sessionId")
                //APP_Defaults .synchronize()
                
                APP_Defaults.set(true, forKey: "login")
                APP_Defaults .synchronize()
                
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
                
                
                let arrayCheck = APP_Defaults.value(forKey: "favList")
                if((arrayCheck) != nil)
                {
                    GlobalVariables.myFavs = arrayCheck as! [CurrencyModel]
                }
                DispatchQueue.main.async {
                self.loadOrders(pageNumber: 1)
                self.loadPendingOrders(pageNumber: 1)
                    
                let destViewController : TabViewController = self.storyboard!.instantiateViewController(withIdentifier: "landingPage") as! TabViewController
                self.navigationController!.pushViewController(destViewController, animated: true)
                    
                }
                
                
                APP_Defaults .synchronize()
                

            }
            else  {
                return
            }
            
            
            
        })
        
        
        
        
    }
    
    func loadOrders(pageNumber:Int)
    {
        
        Api.request(endpoint: .getOrders(pageNumber: pageNumber)) { (json) in
            // print("current result for orders are",json)
            
            let userNetData = json["data"].array
            
            if((userNetData) != nil && userNetData!.count>0)
            {
                GlobalVariables.orders = json["data"].array!
            }
            
            
        }
        
    }
    
    func loadPendingOrders(pageNumber:Int)
    {
        let dict = ["status":1]
        
        Api.request(endpoint: .getPendingOrders(pageNumber: pageNumber, filters: dict)) { (json) in
            //  print("current result for orders are",json)
            
            let userNetData = json["data"].array
            
            if((userNetData) != nil && userNetData!.count>0)
            {
                GlobalVariables.pendingOrders = json["data"].array!
            }
        }
        
    }
    

}

extension FirstVCViewController {
    
    func authenticationWithTouchID() {
        let localAuthenticationContext = LAContext()
        localAuthenticationContext.localizedFallbackTitle = "Use Passcode"
        
        var authError: NSError?
        let reasonString = "To access the secure data"
        
        if localAuthenticationContext.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &authError) {
            
            localAuthenticationContext.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reasonString) { success, evaluateError in
                
                if success {
                    
                    let destViewController : TabViewController = self.storyboard!.instantiateViewController(withIdentifier: "landingPage") as! TabViewController
                    self.navigationController!.pushViewController(destViewController, animated: true)
                    //TODO: User authenticated successfully, take appropriate action
                    
                } else {
                    //TODO: User did not authenticate successfully, look at error and take appropriate action
                    guard let error = evaluateError else {
                        return
                    }
                    
                    print(self.evaluateAuthenticationPolicyMessageForLA(errorCode: error._code))
                    
                    //exit(0)
                    
                    //TODO: If you have choosen the 'Fallback authentication mechanism selected' (LAError.userFallback). Handle gracefully
                    //LAError.userFallback
                }
            }
        } else {
            
            guard let error = authError else {
                return
            }
            //TODO: Show appropriate alert if biometry/TouchID/FaceID is lockout or not enrolled
            print(self.evaluateAuthenticationPolicyMessageForLA(errorCode: error.code))
        }
    }
    
    func evaluatePolicyFailErrorMessageForLA(errorCode: Int) -> String {
        var message = ""
        if #available(iOS 11.0, macOS 10.13, *) {
            switch errorCode {
            case LAError.biometryNotAvailable.rawValue:
                message = "Authentication could not start because the device does not support biometric authentication."
                
            case LAError.biometryLockout.rawValue:
                message = "Authentication could not continue because the user has been locked out of biometric authentication, due to failing authentication too many times."
                
            case LAError.biometryNotEnrolled.rawValue:
                message = "Authentication could not start because the user has not enrolled in biometric authentication."
                
            default:
                message = "Did not find error code on LAError object"
            }
        } else {
            switch errorCode {
            case LAError.touchIDLockout.rawValue:
                message = "Too many failed attempts."
                
            case LAError.touchIDNotAvailable.rawValue:
                message = "TouchID is not available on the device"
                
            case LAError.touchIDNotEnrolled.rawValue:
                message = "TouchID is not enrolled on the device"
                
            default:
                message = "Did not find error code on LAError object"
            }
        }
        
        return message;
    }
    
    func evaluateAuthenticationPolicyMessageForLA(errorCode: Int) -> String {
        
        var message = ""
        
        switch errorCode {
            
        case LAError.authenticationFailed.rawValue:
            message = "The user failed to provide valid credentials"
            
        case LAError.appCancel.rawValue:
            message = "Authentication was cancelled by application"
            
        case LAError.invalidContext.rawValue:
            message = "The context is invalid"
            
        case LAError.notInteractive.rawValue:
            message = "Not interactive"
            
        case LAError.passcodeNotSet.rawValue:
            message = "Passcode is not set on the device"
            
        case LAError.systemCancel.rawValue:
            message = "Authentication was cancelled by the system"
            
        case LAError.userCancel.rawValue:
            message = "The user did cancel"
            
        case LAError.userFallback.rawValue:
            message = "The user chose to use the fallback"
            
        default:
            message = evaluatePolicyFailErrorMessageForLA(errorCode: errorCode)
        }
        
        return message
    }
}
