//
//  Open_HistoryVCNew.swift
//  PCEX2
//
//  Created by Himanshu Jha on 11/09/19.
//  Copyright © 2019 Panaesha Capital pvt. ltd. All rights reserved.
//

import UIKit
import Foundation
import SwiftyJSON

class AllOrders_HistoryVCNew: UIViewController {
    
    let image = UIImage(named: "button") as UIImage?
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var headerView: UIView!
    
    @IBOutlet weak var openBtn: UIButton!
    @IBOutlet weak var orderBtn: UIButton!
    @IBOutlet weak var tradesBtn: UIButton!
    @IBOutlet weak var viewOrderTrades: UIView!
    
    var NavHeight: CGFloat!
    var checkIsPipe:Bool! = false
    var swiftBlogs = [JSON]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NavHeight = headerView.frame.size.height
        
        if(checkIsPipe)
        {
//            self.backWidth.constant = 60
            self.btnBack.isHidden = false
        }
        else
        {
//            self.backWidth.constant = 0
            self.btnBack.isHidden = true
            
        }
        
        initPageMenu()

        // Do any additional setup after loading the view.
    }
    
    
    func initPageMenu() {
        
//        tableView.isHidden = false
        openBtn.isSelected = true
        
        if #available(iOS 11.0, *) {
            self.openBtn.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
            
            self.orderBtn.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
            self.tradesBtn.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        } else {
            self.openBtn.roundedAllCorner()
            self.orderBtn.roundedAllCorner()
            self.tradesBtn.roundedAllCorner()
        }
        
        
        let viewControllers = getViewControllers()
        let option = getPageMenuOption()
        let pageMenu = PageMenuView(
            viewControllers: viewControllers,
            option: option)
        pageMenu.delegate = self
        pageMenu.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        viewOrderTrades.addSubview(pageMenu)
//        viewOrderTrades.isHidden = false
    }
    
    
    @IBAction func backBtnAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func openBtnAction(_ sender: UIButton) {
        
        openBtn.isSelected = true
        orderBtn.isSelected = false
        tradesBtn.isSelected = false
        viewOrderTrades.isHidden = false
        
    }
    
    @IBAction func orderBtnAction(_ sender: UIButton) {
        
        openBtn.isSelected = false
        orderBtn.isSelected = true
        tradesBtn.isSelected = false
        viewOrderTrades.isHidden = false
        
    }
    
    @IBAction func tradesBtnAction(_ sender: UIButton) {
        
        openBtn.isSelected = false
        orderBtn.isSelected = false
        tradesBtn.isSelected = true
        tradesBtn.setBackgroundImage(image, for: .selected)
        tradesBtn.setTitleColor(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), for: .selected)
        viewOrderTrades.isHidden = false
    }
    
}

extension AllOrders_HistoryVCNew: PageMenuViewDelegate {
    
    func willMoveToPage(_ pageMenu: PageMenuView, from viewController: UIViewController, index currentViewControllerIndex: Int) {
        
        print(viewController.title!)
    }
    
    func didMoveToPage(_ pageMenu: PageMenuView, to viewController: UIViewController, index currentViewControllerIndex: Int) {
        print(viewController.title!)
        print("---")
        if (viewController.title == "All Pairs")
        {
            let vc = viewController as! OrdersVC
            vc.requestNewForSelectio()
        }
        else
        {
            let vc = viewController as! TradesVC
            vc.reloadViewForTrades()
            
        }
    }
}


// MARK: - Model

extension AllOrders_HistoryVCNew {
    
    func getPageMenuOption() -> PageMenuOption {
        var option = PageMenuOption(frame: CGRect(
            x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height - NavHeight))
        option.menuItemWidth = view.frame.size.width / 2
        option.menuItemBackgroundColorNormal = .white //UIColor(red:0.388, green:0.424, blue:0.467, alpha:1)
        option.menuItemBackgroundColorSelected = .white //UIColor(red:0.067, green:0.227, blue:0.498, alpha:1)
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
        let animalViewController = OrdersVC.initFromStoryboard()
        animalViewController.title = "This Pair"
        viewControllers.append(animalViewController)
        // }
        
        let animalViewController2 = TradesVC.initFromStoryboard()
        animalViewController2.title = "All Pairs"
        viewControllers.append(animalViewController2)
        
        return viewControllers
    }
    
    
}





    
    
    
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

