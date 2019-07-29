//
//  OrdersCell.swift
//  PCEX
//
//  Created by CHHAGAN on 3/20/19.
//  Copyright © 2019 Chhagan SIngh. All rights reserved.
//

import UIKit
import Foundation

class OrdersCell: UITableViewCell {
    @IBOutlet weak var lblOrderNo: UILabel!
    @IBOutlet weak var lblMarket: UILabel!
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var lblMarketType: UILabel!
    @IBOutlet weak var lblBuySell: UILabel!
    @IBOutlet weak var lblQty: UILabel!
    @IBOutlet weak var lblRate: UILabel!
    @IBOutlet weak var lblPendingQty: UILabel!
    @IBOutlet weak var btnModify: UIButton!
    @IBOutlet weak var btnCancel: UIButton!
    @IBOutlet weak var lblStatus: UILabel!
    
    @IBOutlet weak var imgSymbol: UIImageView!
    @IBOutlet weak var statusHeightConstrint: NSLayoutConstraint!
    
    @IBOutlet weak var btnsHeightConstrint: NSLayoutConstraint!
    
    @IBOutlet weak var viewOutLayer: UIView!
    func configureCellForIndexPath()
    {
        
        if #available(iOS 11.0, *) {
           self.viewOutLayer.layer.cornerRadius = 20
            self.viewOutLayer.clipsToBounds = true
        }
        else
        {
            self.viewOutLayer.roundedAllCorner()
        }
        
//        self.viewOutLayer.layer.shadowColor = UIColor.black.cgColor
//        self.viewOutLayer.layer.shadowOffset = CGSize(width: 5, height: 5)
//        self.viewOutLayer.layer.shadowOpacity = 0.7
//        self.viewOutLayer.layer.shadowRadius = 1
//        self.viewOutLayer.layer.masksToBounds = false

        
    }
    
    func hideAndAdjustcell()
   {
//        self.statusHeightConstrint.constant = 0
//        self.btnsHeightConstrint.constant = 0
//        self.lblStatus.isHidden = true
//        self.btnModify.isHidden = true
//        self.btnCancel.isHidden = true
    }
    
}
