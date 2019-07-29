//
//  AppDelegate.swift
//  PCEX
//
//  Created by CHHAGAN on 3/12/19.
//  Copyright © 2019 Chhagan SIngh. All rights reserved.
//

import UIKit
import CoreData
import IQKeyboardManagerSwift

import Starscream
import NotificationBannerSwift
import Alamofire
import SwiftyJSON
import Messages
import LocalAuthentication

struct AppDelegateGlobal {
    
    static var SocketUrl: String!
}

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        IQKeyboardManager.shared.enable = true
        
        let defaults = UserDefaults.standard
        //testing
//        defaults.set("api1", forKey: "server")
//        AppDelegateGlobal.SocketUrl = "https://pcex.io:3333/socket.io/"
    
//        //live
        defaults.set("api2", forKey: "server")
        AppDelegateGlobal.SocketUrl = "https://pcex.io:4444/socket.io/"
        
//        if AppDataManager.shared.logged {
         
        let date = Int(Date().timeIntervalSince1970)
        let lastActiveDateTimeStamp = UserDefaults.standard.integer(forKey: "last_active_time")
        if (date - lastActiveDateTimeStamp > 10 &&  APP_Defaults.bool(forKey: "login"))
        {
            self.startLoginController()
        }
       
        defaults.synchronize()
        return true
    }
    
    public func startLoginController() {
        
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "RegisterNav") as! UINavigationController
        self.window?.rootViewController = vc
        
//        let destViewController : TabViewController = storyBoard!.instantiateViewController(withIdentifier: "landingPage") as! TabViewController
//        self.navigationController!.pushViewController(destViewController, animated: true)
        
//        let storyBoard = UIStoryboard(name: "First", bundle: nil)
//        let vc = storyBoard.instantiateViewController(withIdentifier: "RegisterNav") as! UINavigationController
//        self.window?.rootViewController = vc
    }

    
    func applicationWillResignActive(_ application: UIApplication) {
        let dateTimeStamp = Date().timeIntervalSince1970
        UserDefaults.standard.set(dateTimeStamp, forKey: "last_active_time")
        UserDefaults.standard.synchronize()
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        
        let date = Int(Date().timeIntervalSince1970)
        let lastActiveDateTimeStamp = UserDefaults.standard.integer(forKey: "last_active_time")
        if date - lastActiveDateTimeStamp > 10  {
            if (date - lastActiveDateTimeStamp > 10 &&  APP_Defaults.bool(forKey: "login"))
            {
                self.startLoginController()
            } else {
                let mainStoryBoard = UIStoryboard(name: "Main", bundle: nil)
                let redViewController = mainStoryBoard.instantiateViewController(withIdentifier: "respectiveIdentifier")
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                appDelegate.window?.rootViewController = redViewController
            }
        }
        
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    
}



