//
//  USDWithDraw.swift
//  PCEX2
//
//  Created by CHHAGAN SINGH on 5/24/19.
//  Copyright © 2019 Panaesha Capital pvt. ltd. All rights reserved.
//

import UIKit
import Foundation
import SwiftyJSON
import IQKeyboardManagerSwift
import NotificationBannerSwift
class USDWithDraw: UIViewController {
    
    @IBOutlet var viewWireTransfer: UIView!
    @IBOutlet var viewPayPal: UIView!

    @IBOutlet var viewCryptoWithDrwal: UIView!
    
      @IBOutlet var btnCollection: [UIButton]!
    
      var scrollView: UIScrollView!
    
    @IBOutlet weak var txtChooseBank: UITextField!
    @IBOutlet weak var txtWithDrawalAmount: UITextField!
    @IBOutlet weak var lblAccountHolderName: UILabel!
    @IBOutlet weak var lblAccountNumber: UILabel!
    @IBOutlet weak var lblBankName: UILabel!
    @IBOutlet weak var lblIfscCode: UILabel!
    @IBOutlet weak var lblSwiftCode: UILabel!
    @IBOutlet weak var txtPPWiithAmount: UITextField!
    @IBOutlet weak var txtPayPalAddress: UITextField!
    
    @IBOutlet weak var txtCryptoWalletAddress: UITextField!
    
    @IBOutlet weak var txtCryptoAmount: UITextField!
    
    @IBOutlet var btnTnCCollection: [UIButton]!
    
     var processPay:Int! = 0
    var isCrypto:Bool! = false
    
    var paramsWithDrawal: [String:Any]!
    var imglogoPath: String!
    var currenyName: String!
    
    class func initFromWithoutStoryboard() -> USDWithDraw {
        let animalViewController = USDWithDraw(nibName: "USDWithDraw", bundle: nil)
        return animalViewController
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        
        for btn in btnTnCCollection {
            btn.isSelected = false
        }
        
        if(isCrypto)
        {
            let width = UIScreen.main.bounds.width
            let height = UIScreen.main.bounds.height
            
            scrollView = UIScrollView(frame: CGRect(x: 0, y: 20, width: view.frame.size.width, height: view.frame.size.height))
            scrollView.backgroundColor = .white
            view.addSubview(scrollView)
            scrollView.addSubview(viewCryptoWithDrwal)
            viewCryptoWithDrwal.frame = CGRect(
                x: 0, y: 20, width: width, height: viewCryptoWithDrwal.frame.size.height)
            if(height > 730)
            {
                scrollView.updateContentView()
            }
            else
            {
                scrollView.contentSize = CGSize(width: width, height: 1100)
            }
        }
    }

    @IBAction func btnChooseWithdrawalAction(_ sender: UIButton) {
        
        for btn in btnCollection {
            btn.isSelected = false
            
            if(btn.tag == sender.tag)
            {
                btn.isSelected = true
            }
        }
        
        
        scrollView = UIScrollView(frame: CGRect(x: 0, y: 20, width: view.frame.size.width, height: view.frame.size.height))
        scrollView.backgroundColor = .white
        view.addSubview(scrollView)
        //
        let height = UIScreen.main.bounds.height
        let width = UIScreen.main.bounds.width
        if(sender.tag == 1)
        {
            scrollView.addSubview(viewWireTransfer)
            viewWireTransfer.frame = CGRect(
                x: 0, y: 20, width: width, height: viewWireTransfer.frame.size.height)
            if(height > 730)
            {
                scrollView.updateContentView()
            }
            else
            {
                scrollView.contentSize = CGSize(width: width, height: 1100)
            }
        }
        else if(sender.tag == 2)
        {
            scrollView.addSubview(viewPayPal)
            viewPayPal.frame = CGRect(
                x: 0, y: 20, width: width, height: viewPayPal.frame.size.height)
        }
        else if(sender.tag == 3)
        {
            scrollView.addSubview(viewWireTransfer)
            viewWireTransfer.frame = CGRect(
                x: 0, y: 20, width: width, height: viewWireTransfer.frame.size.height)
            
            if(height > 730)
            {
                scrollView.updateContentView()
            }
            else
            {
                scrollView.contentSize = CGSize(width: width, height: 1100)
            }
        }

        
        //scrollView.contentSize = CGSize(width: view.frame.size.width, height: view.frame.size.height)
        
    }
    
    @IBAction func btnConditionApply(_ sender: UIButton) {
        
        for btn in btnTnCCollection {
            btn.isSelected = false
            
            if(btn.tag == sender.tag)
            {
                btn.isSelected = true
            }
        }
        
    }
    
    
    @IBAction func btnCancelAction(_ sender: UIButton) {
        
        if(sender.tag == 1)
        {
            self.viewWireTransfer.removeFromSuperview()
        }
        else if(sender.tag == 2)
        {
            self.viewPayPal.removeFromSuperview()
        }

        
        scrollView.removeFromSuperview()
        
        for btn in btnCollection {
            btn.isSelected = false
        }
    }


