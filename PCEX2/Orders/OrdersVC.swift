//
//  OrdersVC.swift
//  PCEX
//
//  Created by CHHAGAN on 3/19/19.
//  Copyright © 2019 Chhagan SIngh. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import SwiftyJSON
import NotificationBannerSwift
import KRProgressHUD


class OrdersVC: UIViewController, UITableViewDataSource, UITableViewDelegate,ordersUpdateDelegate {
   
    static let userId = APP_Defaults.value(forKey: "userId") as! Int
    static let sessionId = APP_Defaults.value(forKey: "sessionId") as! String
    static let fastSessionId = APP_Defaults.value(forKey: "fastSessionId") as! Int
    
    @IBOutlet weak var customTradeView: UIView!
    @IBOutlet weak var tradeViewheightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var lblNothingTOShow: UILabel!
    @IBOutlet weak var segmentView: UISegmentedControl!
    
    @IBOutlet weak var lblBalance: UILabel!
    
    @IBOutlet weak var txtPrice: UITextField!
    
    @IBOutlet weak var txtQuantity: UITextField!
    
    @IBOutlet weak var txtTotal: UITextField!
    
    @IBOutlet weak var txtLotSize: UITextField!
    
    @IBOutlet weak var lblLotSize: UILabel!
    
    @IBOutlet weak var imgBgOrderModified: UIImageView!

    @IBOutlet weak var btnDelivery: UIButton!
    
    @IBOutlet weak var btnIntraday: UIButton!
    var is_TradeViewVisible:Bool!
    
    var placeOrder = [String:AnyObject]()
    
    var msgTrade: String!
    var brokrage: Double!
    var lotSize: String!
    var category: Int!
    var symbolId:String!
    var symbolName: String!
    var market: String!
    var orderType: Int!
    var orderId:Int!
    
    var strPriceModOf : String!
    
    
    @IBOutlet var tableView: UITableView!
    
    
    let textCellIdentifier = "TextCell"
    
    var swiftBlogs = [JSON]()
    
    //    let swiftBlogs = ["Ray Wenderlich", "NSHipster", "iOS Developer Tips", "Jameson Quave", "Natasha The Robot", "Coding Explorer", "That Thing In Swift", "Andrew Bancroft", "iAchieved.it", "Airspeed Velocity"]
    
//    private var markets = [Markets]()
    
    class func initFromStoryboard() -> OrdersVC {
        let storyboard = UIStoryboard.init(name: "Main", bundle: Bundle.main)
        let animalViewController = storyboard.instantiateViewController(
            withIdentifier: "OrdersVC") as! OrdersVC
        return animalViewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        if(APP_Defaults.bool(forKey: "login"))
        {
            let socket = Service()
            socket.delegate = self
        }
        
        self.customTradeView.clipsToBounds = true
        self.customTradeView.layer.cornerRadius = 15
        if #available(iOS 11.0, *) {
            self.customTradeView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        } else {
            self.customTradeView.roundedLeft()
        }
        
      //  customTradeView.isHidden = true
        imgBgOrderModified.isHidden = true
        
