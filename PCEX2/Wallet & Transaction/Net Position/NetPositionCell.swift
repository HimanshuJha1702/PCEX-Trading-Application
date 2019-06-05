//
//  NetPositionCell.swift
//  PCEX
//
//  Created by CHHAGAN on 3/20/19.
//  Copyright © 2019 Chhagan SIngh. All rights reserved.
//

import UIKit
import Foundation

class NetPositionCell: UITableViewCell {
    
    @IBOutlet weak var lblSymbol: UILabel!

    @IBOutlet weak var lblOpeningPrice: UILabel!
    @IBOutlet weak var bgImgView: UIImageView!
    
    @IBOutlet weak var lblCurrentMarket: UILabel!
    
    @IBOutlet weak var lblMTM: UILabel!
    
    @IBOutlet weak var lblNetQty: UILabel!

    @IBOutlet weak var imgSymbol: UIImageView!
    
    func configureCellForIndexPath()
    {
        
        if #available(iOS 11.0, *) {
            self.bgImgView.layer.cornerRadius = 20
            self.bgImgView.clipsToBounds = true
        }
        else
        {
            self.bgImgView.roundedAllCorner()
        }
        
//        self.bgImgView.layer.shadowColor = UIColor.black.cgColor
//        self.bgImgView.layer.shadowOffset = CGSize(width: 5, height: 10)
//        self.bgImgView.layer.shadowOpacity = 0.2
//        self.bgImgView.layer.shadowRadius = 1
//        self.bgImgView.layer.masksToBounds = false
        
        
    }
}


