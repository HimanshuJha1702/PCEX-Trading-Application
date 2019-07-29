//
//  Service.swift
//  PCEX
//
//  Created by CHHAGAN on 12/03/19.
//  Copyright © 2019 Chhagan SIngh. All rights reserved.
//

import Foundation
import Starscream
import SocketIO
import SwiftyJSON
import NotificationBannerSwift

protocol PcexServiceListenerProtocol {
    var objectID : Int! {get}
    func receivedUpdatesForUSD(_ scrip:CurrencyModel)
    func receivedUpdatesForBTC(_ scrip:CurrencyModel)
    func receivedUpdatesForFCC(_ scrip:CurrencyModel)
    func receivedUpdatesForETH(_ scrip:CurrencyModel)
    
    //for all currencies
    func receivedUpdates(_ scrip:CurrencyModel)
}

protocol PcexServiceWalletsProtocol {
    var objectID : Int! {get}
    func receivedUpdatesForWallets(_ scrip:AnyObject)
    
}


protocol ordersUpdateDelegate:class {
    func receiveOrdersUpdate(scrip:JSON)
}

protocol logsUpdateDelegate:class {
    func receiveLogsUpdate(scrip:JSON)
}



struct GlobalVariables {
    
    static var NavHeight: CGFloat!
    
    
    static var globalString = "MyString"
    static var myWalletList = [AnyObject]()
    static var orders = [JSON]()
    static var pendingOrders = [JSON]()
    static var trades = [JSON]()
    static var logs = [JSON]()
    static var myFavs = [CurrencyModel]()
    
    static var currenciesImages = [String:String]()
    
    //var fullMarketWatch
    var allMarketRms = [AnyObject]()
    var netPositionObject = [AnyObject]()
    
    var selectedMarketObject = [AnyObject]()
    var M2M = [AnyObject]()
    var RMS = [AnyObject]()
    var RMSList = [AnyObject]()
    
    var selectedM2MObject = [ "m2m": 0, "qty": 0 ];
    var selectedRMSObject = [ "rms": 0, "qty": 0 ];
    var netPositionObj = ["net": 0, "qty": 0 ];
    
   
}


class Service {
    
    
        weak var delegate: ordersUpdateDelegate?
        weak var delegateLogs: logsUpdateDelegate?
    
    
    static let shared = Service()
    //let  socket :SocketIOClient!
    //demo :- https://pcex.io:3333/socket.io/
    //live :- https://pcex.io:4444/socket.io/
    
  //  let manager = SocketManager(socketURL:  URL(string: AppDelegateGlobal.SocketUrl)!, config: [.log(false)])
    
    //live for testing
     let manager = SocketManager(socketURL:  URL(string: "https://pcex.io:4444/socket.io/")!, config: [.log(false)])
    
    //demo for testing
    //let manager = SocketManager(socketURL:  URL(string: "https://pcex.io:3333/socket.io/")!, config: [.log(false)])
    
    var socketObj:SocketIOClient!
    
    var observers = [Int:PcexServiceListenerProtocol]()
    var obsWallet = [Int:PcexServiceWalletsProtocol]()
    
    
    var allData = [AnyObject]()
    var wallets = [AnyObject]()
    
    
    
    
    var myorders: [String: AnyObject] = ["pageNumber": 1 as AnyObject,"data": [] as AnyObject,"hasMore": true as AnyObject]
    var trades: [String: AnyObject] = ["pageNumber": 1 as AnyObject,"data": [] as AnyObject,"hasMore": true as AnyObject]
    var pendingOrders: [String: Any] = ["pageNumber": 1,"data": [],"hasMore": true]
    var ledgers: [String: Any] = ["pageNumber": 1,"data": [],"hasMore": true, "currency":"USD", "openingBalance":0, "closingBalance":0]
    let logs: [String: Any] = ["pageNumber": 1,"data": [],"hasMore": true]
    let brokers: [String: Any] = ["pageNumber": 1,"data": [],"hasMore": true]
    let allWallets: [String: Any] = ["data": []]
    
    
    static let userId = APP_Defaults.value(forKey: "userId") as! Int
    static let sessionId = APP_Defaults.value(forKey: "sessionId") as! String
    static let fastSessionId = APP_Defaults.value(forKey: "fastSessionId") as! Int
    
