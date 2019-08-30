//
//  LogsViewVC.swift
//  PCEX2
//
//  Created by CHHAGAN SINGH on 5/22/19.
//  Copyright © 2019 Panaesha Capital pvt. ltd. All rights reserved.
//

import UIKit
import Foundation
import UIKit
import Alamofire
import SwiftyJSON
import NotificationBannerSwift
import KRProgressHUD


class LogsViewVC: UIViewController,UITableViewDataSource, UITableViewDelegate,logsUpdateDelegate {

    
    var swiftBlogs = [JSON]()
    
    var logsArray = [JSON]()
    
    @IBOutlet weak var tblView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        if(APP_Defaults.bool(forKey: "login"))
        {
            let socket = Service()
            socket.delegateLogs = self
        }
        tblView.delegate = self
        tblView.dataSource = self
        
        tblView.register(LogsCell.self, forCellReuseIdentifier: "logs")
        tblView.register(UINib(nibName: "LogsCell", bundle: nil), forCellReuseIdentifier: "logs")

    }
    
    @IBAction func btnBackAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        if(swiftBlogs.count == 0 && GlobalVariables.logs.count > 0)
        {
            swiftBlogs = GlobalVariables.logs
            tblView.reloadData()
        }
    }
    
    
    func receiveLogsUpdate(scrip: JSON)
    {
        print("&*&*",scrip)
    }

    // MARK:  UITextFieldDelegate Methods
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return swiftBlogs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "logs", for: indexPath) as! LogsCell
  
        
        let row = indexPath.row
        
        let dict = swiftBlogs[row]
         print("dict*******",dict)

        cell.configureCell(with: dict)
 
        //self.convertDateFormatter(date: dict["timeStamp"].stringValue)
        
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80.0;
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
}
