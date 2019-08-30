//
//  ListerTableViewCell.swift
//  PCEX
//
//  Created by CHHAGAN on 12/03/19.
//  Copyright © 2019 Chhagan SIngh. All rights reserved.
//

import UIKit
import Foundation

class ListerTableViewCell: UITableViewCell {
    
    @IBOutlet weak var currNameLblOutlet: UILabel!
    @IBOutlet weak var priceLblOutlet: UILabel!
    @IBOutlet weak var volumeTradedLblOutlet: UILabel!
    @IBOutlet weak var changePerLblOutlet: UILabel!
    @IBOutlet weak var traderRateImgViewOutlet: UIImageView!
    
    @IBOutlet weak var imgGraph: UIImageView!
    @IBOutlet weak var imgSymbolCurrency: UIImageView!
    
    @IBOutlet weak var btnAddFav: UIButton!
    
    @IBOutlet weak var removeFromFav: UIButton!
    
    
    @IBOutlet weak var lblFuture: UILabel!
    @IBOutlet weak var futureHeightconstrainet: NSLayoutConstraint!
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    func configure(with scrip:CurrencyModel,  numberToCompare number:Double?, colorTheme:PCEXColorTheme?){
        self.backgroundColor = colorTheme?.backgroundColor
        
//        if scrip.symbolType == 2
//        {
//            lblFuture.text =  "Future" + " " + scrip.expiryDate!
//        }
        
        currNameLblOutlet.text = scrip.currency()
        print(scrip.currency())
        //currNameLblOutlet.textColor = (UIColor(hexString: VioletPCEX_CUSTOM))
        
        
       let priceCurrent = Double(scrip.ltp!)
        
        priceLblOutlet.text = String(format:"%.4g%n", priceCurrent!)
        priceLblOutlet.textColor = (UIColor(hexString: VioletPCEX_CUSTOM))
        
        changePerLblOutlet.text = scrip.todayChange
        changePerLblOutlet.textColor = colorTheme?.foregroundColor
        
        //let volCur = Double(scrip.volume!)
       // volumeTradedLblOutlet.text = String(format:"%.4g%n", volCur!)
        volumeTradedLblOutlet.text = scrip.volume
        volumeTradedLblOutlet.textColor = (UIColor(hexString: VioletPCEX_CUSTOM))
        
        
        
        
        let symbol = (scrip.symbolName!).lowercased()
        
        var imgPath = "https://www.pcex.io/assets/icons/\(symbol).png"


        
        
        //  print("my image path ",imgPath)
        
        imgSymbolCurrency.sd_setImage(with: URL(string: imgPath), placeholderImage: UIImage(named: "placeholder.png"))
        
        imgSymbolCurrency.backgroundColor = .clear
        
        
        let randomInt = Int.random(in: 0..<6)
        
        if(randomInt % 2 == 0)
        {
            imgGraph.image = UIImage(named: "graph.jpg")
        }
        else
        {
            imgGraph.image = UIImage(named: "graph 1.jpg")
        }
        
       // imgGraph.sd_setImage(with: <#T##URL?#>, completed: <#T##SDExternalCompletionBlock?##SDExternalCompletionBlock?##(UIImage?, Error?, SDImageCacheType, URL?) -> Void#>)
        
        let change = Double(changePerLblOutlet.text!)
        
        if let anumber = change{
            if  0 > anumber {
                //print("loss found",anumber)
                traderRateImgViewOutlet.image = UIImage(named: "lossarrow.jpg")
            }else if  0 < anumber {
                // print("profit found",anumber)
                traderRateImgViewOutlet.image = UIImage(named: "up arrow.jpg")
                
            }else{
                traderRateImgViewOutlet.image = nil
            }
        }else {
            traderRateImgViewOutlet.image = nil
        }

        
        
    }
}

