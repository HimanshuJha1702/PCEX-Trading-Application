//
//  AppDataManager.swift
//  PCEX2
//
//  Created by Chhagan Singh on 19/06/19.
//  Copyright © 2019 Panaesha Capital pvt. ltd. All rights reserved.
//

import Foundation
import UIKit

class AppDataManager {
    static let shared = AppDataManager()
   
    var token:String? {
        get {
            if let userData = UserDefaults.standard.string(forKey: "user_data"), userData.count > 0 {
                return userData
            }
            return nil
        } set (newValue) {
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            UserDefaults.standard.set(newValue ?? "", forKey: "user_data")
        }
    }
    
    
    var passCode:String? {
        get {
            if let code = UserDefaults.standard.string(forKey: "code"), code.count > 0 {
                return code
            }
            return nil
        } set (newValue) {
            UserDefaults.standard.set(newValue ?? "", forKey: "code")
        }
        
    }
    
    var canShowPassCode:Bool {
        return self.logged && self.passCode != nil
    }
    
    
    
    var logged:Bool {
        get {
            return APP_Defaults.bool(forKey: "login")
        }
    }
    
}
