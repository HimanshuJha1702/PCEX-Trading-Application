//
//  WithdrawalVC.swift
//  PCEX
//
//  Created by RAHUL BANSAL on 3/24/19.
//  Copyright © 2019 Chhagan SIngh. All rights reserved.
//

import UIKit
import Foundation
import IQDropDownTextField
import SwiftyJSON
import SDWebImage
import IQKeyboardManagerSwift
import NotificationBannerSwift


class WithdrawalVC: UIViewController, UITextFieldDelegate,IQDropDownTextFieldDataSource {
    
    @IBOutlet weak var imgCurrency: UIImageView!
    @IBOutlet weak var lblCurrencyName: UILabel!
    @IBOutlet weak var txtWalletAddress: UITextField!
    @IBOutlet weak var txtAmount: UITextField!
    @IBOutlet weak var btnSUbmit: UIButton!
    
    @IBOutlet weak var viewWithDrawal: UIView!
    var imglogoPath: String!
    var currenyName: String!
    
    var paramsWithDrawal: [String:Any]!
    var transaferFormData = false
    var paypalWithdraw = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imgCurrency.sd_setImage(with: URL(string: self.imglogoPath), placeholderImage: UIImage(named: "placeholder.png"))
        lblCurrencyName.text = currenyName
        btnSUbmit.isEnabled = false
        
        self.btnSUbmit.layer.cornerRadius = 5
        self.btnSUbmit.layer.borderColor = (UIColor(hexString: GREEN_COLOR_CUSTOM)).cgColor
        self.btnSUbmit.layer.borderWidth = 2
        self.btnSUbmit.backgroundColor = (UIColor(hexString: GREEN_COLOR_CUSTOM))
        
        
        self.viewWithDrawal.clipsToBounds = true
        self.viewWithDrawal.layer.cornerRadius = 15
        if #available(iOS 11.0, *) {
            self.viewWithDrawal.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner, .layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        } else {
            self.viewWithDrawal.roundedAllCorner()
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillAppear(_ animated: Bool) {
        
        // self.getNetposition()
        
    }
    
    
    @IBAction func btnTermsCondition(_ sender: UIButton) {
        
        if(sender.isSelected)
        {
            sender.isSelected = false
            btnSUbmit.isEnabled = false
        }
        else
        {
            
            if((txtWalletAddress.text?.isEmpty)! || txtWalletAddress.text == "" || txtAmount.text == "" || (txtAmount.text?.isEmpty)!)
            {
                let alert = UIAlertController(title: "PCEX", message: "Wallet address and amount must be filled, with Valid wallet address.", preferredStyle: UIAlertController.Style.alert)
                
                // add an action (button)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                
                // show the alert
                self.present(alert, animated: true, completion: nil)
                
                return
            }
            
            btnSUbmit.isEnabled = true
            sender.isSelected = true
        }
    }
    
    @IBAction func btnSubmit(_ sender: Any) {
        
        if(txtAmount.text == "" || txtAmount.text!.isEmpty || txtWalletAddress.text == "" || txtWalletAddress.text!.isEmpty || txtWalletAddress.text!.count<=6)
        {
            let alert = UIAlertController(title: "PCEX", message: "Wallet address and amount must be filled, with Valid wallet address.", preferredStyle: UIAlertController.Style.alert)
            
            // add an action (button)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            
            // show the alert
            self.present(alert, animated: true, completion: nil)
            
            return
        }
        
        
        self.sendRequestForWithdrawal()
        
        
    }
    
    
    func sendRequestForWithdrawal()  {
        
        if(transaferFormData){
            paramsWithDrawal = ["process":1,"amount":txtAmount.text!,"currency":"USD"]
        }
        else if(paypalWithdraw)
        {
            paramsWithDrawal = ["process":2,"amount":txtAmount.text!,"currency":"USD","address":"paypaladdress"]
        }
        else
        {
            paramsWithDrawal = ["process":3,"amount":txtAmount.text!,"currency":currenyName,"address":txtWalletAddress.text!]
        }
        
        
        Api.request(endpoint: .getWithdrawal(params: paramsWithDrawal)) { (JSON) in
            if(JSON["status"] == 200)
            {
                let banner = StatusBarNotificationBanner(title: JSON["message"].stringValue, style: .success)
                banner.dismiss()
                banner.show()
                self.navigationController?.popViewController(animated: true)
            }
            else
            {
                
//                let alert = UIAlertController(title: "PCEX", message: JSON["message"].stringValue, preferredStyle: UIAlertController.Style.alert)
//                
//                // add an action (button)
//                alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
//                
//                // show the alert
//                self.present(alert, animated: true, completion: nil)
                
                let banner = StatusBarNotificationBanner(title: JSON["message"].stringValue, style: .success)
                banner.dismiss()
                banner.show()
                self.navigationController?.popViewController(animated: true)
            }
            
        }
        
    }
    
}
