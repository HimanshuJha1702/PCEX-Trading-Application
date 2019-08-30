//
//  DetailPlaceOrderVC.swift
//  PCEX2
//
//  Created by CHHAGAN SINGH on 4/25/19.
//  Copyright © 2019 Panaesha Capital pvt. ltd. All rights reserved.
//

import UIKit
import Foundation
import SwiftyJSON
import Starscream
import NotificationBannerSwift
import Alamofire
import SwiftyGif

class DetailPlaceOrderVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate  {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var heightGraph: NSLayoutConstraint!
    
    @IBOutlet weak var lblCurrentLtp: UILabel!
    @IBOutlet weak var lblVolume: UILabel!
    @IBOutlet weak var imgStatus: UIImageView!
    @IBOutlet weak var lbl24CloseHigh: UILabel!
    @IBOutlet weak var lbl24Volume: UILabel!
    
    @IBOutlet weak var lblAsk: UILabel!
    @IBOutlet weak var lblBid: UILabel!
    @IBOutlet weak var lblOpen: UILabel!
    @IBOutlet weak var lblClose: UILabel!
    
    @IBOutlet weak var imgCH_Status: UIImageView!
    @IBOutlet weak var imgVol_Status: UIImageView!
    @IBOutlet weak var btnView: UIButton!
    @IBOutlet weak var sellView: UIButton!
    
    @IBOutlet var lblBuyQtyCollection: [UILabel]!
    @IBOutlet var lblBuyPriceCollection: [UILabel]!
    @IBOutlet var lblSellQtyCollection: [UILabel]!
    @IBOutlet  var lblSellPriceCollection: [UILabel]!
    
    @IBOutlet weak var lblMtm: UILabel!
    @IBOutlet weak var lblQty: UILabel!
    
    @IBOutlet weak var txtBuyQty: UITextField!
    
    @IBOutlet weak var lblBuySellSymbol: UILabel!
    @IBOutlet weak var lblTradeSymbol: UILabel!
    
    @IBOutlet weak var lblMarketTradeSymbol: UILabel!
    @IBOutlet weak var txtMarketCost: UITextField!
    @IBOutlet weak var lblmarket: UILabel!
    
    @IBOutlet weak var lblTotalAmount: UILabel!
    
    @IBOutlet weak var lblMtmValue: UILabel!
    @IBOutlet weak var lblMtmQty: UILabel!
    
    @IBOutlet weak var btnDelivery: UIButton!
    
    @IBOutlet weak var imgBuyModify: UIImageView!
    @IBOutlet weak var imgSellMofiy: UIImageView!
    
    @IBOutlet weak var btnIntraDay: UIButton!
    
    @IBOutlet weak var btnChart: UIButton!
    
    
    @IBOutlet weak var lblTotalUSDDisplay: UILabel!

    @IBOutlet var lblUsdToggle: [UILabel]!
    
    @IBOutlet weak var usdViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var viewUsd: UIView!
    
    @IBOutlet weak var adjustVatTaxView: NSLayoutConstraint!
    
    
    var script:CurrencyModel? = nil

    var isFromMarket:Bool! = false
    
    @IBOutlet weak var btnBack: UIButton!
    
    var placeOrder = [String:AnyObject]()
    
    var msgTrade: String!
    var brokrage: Double!
    var lotSize: String!
    var category: Int!
    var symbolId:Int!
    var symbolName: String!
    var market: String!
    var orderType: Int!
    
    @IBOutlet weak var dropDownTable: UITableView!
    var currenciesListObj = [Int:CurrencyModel]()
    var comparisonNumber: Double?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.dropDownTable.delegate = self
        self.dropDownTable.dataSource = self
        self.txtBuyQty.delegate = self
        self.txtMarketCost.delegate = self
        
        
        dropDownTable.register(CurrencyNameCell.self, forCellReuseIdentifier: "CurrencyNameCell")
        dropDownTable.register(UINib(nibName: "CurrencyNameCell", bundle: nil), forCellReuseIdentifier: "CurrencyNameCell")
        
        Service.shared.subscribe(self)
        
        // Do any additional setup after loading the view.
        
        if(script != nil)
        {
            adjustUIWithDetails()
        }
        else
        {
            script = currenciesListObj[1]
            adjustUIWithDetails()
        }
        
