//
//  Deposit.swift
//  PCEX
//
//  Created by CHHAGAN SINGH on 3/24/19.
//  Copyright © 2019 Chhagan SIngh. All rights reserved.
//

import UIKit
import Foundation
import IQDropDownTextField
import SwiftyJSON
import SDWebImage
import IQKeyboardManagerSwift
import NotificationBannerSwift

class Deposit: UIViewController, UITextFieldDelegate,IQDropDownTextFieldDataSource {
    
    @IBOutlet weak var imgLogo: UIImageView!
    @IBOutlet weak var lblCurrencyName: UILabel!
    @IBOutlet weak var lblWalletAddress: UILabel!
    @IBOutlet weak var qrCode: UIImageView!
    @IBOutlet weak var txtAmount: UITextField!
    @IBOutlet weak var txtTransactionId: UITextField!
    @IBOutlet weak var txtDateTime: IQDropDownTextField!
    
    @IBOutlet weak var checkMarkToggle: UIButton!
    @IBOutlet weak var btnSUbmit: UIButton!
    
    var dictResult = [JSON]()
    var addressString: String!
    var imglogoPath: String!
    var currenyName: String!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.qrCode.image = self.generateQRCode(from: addressString)

        imgLogo.sd_setImage(with: URL(string: self.imglogoPath), placeholderImage: UIImage(named: "placeholder.png"))
        
        lblCurrencyName.text = currenyName
        lblWalletAddress.text = addressString
        
        //txtDateTime.datePickerMode
      //  txtDateTime.dataSource = (self as! IQDropDownTextFieldDataSource)
        self.txtDateTime.isOptionalDropDown = false
        self.txtDateTime.dropDownMode = IQDropDownMode.datePicker
        
        btnSUbmit.isEnabled = false
        
        self.btnSUbmit.layer.cornerRadius = 5
        self.btnSUbmit.layer.borderColor = (UIColor(hexString: WHITE_COLOR)).cgColor
        self.btnSUbmit.layer.borderWidth = 2

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillAppear(_ animated: Bool) {
        
        // self.getNetposition()
        
    }
    @IBAction func btnToggleAction(_ sender: Any) {
        
        if(checkMarkToggle.isSelected)
        {
            checkMarkToggle.isSelected = false
            btnSUbmit.isEnabled = false
        }
        else
        {
            
            if((txtTransactionId.text?.isEmpty)! || txtTransactionId.text == "" || txtAmount.text == "" || (txtAmount.text?.isEmpty)!)
            {
                let alert = UIAlertController(title: "PCEX", message: "Transaction Id and amount must be filled.", preferredStyle: UIAlertController.Style.alert)
                
                // add an action (button)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                
                // show the alert
                self.present(alert, animated: true, completion: nil)
                
                return
            }
            
            btnSUbmit.isEnabled = true
            checkMarkToggle.isSelected = true
        }
        
    }
    
    @IBAction func btnSubmitAction(_ sender: Any) {
        
        if((txtTransactionId.text?.isEmpty)! || txtTransactionId.text == "" || txtAmount.text == "" || (txtAmount.text?.isEmpty)!)
        {
            let alert = UIAlertController(title: "PCEX", message: "Transaction Id and amount must be filled.", preferredStyle: UIAlertController.Style.alert)
            
            // add an action (button)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            
            // show the alert
            self.present(alert, animated: true, completion: nil)
            
            return
        }
        
        self.depositForCurrency()
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
    
    
    func depositForCurrency() {
        
        let process = 3
        
//        Api.request(endpoint: .getDeposit(amount: txtAmount.text!, currency: currenyName, transactionId: txtTransactionId.text!, userRemarks: txtDateTime.selectedItem!, process: process)) { (JSON) in
//
////            print("***** deposit request",JSON)
//
//            if(JSON["status"] == 200)
//            {
//            let banner = StatusBarNotificationBanner(title: JSON["message"].stringValue, style: .success)
//            banner.dismiss()
//            banner.show()
//            self.navigationController?.popViewController(animated: true)
//            }
        
        //}
    }
    
}
