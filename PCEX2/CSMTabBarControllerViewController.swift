//
//  CSMTabBarControllerViewController.swift
//  PCEX2
//
//  Created by RAHUL BANSAL on 4/5/19.
//  Copyright © 2019 Panaesha Capital pvt. ltd. All rights reserved.
//

import UIKit


struct CSMTabBar {
    
    static var GlobalTab:UITabBarController!
}


class CSMTabBarControllerViewController: UITabBarController {

    static let sharedTab = CSMTabBarControllerViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.selectedIndex = 0

        
       // tabBar.selectionIndicatorImage = UIImage(named: "gradtab")
        
        

        
        if let items = self.tabBar.items {
            let height = self.tabBar.bounds.size.height+10;
          //  let imgHeight = height+20;
            let numItems = CGFloat(items.count)
            let itemSize = CGSize(
                width: tabBar.frame.width / numItems,
                height: tabBar.frame.height)
            
           // let itemImageSize = CGSize(
           //     width: tabBar.frame.width / numItems,
           //     height: imgHeight)
            
           // let color = UIColor.clear
            
           // let color = UIColor(patternImage: UIImage(named: "gradtab 2")!)
            
           // tabBar.selectionIndicatorImage = UIImage.imageWithColor(color: color, size: itemImageSize).resizableImage(withCapInsets: .zero)
           // tabBar.selectionIndicatorImage = UIImage.imageWithColor(color: color, size: itemImageSize).resizableImage(withCapInsets: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0))
            
            // remove default border
            tabBar.frame.size.width = self.view.frame.width + 4
            tabBar.frame.origin.x = -2
            
            for (index, _) in items.enumerated() {
                if index > 0 {
                    let xPosition = itemSize.width * CGFloat(index)
                    let separator = UIView(frame: CGRect(
                        x: xPosition, y: 0, width: 0.5, height: height))
                    separator.backgroundColor = UIColor.gray
                    tabBar.insertSubview(separator, at: 1)
                }
            }
        }

    }
    
    override func viewWillAppear(_ animated: Bool) {
        print("cureent index selected",self.selectedIndex)
        if(!APP_Defaults.bool(forKey: "login"))
        {
            self.selectedIndex = 0
        }
  
        
        print("cureent index selected",self.selectedIndex)
    }
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        
        print("current index is ",self.selectedIndex)
        if(!APP_Defaults.bool(forKey: "login"))
        {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let controller = storyboard.instantiateViewController(withIdentifier: "Login")
            //self.present(controller, animated: true, completion: nil)
            
            let navController = UINavigationController(rootViewController: controller)
            self.present(navController, animated:true, completion: nil)
        }
    }
}

extension UIImage {
    class func imageWithColor(color: UIColor, size: CGSize) -> UIImage {
        let rect: CGRect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        color.setFill()
        UIRectFill(rect)
        let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return image
    }
}