    let userdetail = ["userId":userId,"fastSessionId":fastSessionId,"sessionId":sessionId] as Any
    
    let sessionUser: [String : Any]  = ["userId":userId,"fastSessionId":fastSessionId,"sessionId":sessionId]
    
    var controllerCheck = [PcexServiceListenerProtocol]()
    
    init() {
        
        
        let userdetaiSessionl = ["userId":Service.userId,"fastSessionId":Service.fastSessionId,"sessionId":Service.sessionId] as [String : Any]
       
        
        self.socketObj = manager.defaultSocket
        //self.setSocketEvents()
        self.socketObj.on(clientEvent: .connect) {data, ack in
            //self.socketObj.write(string: "{\"command\":\"subscribe\",\"channel\":\"1002\"}")
            let banner = StatusBarNotificationBanner(title: "Connected", style: .success)
            banner.dismiss()
            banner.show()
            print("websocket is connected")
            //self.socketObj.emit("storeSession", ["userId":Service.userId,"fastSessionId":Service.fastSessionId,"sessionId":Service.sessionId])
            //self.socketObj.emit("storeSession", [userdetaiSessionl])
             print("data sent to server",userdetaiSessionl)
            self.socketObj.emit("storeSession", with: [userdetaiSessionl])
        };
        
        
        self.socketObj.on(clientEvent: .disconnect) {data, ack in
            let banner = StatusBarNotificationBanner(title: "Diconnected", style: .danger)
            banner.dismiss()
            banner.show()
            print("socket disconnect");
        }
        
        
        /*
         // MARK: - Navigation
         get market data dynamically on market change
         */
        self.socketObj.on("marketWatchChanged") {response, ack in
            // print("***** marketWatchChanged")
            let dict = response[0] as! [String: AnyObject]
            let scripinfo = dict["data"] as! [String: AnyObject]
            self.adjustDataToChange([scripinfo] as [[String: AnyObject]])
        };
        
//        /*
//         // MARK: - Navigation
//         get notifications
//         */
        self.socketObj.on("notification") {response, ack in
            print("***** notification",response)
//            let dict = response[0] as! [String: AnyObject]
//            let scripinfo = dict["data"] as! [String: AnyObject]
//            self.adjustDataToChange([scripinfo] as [[String: AnyObject]])
        };
//        /*
//         // MARK: - Navigation
//         get storeSessionResult
//         */
        self.socketObj.on("storeSessionResult") {response, ack in
            print("***** storeSessionResult",response)
//            let dict = response[0] as! [String: AnyObject]
//            let scripinfo = dict["data"] as! [String: AnyObject]
//            self.adjustDataToChange([scripinfo] as [[String: AnyObject]])
        };
//
//        /*
//         // MARK: - Navigation
//         get storeSessionResult
//         */
        self.socketObj.on("kycNotifier") {response, ack in
            print("***** kycNotifier",response)
//            let dict = response[0] as! [String: AnyObject]
//            let scripinfo = dict["data"] as! [String: AnyObject]
//            self.adjustDataToChange([scripinfo] as [[String: AnyObject]])
        };


        
//        /*
//         // MARK: - Navigation
//         get all markets data
//         */
        
        self.socketObj.on("fullMarketWatch") {response, ack in
             print("***** fullMarketWatch")
            let dict = response[0] as! [String: AnyObject]
            let weather = dict["data"] as! [AnyObject]
            self.allData = weather
            self.manageSocketDataJAson(weather as AnyObject)
            
        };
        
        /*
         // MARK: - Navigation
         get wallets data dynamically
         */
        self.socketObj.on("getWalletsResult") { response, ack in
            print("***** getWalletsResult")
            let dict = response[0] as! [String: AnyObject]
            let weather = dict["data"] as! [AnyObject]
            
            self.wallets = weather
            
            GlobalVariables.myWalletList = weather
            
  
            
            for scripinfo in weather as! [[String: AnyObject]] {
                var dict = scripinfo
                GlobalVariables.currenciesImages.updateValue((dict["path"] as! String), forKey: (dict["currency"] as! String))
            }
            
            
            
        }
        /*
         // MARK: - Navigation
         notifiyers for every notification
         */
        
        self.socketObj.on("notifier") {response, ack in
            print("***** notifier",response)
//            let dict = response[0] as! [String: AnyObject]
//            //let obj = dict["type"] as! String
//            let notifier = dict["message"] as! String
//
//            let banner = StatusBarNotificationBanner(title: notifier, style: .info)
//            banner.dismiss()
//            banner.show()
        }
        
        
        /*
         // MARK: - Navigation
         notifiyers for every notification
         */
        self.socketObj.on("depositNotifier") {response, ack in
            
            let dict = response[0] as! [String: AnyObject]
            //let obj = dict["type"] as! String
            let notifier = dict["message"] as! String

            let banner = StatusBarNotificationBanner(title: notifier, style: .info)
            banner.dismiss()
            banner.show()

        }
        
        /*
         // MARK: - Navigation
         get list of CustomMarket
         */
        
//        self.socketObj.on("listCustomMarket") {response, ack in
//
//            let dict = response[0] as! [String: AnyObject]
//            //let obj = dict["type"] as! String
//            let notifier = dict["message"] as! String
//
//            let banner = StatusBarNotificationBanner(title: notifier, style: .info)
//            banner.dismiss()
//            banner.show()
//        }
        
        /*
         // MARK: - Navigation
         get orders changed
         */
        
        self.socketObj.on("ordersChanged") {response, ack in
             print("***** getOrdersChanged")
            let dict = response[0] as! [String: AnyObject]
            
          // let weather = dict["data"] as! JSON
            let quoteDictionary = dict["data"] as! Dictionary<String,AnyObject>
           // print("weather",quoteDictionary)
            
            let jsonData = try? JSONSerialization.data(withJSONObject: quoteDictionary, options: [])
            let jsonString = String(data: jsonData!, encoding: .utf8)

            
            if let dataFromString = jsonString!.data(using: .utf8, allowLossyConversion: false) {
                let pixer = try! JSON(data: dataFromString)
                GlobalVariables.orders = [pixer]
                self.notifyOvserverOrdersUpdate(updates: pixer)
               // print(pixer)
            }
        };
        
        /*
         // MARK: - Navigation
         get trades Changed
         */
        
        self.socketObj.on("tradesChanged") {response, ack in
             print("***** getTradesChanged")
            let dict = response[0] as! [String: AnyObject]
            let quoteDictionary = dict["data"] as! Dictionary<String,AnyObject>
           // print("weather",quoteDictionary)
            
            let jsonData = try? JSONSerialization.data(withJSONObject: quoteDictionary, options: [])
            let jsonString = String(data: jsonData!, encoding: .utf8)
            
            
            if let dataFromString = jsonString!.data(using: .utf8, allowLossyConversion: false) {
                let pixer = try! JSON(data: dataFromString)
                GlobalVariables.trades = [pixer]
                self.notifyOvserverOrdersUpdate(updates: pixer)
                // print(pixer)
            }

        };
        
        /*
         // MARK: - Navigation
         get Trades Result
         */
        
        self.socketObj.on("getTradesResult") {response, ack in
            print("***** getTradesResult")
            
//            let jsonData = try? JSONSerialization.data(withJSONObject:response)
//
//            let json = try? JSON(data: jsonData!)
//             print("***** getTradesResult",json)
            
            let dict = response[0] as! [String: AnyObject]
            let quoteDictionary = dict["data"] as! Array<AnyObject>
            //print("weather",quoteDictionary)
            
            let jsonData = try? JSONSerialization.data(withJSONObject: quoteDictionary, options: [])
            let jsonString = String(data: jsonData!, encoding: .utf8)
            
            
            if let dataFromString = jsonString!.data(using: .utf8, allowLossyConversion: false) {
                let pixer = try! JSON(data: dataFromString)
                GlobalVariables.trades = pixer.arrayValue
                self.notifyOvserverOrdersUpdate(updates: pixer)
                // print(pixer)
            }
           // GlobalVariables.trades = json!.arrayValue
            
//            let dict = response[0] as! [String: AnyObject]
//            let weather = dict["data"] as! [AnyObject]
//            self.allData = weather
//            self.manageSocketDataJAson(weather as AnyObject)

        };
        
        
        
        
        /*
         // MARK: - Navigation
         get Broker Result
         */
        
//        self.socketObj.on("getBrokerResult") {response, ack in
//
//            let dict = response[0] as! [String: AnyObject]
//            let weather = dict["data"] as! [AnyObject]
//            self.allData = weather
//            self.manageSocketDataJAson(weather as AnyObject)
//
//        };
        
        
        /*
         // MARK: - Navigation
         get broker Changed
         */
        
//        self.socketObj.on("brokerChanged") {response, ack in
//
//            let dict = response[0] as! [String: AnyObject]
//            let weather = dict["data"] as! [AnyObject]
//            self.allData = weather
//            self.manageSocketDataJAson(weather as AnyObject)
//
//        };
        
        
        /*
         // MARK: - Navigation
         get Ledger Result
         */
        
        self.socketObj.on("getLedgerResult") {response, ack in
            print("***** getLedgerResult",response)
//            let dict = response[0] as! [String: AnyObject]
//            let weather = dict["data"] as! [AnyObject]
//            self.allData = weather
//            self.manageSocketDataJAson(weather as AnyObject)

        };
        
        /*
         // MARK: - Navigation
         get MTM For User Result
         */
        
        self.socketObj.on("getMTMForUserResult") {response, ack in
            print("***** getMTMForUserResult",response)
//            let dict = response[0] as! [String: AnyObject]
//            let weather = dict["data"] as! [AnyObject]
//            self.allData = weather
//            self.manageSocketDataJAson(weather as AnyObject)

        };

        /*
         // MARK: - Navigation
         get RMS of Users
         */
        
        self.socketObj.on("getRMSForMEResult") {response, ack in
             print("***** getRMSForMEResult",response)
//            let dict = response[0] as! [String: AnyObject]
//            let weather = dict["data"] as! [AnyObject]
//            self.allData = weather
//            self.manageSocketDataJAson(weather as AnyObject)
            
        };
        
        
        /*
         // MARK: - Navigation
         get logs of Users
         */
        
        self.socketObj.on("getLogsResult") {response, ack in
            print("***** getLogsResult")
            let dict = response[0] as! [String: AnyObject]
            let quoteDictionary = dict["data"] as! Array<AnyObject>
          //  print("weather",quoteDictionary)
            
            let jsonData = try? JSONSerialization.data(withJSONObject: quoteDictionary, options: [])
            let jsonString = String(data: jsonData!, encoding: .utf8)
            
            
            if let dataFromString = jsonString!.data(using: .utf8, allowLossyConversion: false) {
                let pixer = try! JSON(data: dataFromString)
                GlobalVariables.logs = pixer.arrayValue
                self.notifyOvserverOrdersUpdate(updates: pixer)
            }
            
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
            
             self.notifyObservers(updates: newScrip)
            
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
    
    
    func subscribe(_ observer:PcexServiceListenerProtocol){
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
        
    }
    
    func unsubscribe(_ observer:PcexServiceListenerProtocol){
        observers[observer.objectID] = nil
        if observers.count == 0 {
            //Disconnect the server
            socketObj.disconnect()
        }
    }
    
    
    func notifyObservers(updates scrip:CurrencyModel) {
        for (_,observer) in observers {
            observer.receivedUpdates(scrip)
        }
    }
    
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
    
    // wallets listner
    func subscWallets(_ observer:PcexServiceWalletsProtocol){
        
        obsWallet[observer.objectID] = observer
        
    }
    func unsubscWalletsl(_ observer:PcexServiceWalletsProtocol){
        obsWallet[observer.objectID] = nil
        
    }
    
    func notifyObserverWalletListner(updates scrip: AnyObject) {
        for (_,observer) in obsWallet {
            observer.receivedUpdatesForWallets(wallets as AnyObject)
        }
    }
    
    
    func notifyOvserverOrdersUpdate(updates scrip:JSON) {
        
        delegate?.receiveOrdersUpdate(scrip: scrip)
        //delegate?.myVCDidFinish(scrip)
    }
    
    
    func notifyLogsUpdate(updates scrip:JSON) {
        
        delegateLogs?.receiveLogsUpdate(scrip: scrip)
        //delegate?.myVCDidFinish(scrip)
    }
    /*
     // MARK: - Navigation
     wallets emiting
     */
    
    func getWallets()
    {
        let userss = self.sessionUser as Any
        self.socketObj.emit("getWallets", with: [userss])
    }
    
    /*
     // MARK: - Navigation
     All methods of scoket like in front end
     */
    func getOrders() {
        
        let pageNumber = self.myorders["pageNumber"] as! Int
        
        Api.request(endpoint: .getOrders(pageNumber: pageNumber)) { (data) in
            if data["status"] == 200
            {
                self.myorders.updateValue(data["data"] as AnyObject, forKey: "data")
                self.myorders.updateValue(data["pageNumber"] as AnyObject, forKey: "pageNumber")
                self.myorders.updateValue(data["hasMore"] as AnyObject, forKey: "hasMore")
            }
        }
    }
    
    func  getPendingOrders() {
        
//        let pageNumber = self.pendingOrders["pageNumber"] as! Int
//        let filters = self.pendingOrders["filters"] as! [String:String]
//        
//        Api.request(endpoint: .getPendingOrders(pageNumber: pageNumber, filters: filters)) { (data) in
//            if data["status"] == 200
//            {
//                self.pendingOrders.updateValue(data["data"] as AnyObject, forKey: "data")
//                self.pendingOrders.updateValue(data["pageNumber"] as AnyObject, forKey: "pageNumber")
//                self.pendingOrders.updateValue(data["hasMore"] as AnyObject, forKey: "hasMore")
//            }
//        }
    }
    
    func getNextTradesFromSocket() {
        
        if (self.trades["hasMore"] as! Bool == true)
        {
            self.trades.updateValue(false as AnyObject, forKey: "hasMore")
            var pageNumber = self.trades["pageNumber"] as! Int;
            pageNumber+=1
            var moreTrades  = [String:Any]();
            moreTrades = self.sessionUser
            moreTrades.updateValue(pageNumber, forKey: "pageNumber")
            self.socketObj.emit("getTrades", with: [moreTrades as Any])
        }
        
    }
    
    
    func getPrevTradesFromSocket() {
        if (self.trades["hasMore"] as! Int > 1) {
            var pageNumber = self.trades["pageNumber"] as! Int;
            pageNumber-=1
            
            var moreTrades  = [String:Any]();
            moreTrades = self.sessionUser
            moreTrades.updateValue(pageNumber, forKey: "pageNumber")
            self.socketObj.emit("getTrades", with: [moreTrades as Any])
        }
    }
    
    func  getNextLedgersFromSocket(currency:String) {
        if (self.ledgers["hasMore"] as! Bool == true)
        {
            self.ledgers.updateValue(false as AnyObject, forKey: "hasMore")
            self.ledgers["data"] = []
            self.ledgers["openingBalance"] = 0
            self.ledgers["closingBalance"] = 0
            
            self.ledgers["currency"] = currency
            
            var pageNumber = self.ledgers["pageNumber"] as! Int;
            pageNumber+=1
            
            
            var moreLedgers  = [String:Any]();
            moreLedgers = self.sessionUser
            moreLedgers.updateValue(pageNumber, forKey: "pageNumber")
            moreLedgers.updateValue(currency, forKey: "currency")
            
            self.socketObj.emit("getLedgers", with: [moreLedgers as Any])
        }
    }
    
    
    func getPrevLedgersFromSocket(currency : String) {
        if (self.trades["hasMore"] as! Int > 1) {
            self.ledgers["data"] = []
            self.ledgers["openingBalance"] = 0
            self.ledgers["closingBalance"] = 0
            self.ledgers["currency"] = currency
            
            var pageNumber = self.ledgers["pageNumber"] as! Int;
            pageNumber-=1
            var moreLedgers  = [String:Any]();
            moreLedgers = self.sessionUser
            moreLedgers.updateValue(pageNumber, forKey: "pageNumber")
            moreLedgers.updateValue(currency, forKey: "currency")
            
            self.socketObj.emit("getLedgers", with: [moreLedgers as Any])
        }
    }
    
    
}
