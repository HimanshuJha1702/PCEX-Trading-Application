//
//  CurrencyNameCell.swift
//  PCEX2
//
//  Created by CHHAGAN SINGH on 5/30/19.
//  Copyright © 2019 Panaesha Capital pvt. ltd. All rights reserved.
//

import UIKit
import Foundation
class CurrencyNameCell: UITableViewCell {

    @IBOutlet weak var imgSymbol: UIImageView!
    @IBOutlet weak var lblCurrency: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    func configure(with scrip:CurrencyModel,  numberToCompare number:Double?, colorTheme:PCEXColorTheme?){
        self.backgroundColor = colorTheme?.backgroundColor
        self.lblCurrency.text =  scrip.currency()
        
                if scrip.symbolType == 2
                {
                    self.lblCurrency.text =  "\(self.lblCurrency.text)_FUT"
                }
        
        let symbol = (scrip.symbolName!).lowercased()
        var imgPath = "https://www.pcex.io/assets/icons/\(symbol).png"
        
//        var imgPath = ""
//        if(symbol == "fcc")
//        {
//            imgPath = "https://www.pcex.io/assets/icons/fcc.png"
//        }
//        else
//        {
//           // imgPath = "https://cryptoicons.org/api/icon/\(symbol)/20"
//
//
//            var  symbol2 = (scrip.symbolName!).uppercased()
//            imgPath = "https://www.coineal.com/res/img/coin/\(symbol2).png"
//        }
        imgSymbol.sd_setImage(with: URL(string: imgPath), placeholderImage: UIImage(named: "placeholder.png"))
    }
}

