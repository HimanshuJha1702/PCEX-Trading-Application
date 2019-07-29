//
//  WalletCell.swift
//  PCEX
//
//  Created by CHHAGAN on 22/03/19.
//  Copyright © 2019 Chhagan SIngh. All rights reserved.
//

import UIKit
import Foundation

class WalletCell:UITableViewCell {
    @IBOutlet weak var imgLogo: UIImageView!
    @IBOutlet weak var lblCurrencyName: UILabel!

    @IBOutlet weak var viewMainBalance
    : UIView!
    @IBOutlet weak var viewCrypto: UIView!
    
    @IBOutlet weak var btnShowMainMarket: UIButton!
    @IBOutlet weak var btnShowIntraDay: UIButton!
    
    @IBOutlet weak var lblCurrent: UILabel!
    @IBOutlet weak var lblHold: UILabel!
    @IBOutlet weak var lblNetValue: UILabel!
    @IBOutlet weak var btnDeposit: UIButton!
    @IBOutlet weak var btnWithdrawal: UIButton!
    @IBOutlet weak var viewButtons: UIView!
    
    @IBOutlet weak var viewMain: UIView!
    @IBOutlet weak var lblExposere: UILabel!
    
    @IBOutlet weak var lblExpoHold: UILabel!
    
    @IBOutlet weak var lblNetExpo: UILabel!
    @IBOutlet weak var btnHistory: UIButton!
    
    @IBOutlet weak var lblNameMainMarkt: UILabel!
    
    @IBOutlet weak var lblNameIntradMarket: UILabel!
    // buy section crypto
    
    @IBOutlet weak var lblBuy: UILabel!
    @IBOutlet weak var lblBuyHold: UILabel!
    @IBOutlet weak var lblNetBuy: UILabel!
    
    // sell section crypto
    
    @IBOutlet weak var lblSell: UILabel!
    @IBOutlet weak var lblSellHold: UILabel!
    @IBOutlet weak var lblNetSell: UILabel!
    
    @IBOutlet var btnCollection: [UIButton]!
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        print("MyCell1 Initialization Done")
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func configureCellForIndexPath()
    {
        if #available(iOS 11.0, *) {
            self.viewMain.layer.cornerRadius = 20
            self.viewMain.clipsToBounds = true
            
            self.viewButtons.layer.cornerRadius = 10
            self.viewButtons.clipsToBounds = true
            
        }
        else
        {
            self.viewMain.roundedAllCorner()
            self.viewButtons.roundedAllCorner()
        }
        
        for btn in btnCollection {
            btn.imageView?.contentMode = .center
        }
        
        self.viewMain.layer.shadowColor = UIColor.black.cgColor
        self.viewMain.layer.shadowOffset = CGSize(width: 5, height: 10)
        self.viewMain.layer.shadowOpacity = 0.2
        self.viewMain.layer.shadowRadius = 1
        self.viewMain.layer.masksToBounds = false
        
        self.viewButtons.layer.shadowColor = UIColor.black.cgColor
        self.viewButtons.layer.shadowOffset = CGSize(width: 5, height: 10)
        self.viewButtons.layer.shadowOpacity = 0.2
        self.viewButtons.layer.shadowRadius = 1
        self.viewButtons.layer.masksToBounds = false
        
    }
    
}





