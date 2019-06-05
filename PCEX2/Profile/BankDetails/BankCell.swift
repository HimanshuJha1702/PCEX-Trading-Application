//
//  BankCell.swift
//  PCEX2
//
//  Created by RAHUL BANSAL on 5/28/19.
//  Copyright © 2019 Panaesha Capital pvt. ltd. All rights reserved.
//

import UIKit
import SwiftyJSON

class BankCell: UITableViewCell {
    @IBOutlet weak var lblUserBankName: UILabel!
    @IBOutlet weak var lblAccountNumber: UILabel!
    @IBOutlet weak var lblBankName: UILabel!
    @IBOutlet weak var lblIfscCode: UILabel!
    @IBOutlet weak var lblSwiftCode: UILabel!
    @IBOutlet weak var btnDelete: UIButton!
    @IBOutlet weak var btnEdit: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureCell(with dict:JSON) {
        lblUserBankName.text =  "N.A."//dict["message"].stringValue
        lblBankName.text = (dict["bankName"].stringValue)
        lblAccountNumber.text =  dict["accountNumber"].stringValue
        lblIfscCode.text = dict["ifscCode"].stringValue
        lblSwiftCode.text = dict["swiftCode"].stringValue
    }
    
}
