//
//  CSMTabbar.swift
//  PCEX2
//
//  Created by RAHUL BANSAL on 4/24/19.
//  Copyright © 2019 Panaesha Capital pvt. ltd. All rights reserved.
//

import UIKit

@objc(CSMTabbar) class CSMTabbar: UIStoryboardSegue {

    override func perform() {
        let tabBarViewController:TabViewController = self.source as! TabViewController
        
        if((tabBarViewController.destinationViewController) != nil)
        {
            let myDestinationviewController = tabBarViewController.destinationViewController!
            
            //  let myDestinationviewController:UIViewController=tabBarViewController.destinationViewController! as UIViewController
            
            if((tabBarViewController.oldViewController) != nil && tabBarViewController.oldViewController.isViewLoaded)
            {
                tabBarViewController.oldViewController!.willMove(toParent: nil)
                tabBarViewController.oldViewController!.view.removeFromSuperview()
                tabBarViewController.oldViewController!.removeFromParent()
            }
            
            myDestinationviewController.view.frame=tabBarViewController.container.bounds
            tabBarViewController.addChild(myDestinationviewController)
            tabBarViewController.container.addSubview(myDestinationviewController.view)
            myDestinationviewController.didMove(toParent: tabBarViewController)
        }
        
    }

}
