//
//  Currency.swift
//  PCEX
//
//  Created by CHHAGAN on 13/03/19.
//  Copyright © 2019 Chhagan SIngh. All rights reserved.
//

import Foundation

class CurrencyName {
    static let var1: String = "FCC"
    static let var2: String = "BTC"
    static let var3: String = "ETH"
    static let var4: String = "LTC"
    static let var5: String = "DASH"
    static let var6: String = "XMR"
    static let var7: String = "BCH"
    
    static let shared = CurrencyName()
    var currencyID = [
        1 : "USD / FCC",
        2 : "USD / BTC",
        3 : "USD / ETH",
        4 : "USD / LTC",
        5 : "USD / DASH",
        6 : "USD / XMR",
        8 : "USD / BCH",
        9 : "FCC / BTC",
        10: "FCC / ETH",
        11: "FCC / LTC",
        12: "FCC / DASH",
        13: "FCC / XMR",
        14: "FCC / BCH",
        16: "BTC / ETH",
        17: "BTC / LTC",
        18: "BTC / DASH",
        19: "BTC / BCH",
        21: "ETH / LTC",
        22: "ETH / DASH",
        23: "ETH / XMR",
        24: "ETH / BCH",
        26: "BTC / XMR",
        29: "USD / FCC",
        30: "USD / BTC",
        31: "USD  / ETH",
        32: "USD / LTC",
        33: "USD / DASH",
        34: "USD / XMR",
        35: "USD / BCH"
    ]
    
   public func currencyNameForID(id:Int) -> String {
        return self.currencyID[id] ?? "N/A"
    }
}

