//
//  LogsCell.swift
//  PCEX2
//
//  Created by CHHAGAN SINGH on 5/22/19.
//  Copyright © 2019 Panaesha Capital pvt. ltd. All rights reserved.
//

import UIKit
import Foundation
import SwiftyJSON

class LogsCell: UITableViewCell {
    @IBOutlet weak var lblLogId: UILabel!
    
    @IBOutlet weak var lblDiscription: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureCell(with dict:JSON) {
       // print("dict result",dict)
        lblLogId.text = "#\(dict["_id"].stringValue)"
        lblDiscription.text =  dict["message"].stringValue
        
        if(dict["message"].intValue == 1)
        {
            lblDiscription.textColor = (UIColor(hexString: "#223e7d"))
        }
        else if(dict["message"].intValue == 2)
        {
            lblDiscription.textColor = (UIColor(hexString: "#129F4b"))
        }
        else if(dict["message"].intValue == 3)
        {
            lblDiscription.textColor = (UIColor(hexString: "#ed1F24"))
        }
        
        lblDate.text = dict["timeStamp"].stringValue
        lblDate.textColor = (UIColor(hexString: "#797b7b"))
        
    }
    
}
