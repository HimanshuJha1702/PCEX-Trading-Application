//
//  TradesTableCell.swift
//  PCEX2
//
//  Created by Himanshu Jha on 01/09/19.
//  Copyright © 2019 Panaesha Capital pvt. ltd. All rights reserved.
//

import UIKit

class TradesTableCell: UITableViewCell {

    @IBOutlet weak var orderRateValue: UILabel!
    @IBOutlet weak var amountValue: UILabel!
    @IBOutlet weak var tradeRateValue: UILabel!
    @IBOutlet weak var lblQtyValue: UILabel!
    @IBOutlet weak var imageSymbol: UIImageView!
    @IBOutlet weak var lblMarket: UILabel!
    @IBOutlet weak var buySellLabel: UILabel!
    @IBOutlet weak var timeStampLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
