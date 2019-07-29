//
//  WalletVC_New.swift
//  PCEX2
//
//  Created by CHHAGAN SINGH on 6/4/19.
//  Copyright © 2019 Panaesha Capital pvt. ltd. All rights reserved.
//

import UIKit
import Foundation
import SwiftyJSON
import SDWebImage
import Starscream
import NotificationBannerSwift
import Alamofire
import SwiftyGif

class WalletVC_New: UIViewController,UITableViewDataSource, UITableViewDelegate {

     @IBOutlet weak var tableview: UITableView!
     @IBOutlet weak var viewHeader: UIView!
    @IBOutlet weak var btnMarketMain: UIButton!
    @IBOutlet weak var btnIntraDay: UIButton!
    
    @IBOutlet weak var btnHistory: UIButton!
    var swiftBlogs = [AnyObject]()
    
    var walletsShow = [Int]()
    
    var is_main:Bool = true
    
    var crypto = [String: String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableview.delegate = self
        tableview.dataSource = self
        
        swiftBlogs = GlobalVariables.myWalletList
        self.navigationController?.navigationBar.isHidden = true
        // Do any additional setup after loading the view.
        
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
        
        btnHistory.imageView?.contentMode = .scaleAspectFit
        
        
        tableview.register(LogsCell.self, forCellReuseIdentifier: "walletCell_New")
        tableview.register(UINib(nibName: "walletCell_New", bundle: nil), forCellReuseIdentifier: "walletCell_New")
        
        
        crypto = ["USD":"USD","BTC":"Bitcoin","DASH":"DASH Coin","BCH":"Bitcoin Cash","XMR":"Monero","ETH":"Ethereum","LTC":"Litecoin","FCC":"Feelium"]
        
        
        tableview.tableFooterView = UIView()
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
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "walletCell_New", for: indexPath) as! walletCell_New
        
        //cell.configureCellForIndexPath()
        
        let row = indexPath.row
        
        let dict = swiftBlogs[row ]
          print("dict*******",dict)
        
        let intraday = dict["intraday"] as! [String:AnyObject]
        let delivery = dict["delivery"] as! [String:AnyObject]
        
        cell.lblCurrencyName.text = (dict["currency"] as! String)
        
        let coin = (dict["currency"] as! String)
        
        if(is_main)
        {
            if(coin == "USD")
            {
                cell.viewUSD.isHidden = false
                cell.lblCurrent.text =  String(format:"%.4f", Double(delivery["mainBalance"] as! String)!)
                cell.lblHold.text = String(format:"%.4f", Double(delivery["holdBalance"] as! String)!)
                cell.lblNetValue.text = String(format:"%.4f", Double(delivery["totalBalance"] as! String)!)
            }
            else
            {
                cell.viewUSD.isHidden = true
                
                let symbol = crypto[coin]
                
                cell.lblNetBuy.text =  symbol
                cell.lblNetSell.text =  String(format:"%.4f", Double(delivery["mainBalance"] as! String)!)
            }
        }
        else
        {
            if(coin == "USD")
            {
                cell.viewUSD.isHidden = false
                cell.lblCurrent.text = String(format:"%.4f", Double(intraday["mainBalance"] as! String)!)
                cell.lblHold.text = String(format:"%.4f", Double(intraday["holdBalance"] as! String)!)
                cell.lblNetValue.text = String(format:"%.4f", Double(intraday["totalBalance"] as! String)!)
            }
            else
            {
                cell.viewUSD.isHidden = true
                cell.lblNetBuy.text =  "Net buy: \(String(format:"%.4f", Double(intraday["buyTotalPosition"] as! String)!))"
                cell.lblNetSell.text =  "Net sell: \(String(format:"%.4f", Double(intraday["sellTotalPosition"] as! String)!))"
            }
        }

        
        
        cell.btnDeposit.tag = indexPath.row
        cell.btnDeposit.addTarget(self, action: #selector(depositCurrency(sender:)), for: .touchUpInside)
        
        cell.btnWithdrawal.tag = indexPath.row
        cell.btnWithdrawal.addTarget(self, action: #selector(withdrawalCurrency(sender:)), for: .touchUpInside)
        
        let imgPath = (dict["path"] as! String)
        
        cell.imgLogo.sd_setImage(with: URL(string: imgPath), placeholderImage: UIImage(named: "placeholder.png"))
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 68.0;
    }
    
    // MARK:  Custom buttons actions
    
    @IBAction func btnIntradayorMain(_ sender: UIButton) {
        
        if(sender.tag == 1)
        {
            is_main = true
            btnMarketMain.isSelected = true
            btnIntraDay.isSelected = false
        }
        else
        {
            is_main = false
            btnMarketMain.isSelected = false
            btnIntraDay.isSelected = true
        }
        
        tableview.reloadData()
        
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
    
    @IBAction func btnHistory(_ sender: Any) {
        
        Api.request(endpoint: .getTransactionHistory(pageNumber: 1, type: 2, currency: "All", status: -1)) { (JSON) in
            
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