        removeAnimate()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        if(APP_Defaults.bool(forKey: "login"))
        {
            
            if(self.title == "Pending")
            {
                KRProgressHUD.show(withMessage: "Please Wait...")
                
                self.loadOrders(pageNumber: 1)
                
                if(GlobalVariables.orders.count>0 && swiftBlogs.count==0)
                {
                    print("orders",GlobalVariables.orders)
                    
                   // swiftBlogs = GlobalVariables.orders
                    
                     swiftBlogs = GlobalVariables.orders.filter {
                        $0["orderStatus"].intValue == 1
                    }
                    
                    print("orders after filter",swiftBlogs)
                    
                    tableView.reloadData()
                    
                }
                else
                {
                    //                    self.swiftBlogs.removeAll()
                    //                    self.tableView.reloadData()
                }
            }
            else
            {
                // self.loadTrades(pageNumber: 1)
            }
            
            
        }

        
    }
    
    
    
    // MARK:  UITextFieldDelegate Methods
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(swiftBlogs.count==0)
        {
            lblNothingTOShow.isHidden = false
            return 0
        }
        return swiftBlogs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let orderCell = tableView.dequeueReusableCell(withIdentifier: "OrdersCell", for: indexPath) as! OrdersCell
        //        let cell = tableView.dequeueReusableCell(withIdentifier: textCellIdentifier, for: indexPath)
        
        let row = indexPath.row
        
        var dict = swiftBlogs[row]
       // print("dict*******",dict)
        

            if(dict["orderStatus"].intValue == 2)
            {
                orderCell.lblStatus.text = "succeed"
                //  orderCell.hideAndAdjustcell()
            }
            else if(dict["orderStatus"].intValue == 1)
            {
                orderCell.lblStatus.text = "pending"
            }
            else
            {
                orderCell.lblStatus.text = "canceled"
                // orderCell.configureCellForIndexPath()
            }
        
        
        
        orderCell.configureCellForIndexPath()
        
        
       // orderCell.lblOrderNo.text = dict["orderId"].stringValue
        orderCell.lblMarket.text = (dict["symbolName"].stringValue)
        orderCell.lblRate.text = dict["orderRate"].stringValue
        //orderCell.lblTime.text = dict["timeStamp"].stringValue
        orderCell.lblQty.text = dict["orderQty"].stringValue
        orderCell.lblPendingQty.text = dict["pendingQty"].stringValue
        orderCell.lblTime.text = self.convertDateFormatter(date: dict["timeStamp"].stringValue)
        
        let symbol = (dict["symbolName"].stringValue).lowercased()
        
            var imgPath = "https://www.pcex.io/assets/icons/\(symbol).png"
