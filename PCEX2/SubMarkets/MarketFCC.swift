//
//  MarketFCC.swift
//  PCEX
//
//  Created by CHHAGAN on 3/15/19.
//  Copyright © 2019 Chhagan SIngh. All rights reserved.
//

import Foundation
import UIKit
import Starscream
import NotificationBannerSwift
import Alamofire


protocol FCC_VC_Delegate:class {
    func myVCDidFinish(_ scrip: CurrencyModel)
}


class MarketFCC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    weak var delegate: FCC_VC_Delegate?


    @IBOutlet weak var tradeListerTableViewOutlet: UITableView!
    
    var currenciesListObj = [Int:CurrencyModel]()
    var comparisonNumber: Double?
    
    class func initFromStoryboardforMarketFCC() ->  MarketFCC
    {
        let storyboard = UIStoryboard.init(name: "Main", bundle: Bundle.main)
        let animalViewController = storyboard.instantiateViewController(
            withIdentifier: "MarketFCC") as! MarketFCC
        return animalViewController
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tradeListerTableViewOutlet.delegate = self
        self.tradeListerTableViewOutlet.dataSource = self

        
        self.hideKeyboard()
        
        if Connectivity.isConnectedToInternet {
            print("Yes! internet is available.")
            if(APP_Defaults.bool(forKey: "login"))
            {
                Service.shared.subscribe(self)
            }
            else
            {
                DirectMarketDemo.shared.subscribe(self)
            }
            
        }
        else{
            let banner = StatusBarNotificationBanner(title: "No Network Connection", style: .danger)
            banner.dismiss()
            banner.show()
        }
        
         tradeListerTableViewOutlet.tableFooterView = UIView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.navigationItem.setHidesBackButton(true, animated:true);
        let defaults = UserDefaults.standard
        print("sel",self.title ?? "na")

        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        //Service.shared.unsubscribe(self)
    }

    
    deinit {
        // Service.shared.unsubscribe(self)
    }
    
    // MARK: - Button Action
    @IBAction func signOutBtnAction(_ sender: Any) {
        // Service.shared.unsubscribe(self)
        let banner = StatusBarNotificationBanner(title: "Signed Out", style: .info)
        banner.dismiss()
        banner.show()
        _ = navigationController?.popToRootViewController(animated: true)
    }
    
    // MARK: - View Delegates
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return currenciesListObj.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let scripCell = tableView.dequeueReusableCell(withIdentifier: "traderCellID", for: indexPath) as? ListerTableViewCell
        let scrip = Array(currenciesListObj.values).sorted{$0.symbolId<$1.symbolId}[indexPath.row]
        scripCell?.configure(with: scrip, numberToCompare: comparisonNumber, colorTheme:nil)
        scripCell!.btnAddFav.tag = indexPath.row
        scripCell!.btnAddFav.addTarget(self, action: #selector(btnAddFavRequest(sender:)), for: .touchUpInside)
        
        if GlobalVariables.myFavs.contains(where: { $0.symbolId == scrip.symbolId }) {
            // found
            scripCell!.btnAddFav.isSelected = true
        } else {
            // not
            scripCell!.btnAddFav.isSelected = false
        }
        
        return scripCell!
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60.0;
    }
    
    
    
    // MARK:  UITableViewDelegate Methods
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //showAnimate()
        if(APP_Defaults.bool(forKey: "login"))
        {
            let scrip = Array(currenciesListObj.values).sorted{$0.symbolId<$1.symbolId}[indexPath.row]
            
            delegate?.myVCDidFinish(scrip)
        }
    }
    
    
    @objc func btnAddFavRequest(sender: UIButton){
        
        let scrip = Array(currenciesListObj.values).sorted{$0.symbolId<$1.symbolId}[sender.tag]
        if GlobalVariables.myFavs.contains(where: { $0.symbolId == scrip.symbolId }) {
            // found
            // GlobalVariables.myFavs.append(scrip)
            if let index = GlobalVariables.myFavs.index(where: { $0.symbolId == scrip.symbolId })
            {
                GlobalVariables.myFavs.remove(at: index)
            }
        } else {
            // not
            GlobalVariables.myFavs.append(scrip)
        }
        
       // APP_Defaults.set(GlobalVariables.myFavs, forKey: "favList")
       // APP_Defaults .synchronize()
        
        let indexPath = IndexPath(row: sender.tag, section: 0)
        if tradeListerTableViewOutlet.indexPathsForVisibleRows?.contains(indexPath) ?? false {
            self.tradeListerTableViewOutlet.reloadRows(at: [indexPath], with: .fade)
        }
    }
    
    // MARK: - API Calls
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
}
extension MarketFCC : PcexServiceListenerProtocol, PcexServiceListenerProtocolDemo {
    func receivedUpdates(_ scrip: CurrencyModel) {
        
    }
    
    func receivedUpdatesForUSD(_ scrip: CurrencyModel) {
    }
    
    func receivedUpdatesForBTC(_ scrip: CurrencyModel) {
    }
    
    func receivedUpdatesForETH(_ scrip: CurrencyModel) {
    }
    
    func receivedUpdatesForFCC(_ scrip: CurrencyModel) {
        if (currenciesListObj[scrip.symbolId] != nil){
            let arrayOfTicks = Array(currenciesListObj.values).sorted{$0.symbolId<$1.symbolId}
            var index = 0
            for i in arrayOfTicks {
                if i.symbolId == scrip.symbolId {
                    break
                }
                index = index + 1
            }
            currenciesListObj[scrip.symbolId] = scrip
            let indexPath = IndexPath(row: index, section: 0)
            if tradeListerTableViewOutlet.indexPathsForVisibleRows?.contains(indexPath) ?? false {
                self.tradeListerTableViewOutlet.reloadRows(at: [indexPath], with: .fade)
            }
        }else{
            
            currenciesListObj[scrip.symbolId] = scrip
            //do something if it's an instance of that class
            self.tradeListerTableViewOutlet.reloadData()
        }
    }

    var objectID: Int! {
        return self.hashValue
    }
}

