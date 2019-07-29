//
//  NetPositionVC.swift
//  PCEX
//
//  Created by CHHAGAN on 3/12/19.
//  Copyright © 2019 Chhagan SIngh. All rights reserved.
//

import UIKit
import Foundation
import SwiftyJSON

class NetPositionVC: UIViewController,UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet var tableView: UITableView!
    
    let textCellIdentifier = "TextCell"
    
    var swiftBlogs = [JSON]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillAppear(_ animated: Bool) {
        
        self.getNetposition()
        
    }
    
    
    // MARK:  UITextFieldDelegate Methods
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return swiftBlogs.count+1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "NetPositionCell", for: indexPath) as? NetPositionCell
        //        let cell = tableView.dequeueReusableCell(withIdentifier: textCellIdentifier, for: indexPath)
        
        let row = indexPath.row
        if(indexPath.row>0)
        {
            let dict = swiftBlogs[row - 1]
            // print("dict*******",dict)
            cell!.lblSymbol.text = dict["symbolName"].stringValue
            cell!.lblOpeningPrice.text = dict["currentPrice"].stringValue
            cell!.lblNetQty.text = dict["netOrderQty"].stringValue
             cell!.lblCurrentMarket.text = dict["type"].stringValue
            cell!.lblOpeningPrice.text = dict["openingPrice"].stringValue
            cell!.lblMTM.text = dict["MTM"].stringValue
        }
        
        
        return cell!
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60.0;
    }
    
    func getNetposition()
    {
        
        Api.request(endpoint: .getNetposition(offset: 1)) { (JSON) in
            print("******",JSON)
            
            let userNetData = JSON["data"].array
            
            if(userNetData != nil)
            {
                self.swiftBlogs = JSON["data"].array!
                
                self.tableView.reloadData()
            }
            
            
        }
        
        //            Api.request(endpoint: .getOrders(pageNumber: pageNumber)) { (json) in
        //                print("current result for orders are",json)
        //
        //                self.swiftBlogs.append(json["data"].arrayValue as AnyObject)
        //
        //                self.tableView.reloadData()
        //            }
        
    }
    
    
    
    
}
