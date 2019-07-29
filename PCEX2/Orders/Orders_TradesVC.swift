//
//  Orders_TradesVC.swift
//  PCEX
//
//  Created by CHHAGAN on 3/12/19.
//  Copyright © 2019 Chhagan SIngh. All rights reserved.
//

import UIKit
import Foundation
import SwiftyJSON

class Orders_TradesVC: UIViewController,UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var backWidth: NSLayoutConstraint!
    
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var headerHeightConstrant: NSLayoutConstraint!
    
    @IBOutlet weak var headerView: UIView!
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var viewOrdersTrades: UIView!
    var NavHeight: CGFloat!
    
    @IBOutlet weak var btnNetposition: UIButton!
    @IBOutlet weak var btnOrders: UIButton!
    @IBOutlet weak var headerImgBg: UIImageView!
    let textCellIdentifier = "TextCell"
    @IBOutlet weak var viewTblHeader: UIView!
    
    var checkIsPipe:Bool! = false
    
    var swiftBlogs = [JSON]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // headerHeightConstrant.constant = GlobalVariables.NavHeight
        
        NavHeight = headerView.frame.size.height
        
        if(checkIsPipe)
        {
            self.backWidth.constant = 60
             self.btnBack.isHidden = false
        }
        else
        {
            self.backWidth.constant = 0
            self.btnBack.isHidden = true
            
        }
        
        initPageMenu()
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        navigationController?.navigationBar.isHidden = true
        
        self.getNetposition()
        
    }
    
    @IBAction func btnBackAction(_ sender: Any) {
        
        self.navigationController?.popViewController(animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        // navigationController?.navigationBar.isHidden = false
    }
    
    
    func initPageMenu() {
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.isHidden = true
        viewTblHeader.isHidden = true
        btnOrders.isSelected = true
        
    
        if #available(iOS 11.0, *) {
            self.btnOrders.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
            
               self.btnNetposition.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        } else {
            self.btnOrders.roundedAllCorner()
            self.btnNetposition.roundedAllCorner()
        }

        
        let viewControllers = getViewControllers()
        let option = getPageMenuOption()
        let pageMenu = PageMenuView(
            viewControllers: viewControllers,
            option: option)
        pageMenu.delegate = self
        pageMenu.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        viewOrdersTrades.addSubview(pageMenu)
    }
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return swiftBlogs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "NetPositionCell", for: indexPath) as? NetPositionCell
        //        let cell = tableView.dequeueReusableCell(withIdentifier: textCellIdentifier, for: indexPath)
        
        let row = indexPath.row
      
            cell?.configureCellForIndexPath()
            let dict = swiftBlogs[row]
            // print("dict*******",dict)
            cell!.lblSymbol.text = dict["symbolName"].stringValue
           // cell!.lblOpeningPrice.text = dict["currentPrice"].stringValue
        
        cell!.lblNetQty.text =  String(format:"%.4f",dict["netOrderQty"].doubleValue)
            cell!.lblCurrentMarket.text = String(format:"%.4f",dict["currentPrice"].doubleValue)
            cell!.lblOpeningPrice.text = String(format:"%.4f",dict["openingPrice"].doubleValue)
            cell!.lblMTM.text = String(format:"%.4f",dict["MTM"].doubleValue)
        
        let symbol = (dict["symbolName"].stringValue).lowercased()
        
        let imgPath = "https://www.pcex.io/assets/icons/\(symbol).png"
//        if(symbol == "fcc")
//        {
//            imgPath = "https://www.pcex.io/assets/icons/fcc.png"
//        }
//        else
//        {
//          //  imgPath = "https://cryptoicons.org/api/icon/\(symbol)/20"
//
//
//            let  symbol2 = (dict["symbolName"].stringValue).uppercased()
//            imgPath = "https://www.coineal.com/res/img/coin/\(symbol2).png"
//        }
        
        cell!.imgSymbol.sd_setImage(with: URL(string: imgPath), placeholderImage: UIImage(named: "placeholder.png"))
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60.0;
    }
    @IBAction func btnOrdersAction(_ sender: Any) {
        
    btnOrders.isSelected = true
        btnNetposition.isSelected = false
        viewOrdersTrades.isHidden = false
        tableView.isHidden = true
        viewTblHeader.isHidden = true
    }
    
    @IBAction func btnNetPositionsAction(_ sender: Any) {
        
        btnOrders.isSelected = false
        btnNetposition.isSelected = true
         viewOrdersTrades.isHidden = true
        tableView.isHidden = false
        viewTblHeader.isHidden = false
        
    }
    func getNetposition()
    {
        
        Api.request(endpoint: .getNetposition(offset: 1)) { (JSON) in
            print("******",JSON)
            
            let userNetData = JSON["data"].array
            
            if(userNetData != nil)
            {
                self.swiftBlogs = JSON["data"].array!
                
                self.tableView.reloadData()
            }
            
            
        }
        
    }
    
}
// MARK: - PageMenuViewDelegate

extension Orders_TradesVC: PageMenuViewDelegate {
    
    func willMoveToPage(_ pageMenu: PageMenuView, from viewController: UIViewController, index currentViewControllerIndex: Int) {
        
        print(viewController.title!)
    }
    
    func didMoveToPage(_ pageMenu: PageMenuView, to viewController: UIViewController, index currentViewControllerIndex: Int) {
        print(viewController.title!)
        print("---")
        if (viewController.title == "Pending")
        {
            let vc = viewController as! OrdersVC
            vc.requestNewForSelectio()
        }
        else
        {
            let vc = viewController as! TradesVC
            vc.reloadViewForTrades()
            
        }
    }
}


// MARK: - Model

extension Orders_TradesVC {
    
    func getPageMenuOption() -> PageMenuOption {
        var option = PageMenuOption(frame: CGRect(
            x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height - NavHeight))
        option.menuItemWidth = view.frame.size.width / 2
        option.menuItemBackgroundColorNormal = .white //UIColor(red:0.388, green:0.424, blue:0.467, alpha:1)
        option.menuItemBackgroundColorSelected = .white //UIColor(red:0.067, green:0.227, blue:0.498, alpha:1)
        option.menuTitleMargin = 12
        option.menuTitleColorNormal = .lightGray
        option.menuTitleColorSelected = UIColor(red:0.067, green:0.227, blue:0.498, alpha:1)
        option.menuIndicatorHeight = 2
        option.menuIndicatorColor = UIColor(red:0.067, green:0.227, blue:0.498, alpha:1)
        return option
    }
    
    func getViewControllers() -> [UIViewController] {
        
       // let markets = ["Orders"]
        
        var viewControllers = [UIViewController]()
//        for name in markets {
            let animalViewController = OrdersVC.initFromStoryboard()
            animalViewController.title = "Pending"
            viewControllers.append(animalViewController)
       // }
        
        let animalViewController2 = TradesVC.initFromStoryboard()
        animalViewController2.title = "Trades"
        viewControllers.append(animalViewController2)
        
        return viewControllers
    }
    
    
}



