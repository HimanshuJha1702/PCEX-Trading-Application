//
//  OpenTableCell.swift
//  PCEX2
//
//  Created by Himanshu Jha on 11/09/19.
//  Copyright © 2019 Panaesha Capital pvt. ltd. All rights reserved.
//

import Foundation
import UIKit

class OpenTableCell : UITableViewCell {
    
    @IBOutlet weak var imageSymbol: UIImageView!
    @IBOutlet weak var buySellLabel: UILabel!
    @IBOutlet weak var timeStampLbl: UILabel!
    
    @IBOutlet weak var lblMarket: UILabel!
    @IBOutlet weak var pendingLbl: UILabel!
    
    @IBOutlet var qtyValue: UITextField!
    @IBOutlet var pendingQtyValue: UITextField!
    @IBOutlet var priceValue: UITextField!
    
    
    @IBAction func editBtnAction(_ sender: UIButton) {
        
    }
    
    @IBAction func deleteBtnAction(_ sender: UIButton) {
        
    }
    
    
}