    @IBAction func btnSubmitWireBankWithdrawal(_ sender: Any) {
        
        processPay = 1
        
        if(checkAllFields())
        {
            print("working fine")
            self.sendRequestForWithdrawal()
        }
        
    }
    
    @IBAction func btnPPWithdrawal(_ sender: Any) {
        processPay = 2
        
        if(checkAllFields())
        {
            print("working fine")
            self.sendRequestForWithdrawal()
        }
    }
    
    @IBAction func btnSubmitCrypto(_ sender: Any) {
        
        let res1 = txtCryptoAmount.text!.removeWhitespace()
        let res2 = txtCryptoWalletAddress.text!.removeWhitespace()
        
        if(txtCryptoWalletAddress.text!.isEmpty || txtCryptoAmount.text!.isEmpty || res1.isEmpty || res2.isEmpty)
        {
            let banner = StatusBarNotificationBanner(title: "Please fill all fields first.", style: .danger)
            banner.dismiss()
            banner.show()
        }
        
        let amount = Double(txtCryptoAmount.text!)!
        let minAmount = 0.00
        
        if(amount.isLessThanOrEqualTo(minAmount))
        {
            let banner = StatusBarNotificationBanner(title: "Amount should be greater then 0.00", style: .danger)
            banner.dismiss()
            banner.show()
        }
        
        self.sendRequestForWithdrawal()
    }
    
    
    @IBAction func btnCancelCrypto(_ sender: Any) {
        
    }
    
    
    func checkAllFields() -> Bool
    {
        if(processPay == 1)
        {
            let res1 = txtChooseBank.text!.removeWhitespace()
            let res2 = txtWithDrawalAmount.text!.removeWhitespace()
            
            if(txtChooseBank.text!.isEmpty || txtWithDrawalAmount.text!.isEmpty || res1.isEmpty || res2.isEmpty)
            {
                let banner = StatusBarNotificationBanner(title: "Please fill all fields first.", style: .danger)
                banner.dismiss()
                banner.show()
                
                return false
            }
            
            let amount = Double(txtWithDrawalAmount.text!)!
            let minAmount = 0.00
            
            if(amount.isLessThanOrEqualTo(minAmount))
            {
                let banner = StatusBarNotificationBanner(title: "Amount should be greater then 0.00", style: .danger)
                banner.dismiss()
                banner.show()
                return false
            }
            
            
        }
        else if(processPay == 2)
        {
            let res1 = txtPPWiithAmount.text!.removeWhitespace()
            let res2 = txtPayPalAddress.text!.removeWhitespace()
            
            if(txtPPWiithAmount.text!.isEmpty || txtPayPalAddress.text!.isEmpty || res1.isEmpty || res2.isEmpty)
            {
                let banner = StatusBarNotificationBanner(title: "Please fill paypal address and amount", style: .danger)
                banner.dismiss()
                banner.show()
                
                return false
            }
            
            let amount = Double(txtPPWiithAmount.text!)!
            let minAmount = 0.00
            
            if(amount.isLessThanOrEqualTo(minAmount))
            {
                let banner = StatusBarNotificationBanner(title: "Amount should be greater then 0.00", style: .danger)
                banner.dismiss()
                banner.show()
                return false
            }
        }
       
        
        var isConditionApply:Bool! = false
        for btn in btnTnCCollection {
            if(btn.isSelected)
            {
                isConditionApply = true
                return true
            }
        }
        
        if(!isConditionApply)
        {
            let banner = StatusBarNotificationBanner(title: "Select T&C and Privacy Policy First!", style: .danger)
            banner.dismiss()
            banner.show()
            
            return false
        }
        
        return false
    }
    
    func sendRequestForWithdrawal()  {
        
        if(processPay == 1){
            paramsWithDrawal = ["process":1,"amount":txtWithDrawalAmount.text!,"currency":"USD"]
        }
        else if(processPay == 2)
        {
            paramsWithDrawal = ["process":2,"amount":txtPPWiithAmount.text!,"currency":"USD","address":txtPayPalAddress.text!]
        }
        else
        {
            paramsWithDrawal = ["process":3,"amount":txtCryptoAmount.text!,"currency":currenyName,"address":txtCryptoWalletAddress.text!]
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

extension String {
    func replace(string:String, replacement:String) -> String {
        return self.replacingOccurrences(of: string, with: replacement, options: NSString.CompareOptions.literal, range: nil)
    }
    
    func removeWhitespace() -> String {
        return self.replace(string: " ", replacement: "")
    }
}
