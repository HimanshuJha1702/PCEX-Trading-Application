//
//  HistoryDepositWithDrawCell.swift
//  PCEX2
//
//  Created by CHHAGAN SINGH on 5/22/19.
//  Copyright © 2019 Panaesha Capital pvt. ltd. All rights reserved.
//

import UIKit
import Foundation
import SwiftyJSON

class HistoryDepositWithDrawCell: UITableViewCell {
    
    @IBOutlet weak var imgWallet: UIImageView!
    @IBOutlet weak var btnCancel: UIButton!
    @IBOutlet weak var lblAddress: UILabel!
    @IBOutlet weak var lblProcessType: UILabel!
    @IBOutlet weak var lblStatus: UILabel!
    
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblCurrency: UILabel!
    
    @IBOutlet weak var imgSymbol: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureCell(with dict:JSON) {
        self.lblStatus.text = dict["status"].stringValue
        
        if(dict["status"].stringValue != "Pending")
        {
      
            btnCancel.isHidden = true
        }
        
//        if(dict["status"].stringValue == "Pending")
//        {
//            lblStatus.textColor = (UIColor(hexString: RED_COLOR_CUSTOM))
//            self.lblStatus.layer.borderColor = (UIColor(hexString: RED_COLOR_CUSTOM)).cgColor
//        }
//        else if (dict["status"].stringValue == "Success")
//        {
//            lblStatus.textColor = (UIColor(hexString: GREEN_COLOR_CUSTOM))
//        }
//        else
//        {
//            lblStatus.textColor = (UIColor(hexString: WHITE_COLOR))
//            self.lblStatus.layer.borderColor = (UIColor(hexString: WHITE_COLOR)).cgColor
//        }
        
        
       // lblAmount.text = dict["amount"].stringValue
        
        lblCurrency.text = "\(dict["amount"].stringValue) \(dict["currency"].stringValue)"
        lblProcessType.text = dict["process"].stringValue
       // lblTransactionid.text = dict["transactionId"].stringValue
        
        //print("***",GlobalVariables.currenciesImages)
        
        let imgPath = GlobalVariables.currenciesImages[lblCurrency.text!]
        
        imgSymbol.sd_setImage(with: URL(string: imgPath!), placeholderImage: UIImage(named: "placeholder.png"))
    }
    
}
