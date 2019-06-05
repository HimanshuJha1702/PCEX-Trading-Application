//
//  USDDepositVC.swift
//  PCEX2
//
//  Created by RAHUL BANSAL on 5/24/19.
//  Copyright © 2019 Panaesha Capital pvt. ltd. All rights reserved.
//

import UIKit
import Foundation
import IQDropDownTextField
import SwiftyJSON
import SDWebImage
import IQKeyboardManagerSwift
import NotificationBannerSwift

class USDDepositVC: UIViewController,UITextFieldDelegate,IQDropDownTextFieldDataSource {
    
    
    @IBOutlet weak var fixedWidthConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var viewCrypto: UIView!
    @IBOutlet var viewWireTransfer: UIView!
    @IBOutlet var viewGiftCard: UIView!
    
    @IBOutlet var viewPayPal: UIView!
    @IBOutlet var viewDebitCredit: UIView!
    @IBOutlet var btnCollection: [UIButton]!
    
    @IBOutlet weak var txtDCdepositAmount: UITextField!
    @IBOutlet weak var txtDCgateWayFee: UITextField!
    @IBOutlet weak var txtDCtotalAmount: UITextField!
    @IBOutlet weak var txtWBTamountDeposit: UITextField!
    @IBOutlet weak var txtWBTtransactionId: UITextField!
    @IBOutlet weak var txtWBTdateTime: IQDropDownTextField!
    @IBOutlet weak var txtCCcouponCode: UITextField!
    @IBOutlet weak var txtCCcouponPin: UITextField!
    @IBOutlet weak var txtPPtoSendAddress: UITextField!
    @IBOutlet weak var txtPPfromAddress: UITextField!
    @IBOutlet weak var txtPPamount: UITextField!
    @IBOutlet weak var txtPPtransactionId: UITextField!
    @IBOutlet weak var txtPPDateTime: IQDropDownTextField!
    
    @IBOutlet var btnTnCCollection: [UIButton]!
    
    @IBOutlet weak var imgSymbol: UIImageView!
    @IBOutlet weak var txtCryptoAmount: UITextField!
    @IBOutlet weak var imgQRScanCode: UIImageView!
    @IBOutlet weak var lblWalletAddress: UILabel!
    
    @IBOutlet weak var txtTransactionId: UITextField!
    
    var processPay:Int! = 0
    var isCrypto:Bool! = false
    
    var dictResult = [JSON]()
    var addressString: String!
    var imglogoPath: String!
    var currenyName: String!

    
    var scrollView: UIScrollView!
    
    class func initFromWithoutStoryboard() -> USDDepositVC {
        let animalViewController = USDDepositVC(nibName: "USDDepositVC", bundle: nil)
        return animalViewController
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.txtPPDateTime.isOptionalDropDown = false
        self.txtPPDateTime.dropDownMode = IQDropDownMode.datePicker
        
        self.txtWBTdateTime.isOptionalDropDown = false
        self.txtWBTdateTime.dropDownMode = IQDropDownMode.datePicker
        
