//
//  CurrencyModel.swift
//  PCEX
//
//  Created by CHHAGAN on 13/03/19.
//  Copyright © 2019 Chhagan SIngh. All rights reserved.
//

import Foundation

struct CurrencyModel {
    var symbolId            : Int
    var buyQty              : Array<String>?
    var buyRate             : Array<String>?
    var sellQty             : Array<String>?
    var sellRate            : Array<String>?
    var displayName         : String?
    var expiryDate          : String?
    var loadMaxQty          : String?
    var lotSize             : String?
    var ltp                 : String?
    var margin              : String?
    var marginType          : String?
    var market              : String?
    var moq                 : String?
    var prevTick            : String?
    var priority            : String?
    var startRate           : String?
    var symbolName          : String?
    var symbolType          : Int
    var tempRates           : String?
    var tickSize            : String?
    var todayChange         : String?
    var todayHigh           : String?
    var todayLow            : String?
    var volatilePercentDown : String?
    var volatilePercentUp   : String?
    var volume              : String?
    
    func currency()-> String {
        return CurrencyName.shared.currencyNameForID(id:self.symbolId)
    }
//    func market() -> String {
//        return CurrencyModel
//    }
}

