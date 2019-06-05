//
//  TransactionCell.swift
//  PCEX
//
//  Created by CHHAGAN on 22/03/19.
//  Copyright © 2019 Chhagan SIngh. All rights reserved.
//

import UIKit
import Foundation
import SwiftyJSON
class TransactionCell:UITableViewCell {
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var lblPaymentMethod: UILabel!
    
    @IBOutlet weak var lblTransactionid: UILabel!
    @IBOutlet weak var imgLogoCurrency: UIImageView!
    @IBOutlet weak var lblCurrency: UILabel!
    @IBOutlet weak var lblAmount: UILabel!
    @IBOutlet weak var lblStatus: UILabel!
    @IBOutlet weak var btnCancel: UIButton!
    
    @IBOutlet weak var btncancelHeight: NSLayoutConstraint!
    func configureCellForIndexPath()
    {
        self.lblStatus.layer.cornerRadius = 5
        self.lblStatus.layer.borderColor = (UIColor(hexString: GREEN_COLOR_CUSTOM)).cgColor
        self.lblStatus.layer.borderWidth = 2
        
//        self.btnCancel.layer.cornerRadius = 5
//        self.btnCancel.layer.borderColor = (UIColor(hexString: RED_COLOR_CUSTOM)).cgColor
//        self.btnCancel.layer.borderWidth = 2
    }
    
    
    func configureCell(with dict:JSON) {
        self.lblStatus.text = dict["status"].stringValue
        
        if(dict["status"].stringValue != "Pending")
        {
            btncancelHeight.constant = 0
            btnCancel.isHidden = true
        }
        
        if(dict["status"].stringValue == "Pending")
        {
            lblStatus.textColor = (UIColor(hexString: RED_COLOR_CUSTOM))
             self.lblStatus.layer.borderColor = (UIColor(hexString: RED_COLOR_CUSTOM)).cgColor
        }
        else if (dict["status"].stringValue == "Success")
        {
            lblStatus.textColor = (UIColor(hexString: GREEN_COLOR_CUSTOM))
        }
        else
        {
            lblStatus.textColor = (UIColor(hexString: WHITE_COLOR))
             self.lblStatus.layer.borderColor = (UIColor(hexString: WHITE_COLOR)).cgColor
        }
        
        
        lblAmount.text = dict["amount"].stringValue
        
        lblCurrency.text = dict["currency"].stringValue
        lblPaymentMethod.text = dict["process"].stringValue
        lblTransactionid.text = dict["transactionId"].stringValue
        
        //print("***",GlobalVariables.currenciesImages)
        
        let imgPath = GlobalVariables.currenciesImages[lblCurrency.text!]
        
        imgLogoCurrency.sd_setImage(with: URL(string: imgPath!), placeholderImage: UIImage(named: "placeholder.png"))
    }
    /*
     cell.lblStatus.text = dict["status"].stringValue
     
     if(dict["status"].stringValue != "Pending")
     {
     cell.btncancelHeight.constant = 0
     cell.btnCancel.isHidden = true
     }
     
     if(dict["status"].stringValue == "Pending")
     {
     cell.lblStatus.textColor = (UIColor(hexString: RED_COLOR_CUSTOM))
     }
     else if (dict["status"].stringValue == "Success")
     {
     cell.lblStatus.textColor = (UIColor(hexString: GREEN_COLOR_CUSTOM))
     }
     else
     {
     cell.lblStatus.textColor = (UIColor(hexString: WHITE_COLOR))
     }
     
     cell.lblTime.text = self.convertDateFormatter(date: dict["timeStamp"].stringValue)
     cell.lblAmount.text = dict["amount"].stringValue
     
     cell.lblCurrency.text = dict["currency"].stringValue
     cell.lblPaymentMethod.text = dict["process"].stringValue
     cell.lblTransactionid.text = dict["transactionId"].stringValue
     
     //print("***",GlobalVariables.currenciesImages)
     
     let imgPath = GlobalVariables.currenciesImages[cell.lblCurrency.text!]
     
     cell.imgLogoCurrency.sd_setImage(with: URL(string: imgPath!), placeholderImage: UIImage(named: "placeholder.png"))
 */
    
}