        if(isFromMarket)
        {
            btnBack.isHidden = false
        }
        else
        {
            btnBack.isHidden = true
        }
        

    
    }
    
    @objc func dismissTableView() {
       self.dropDownTable.isHidden = true
    }
    
    func adjustUIWithDetails(){
        
        // print("parameters get from json",script)
        
        let buyQtyArray = script!.buyQty as! Array<String>
        let buyRateArray = script!.buyRate as! Array<String>
        let sellRateArray = script!.sellRate as! Array<String>
        let sellQtyArray = script!.sellQty as! Array<String>
        lblTitle.text = script!.displayName
        lblCurrentLtp.text = "LTP: \(String(describing: script!.ltp!))"
        lblVolume.text = "VOL: \(String(describing: script!.volume!))"
        
        for (lbl, name) in zip(lblBuyQtyCollection, buyQtyArray) {
            lbl.text = "\(String(describing: name))"
        }
        
        for (lbl, name) in zip(lblBuyPriceCollection, buyRateArray) {
            lbl.text = "\(String(describing: name))"
        }
        
        for (lbl, name) in zip(lblSellQtyCollection, sellQtyArray) {
            lbl.text = "\(String(describing: name))"
        }
        
        for (lbl, name) in zip(lblSellPriceCollection, sellRateArray) {
            lbl.text = "\(String(describing: name))"
        }
        
        heightGraph.constant = 240
        btnChart.isSelected = true
        
        lblClose.text = "Close: \(String(describing: script!.todayLow!))"
        lbl24CloseHigh.text = "24 Ch \(String(describing: script!.todayHigh!))"
        
        lblBuySellSymbol.text = script!.symbolName
        lblmarket.text = script!.market
        
        lblTradeSymbol.text = "\(script!.symbolName!) to Purchase"
        lblMarketTradeSymbol.text = "\(script!.market!) to Spend"
        
        if(script!.market! == "USD")
        {
            for lbl in lblUsdToggle
            {
                lbl.isHidden = false
            }
            
            usdViewHeightConstraint.constant = 35
            viewUsd.isHidden = false
            adjustVatTaxView.constant = 68
        }
        else
        {
            for lbl in lblUsdToggle
            {
                lbl.isHidden = true
            }
            
            usdViewHeightConstraint.constant = 0
            viewUsd.isHidden = true
            
             adjustVatTaxView.constant = 28
        }
        
        txtMarketCost.text = String(describing: script!.ltp!)
        
//        
//        let changeToday = script!.todayChange as! String
//        let change = Double(changeToday)
        
//        if let anumber = change{
//            if  0 > anumber {
//                //print("loss found",anumber)
//                imgStatus.isHighlighted = true
//            }else if  0 < anumber {
//                // print("profit found",anumber)
//                imgStatus.isHighlighted = false
//            }else{
//                imgStatus.isHighlighted = false
//            }
//        }else {
//            imgStatus.isHighlighted = true
//        }
        
        
        
        if((script!.lotSize == nil))
        {
            lotSize = "1"
        }
        else
        {
            lotSize = script!.lotSize
        }
        
        if(Int(lotSize)! > 1)
        {
            brokrage = 0.006
        }
        else
        {
            brokrage = 0.0006
        }
        
        market = script!.market
        symbolName = script!.symbolName
        symbolId = script!.symbolId
        
        category = 2
        orderType = 1
        
        
        self.navigationController?.navigationBar.isHidden = true
    }
    
    // MARK: - Table View Datasource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return currenciesListObj.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
