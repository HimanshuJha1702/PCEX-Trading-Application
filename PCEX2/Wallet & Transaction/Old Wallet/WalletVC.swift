//
//  WalletVC.swift
//  PCEX
//
//  Created by CHHAGAN on 3/12/19.
//  Copyright © 2019 Chhagan SIngh. All rights reserved.
//

import UIKit
import Foundation
import SwiftyJSON
import SDWebImage
import Starscream
import NotificationBannerSwift
import Alamofire
import SwiftyGif

class WalletVC: UIViewController,UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableview: UITableView!
    
    @IBOutlet weak var viewHeader: UIView!
    @IBOutlet weak var headerHeightConstraint: NSLayoutConstraint!
    var swiftBlogs = [AnyObject]()
    
    var walletsShow = [Int]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableview.delegate = self
        tableview.dataSource = self
        
            swiftBlogs = GlobalVariables.myWalletList
        self.navigationController?.navigationBar.isHidden = true
            //print("wallet list",swiftBlogs)
        self.headerHeightConstraint.constant = GlobalVariables.NavHeight
        
        
        if #available(iOS 11.0, *) {
            self.viewHeader.layer.cornerRadius = 20
            self.viewHeader.clipsToBounds = true
        }
        else
        {
            self.viewHeader.roundedAllCorner()
        }
        
        self.viewHeader.layer.shadowColor = UIColor.black.cgColor
        self.viewHeader.layer.shadowOffset = CGSize(width: 5, height: 10)
        self.viewHeader.layer.shadowOpacity = 0.2
        self.viewHeader.layer.shadowRadius = 1
        self.viewHeader.layer.masksToBounds = false
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        
        if(swiftBlogs.count == 0 && GlobalVariables.myWalletList.count > 0)
        {
            swiftBlogs = GlobalVariables.myWalletList
            tableview.reloadData()
        }
    }
    
    
    // MARK:  UITextFieldDelegate Methods
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return swiftBlogs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "WalletCell", for: indexPath) as! WalletCell
        
        //cell.configureCellForIndexPath()
        
        let row = indexPath.row
        
        let dict = swiftBlogs[row ]
       //  print("dict*******",dict)
        
        let intraday = dict["intraday"] as! [String:AnyObject]
        let delivery = dict["delivery"] as! [String:AnyObject]
        cell.lblCurrencyName.text = (dict["currency"] as! String)
        
        cell.lblCurrent.text =  String(format:"%.4f", Double(delivery["mainBalance"] as! String)!)
        cell.lblHold.text = String(format:"%.4f", Double(delivery["holdBalance"] as! String)!)
        cell.lblNetValue.text = String(format:"%.4f", Double(delivery["totalBalance"] as! String)!)
        
         let coin = (dict["currency"] as! String)
        
        if(coin == "USD")
        {
            cell.lblExposere.text = String(format:"%.4f", Double(intraday["mainBalance"] as! String)!)
            cell.lblExpoHold.text = String(format:"%.4f", Double(intraday["holdBalance"] as! String)!)
            cell.lblNetExpo.text = String(format:"%.4f", Double(intraday["totalBalance"] as! String)!)
        }
        else
        {
            cell.lblBuy.text = String(format:"%.4f", Double(intraday["buyOpenPosition"] as! String)!)
            cell.lblBuyHold.text = String(format:"%.4f", Double(intraday["buyHoldPosition"] as! String)!)
            cell.lblNetBuy.text = String(format:"%.4f", Double(intraday["buyTotalPosition"] as! String)!)
            
            cell.lblSell.text = String(format:"%.4f", Double(intraday["sellOpenPosition"] as! String)!)
            cell.lblSellHold.text = String(format:"%.4f", Double(intraday["sellHoldPosition"] as! String)!)
            cell.lblNetSell.text = String(format:"%.4f", Double(intraday["sellTotalPosition"] as! String)!)
        }
        
        cell.viewMainBalance.isHidden = false
        cell.viewCrypto.isHidden = true
        
        if(walletsShow.contains(indexPath.row))
        {
            if(coin == "USD")
            {
                cell.viewMainBalance.isHidden = true
                cell.viewCrypto.isHidden = true
            }
            else
            {
                cell.viewCrypto.isHidden = false
                cell.viewMainBalance.isHidden = false
            }
            
            cell.lblNameMainMarkt.textColor = (UIColor(hexString: GREY_COLOR))
            cell.lblNameIntradMarket.textColor = (UIColor(hexString: VioletPCEX_CUSTOM))
        }
        else
        {
            cell.lblNameMainMarkt.textColor = (UIColor(hexString: VioletPCEX_CUSTOM))
            cell.lblNameIntradMarket.textColor = (UIColor(hexString: GREY_COLOR))
        }
        
        
        
        
        cell.btnShowIntraDay.tag = indexPath.row
        cell.btnShowIntraDay.addTarget(self, action: #selector(showIntraDay(sender:)), for: .touchUpInside)
        
        cell.btnShowMainMarket.tag = indexPath.row
        cell.btnShowMainMarket.addTarget(self, action: #selector(showIntraDay(sender:)), for: .touchUpInside)
        
        
        cell.btnDeposit.tag = indexPath.row
        cell.btnDeposit.addTarget(self, action: #selector(depositCurrency(sender:)), for: .touchUpInside)
        
        cell.btnWithdrawal.tag = indexPath.row
        cell.btnWithdrawal.addTarget(self, action: #selector(withdrawalCurrency(sender:)), for: .touchUpInside)
        
        cell.btnHistory.tag = indexPath.row
        cell.btnHistory.addTarget(self, action: #selector(historyCurrency(sender:)), for: .touchUpInside)
        
        let imgPath = (dict["path"] as! String)
        
        cell.imgLogo.sd_setImage(with: URL(string: imgPath), placeholderImage: UIImage(named: "placeholder.png"))
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        let row = indexPath.row
        
        let dict = swiftBlogs[row ]
         let coin = (dict["currency"] as! String)
        if(coin == "USD")
        {
            return 158.0;
        }
        else
        {
            if(walletsShow.contains(indexPath.row))
            {
                return 200.0;
            }
            
             return 158.0;
        }
        
    }
    
    
    
    
    @IBAction func btnTransactionAction(_ sender: Any) {
        
        Api.request(endpoint: .getTransactionHistory(pageNumber: 1, type: 2, currency: "all", status: -1)) { (JSON) in
            
            if (JSON["status"] == 200)
            {
                let userNetData = JSON["data"].array
                
                if((userNetData) != nil && userNetData!.count>0)
                {
                    let destViewController : DepositWithdrawl = self.storyboard!.instantiateViewController(withIdentifier: "pushToDWH") as! DepositWithdrawl
                    destViewController.swiftBlogs = JSON["data"].array!
                    destViewController.depositArray = JSON["data"].array!
                    self.navigationController!.pushViewController(destViewController, animated: true)
                }
                else
                {
                    let alert = UIAlertController(title: "PCEX", message: "You don't have any transactions yet.", preferredStyle: UIAlertController.Style.alert)
                    
                    // add an action (button)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                    
                    // show the alert
                    self.present(alert, animated: true, completion: nil)
                }
                
                
            }
        }
    }
    
    // MARK:  Custom buttons actions
    
    @objc func showIntraDay(sender: UIButton){
      
        if(walletsShow.contains(sender.tag))
        {
         let index =  walletsShow.index(of: sender.tag)
            walletsShow.remove(at: index!)
        }
        else
        {
            walletsShow.append(sender.tag)
        }
        
        let indexPath = IndexPath(row: sender.tag, section: 0)
        if tableview.indexPathsForVisibleRows?.contains(indexPath) ?? false {
            self.tableview.reloadRows(at: [indexPath], with: .fade)
        }

    }
    // MARK:  Custom buttons actions

    @objc func depositCurrency(sender: UIButton){
        
        let dict = swiftBlogs[sender.tag]
        
        let coin = (dict["currency"] as! String)
        
        if(coin == "USD")
        {
          let usdVC = USD_BaseDepositWithDraw(nibName: "USD_BaseDepositWithDraw", bundle: nil)
            usdVC.isCrypto = false
             usdVC.currenyName = coin
            self.navigationController?.pushViewController(usdVC, animated: true)
        }
        else
        {
            Api.request(endpoint: .getWalletAddress(coin: coin)) { (JSON) in
                
                if (JSON["status"] == 200)
                {
                    let usdVC = USD_BaseDepositWithDraw(nibName: "USD_BaseDepositWithDraw", bundle: nil)
                    usdVC.isCrypto = true
                    usdVC.addressString = JSON["address"].stringValue
                    usdVC.currenyName = coin
                    usdVC.imglogoPath = (dict["path"] as! String)
                    self.navigationController?.pushViewController(usdVC, animated: true)
                }
                
            }
        }
    }
    
    @objc func withdrawalCurrency(sender: UIButton){
        
        let dict = swiftBlogs[sender.tag]
        
        let coin = (dict["currency"] as! String)
        
        if(coin == "USD")
        {
            let usdVC = USD_BaseDepositWithDraw(nibName: "USD_BaseDepositWithDraw", bundle: nil)
            usdVC.isCrypto = false
            usdVC.currenyName = coin
            usdVC.imglogoPath = (dict["path"] as! String)
            self.navigationController?.pushViewController(usdVC, animated: true)
        }
        else
        {
            
            let usdVC = USD_BaseDepositWithDraw(nibName: "USD_BaseDepositWithDraw", bundle: nil)
            usdVC.isCrypto = true
            usdVC.currenyName = coin
            usdVC.imglogoPath = (dict["path"] as! String)
            self.navigationController?.pushViewController(usdVC, animated: true)
        }
        
    }
    
    @objc func historyCurrency(sender: UIButton){
        
        let dict = swiftBlogs[sender.tag]
        
        let coin = (dict["currency"] as! String)
        
        Api.request(endpoint: .getTransactionHistory(pageNumber: 1, type: 2, currency: coin, status: -1)) { (JSON) in
            
            if (JSON["status"] == 200)
            {
                let userNetData = JSON["data"].array
                
                if((userNetData) != nil && userNetData!.count>0)
                {
                    let depositHistory : DepositWithDrawHistory = DepositWithDrawHistory(nibName: "DepositWithDrawHistory", bundle: nil)
                    depositHistory.swiftBlogs = JSON["data"].array!
                    depositHistory.depositArray = JSON["data"].array!
                    self.navigationController!.pushViewController(depositHistory, animated: true)
                }
                else
                {
                    let alert = UIAlertController(title: "PCEX", message: "You don't have any transactions yet.", preferredStyle: UIAlertController.Style.alert)
                    
                    // add an action (button)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                    
                    // show the alert
                    self.present(alert, animated: true, completion: nil)
                }
                
                
            }
        }
    }
}