//        if(symbol == "fcc")
//        {
//            imgPath = "https://www.pcex.io/assets/icons/fcc.png"
//        }
//        else
//        {
//           // imgPath = "https://cryptoicons.org/api/icon/\(symbol)/20"
//
//
//            let  symbol2 = (dict["symbolName"].stringValue).uppercased()
//            imgPath = "https://www.coineal.com/res/img/coin/\(symbol2).png"
//        }
        
        orderCell.imgSymbol.sd_setImage(with: URL(string: imgPath), placeholderImage: UIImage(named: "placeholder.png"))
        
        
        if dict["orderType"].intValue == 1 {
            orderCell.lblBuySell.text = "Sell"
            //orderCell.lblBuySell.textColor = .red
            orderCell.lblBuySell.textColor = (UIColor(hexString: "#ed1F24"))
        }
        else
        {
            orderCell.lblBuySell.text = "Buy"
           // orderCell.lblBuySell.textColor = .green
            orderCell.lblBuySell.textColor = (UIColor(hexString: "#129F4b"))
        }

        orderCell.btnCancel.tag = indexPath.row
        orderCell.btnCancel.addTarget(self, action: #selector(cancelOrderRequest(sender:)), for: .touchUpInside)
        
        orderCell.btnModify.tag = indexPath.row
        orderCell.btnModify.addTarget(self, action: #selector(modifiedOrderRequest(sender:)), for: .touchUpInside)
        
        return orderCell
    }
    
    // MARK:  UITableViewDelegate Methods
    //    private func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    //        tableView.deselectRow(at: indexPath as IndexPath, animated: true)
    //
    //
    //
    //        let row = indexPath.row
    //      //  print(swiftBlogs[row])
    //    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

            return 120.0;
    
    }
    
    
    func convertDateFormatter(date: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm:ss dd-MMM-yyyy"//this your string date format
        //dateFormatter.timeZone = NSTimeZone(name: "UTC") as TimeZone!
        dateFormatter.locale = Locale(identifier: "your_loc_id")
        let convertedDate = dateFormatter.date(from: date)
        
        guard dateFormatter.date(from: date) != nil else {
           // assert(false, "no date from string")
            print( "no date from string")
            return ""
        }
        
        dateFormatter.dateFormat = "dd-MM-yyyy HH:mm:ss"///this is what you want to convert format
       // dateFormatter.timeZone = NSTimeZone(name: "UTC") as TimeZone!
        let timeStamp = dateFormatter.string(from: convertedDate!)
        
        return timeStamp
    }
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        var updatedTextString : NSString = textField.text! as NSString
        updatedTextString = updatedTextString.replacingCharacters(in: range, with: string) as NSString
        
        //        let strCheck1 = txtQuantity.text!.removeWhitespace()
        //        let strCheck2 = txtPrice.text!.removeWhitespace()
        
        var QuantityUpdated = ""
        var priceUpdted = ""
        
        if(textField == txtQuantity)
        {
            QuantityUpdated = updatedTextString.trimmingCharacters(in: .whitespacesAndNewlines) as String
            
            if(QuantityUpdated.count == 0)
            {
                txtPrice.text = strPriceModOf
                self.txtTotal.text = "0.0000"
            }
            else
            {
                priceUpdted = txtPrice.text!.trimmingCharacters(in: .whitespacesAndNewlines)
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
            
            self.txtTotal.text = String(format:"%f", brokerageC)
            
            if(textField == txtQuantity)
            {
                txtPrice.text = String(format:"%f", total)
            }
            
        }
        
        
        return true
    }
    
    @IBAction func txtValueChange(_ sender: UITextField) {
        
//        if (sender.text! != "" || !sender.text!.isEmpty) {
//            
//            if(txtPrice.text!.isEmpty || txtPrice.text == "")
//            {
//                return
//            }
//            else if (txtQuantity.text!.isEmpty || txtQuantity.text == "")
//            {
//                return
//            }
//            else
//            {
//                let price = Double(txtPrice.text!)
//                let qty = Double(txtQuantity.text!)
//                
//                let total = price! * qty!
//                self.txtTotal.text = String(format:"%f", total)
//            }
//            
//        }
        
    }
    
    
    
    
    @objc func cancelOrderRequest(sender: UIButton){
          let dict = swiftBlogs[sender.tag]
        
        let symbolId = dict["symbolId"].stringValue
        let orderType = dict["orderType"].intValue
        let orderId = dict["orderId"].intValue
        
        Api.request(endpoint: .getCancelOrder(symbolId: symbolId, orderType: orderType, orderId: orderId)) { (JSON) in
         
            if(JSON["status"]==200)
            {
                
                let msg = JSON["message"].stringValue
                
                let alert = UIAlertController(title: "PCEX", message: msg, preferredStyle: UIAlertController.Style.alert)
                
                // add an action (button)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                
                // show the alert
                self.present(alert, animated: true, completion: nil)
            }
            else
            {
                
            }
            
        }
    }
    
    @objc func modifiedOrderRequest(sender: UIButton){

        
        let dict = swiftBlogs[sender.tag]
        
        
        
         self.symbolId = dict["symbolId"].stringValue
       let orderType = dict["orderType"].intValue
            self.orderId = dict["orderId"].intValue

        self.txtPrice!.text =  dict["orderRate"].stringValue
        self.txtQuantity.text = dict["orderQty"].stringValue
        
        strPriceModOf = dict["orderRate"].stringValue


        self.market = dict["market"].stringValue
        self.symbolName = dict["symbolName"].stringValue


        lotSize = dict["lotSize"].stringValue
    
        
        if(Int(lotSize)! > 1)
        {
            brokrage = 0.006
        }
        else
        {
            brokrage = 0.0006
        }
        
            let qty = Double(txtQuantity.text!)!
            let rate = Double( txtPrice.text!)!
            let lots = Double(lotSize)!
        
        var payamount = 0.00
        
        if(orderType == 1)
        {
          payamount = qty * rate * lots * (1 + brokrage)
        }
        else
        {
           payamount =  qty * rate * lots * (1 - brokrage)
        }
        
         txtTotal.text! =  String(format:"%.4f",payamount)
        
        if(!self.is_TradeViewVisible)
        {
            showAnimate()
        }
        
        
    }
    
    
    
    public func requestNewForSelectio() {
        
        KRProgressHUD.dismiss()
        
        if(self.title == "Pendings")
        {
            self.loadPendingOrders(pageNumber: 1)
            
//            if(GlobalVariables.pendingOrders.count>0 && swiftBlogs.count==0)
//            {
//                swiftBlogs = GlobalVariables.pendingOrders
//                tableView.reloadData()
//            }
        }
        else if (self.title == "Orders")
        {
            self.loadOrders(pageNumber: 1)
            
            if(GlobalVariables.orders.count>0 && swiftBlogs.count==0)
            {
                swiftBlogs = GlobalVariables.orders
                tableView.reloadData()
            }
        }
        else
        {
            //self.loadTrades(pageNumber: 1)
        }
    }
    
    
    func receiveOrdersUpdate(scrip: JSON)
    {
        print("&*&*",scrip)
    }
    
  
    
    
    
    /*
 Modifiy orders all
 */
    
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
        
        if(txtPrice.text!.isEmpty || txtPrice.text == "" || txtQuantity.text!.isEmpty || txtQuantity.text == "" || Int(txtPrice.text!)! == 0 || Int(txtQuantity.text!)! == 0)
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
    
    @IBAction func btnMarketTypeAction(_ sender: UIButton) {
        
        if(sender.tag==1)
        {
            btnDelivery.isSelected = true
            btnIntraday.isSelected = false
            
            category = 2
        }
        else
        {
            btnDelivery.isSelected = false
            btnIntraday.isSelected = true
            
            category = 1
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
        imgBgOrderModified.isHidden = false
        self.tradeViewheightConstraint.constant = 280
        
        
        UIView.animate(withDuration: 0.6, animations: {
            
            self.customTradeView.alpha = 1.0
            self.customTradeView.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        })
    }
    
    func removeAnimate()
    {
        self.is_TradeViewVisible = false
        self.imgBgOrderModified.isHidden = true
        
        self.tradeViewheightConstraint.constant = 0
        UIView.animate(withDuration: 0.6, animations: {
            self.customTradeView.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
            self.customTradeView.alpha = 0.0
        }, completion: {(finished : Bool) in
            if(finished)
            {
                self.customTradeView.isHidden = true
                self.view.sendSubviewToBack(self.customTradeView)
            }
        })
    }
    
    // MArk :- place order api
    
    func placeOrderOfTrade()
    {
        
        let qty = Float(txtQuantity.text!)!
        let price = Float(txtPrice.text!)!
        
        Api.request(endpoint: .getModifyOrder(symbolId: self.symbolId, orderId: self.orderId, newOrderQty: Double(qty), newOrderRate: Double(price)), completionHandler: { (JSON) in
            print("order response for trade",JSON)
            
            let msg = JSON["message"].stringValue
            
            let alert = UIAlertController(title: "PCEX", message: msg , preferredStyle: UIAlertController.Style.alert)
            
            
            if(JSON["status"] == 200)
            {
                let banner = StatusBarNotificationBanner(title: msg, style: .success)
                banner.dismiss()
                banner.show()
                
                self.removeAnimate()
            }
            else
            {
                let banner = StatusBarNotificationBanner(title: msg, style: .warning)
                banner.dismiss()
                banner.show()
            }
            
            // add an action (button)
            // alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            
            // show the alert
            self.present(alert, animated: true, completion: nil)
            let when = DispatchTime.now() + 5
            DispatchQueue.main.asyncAfter(deadline: when){
                // your code with delay
                alert.dismiss(animated: true, completion: nil)
            }
            
        })
    }
    
    func loadOrders(pageNumber:Int)
    {
        let dict = ["status":3]
        
        Api.request(endpoint: .getPendingOrders(pageNumber: pageNumber, filters: dict)) { (json) in
            print("current result for orders are",json)
            
            let userNetData = json["data"].array
            
            if((userNetData) != nil && userNetData!.count>0)
            {
                //self.swiftBlogs = json["data"].array!
                GlobalVariables.orders.append([json["data"].array!])
                
                
               // self.tableView.reloadData()
                
                KRProgressHUD.dismiss()
            }
            else
            {
                self.swiftBlogs.removeAll()
                 self.tableView.reloadData()
            }
            
        }
        
//        Api.request(endpoint: .getOrders(pageNumber: pageNumber)) { (json) in
//            print("current result for orders are",json)
//
//            let userNetData = json["data"].array
//
//            if((userNetData) != nil && userNetData!.count>0)
//            {
//                self.swiftBlogs = json["data"].array!
//                GlobalVariables.orders.append([json["data"].array!])
//
//
//                self.tableView.reloadData()
//            }
//
//        }
        
    }
    
    func loadPendingOrders(pageNumber:Int)
    {
        let dict = ["status":1]
        
        Api.request(endpoint: .getPendingOrders(pageNumber: pageNumber, filters: dict)) { (json) in
            print("current result for orders are",json)
            
            let userNetData = json["data"].array
            
            if((userNetData) != nil && userNetData!.count>0)
            {
                print("orders from api",json["data"].array!)
                self.swiftBlogs = json["data"].array!
               // GlobalVariables.pendingOrders = json["data"].array!
                
                self.tableView.reloadData()
            }
        }
        
    }
    
    
}
