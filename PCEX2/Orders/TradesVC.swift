//
//  TradesVC.swift
//  PCEX
//
//  Created by CHHAGAN on 3/20/19.
//  Copyright © 2019 Chhagan SIngh. All rights reserved.
//

import UIKit
import Foundation
import SwiftyJSON

class TradesVC: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    
    static let userId = APP_Defaults.value(forKey: "userId") as! Int
    static let sessionId = APP_Defaults.value(forKey: "sessionId") as! String
    static let fastSessionId = APP_Defaults.value(forKey: "fastSessionId") as! Int
    
    @IBOutlet var tableView: UITableView!
    
    let textCellIdentifier = "TextCell"
    
    var swiftBlogs = [JSON]()
    
    //    let swiftBlogs = ["Ray Wenderlich", "NSHipster", "iOS Developer Tips", "Jameson Quave", "Natasha The Robot", "Coding Explorer", "That Thing In Swift", "Andrew Bancroft", "iAchieved.it", "Airspeed Velocity"]
    
//    private var markets = [Markets]()
    
    class func initFromStoryboard() -> TradesVC {
        let storyboard = UIStoryboard.init(name: "Main", bundle: Bundle.main)
        let animalViewController = storyboard.instantiateViewController(
            withIdentifier: "TradesVC") as! TradesVC
        return animalViewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        if(APP_Defaults.bool(forKey: "login"))
        {
            if(GlobalVariables.trades.count>0 && swiftBlogs.count==0)
            {
                swiftBlogs = GlobalVariables.trades
                tableView.reloadData()
            }
            else
            {
                self.loadTrades(pageNumber: 1)
            }
        }

        
    }
    
    
    
    // MARK:  UITextFieldDelegate Methods
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return swiftBlogs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TradesCell", for: indexPath) as! TradesCell
        //        let cell = tableView.dequeueReusableCell(withIdentifier: textCellIdentifier, for: indexPath)
        
        let row = indexPath.row
        
        var dict = swiftBlogs[row]
        print("dict*******",dict)
        
        cell.configureCellForIndexPath()
        
       // cell.lblOrderNo.text = dict["orderId"].stringValue
        cell.lblMarket.text = (dict["symbolName"].stringValue)
        cell.lblOrderRate.text = dict["orderRate"].stringValue
        cell.lblTradeRate.text = dict["tradeRate"].stringValue
       // cell.lblTradeNo.text = dict["bRate"].stringValue
        //orderCell.lblTime.text = dict["timeStamp"].stringValue
        cell.lblQty.text = dict["tradeQty"].stringValue
        cell.lblAmountCerditDebit.text = dict["amount"].stringValue
        
        cell.lblTime.text = self.convertDateFormatter(date: dict["timeStamp"].stringValue)
        
        let symbol = (dict["symbolName"].stringValue).lowercased()
        
            let imgPath = "https://www.pcex.io/assets/icons/\(symbol).png"

        
        cell.imgSymbol.sd_setImage(with: URL(string: imgPath), placeholderImage: UIImage(named: "placeholder.png"))
        
        if dict["orderType"].intValue == 1 {
            cell.lblBuySell.text = "Sell"
           // cell.lblBuySell.textColor = .red
            cell.lblBuySell.textColor = (UIColor(hexString: "#ed1F24"))
        }
        else
        {
            cell.lblBuySell.text = "Buy"
            //cell.lblBuySell.textColor = .green
            cell.lblBuySell.textColor = (UIColor(hexString: "#129F4b"))
        }
        
        
        return cell
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
        return 130.0;
    }
    
    
    public func requestNewForSelectio() {
            self.loadTrades(pageNumber: 1)
    }
    
    
    func convertDateFormatter(date: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm:ss dd-MMM-yyyy"//this your string date format
        dateFormatter.timeZone = NSTimeZone(name: "UTC") as TimeZone!
        dateFormatter.locale = Locale(identifier: "your_loc_id")
        let convertedDate = dateFormatter.date(from: date)
        
        guard dateFormatter.date(from: date) != nil else {
            print("no date from string")
            //assert(false, "no date from string")
            return ""
        }
        
        dateFormatter.dateFormat = "dd-MM-yyyy HH:mm:ss"///this is what you want to convert format
        dateFormatter.timeZone = NSTimeZone(name: "UTC") as TimeZone!
        let timeStamp = dateFormatter.string(from: convertedDate!)
        
        return timeStamp
    }
    
    public func reloadViewForTrades() {
        
        if(GlobalVariables.trades.count>0 && swiftBlogs.count==0)
        {
            swiftBlogs = GlobalVariables.trades
            tableView.reloadData()
        }
    }
    
    
    func loadTrades(pageNumber:Int)
    {
        Api.request(endpoint: .getTrades(pageNumber: pageNumber)) { (json) in
            print("current result for trades are",json)
            
            let userNetData = json["data"].array
            
            if((userNetData) != nil && userNetData!.count>0)
            {
                self.swiftBlogs = json["data"].array!
                GlobalVariables.trades.append(json["data"])
               // GlobalVariables.trades = json["data"].array!
                self.tableView.reloadData()
            }
            
        }
    }
    
    
}
