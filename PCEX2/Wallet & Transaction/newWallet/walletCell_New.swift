//
//  walletCell_New.swift
//  PCEX2
//
//  Created by CHHAGAN SINGH on 6/4/19.
//  Copyright © 2019 Panaesha Capital pvt. ltd. All rights reserved.
//

import UIKit

class walletCell_New: UITableViewCell {


    @IBOutlet weak var imgLogo: UIImageView!
    @IBOutlet weak var lblCurrencyName: UILabel!
    
    @IBOutlet weak var lblCurrent: UILabel!
     @IBOutlet weak var lblHold: UILabel!
    @IBOutlet weak var lblNetValue: UILabel!
    
    @IBOutlet weak var lblNetBuy: UILabel!
    @IBOutlet weak var lblNetSell: UILabel!
    @IBOutlet weak var btnDeposit: UIButton!
    @IBOutlet weak var btnWithdrawal: UIButton!
    
    @IBOutlet weak var viewUSD: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
