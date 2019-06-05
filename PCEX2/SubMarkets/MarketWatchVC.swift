
//  MarketWatchVC.swift
//  PCEX
//
//  Created by CHHAGAN on 3/14/19.
//  Copyright © 2019 Chhagan SIngh. All rights reserved.
//

import Foundation
import UIKit
import Starscream
import NotificationBannerSwift
import Alamofire
import SwiftyGif

class MarketWatchVC: UIViewController , UITextFieldDelegate,USD_VC_Delegate,FCC_VC_Delegate,BTC_VC_Delegate,ETH_VC_Delegate,FAV_VC_Delegate{
    
    @IBOutlet weak var flashLogo: UIImageView!
    var currenciesListObj = [Int:CurrencyModel]()
    var comparisonNumber: Double?
    
    static let userId = APP_Defaults.value(forKey: "userId") as! Int
    
    @IBOutlet weak var customTradeView: UIView!
    @IBOutlet weak var tradeViewheightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var segmentView: UISegmentedControl!
    
    @IBOutlet weak var lblBalance: UILabel!
    
    @IBOutlet weak var txtPrice: UITextField!
    
    @IBOutlet weak var txtQuantity: UITextField!
    
    @IBOutlet weak var txtTotal: UITextField!
    
    @IBOutlet weak var txtLotSize: UITextField!
    
    @IBOutlet weak var lblLotSize: UILabel!
    
    @IBOutlet weak var lotSizeheightConstraint: NSLayoutConstraint!
    @IBOutlet weak var totalNqtyHeightConstraint: NSLayoutConstraint!
    
    var is_TradeViewVisible:Bool!
    
    var placeOrder = [String:AnyObject]()
    
    var msgTrade: String!
    var brokrage: Double!
    var lotSize: String!
    var category: Int!
    var symbolId:Int!
    var symbolName: String!
    var market: String!
    var orderType: Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let topBarHeight = UIApplication.shared.statusBarFrame.size.height +
            (self.navigationController?.navigationBar.frame.height ?? 0.0)
        
        
        print("current height of navigation bar",GlobalVariables.NavHeight)
        
        if(topBarHeight < 50)
        {
            GlobalVariables.NavHeight = topBarHeight+44
        }
        else
        {
            GlobalVariables.NavHeight = topBarHeight
        }
        
        self.navigationController?.navigationBar.isHidden = true
        
        
        initPageMenu()
        
        //self.title = "Market"
        
//        flashLogo.setGifImage(UIImage(gifName: "flash.gif"), manager: .defaultManager, loopCount: 1)
//        flashLogo.startAnimating()
        
        //self.navigationController?.setNavigationBarHidden(false, animated: false)
        
           category = 2
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if Connectivity.isConnectedToInternet {
            print("Yes! internet is available.")
        }
        else{
            let banner = StatusBarNotificationBanner(title: "No Network Connection", style: .danger)
            banner.dismiss()
            banner.show()
        }
        