//        let scripCell = tableView.dequeueReusableCell(withIdentifier: "CurrencyNameCell", for: indexPath) as? CurrencyNameCell
        
         let scripCell = tableView.dequeueReusableCell(withIdentifier: "CurrencyNameCell", for: indexPath) as! CurrencyNameCell
        
        let scrip = Array(currenciesListObj.values).sorted{$0.symbolId<$1.symbolId}[indexPath.row]
        scripCell.configure(with: scrip, numberToCompare: comparisonNumber, colorTheme:nil)
        
        return scripCell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    
    
    // MARK:  UITableViewDelegate Methods
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
       
        script = Array(currenciesListObj.values).sorted{$0.symbolId<$1.symbolId}[indexPath.row]
        self.adjustUIWithDetails()
        
        dropDownTable.isHidden = true
    }
    
    
    @IBAction func btnShowCurriencies(_ sender: Any) {
        
        if(dropDownTable.isHidden)
        {
            dropDownTable.isHidden = false
        }
        
    }
    
    // MARK:  uitextfield delegates Methods
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        var updatedTextString : NSString = textField.text! as NSString
        updatedTextString = updatedTextString.replacingCharacters(in: range, with: string) as NSString
        
        var QuantityUpdated = ""
        var priceUpdted = ""
        
        if(textField == txtBuyQty)
        {
            QuantityUpdated = updatedTextString.trimmingCharacters(in: .whitespacesAndNewlines) as String
            
            if(QuantityUpdated.count == 0)
            {
                txtMarketCost.text = String(describing: script!.ltp!)
                self.lblTotalAmount.text = "0.0000"
                
                if(script!.market! == "USD")
                {
                    self.lblTotalUSDDisplay.text = "0.0000"
                }
            }
            else
            {
                priceUpdted = txtMarketCost.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            }
        }
        else
        {
            priceUpdted = updatedTextString.trimmingCharacters(in: .whitespacesAndNewlines) as String
        }
        
        
        if(QuantityUpdated.count > 0 && priceUpdted.count > 0)
        {
            let price = Double(priceUpdted)
            let qty = Double(QuantityUpdated)
            let total = price! * qty!
            let lots = Double(lotSize)!
            
            let brokerageC = total * lots * (brokrage!)
            
            self.lblTotalAmount.text = String(format:"%.4f", brokerageC)
            
            if(script!.market! == "USD")
            {
                self.lblTotalUSDDisplay.text = String(format:"%.4f", total)
            }

        }


        return true
    }
    

    
    
    @IBAction func btnChart(_ sender: Any) {
        
        if(btnChart.isSelected)
        {
            heightGraph.constant = 0
            btnChart.isSelected = false
        }
        else
        {
            heightGraph.constant = 240
            btnChart.isSelected = true
        }
    }
    
    private func transactionHistory(){
    let storyboard = UIStoryboard(name: "Main", bundle: nil)
    let destViewController : Orders_TradesVC = storyboard.instantiateViewController(withIdentifier: "pushToOT") as! Orders_TradesVC
    destViewController.checkIsPipe = true
    self.navigationController!.pushViewController(destViewController, animated: true)
    }
    
    @IBAction func btnAlertAction(_ sender: Any) {
        self.transactionHistory()
    }
    
    @IBAction func btnBackAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnBuyAction(_ sender: UIButton) {
        
        heightGraph.constant = 0
        btnChart.isSelected = false
        
        imgBuyModify.isHidden = false
        imgSellMofiy.isHidden = true
        
        let bottomOffset = CGPoint(x: 0, y: scrollView.contentSize.height - scrollView.bounds.size.height-240)
        scrollView.setContentOffset(bottomOffset, animated: true)
        
        btnView.sendSubviewToBack(imgSellMofiy)
        sellView.bringSubviewToFront(imgBuyModify)
        
        
        lblTradeSymbol.text = "\(script!.symbolName!) to Purchase"
        lblMarketTradeSymbol.text = "\(script!.market!) to Spend"
    
        orderType = 1
    }
    
    @IBAction func btnSellAction(_ sender: UIButton) {
        
        heightGraph.constant = 0
        btnChart.isSelected = false
        
        imgBuyModify.isHidden = true
        imgSellMofiy.isHidden = false
        
        let bottomOffset = CGPoint(x: 0, y: scrollView.contentSize.height - scrollView.bounds.size.height-240)
        scrollView.setContentOffset(bottomOffset, animated: true)
        
        sellView.sendSubviewToBack(imgSellMofiy)
        btnView.bringSubviewToFront(imgBuyModify)
        
        
        lblTradeSymbol.text = "\(script!.symbolName!) to Sell"
        lblMarketTradeSymbol.text = "\(script!.market!) You Get"
        
        orderType = 2
    }
    
    @IBAction func btnDelivery(_ sender: Any) {
        btnDelivery.isSelected = true
        btnIntraDay.isSelected = false
        
        category = 1
    }
    
    @IBAction func btnIntraDay(_ sender: Any) {
        btnDelivery.isSelected = false
        btnIntraDay.isSelected = true
        
        category = 2
    }
    
    
    @IBAction func btnConfirm(_ sender: Any) {
        
        if(orderType == 1)
        {
            self.confirmForBuyTrade()
        }
        else
        {
            self.confirmForSellTrade()
        }
    }
    
    @IBAction func btnCancel(_ sender: Any) {
        
        self.navigationController?.popViewController(animated: true)
    }
    
    
    func confirmForBuyTrade()
    {

        
        if(txtMarketCost.text!.isEmpty || txtMarketCost.text == "" || txtBuyQty.text!.isEmpty || txtBuyQty.text == "")
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
            
            if(Double(txtBuyQty.text!)!>0 && Double(txtMarketCost.text!)! >  0)
            {
                let qty = Double(txtBuyQty.text!)!
                let rate = Double( txtMarketCost.text!)!
                let lots = Double(lotSize)!
                
                let payamount =  qty * rate * lots  * (1 + brokrage)
               // let payamount =  rate * lots  * (1 + brokrage)
                
                let brokerageC = qty * rate * lots  * (brokrage)
                
                msgTrade = " include brokrage charge \(String(format: " \n amount :%.4f", brokerageC)) \n On Selected Trade you have to pay \(String(format: "\n amount: %.4f", payamount))"
                
                self.alertOnBuySell()
            }
            else
            {
                return
            }
            
            
            
        }
    }
    
    func confirmForSellTrade()
    {
        
        if(txtMarketCost.text!.isEmpty || txtMarketCost.text == "" || txtBuyQty.text!.isEmpty || txtBuyQty.text == "")
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
            
            if(Double(txtBuyQty.text!)!>0 && Double(txtMarketCost.text!)! > 0)
            {
  
                let payamount = Double(txtBuyQty.text!)! * Double( txtMarketCost.text!)! * Double(lotSize)! * (1 - brokrage)

                let brokerageC = Double(txtBuyQty.text!)! * Double( txtMarketCost.text!)! * Double(lotSize)! * (brokrage)
                
                msgTrade = "You will get \(String(format: "\n amount: %.4f", payamount)) \n after  brokrage + tax deduction \(String(format: " \n amount :%.4f", brokerageC))"
                
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
    
    
    // MArk :- place order api
    
    func placeOrderOfTrade()
    {
        
        let qty = Float(txtBuyQty.text!)!
        let price = Float(txtMarketCost.text!)!
        
        
        Api.request(endpoint: .getPlaceOrder(category: category, clientUserId: "", orderQty: qty, orderRate: price, orderType: orderType, symbolId: symbolId, symbolName: symbolName, market: market)) { (JSON) in
            print("order response for trade",JSON)
            
            let msg = JSON["message"].stringValue
            
            let alert = UIAlertController(title: "PCEX", message: msg , preferredStyle: UIAlertController.Style.alert)
            
            
            if(JSON["status"] == 200)
            {
                let banner = StatusBarNotificationBanner(title: msg, style: .success)
                banner.dismiss()
                banner.show()
                self.transactionHistory()
                
            }
            else
            {
                let banner = StatusBarNotificationBanner(title: msg, style: .warning)
                banner.dismiss()
                banner.show()
            }
            
            // add an action (button)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            
            // show the alert
            self.present(alert, animated: true, completion: nil)
            let when = DispatchTime.now() + 5
            DispatchQueue.main.asyncAfter(deadline: when){
                // your code with delay
                alert.dismiss(animated: true, completion: nil)
            }
            
        }
    }
    
}

extension DetailPlaceOrderVC : PcexServiceListenerProtocol {
    
    func receivedUpdatesForUSD(_ scrip: CurrencyModel) {}
    func receivedUpdatesForBTC(_ scrip: CurrencyModel) {}
    func receivedUpdatesForFCC(_ scrip: CurrencyModel) {}
    func receivedUpdatesForETH(_ scrip: CurrencyModel) {}
    
    func receivedUpdates(_ scrip: CurrencyModel) {
        if (currenciesListObj[scrip.symbolId] != nil){
            let arrayOfTicks = Array(currenciesListObj.values).sorted{$0.symbolId<$1.symbolId}
            var index = 0
            for i in arrayOfTicks {
                if i.symbolId == scrip.symbolId {
                    break
                }
                index = index + 1
            }
            currenciesListObj[scrip.symbolId] = scrip
 //           let indexPath = IndexPath(row: index, section: 0)
//            if tradeListerTableViewOutlet.indexPathsForVisibleRows?.contains(indexPath) ?? false {
//                self.tradeListerTableViewOutlet.reloadRows(at: [indexPath], with: .fade)
//            }
        }else{
            
            currenciesListObj[scrip.symbolId] = scrip
            //do something if it's an instance of that class
            self.dropDownTable.reloadData()
        }
    }
    var objectID: Int! {
        return self.hashValue
    }
    
}
