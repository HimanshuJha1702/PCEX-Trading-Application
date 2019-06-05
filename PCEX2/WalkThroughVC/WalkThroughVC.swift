//
//  WalkThroughVC.swift
//  PCEX2
//
//  Created by RAHUL BANSAL on 4/3/19.
//  Copyright © 2019 Panaesha Capital pvt. ltd. All rights reserved.
//

import Foundation
import UIKit
import KRProgressHUD
import SwiftyGif



class WalkThroughVC: UIViewController,  CSMWalkthroughVCDelegate{
    
     @IBOutlet weak var flashLogo: UIImageView!
    
    let walkthroughs = [
        CSMWalkthroughModel(title: "", subtitle: "", icon: "01.jpg"),
        CSMWalkthroughModel(title: "", subtitle: "", icon: "02.jpg"),
        CSMWalkthroughModel(title: "", subtitle: "", icon: "03.jpg"),
        CSMWalkthroughModel(title: "", subtitle: "", icon: "04.jpg"),
        ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        flashLogo.setGifImage(UIImage(gifName: "flash.gif"), manager: .defaultManager, loopCount: 1)
        flashLogo.startAnimating()
    }
    

    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0, execute: {
            self.flashLogo.stopAnimatingGif()
            self.flashLogo.isHidden = true
            
            
            let width = UIScreen.main.bounds.width
            let height = UIScreen.main.bounds.height
            
            let button:UIButton = UIButton(frame: CGRect(x: width - 80, y: height - 60, width: 100, height: 30))
            button.backgroundColor = .clear
            let image = UIImage(named: "button") as UIImage?
            button.setBackgroundImage(image, for: .normal)
            button.setTitle("Skip", for: .normal)
            button.addTarget(self, action:#selector(self.buttonClicked), for: .touchUpInside)
            self.view.superview!.addSubview(button)
            
            
            AppDelegateGlobal.SocketUrl = "https://pcex.io:4444/socket.io/"
            
            if(APP_Defaults.bool(forKey: "login"))
            {
            self.If_LoginedUser()
                
            }
            else
            {
//                AppDelegateGlobal.SocketUrl = "https://pcex.io:3333/socket.io/"
                let walkthroughVC = self.walkthroughVC()
                walkthroughVC.delegate = self
                self.addChildViewControllerWithView(walkthroughVC)
            }
            
        })
    }
    
    func walkthroughViewControllerDidFinishFlow(_ vc: CSMWalkthroughVC) {
        
        let mainStoryBoard = UIStoryboard(name: "Main", bundle: nil)
        let redViewController = mainStoryBoard.instantiateViewController(withIdentifier: "respectiveIdentifier")
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        UIView.transition(with: self.view, duration: 0.3, options: .transitionFlipFromLeft, animations: {
            
                appDelegate.window?.rootViewController = redViewController
            
            vc.view.removeFromSuperview()
            
        }, completion: nil)
        
    }
    
    fileprivate func walkthroughVC() -> CSMWalkthroughVC {
        
        let viewControllers = walkthroughs.map { CSMClassicWalkthroughVC(model: $0, nibName: "CSMClassicWalkthroughVC", bundle: nil) }
        
        return CSMWalkthroughVC(nibName: "CSMWalkthroughVC",
                                            bundle: nil,
                                            viewControllers: viewControllers)
    }
    
    
    
    @objc func buttonClicked() {
        self.navigationController?.navigationBar.isHidden = true
        let mainStoryBoard = UIStoryboard(name: "Main", bundle: nil)
        let redViewController = mainStoryBoard.instantiateViewController(withIdentifier: "respectiveIdentifier")
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.window?.rootViewController = redViewController
    }
    /*
     APP STARTING METHODS
 */
    func If_LoginedUser()
    {
        KRProgressHUD.show(withMessage: "Please Wait...")
        
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
                
                self.loadOrders(pageNumber: 1)
                self.loadPendingOrders(pageNumber: 1)
                
                
                APP_Defaults .synchronize()
                
                let destViewController : TabViewController = self.storyboard!.instantiateViewController(withIdentifier: "landingPage") as! TabViewController
                self.navigationController!.pushViewController(destViewController, animated: true)
                
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
