//
//  USD_BaseDepositWithDraw.swift
//  PCEX2
//
//  Created by RAHUL BANSAL on 5/24/19.
//  Copyright © 2019 Panaesha Capital pvt. ltd. All rights reserved.
//

import UIKit
import Foundation
import SwiftyJSON
class USD_BaseDepositWithDraw: UIViewController {
    
     @IBOutlet weak var headerView: UIView!
      var NavHeight: CGFloat!

    @IBOutlet weak var lblTitle: UILabel!
    
    var isWithdrawal:Bool! = false
    var isCrypto:Bool! = false
    
    var dictResult = [JSON]()
    var addressString: String!
    var imglogoPath: String!
    var currenyName: String!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        
        NavHeight = headerView.frame.size.height
        lblTitle.text = currenyName!
        self.initPageFirstSetup()
        
        
        self.navigationController?.navigationBar.isHidden = true
    
    }


    func initPageFirstSetup()
    {
        let viewControllers = getViewControllers()
        let option = getPageMenuOption()
        let pageMenu = PageMenuView(
            viewControllers: viewControllers,
            option: option)
        pageMenu.delegate = self
        pageMenu.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(pageMenu)
        
    
        
        pageMenu.willMove(toSuperview: viewControllers[1].view)

    }
    
    @IBAction func btnBackAction(_ sender: Any) {
        
        self.navigationController?.popViewController(animated: true)
    }


}

// MARK: - PageMenuViewDelegate

extension USD_BaseDepositWithDraw: PageMenuViewDelegate {
    
    func willMoveToPage(_ pageMenu: PageMenuView, from viewController: UIViewController, index currentViewControllerIndex: Int) {
        
        print(viewController.title!)
    }
    
    func didMoveToPage(_ pageMenu: PageMenuView, to viewController: UIViewController, index currentViewControllerIndex: Int) {
        print(viewController.title!)
        print("---")
//        if (viewController.title == "Pending")
//        {
//            let vc = viewController as! OrdersVC
//            vc.requestNewForSelectio()
//        }
//        else
//        {
//            let vc = viewController as! TradesVC
//            vc.reloadViewForTrades()
//
//        }
    }
}

// MARK: - Model

extension USD_BaseDepositWithDraw {
    
    func getPageMenuOption() -> PageMenuOption {
        var option = PageMenuOption(frame: CGRect(
            x: 0, y: NavHeight, width: view.frame.size.width, height: view.frame.size.height - NavHeight))
        option.menuItemWidth = view.frame.size.width / 2.5
        option.menuItemBackgroundColorNormal = .clear //UIColor(red:0.388, green:0.424, blue:0.467, alpha:1)
        option.menuItemBackgroundColorSelected = .clear //UIColor(red:0.067, green:0.227, blue:0.498, alpha:1)
        option.menuTitleMargin = 12
        option.menuTitleColorNormal = .lightGray
        option.menuTitleColorSelected = UIColor(red:0.067, green:0.227, blue:0.498, alpha:1)
        option.menuIndicatorHeight = 2
        option.menuIndicatorColor = UIColor(red:0.067, green:0.227, blue:0.498, alpha:1)
        return option
    }
    
    func getViewControllers() -> [UIViewController] {
        
        // let markets = ["Orders"]
        
        var viewControllers = [UIViewController]()
        //        for name in markets {
        let animalViewController = USDDepositVC.initFromWithoutStoryboard()
        animalViewController.title = "Deposit"
        animalViewController.isCrypto = isCrypto
        if(isCrypto)
        {
            animalViewController.currenyName = currenyName
            animalViewController.dictResult = dictResult
            animalViewController.imglogoPath = imglogoPath
            animalViewController.addressString = addressString
        }
        
        
        let animalViewController2 = USDWithDraw.initFromWithoutStoryboard()
        animalViewController2.title = "Withdraw"
         animalViewController2.isCrypto = isCrypto
        if(isCrypto)
        {
            animalViewController.currenyName = currenyName
            animalViewController.imglogoPath = imglogoPath
        }
        
        if(isWithdrawal)
        {
            viewControllers.append(animalViewController2)
            viewControllers.append(animalViewController)
        }
        else
        {
            viewControllers.append(animalViewController)
            viewControllers.append(animalViewController2)
        }
        return viewControllers
    }
    
    
}