       // category = 2
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
    }
    
    func initPageMenu() {
        
        self.customTradeView.clipsToBounds = true
        self.customTradeView.layer.cornerRadius = 15
        if #available(iOS 11.0, *) {
            self.customTradeView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        } else {
            self.customTradeView.roundedTop()
        }
        
        
        let defaults = UserDefaults.standard
        var markets = defaults.object(forKey: "markets") as? [String] ?? [String]()
        
        if markets.count == 0
        {
            markets = ["⭐","USD","FCC","BTC","FCC"]
        }
        
        if(markets.count == 4)
        {
            markets.insert("⭐", at: 0)
        }
        
        
        var viewControllers = [UIViewController]()
        
        _ = [FavMarketVC]()
        let customVC = FavMarketVC.initFromStoryboardforFavMarketVC()
        customVC.title = markets[0]
        customVC.delegate = self
        viewControllers.append(customVC)
        
        _ = [ListerVC]()
        let customViewController = ListerVC.initFromStoryboardforListerVC()
        customViewController.title = markets[1]
        customViewController.delegate = self
        viewControllers.append(customViewController)
        
        _ = [MarketFCC]()
        let customViewController1 = MarketFCC.initFromStoryboardforMarketFCC()
        customViewController1.title = markets[2]
        customViewController1.delegate = self
        viewControllers.append(customViewController1)
        
        _ = [MarketBTC]()
        let customViewController2 = MarketBTC.initFromStoryboardforMarketBTC()
        customViewController2.title = markets[3]
        customViewController2.delegate = self
        viewControllers.append(customViewController2)
        
        _ = [MarketETH]()
        let customViewController3 = MarketETH.initFromStoryboardforMarketETH()
        customViewController3.title = markets[4]
        customViewController3.delegate = self
        viewControllers.append(customViewController3)
        
        let option = getPageMenuOption()
        let pageMenu = PageMenuView(
            viewControllers: viewControllers,
            option: option)
        pageMenu.delegate = self
        pageMenu.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(pageMenu)        
        removeAnimate()
        
        
        let btnDefault = UIButton(frame: CGRect(x: 100, y: 100, width: 100, height: 50))
        btnDefault.backgroundColor = .green
        btnDefault.tag = 2
        pageMenu.selectedMenuItem(btnDefault)
    }
    
    
     @IBAction func bellBtnAction(_ sender: Any) {
        
        let logs:LogsViewVC = LogsViewVC(nibName: "LogsViewVC", bundle: nil)
        self.navigationController?.pushViewController(logs, animated: true)
        
     }
    
    /*
     Mark : - text feild delegates
     
     */
    
    @IBAction func txtValueChange(_ sender: UITextField) {
        
        if (sender.text! != "" || !sender.text!.isEmpty) {
            
            if(txtPrice.text!.isEmpty || txtPrice.text == "")
            {
                return
            }
            else if (txtQuantity.text!.isEmpty || txtQuantity.text == "")
            {
                return
            }
            else
            {
                let price = Double(txtPrice.text!)
                let qty = Double(txtQuantity.text!)
                
                let total = price! * qty!
                self.txtTotal.text = String(format:"%f", total)
            }
            
        }
        
    }
    
    
    
    
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
    
    
    //    func scrollViewDidScroll(_ scrollView: UIScrollView) {
    //        removeAnimate()
    //    }
    
    @IBAction func btnCancel(_ sender: Any) {
        removeAnimate()
    }
    
    @IBAction func btnBuy(_ sender: Any) {
        
        if(Int(lotSize)! > 1)
        {
            brokrage = 0.006
        }
        else
        {
            brokrage = 0.0006
        }
        
        
        orderType = 1
        
        if(txtPrice.text!.isEmpty || txtPrice.text == "" || txtQuantity.text!.isEmpty || txtQuantity.text == "")
        {
            let alert = UIAlertController(title: "PCEX", message: "Quantity and price should not be blank.", preferredStyle: UIAlertController.Style.alert)
            
            // add an action (button)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            
            // show the alert
            self.present(alert, animated: true, completion: nil)
            return
        }
        else
        {
            
            if(Double(txtQuantity.text!)!>0 && Double(txtPrice.text!)! >  0)
            {
                let qty = Double(txtQuantity.text!)!
                let rate = Double( txtPrice.text!)!
                let lots = Double(lotSize)!
                
                let payamount =  qty * rate * lots  * (1 + brokrage)
                
                let brokerageC = qty * rate * lots * (brokrage)
                
                msgTrade = "On Selected Trade you have to pay \(String(format: "\n amount: %.4f", payamount)) \n include brokrage charge \(String(format: " \n amount :%.4f", brokerageC))"
                
                self.alertOnBuySell()
            }
            else
            {
                return
            }
            
            
            
        }
        
    }
    
    @IBAction func btnSell(_ sender: Any) {
        
        if(Int(lotSize)! > 1)
        {
            brokrage = 0.006
        }
        else
        {
            brokrage = 0.0006
        }
        
        orderType = 2
        
        if(txtPrice.text!.isEmpty || txtPrice.text == "" || txtQuantity.text!.isEmpty || txtQuantity.text == "")
        {
            let alert = UIAlertController(title: "PCEX", message: "Quantity and price should not be blank.", preferredStyle: UIAlertController.Style.alert)
            
            // add an action (button)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            
            // show the alert
            self.present(alert, animated: true, completion: nil)
            return
        }
        else
        {
            
            if(Double(txtQuantity.text!)!>0 && Double(txtPrice.text!)! > 0)
            {
                
                
                let payamount = Double(txtQuantity.text!)! * Double( txtPrice.text!)! * Double(lotSize)! * (1 - brokrage)
                
                let brokerageC = Double(txtQuantity.text!)! * Double( txtPrice.text!)! * Double(lotSize)! * (brokrage)
                msgTrade = "You will get \(String(format: "\n amount: %.4f", payamount)) \n after brokrage charge deduction \(String(format: " \n amount :%.4f", brokerageC))"
                
                self.alertOnBuySell()
            }
            else
            {
                let alert = UIAlertController(title: "PCEX", message: "Order value or price should be more then 0.", preferredStyle: UIAlertController.Style.alert)
                
                // add an action (button)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                
                // show the alert
                self.present(alert, animated: true, completion: nil)
                return
            }
        }
    }
    
    
    @IBAction func btnMarketTradeTypeSelect(_ sender: UISegmentedControl) {
        
        switch sender.selectedSegmentIndex
        {
        case 0:
            category = 2
        case 1:
            category = 1
        default:
            break
        }
        
    }
    
    
    func alertOnBuySell()
    {
        let alert = UIAlertController(title: "PCEX", message: msgTrade, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { action in
            
            self.placeOrderOfTrade()
            
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .destructive, handler: { action in
            print("Click of cancel button")
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    /*
     
     Mark : delegate methods for child classes
     */
    
    func showAnimate()
    {
        self.is_TradeViewVisible = true
        
        self.view.bringSubviewToFront(self.customTradeView)
        
        self.customTradeView.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        self.customTradeView.alpha = 0.0
        self.customTradeView.isHidden = false
        
        UIView.animate(withDuration: 0.6, animations: {
            
            self.customTradeView.alpha = 1.0
            self.customTradeView.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        })
    }
    
    func removeAnimate()
    {
        self.is_TradeViewVisible = false
        
        self.tradeViewheightConstraint.constant = 0
        UIView.animate(withDuration: 0.6, animations: {
            self.customTradeView.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
            self.customTradeView.alpha = 0.0
            self.lotSizeheightConstraint.constant = 0
            self.tradeViewheightConstraint.constant = 0
        }, completion: {(finished : Bool) in
            if(finished)
            {
                self.customTradeView.isHidden = true
                self.view.sendSubviewToBack(self.customTradeView)
            }
        })
    }
    
    
    func myVCDidFinish(_ scrip: CurrencyModel) {
        
//       //
//
//        let vc = DetailPlaceOrderVC(nibName: "DetailPlaceOrderVC", bundle: nil)
//        vc.isFromMarket = true
//        vc.script = scrip
//        self.navigationController?.pushViewController(vc, animated: true)
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let destViewController : DetailPlaceOrderVC = storyboard.instantiateViewController(withIdentifier: "placeOrderView") as! DetailPlaceOrderVC
        destViewController.isFromMarket = true
        destViewController.script = scrip
        self.navigationController!.pushViewController(destViewController, animated: true)
    }
    
    
    
    /*
     
     Mark : place order api for buy sell
     */
    
    
    // MArk :- place order api
    
    func placeOrderOfTrade()
    {
        
        let qty = Float(txtQuantity.text!)!
        let price = Float(txtPrice.text!)!
        
        
        Api.request(endpoint: .getPlaceOrder(category: category, clientUserId: "", orderQty: qty, orderRate: price, orderType: orderType, symbolId: symbolId, symbolName: symbolName, market: market)) { (JSON) in
            print("order response for trade",JSON)
            
            let msg = JSON["message"].stringValue
            
//            let alert = UIAlertController(title: "PCEX", message: msg , preferredStyle: UIAlertController.Style.alert)
            
//
//            if(JSON["status"] == 200)
//            {
//                let banner = StatusBarNotificationBanner(title: msg, style: .success)
//                banner.dismiss()
//                banner.show()
//
//                self.removeAnimate()
//            }
//            else
//            {
//                let banner = StatusBarNotificationBanner(title: msg, style: .warning)
//                banner.dismiss()
//                banner.show()
//            }
            
            // add an action (button)
            // alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            
            // show the alert
//            self.present(alert, animated: true, completion: nil)
//            let when = DispatchTime.now() + 5
//            DispatchQueue.main.asyncAfter(deadline: when){
//                // your code with delay
//                alert.dismiss(animated: true, completion: nil)
//            }
            
        }
    }
    
}



// MARK: - PageMenuViewDelegate

extension MarketWatchVC: PageMenuViewDelegate {
    
    func willMoveToPage(_ pageMenu: PageMenuView, from viewController: UIViewController, index currentViewControllerIndex: Int) {
        
        print(viewController.title!)
        if(viewController.title! == "⭐")
        {
             print("*******Moveing******")
        }
        removeAnimate()
    }
    
    func didMoveToPage(_ pageMenu: PageMenuView, to viewController: UIViewController, index currentViewControllerIndex: Int) {
        print(viewController.title!)
        if(viewController.title! == "⭐")
        {
            print("*******Moved******")
            
            let vc = viewController as! FavMarketVC
            vc.reloadTableCustom()
        }
        print("---")
    }
}

// MARK: - Model

extension MarketWatchVC {
    
    func getPageMenuOption() -> PageMenuOption {
        var option = PageMenuOption(frame: CGRect(
            x: 0, y: GlobalVariables.NavHeight, width: view.frame.size.width, height: view.frame.size.height - GlobalVariables.NavHeight))
        option.menuItemWidth = view.frame.size.width / 5.5
        option.menuItemBackgroundColorNormal = .clear //UIColor(red:0.388, green:0.424, blue:0.467, alpha:1)
        option.menuItemBackgroundColorSelected = UIColor(patternImage: UIImage(named: "purchase blue button.jpg")!)//UIColor(red:0.227, green:0.678, blue:0.851, alpha:1)
        option.menuTitleMargin = 12
        option.menuTitleColorNormal = (UIColor(hexString: VioletPCEX_CUSTOM))
        option.menuTitleColorSelected = .black
        option.menuIndicatorHeight = 3
        option.menuIndicatorColor = (UIColor(hexString: VioletPCEX_CUSTOM))
        return option
    }
}

