//
//  DepositWithdrawl.swift
//  PCEX
//
//  Created by CHHAGAN on 3/12/19.
//  Copyright © 2019 Chhagan SIngh. All rights reserved.
//

import UIKit
import Foundation
import SwiftyJSON

class DepositWithdrawl: UIViewController,UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var tableview: UITableView!
    
    @IBOutlet weak var btnWithdrawal: UIButton!
    @IBOutlet weak var btnDeposit: UIButton!
    var swiftBlogs = [JSON]()
    
    var depositArray = [JSON]()
    var withDrawalArray = [JSON]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //addSlideMenuButton()
        tableview.delegate = self
        tableview.dataSource = self
        
        btnDeposit.backgroundColor = UIColor.white
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillAppear(_ animated: Bool) {
        
        // self.getNetposition()
        
    }
    
    
    // MARK:  UITextFieldDelegate Methods
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return swiftBlogs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TransactionCell", for: indexPath) as! TransactionCell
        
        let row = indexPath.row
        
        
        cell.configureCellForIndexPath()
        
         let dict = swiftBlogs[row ]
        // print("dict*******",dict)
        
        cell.configureCell(with: dict)
        
        cell.lblTime.text = self.convertDateFormatter(date: dict["timeStamp"].stringValue)

        
        cell.btnCancel.tag = indexPath.row
        cell.btnCancel.addTarget(self, action: #selector(depositCancel(sender:)), for: .touchUpInside)
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
         let row = indexPath.row
         let dict = swiftBlogs[row]
        if(dict["status"].stringValue == "Pending")
        {
            return 220
        }
        
        return 190.0;
    }
    
    @objc func depositCancel(sender: UIButton){
        
        let dict = swiftBlogs[sender.tag]
        
        let requestid = dict["requestId"].stringValue
        let type = dict["type"].stringValue
        
        
        Api.request(endpoint: .getCancelWithdrawRequest(requestId: requestid, type: type)) { (JSON) in
            print("****",JSON)
        }
        
        
    }
    
    func convertDateFormatter(date: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm:ss dd-MMM-yyyy"//this your string date format
        //dateFormatter.timeZone = NSTimeZone(name: "UTC") as TimeZone!
        dateFormatter.locale = Locale(identifier: "your_loc_id")
        let convertedDate = dateFormatter.date(from: date)
        
        guard dateFormatter.date(from: date) != nil else {
            assert(false, "no date from string")
            return ""
        }
        
        dateFormatter.dateFormat = "dd-MMM-yyyy  HH:mm:ss"///this is what you want to convert format
        //dateFormatter.timeZone = NSTimeZone(name: "UTC") as TimeZone!
        let timeStamp = dateFormatter.string(from: convertedDate!)
        
        return timeStamp
    }
    
    @IBAction func btnDepositActio(_ sender: Any) {
        
        
        btnWithdrawal.backgroundColor = (UIColor(hexString: "#0A1D2F"))
        btnDeposit.backgroundColor = UIColor.white
        
        
        self.swiftBlogs  = self.depositArray
        self.tableview.reloadData()
    }
    
    
    @IBAction func btnWithdrawalAction(_ sender: Any) {
        
        btnDeposit.backgroundColor = (UIColor(hexString: "#0A1D2F"))
        btnWithdrawal.backgroundColor = UIColor.white
        
        self.swiftBlogs.removeAll()
        
        if(withDrawalArray.count>0)
        {
            self.tableview.reloadData()
        }
        else
        {
            self.getWithdrawalHistory(pageNumber: 1)
        }
    }
    
    func getWithdrawalHistory(pageNumber:Int)
    {
        
        Api.request(endpoint: .getTransactionHistory(pageNumber: pageNumber, type: 1, currency: "all", status: -1)) { (JSON) in
            
            if (JSON["status"] == 200)
            {
                let userNetData = JSON["data"].array
                
                if((userNetData) != nil && userNetData!.count>0)
                {
                    self.swiftBlogs = JSON["data"].array!
                    self.withDrawalArray = JSON["data"].array!
                }
                else
                {
                    let alert = UIAlertController(title: "PCEX", message: "You don't have any withdrawals yet.", preferredStyle: UIAlertController.Style.alert)
                    
                    // add an action (button)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                    
                    // show the alert
                    self.present(alert, animated: true, completion: nil)
                }
                
                self.tableview.reloadData()
            }
        }

        
    }
    
    
    
    
}