        for btn in btnTnCCollection {
            btn.isSelected = false
        }
        
        
        if(isCrypto)
        {
            let width = UIScreen.main.bounds.width
            let height = UIScreen.main.bounds.height
            
            imgQRScanCode.image = self.generateQRCode(from: addressString)
            
            imgSymbol.sd_setImage(with: URL(string: self.imglogoPath), placeholderImage: UIImage(named: "placeholder.png"))
            
           // lblCurrencyName.text = currenyName
            lblWalletAddress.text = addressString
            
            
            scrollView = UIScrollView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height))
            scrollView.backgroundColor = .white
            view.addSubview(scrollView)
            scrollView.addSubview(viewCrypto)
            viewCrypto.frame = CGRect(
                x: 0, y: 20, width: width, height: viewCrypto.frame.size.height)
//            if(height > 730)
//            {
//                scrollView.updateContentView()
//            }
//            else
//            {
                scrollView.contentSize = CGSize(width: width, height: 1100)
            //}
        }
        
    }


    @IBAction func btnDebitAction(_ sender: UIButton) {
        
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
        let width = UIScreen.main.bounds.width
        let height = UIScreen.main.bounds.height
        if(sender.tag == 1)
        {
            processPay = 1
            
            scrollView.addSubview(viewDebitCredit)
            viewDebitCredit.frame = CGRect(
                x: 0, y: 20, width: width, height: viewDebitCredit.frame.size.height)
            if(height > 730)
            {
                scrollView.updateContentView()
            }
            else
            {
                
                let tempHeight = 1000 - height
                scrollView.contentSize = CGSize(width: width, height: height+tempHeight)
            }
        }
        else if(sender.tag == 2)
        {
            processPay = 2
            
            scrollView.addSubview(viewGiftCard)
            viewGiftCard.frame = CGRect(
                x: 0, y: 20, width: width, height: viewGiftCard.frame.size.height)
            if(height > 730)
            {
                scrollView.updateContentView()
            }
            else
            {
                scrollView.contentSize = CGSize(width: width, height: height)
            }
        }
        else if(sender.tag == 3)
        {
            processPay = 3
            
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
        else if(sender.tag == 4)
        {
            processPay = 4
            
            scrollView.addSubview(viewPayPal)
            viewPayPal.frame = CGRect(
                x: 0, y: 20, width: width, height: viewPayPal.frame.size.height)
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
    
    
    @IBAction func btnTCApply(_ sender: UIButton) {
        
        for btn in btnTnCCollection {
            btn.isSelected = false
            
            if(btn.tag == sender.tag)
            {
                btn.isSelected = true
            }
        }
    
    }
    
    @IBAction func couponApply(_ sender: Any) {
    }
    
    
    @IBAction func btnCancelAction(_ sender: UIButton) {
       
       if(sender.tag == 1)
       {
        self.viewDebitCredit.removeFromSuperview()
        }
        else if(sender.tag == 2)
       {
        self.viewGiftCard.removeFromSuperview()
        }
       else if(sender.tag == 3)
       {
        self.viewWireTransfer.removeFromSuperview()
        }
       else if(sender.tag == 4)
       {
        self.viewPayPal.removeFromSuperview()
        }
        
        scrollView.removeFromSuperview()
        
        for btn in btnCollection {
            btn.isSelected = false
        }
        
        for btn in btnTnCCollection {
            btn.isSelected = false
        }
    }
    
    
    @IBAction func btnDebitCreditAction(_ sender: Any) {
        
        processPay = 1
        
        if(checkAllFields())
        {
            print("working fine")
            self.depositForCurrency(process: 1, address: "")
        }
    }
    
    @IBAction func btnWireTransFerAction(_ sender: Any) {
        processPay = 3
        if(checkAllFields())
        {
            print("working fine")
            self.depositForCurrency(process: 1, address: "")
        }
    }
    
    @IBAction func btnGiftCardAction(_ sender: Any) {
        
        processPay = 2
        
        if(checkAllFields())
        {
            print("working fine")
            self.depositForCurrency(process: 6, address: "")
        }
    }
    
    @IBAction func btnPayPalAction(_ sender: Any) {
        
        processPay = 4
        
        if(checkAllFields())
        {
            print("working fine")
            self.depositForCurrency(process: 2, address:txtPPfromAddress.text!)
        }
    }
    
    
    @IBAction func btnSubmitCrypto(_ sender: Any) {
        
        let res1 = txtCryptoAmount.text!.removeWhitespace()
        let res2 = txtTransactionId.text!.removeWhitespace()
        
        
        if(txtCryptoAmount.text!.isEmpty || txtTransactionId.text!.isEmpty || res1.isEmpty || res2.isEmpty)
        {
            let banner = StatusBarNotificationBanner(title: "Fields must be filled!", style: .danger)
            banner.dismiss()
            banner.show()
            
            return
        }
        else if(txtTransactionId.text!.count < 6)
        {
            let banner = StatusBarNotificationBanner(title: "Transaction Id's Minimum 6 characters length", style: .danger)
            banner.dismiss()
            banner.show()
            
            return
        }
        
        let amount = Double(txtCryptoAmount.text!)!
        let minAmount = 0.00
        
        if(amount.isLessThanOrEqualTo(minAmount))
        {
            let banner = StatusBarNotificationBanner(title: "Amount should be greater then 0.00", style: .danger)
            banner.dismiss()
            banner.show()
            return
        }
        
        self.depositForCurrency(process: 3, address:"")
        
    }
    
    @IBAction func btnCancelCrypto(_ sender: Any) {
        
        self.navigationController?.popViewController(animated: true)
    }

    func checkAllFields() -> Bool
    {
        if(processPay == 1)
        {
            let res1 = txtDCgateWayFee.text!.removeWhitespace()
            let res2 = txtDCtotalAmount.text!.removeWhitespace()
            let res3 = txtDCdepositAmount.text!.removeWhitespace()
            
            if(txtDCgateWayFee.text!.isEmpty || txtDCtotalAmount.text!.isEmpty || txtDCdepositAmount.text!.isEmpty || res1.isEmpty || res2.isEmpty || res3.isEmpty)
            {
                let banner = StatusBarNotificationBanner(title: "Please fill all fields first.", style: .danger)
                banner.dismiss()
                banner.show()
                
                return false
            }
            
            let amount = Double(txtDCdepositAmount.text!)!
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
            let res1 = txtCCcouponPin.text!.removeWhitespace()
            let res2 = txtCCcouponCode.text!.removeWhitespace()
            
            if(txtCCcouponPin.text!.isEmpty || txtCCcouponCode.text!.isEmpty || res1.isEmpty || res2.isEmpty)
            {
                let banner = StatusBarNotificationBanner(title: "Please fill all fields first.", style: .danger)
                banner.dismiss()
                banner.show()
                
                return false
            }
            
           
        }
        else if(processPay == 3)
        {
            let res1 = txtWBTamountDeposit.text!.removeWhitespace()
            let res2 = txtWBTtransactionId.text!.removeWhitespace()

            
            if(txtWBTamountDeposit.text!.isEmpty || txtWBTtransactionId.text!.isEmpty || res1.isEmpty || res2.isEmpty)
            {
                let banner = StatusBarNotificationBanner(title: "Fields must be filled!", style: .danger)
                banner.dismiss()
                banner.show()
                
                return false
            }
            else if(txtWBTtransactionId.text!.count < 6)
            {
                let banner = StatusBarNotificationBanner(title: "Transaction Id's Minimum 6 characters length", style: .danger)
                banner.dismiss()
                banner.show()
                
                return false
            }
            
            let amount = Double(txtWBTamountDeposit.text!)!
            let minAmount = 0.00
            
            if(amount.isLessThanOrEqualTo(minAmount))
            {
                let banner = StatusBarNotificationBanner(title: "Amount should be greater then 0.00", style: .danger)
                banner.dismiss()
                banner.show()
                return false
            }
            
            
        }
        else if(processPay == 4)
        {
            let res1 = txtPPamount.text!.removeWhitespace()
            let res2 = txtPPfromAddress.text!.removeWhitespace()
            let res3 = txtPPtoSendAddress.text!.removeWhitespace()
             let res4 = txtPPtoSendAddress.text!.removeWhitespace()
            
            if(txtPPamount.text!.isEmpty || txtPPfromAddress.text!.isEmpty || txtPPtoSendAddress.text!.isEmpty || txtPPtransactionId.text!.isEmpty || res1.isEmpty || res2.isEmpty || res3.isEmpty || res4.isEmpty)
            {
                let banner = StatusBarNotificationBanner(title: "Fields must be filled!", style: .danger)
                banner.dismiss()
                banner.show()
                
                return false
            }
            else if(txtPPtransactionId.text!.count < 6)
            {
                let banner = StatusBarNotificationBanner(title: "Transaction Id's Minimum 6 characters length", style: .danger)
                banner.dismiss()
                banner.show()
                return false
            }
            
            let amount = Double(txtPPamount.text!)!
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
    
 
    
    
    func generateQRCode(from string: String) -> UIImage? {
        let data = string.data(using: String.Encoding.ascii)
        
        if let filter = CIFilter(name: "CIQRCodeGenerator") {
            filter.setValue(data, forKey: "inputMessage")
            let transform = CGAffineTransform(scaleX: 3, y: 3)
            
            if let output = filter.outputImage?.transformed(by: transform) {
                return UIImage(ciImage: output)
            }
        }
        
        return nil
    }
    
    
    func depositForCurrency(process: Int, address:String) {
        
        var pin = Int(txtCCcouponPin.text!)!
        
        if(txtCCcouponPin.text!.isEmpty)
        {
            pin = 0
        }
        
        Api.request(endpoint: .getDeposit(amount: txtCryptoAmount.text!, currency: currenyName, transactionId: txtTransactionId.text!, userRemarks: "", process: process, address:address,couponCode:txtCCcouponCode.text!,couponPin:pin)) { (JSON) in
            
            //            print("***** deposit request",JSON)
            
            if(JSON["status"] == 200)
            {
                let banner = StatusBarNotificationBanner(title: JSON["message"].stringValue, style: .success)
                banner.dismiss()
                banner.show()
                self.navigationController?.popViewController(animated: true)
            }
            
        }
    }
    
}


extension UIScrollView {
    func updateContentView() {
        contentSize.height = subviews.sorted(by: { $0.frame.maxY < $1.frame.maxY }).last?.frame.maxY ?? contentSize.height
    }
}

