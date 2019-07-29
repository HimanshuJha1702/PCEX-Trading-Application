//
//  DirectMarketDemo.swift
//  PCEX2
//
//  Created by CHHAGAN SINGH on 4/3/19.
//  Copyright © 2019 Panaesha Capital pvt. ltd. All rights reserved.
//

import Foundation
import Starscream
import SocketIO
import NotificationBannerSwift

protocol PcexServiceListenerProtocolDemo {
    var objectID : Int! {get}
    func receivedUpdatesForUSD(_ scrip:CurrencyModel)
    func receivedUpdatesForBTC(_ scrip:CurrencyModel)
    func receivedUpdatesForFCC(_ scrip:CurrencyModel)
    func receivedUpdatesForETH(_ scrip:CurrencyModel)
}


class DirectMarketDemo {
    
    static let shared = DirectMarketDemo()
    fileprivate var socket :WebSocket!
    let manager = SocketManager(socketURL:  URL(string: AppDelegateGlobal.SocketUrl)!, config: [.log(false)])
    fileprivate var socketObj:SocketIOClient!
    
    var observers = [Int:PcexServiceListenerProtocolDemo]()
    
    var allData = [AnyObject]()
    var controllerCheck = [PcexServiceListenerProtocolDemo]()
    
    init() {
        
        self.socketObj = manager.defaultSocket
        //self.setSocketEvents()
        self.socketObj.on(clientEvent: .connect) {data, ack in
            //self.socketObj.write(string: "{\"command\":\"subscribe\",\"channel\":\"1002\"}")
            let banner = StatusBarNotificationBanner(title: "Connected", style: .success)
            banner.dismiss()
            banner.show()
            print("websocket is connected")
        };
        
        self.socketObj.on(clientEvent: .disconnect) {data, ack in
            let banner = StatusBarNotificationBanner(title: "Diconnected", style: .danger)
            banner.dismiss()
            banner.show()
            // print("websocket is disconnected: \(error?.localizedDescription ?? "")")
            
            print("socket disconnect");
        }
 
        self.socketObj.on("marketWatchChanged") {response, ack in
            let dict = response[0] as! [String: AnyObject]
            let scripinfo = dict["data"] as! [String: AnyObject]
            self.adjustDataToChange([scripinfo] as [[String: AnyObject]])
        };
        
        self.socketObj.on("fullMarketWatch") {response, ack in
            
            let dict = response[0] as! [String: AnyObject]
            let weather = dict["data"] as! [AnyObject]
            self.allData = weather
            self.manageSocketDataJAson(weather as AnyObject)
            
        };
    }
    
    func manageSocketDataJAson(_ weather: AnyObject)
    {
        var markets = [String]()
        
        for scripinfo in weather as! [[String: AnyObject]] {
            
            if !(markets.contains((scripinfo["market"] as! String)))
            {
                markets.append((scripinfo["market"] as! String))
            }
            
        }
        
        let defaults = UserDefaults.standard
        defaults.set(markets, forKey: "markets")
        defaults.synchronize()
        
        let strJason = weather as! [[String: AnyObject]]
        self.adjustDataToChange(strJason as! [[String:AnyObject]])
        // self.allData.append(newScrip)
    }
    
    
    func adjustDataToChange(_ weather:[[String: AnyObject]] )
    {
        for scripinfo in weather as! [[String : AnyObject]] {
            
            let newScrip = CurrencyModel.init(symbolId: scripinfo["symbolId"] as! Int,
                                              buyQty: (scripinfo["buyQty"] as! Array<String>),
                                              buyRate: (scripinfo["buyRate"] as! Array<String>),
                                              sellQty: (scripinfo["sellQty"] as! Array<String>),
                                              sellRate: (scripinfo["sellRate"] as! Array<String>),
                                              displayName: (scripinfo["displayName"] as! String),
                                              expiryDate: scripinfo["expiryDate"] as? String,
                                              loadMaxQty: (scripinfo["loadMaxQty"] as! String),
                                              lotSize: scripinfo["lotSize"] as? String,
                                              ltp: (scripinfo["ltp"] as! String),
                                              margin: scripinfo["margin"] as? String,
                                              marginType: scripinfo["marginType"] as? String,
                                              market: (scripinfo["market"] as! String),
                                              moq: (scripinfo["moq"] as! String),
                                              prevTick: (scripinfo["prevTick"] as! String),
                                              priority: scripinfo["priority"] as? String,
                                              startRate: (scripinfo["startRate"] as! String),
                                              symbolName: (scripinfo["symbolName"] as! String),
                                              symbolType: scripinfo["symbolType"] as! Int,
                                              tempRates: (scripinfo["tempRates"] as! String),
                                              tickSize: (scripinfo["tickSize"] as! String),
                                              todayChange: (scripinfo["todayChange"] as! String),
                                              todayHigh: (scripinfo["todayHigh"] as! String),
                                              todayLow: (scripinfo["todayLow"] as! String),
                                              volatilePercentDown: (scripinfo["volatilePercentDown"] as! String),
                                              volatilePercentUp: (scripinfo["volatilePercentUp"] as! String),
                                              volume: (scripinfo["volume"] as! String))
            
            // self.notifyObservers(updates: newScrip)
            
            if(scripinfo["market"] as! String=="USD")
            {
                self.notifyObserversUSD(updates: newScrip)
            }
            else if(scripinfo["market"] as! String=="FCC")
            {
                self.notifyObserversFCC(updates: newScrip)
            }
            else if(scripinfo["market"] as! String=="ETH")
            {
                self.notifyObserversETH(updates: newScrip)
            }
            else if(scripinfo["market"] as! String=="BTC")
            {
                self.notifyObserversBTC(updates: newScrip)
            }
        }
    }
    
    
    
    
    func subscribe(_ observer:PcexServiceListenerProtocolDemo){
        if observers.count == 0 {
            //Connect the server
            socketObj.connect()
            self.controllerCheck.append(observer)
        }
        observers[observer.objectID] = observer
        
        
        for obui in self.controllerCheck {
            if(obui.objectID == observer.objectID)
            {
                
            }
            else
            {
                self.manageSocketDataJAson(allData as AnyObject)
                self.controllerCheck.append(observer)
                break;
            }
        }
        
        //        if !self.controllerCheck.contains(observer as! String)
        //        {
        //            self.manageSocketDataJAson(allData as AnyObject)
        //        }
        
    }
    func unsubscribe(_ observer:PcexServiceListenerProtocolDemo){
        observers[observer.objectID] = nil
        if observers.count == 0 {
            //Disconnect the server
            socketObj.disconnect()
        }
    }
    
    //    func sendStoredDatatoObserver()
    //    {
    //
    //        for (_,observer) in observers {
    //            observer.receivedUpdates(scrip)
    //        }
    //    }
    

    func notifyObserversUSD(updates scrip:CurrencyModel)
    {
        for (_,observer) in observers {
            observer.receivedUpdatesForUSD(scrip)
        }
    }
    
    func notifyObserversFCC(updates scrip:CurrencyModel)
    {
        for (_,observer) in observers {
            observer.receivedUpdatesForFCC(scrip)
        }
    }
    
    func notifyObserversBTC(updates scrip:CurrencyModel)
    {
        for (_,observer) in observers {
            observer.receivedUpdatesForBTC(scrip)
        }
    }
    
    func notifyObserversETH(updates scrip:CurrencyModel)
    {
        for (_,observer) in observers {
            observer.receivedUpdatesForETH(scrip)
        }
    }
    
}


