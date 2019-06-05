//
//  Registration.swift
//  PCEX
//
//  Created by CHHAGAN on 3/12/19.
//  Copyright © 2019 Chhagan SIngh. All rights reserved.
//

import UIKit
import Foundation
import KeychainAccess
import Alamofire
import NotificationBannerSwift
import IQKeyboardManagerSwift
import IQDropDownTextField
import SwiftyJSON
import KRProgressHUD

class Registration: UIViewController,IQDropDownTextFieldDelegate {
    

    @IBOutlet weak var headerHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var regNameTxtFieldOutlet: UITextField!
    @IBOutlet weak var regEmailTxtFieldOutlet: UITextField!

    @IBOutlet weak var txtPhonExt: UITextField!
    @IBOutlet weak var txtPhoneNo: UITextField!
    @IBOutlet weak var txtRegisterAs: IQDropDownTextField!
    @IBOutlet weak var txtSubBrokerCode: UITextField!
    @IBOutlet weak var txtCity: UITextField!
    @IBOutlet weak var txtPinCode: UITextField!
    
    @IBOutlet weak var txtCountry: IQDropDownTextField!
    @IBOutlet weak var regNameErrorLblOutlet: UILabel!
    @IBOutlet weak var regEmailErrorLabelOutlet: UILabel!
    @IBOutlet weak var regPnoneErrorLblOutlet: UILabel!
    @IBOutlet weak var regCityErrorLblOutlet: UILabel!
    @IBOutlet weak var regPinCodeLblOutlet: UILabel!
    
    @IBOutlet weak var btnTnC: UIButton!
    @IBOutlet weak var regRegisterBtnOutlet: UIButton!
    @IBOutlet weak var btnAlreadyHaveAccount: UIButton!
    
    @IBOutlet var txtCollection: [UITextField]!
    
    var countryCode = [String]()
    var countries = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
         //bindKeyboardNotifications()

        
        //self.headerHeightConstraint.constant = GlobalVariables.NavHeight
        
        
        self.hideKeyboard()
        ///Users/rahulbansal/Desktop/chhagan/pcex_mobile/PCEX/PCEX/Model/CountryCode.json
        //let url = Bundle.main.url(forResource: "CountryCode", withExtension: "json")
        let url = Bundle.main.url(forResource: "Directions", withExtension: "geojson")
        let data = NSData(contentsOf: url!)
        
        //let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
        if let usableData = data {
            do {
                var jsonArray = try JSONSerialization.jsonObject(with: usableData as Data, options: .allowFragments) as! [String:AnyObject]
                
                let country = jsonArray["CountryCode"]


                for scripinfo in country as! [[String: AnyObject]] {

                    if !(countries.contains((scripinfo["name"] as! String)))
                    {
                        countries.append((scripinfo["name"] as! String))
                        countryCode.append((scripinfo["dial_code"] as! String))
                    }

                }
                
                txtCountry.itemList = countries
                txtCountry.delegate = self
                
                txtCountry.selectedItem = "India"
                txtPhonExt.text = "+91"
                
                
               
            } catch {
                print("JSON Processing Failed")
            }
        }
        
        
        
        txtRegisterAs.isOptionalDropDown = false
        txtRegisterAs.itemList = ["Client", "Master Franchise/ Sub Broker"]

    }
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: animated)
        if Connectivity.isConnectedToInternet {
            debugPrint("Yes! internet is available.")
        }
        else
        {
            let banner = StatusBarNotificationBanner(title: "No Network Connection", style: .danger)
            banner.dismiss()
            banner.show()
        }
        DispatchQueue.main.async{
            self.initRegisterUI()
        }
        //self.clearRegFieldValues()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    
    // MARK: - UI functions
    
    func initRegisterUI()
    {
        

        
//        for txt in txtCollection
//        {
//            txt.layer.borderWidth = CGFloat(APP_MAIN_TEXTFIELD_BORDER_WIDTH)
//            txt.layer.borderColor = (UIColor(hexString: APP_MAIN_TEXTFIELD_BORDER_COLOR)).cgColor
//            //txt.textColor = UIColor(hexString: APP_MAIN_TEXTFIELD_TEXT_COLOR)
//        }
        
        
//        self.btnAlreadyHaveAccount.layer.cornerRadius = 5
//        self.btnAlreadyHaveAccount.layer.borderColor = (UIColor(hexString: WHITE_COLOR)).cgColor
//        self.btnAlreadyHaveAccount.layer.borderWidth = 2
        
//        self.regRegisterBtnOutlet.layer.cornerRadius = 5
//        self.regRegisterBtnOutlet.layer.borderColor = (UIColor(hexString: GREEN_COLOR_CUSTOM)).cgColor
//        self.regRegisterBtnOutlet.layer.borderWidth = 2
        
        
        self.regNameTxtFieldOutlet.attributedPlaceholder = NSAttributedString(string: "Full Name", attributes: [NSAttributedString.Key.foregroundColor: UIColor(hexString: APP_MAIN_TEXTFIELD_PLACEHOLDER_COLOR)])
        self.txtPhoneNo.attributedPlaceholder = NSAttributedString(string: "Phone Number", attributes: [NSAttributedString.Key.foregroundColor: UIColor(hexString: APP_MAIN_TEXTFIELD_PLACEHOLDER_COLOR)])
        self.regEmailTxtFieldOutlet.attributedPlaceholder = NSAttributedString(string: "Email", attributes: [NSAttributedString.Key.foregroundColor: UIColor(hexString: APP_MAIN_TEXTFIELD_PLACEHOLDER_COLOR)])
        self.txtSubBrokerCode.attributedPlaceholder = NSAttributedString(string: "Sub Broker Code", attributes: [NSAttributedString.Key.foregroundColor: UIColor(hexString: APP_MAIN_TEXTFIELD_PLACEHOLDER_COLOR)])
        self.txtCity.attributedPlaceholder = NSAttributedString(string: "City", attributes: [NSAttributedString.Key.foregroundColor: UIColor(hexString: APP_MAIN_TEXTFIELD_PLACEHOLDER_COLOR)])
       
        self.txtPinCode.attributedPlaceholder = NSAttributedString(string: "Pin Code", attributes: [NSAttributedString.Key.foregroundColor: UIColor(hexString: APP_MAIN_TEXTFIELD_PLACEHOLDER_COLOR)])
         self.txtCountry.attributedPlaceholder = NSAttributedString(string: "Country", attributes: [NSAttributedString.Key.foregroundColor: UIColor(hexString: APP_MAIN_TEXTFIELD_PLACEHOLDER_COLOR)])
        
        self.regNameTxtFieldOutlet.paddingLeft = CGFloat(APP_MAIN_TEXTFIELD_PLACEHOLDER_LEFT_PADDING)
        self.txtPhoneNo.paddingLeft = CGFloat(APP_MAIN_TEXTFIELD_PLACEHOLDER_LEFT_PADDING)
        self.regEmailTxtFieldOutlet.paddingLeft = CGFloat(APP_MAIN_TEXTFIELD_PLACEHOLDER_LEFT_PADDING)
        self.txtSubBrokerCode.paddingLeft = CGFloat(APP_MAIN_TEXTFIELD_PLACEHOLDER_LEFT_PADDING)
        self.txtCity.paddingLeft = CGFloat(APP_MAIN_TEXTFIELD_PLACEHOLDER_LEFT_PADDING)
    }


    // MARK: - Button Action
    
    @IBAction func btnAllreadyhaveAccount(_ sender: Any) {
    
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func btnBackAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func regSubmitBtnAction(_ sender: Any) {

        validate()
    }
    @IBAction func btnTncAction(_ sender: UIButton) {
        if sender.isSelected {
            sender.isSelected = false
        }else {
            sender.isSelected = true
        }
    }
    
    func validate() {
        do {
            let name = try self.regNameTxtFieldOutlet.validatedText(validationType: ValidatorType.name)
            let email = try self.regEmailTxtFieldOutlet.validatedText(validationType: ValidatorType.email)
            let phone = try self.txtPhoneNo.validatedText(validationType: ValidatorType.phone)
            let city = try self.txtCity.validatedText(validationType: ValidatorType.city)
            let pincode = try self.txtPinCode.validatedText(validationType: ValidatorType.pincode)
            
            let data = RegisterData(name:name, email: email, phone:phone, city:city, pincode:pincode, password: "NA")
            
            self.registeruser()
        } catch(let error) {
            showAlert(for: (error as! ValidationError).message)
        }
    }

    // MARK: - Delegates
    
    func textField(_ textField: IQDropDownTextField, didSelectItem item: String?) {
        
        let row = countries.firstIndex(of: item!)
        
        txtCountry.selectedItem = item
        txtPhonExt.text! = countryCode[row!]
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let textTag = textField.tag+1
        let nextResponder = textField.superview?.viewWithTag(textTag) as UIResponder?
        if(nextResponder != nil)
        {
            nextResponder?.becomeFirstResponder()
        }
        else{
            // stop editing on pressing the done button on the last text field.
            self.view.endEditing(true)
        }
        return true
    }
    
    func showAlert(for alert: String) {
        let alertController = UIAlertController(title: nil, message: alert, preferredStyle: UIAlertController.Style.alert)
        let alertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(alertAction)
        present(alertController, animated: true, completion: nil)
    }
    
    // MARK: - API Calls
    
    func registeruser()
    {
         KRProgressHUD.show(withMessage: "Please Wait...")
        
        var role: Int
        
        if(txtRegisterAs.selectedItem == "Client")
        {
            role = 6
        }
        else
        {
            role = 5
        }
        
        let server = "api1"
            let defaults = UserDefaults.standard
            defaults.set(server, forKey: "server")
            defaults.synchronize()

        Api.request(endpoint: .registrUser(name: self.regNameTxtFieldOutlet.text!, email: self.regEmailTxtFieldOutlet.text!, country: txtCountry.selectedItem!, phone: Int(self.txtPhoneNo.text!)!, role: role, city: self.txtCity.text!, pincode: Int(self.txtPinCode.text!)!, countryCode: Int(txtPhonExt.text!)!, subbrokerCode: self.txtSubBrokerCode.text!)) { (JSON) in

            print("*&$*",JSON)
            
            if(JSON["status"]==200)
            {
                let destViewController : OtpVerify = self.storyboard!.instantiateViewController(withIdentifier: "OtpVerify") as! OtpVerify
                destViewController.message = JSON["message"].stringValue
                destViewController.secretKey = JSON["secretKey"].stringValue
                destViewController.fastSecretKey = JSON["fastSecretKey"].stringValue
                destViewController.name = self.regNameTxtFieldOutlet.text!
                destViewController.email = self.regEmailTxtFieldOutlet.text!
                destViewController.country = self.txtCountry.selectedItem!
                destViewController.phone = Int(self.txtPhoneNo.text!)!
                destViewController.role = role
                destViewController.city = self.txtCity.text!
                destViewController.pincode = Int(self.txtPinCode.text!)!
                destViewController.countryCode = Int(self.txtPhonExt.text!)!
                destViewController.subBrokerCode = self.txtSubBrokerCode.text!
                self.navigationController!.pushViewController(destViewController, animated: true)
            }

            
        }
    }
    
    func  registeronLive() {
        
        var role: Int
        
        if(txtRegisterAs.selectedItem == "Client")
        {
            role = 6
        }
        else
        {
            role = 5
        }
        
        let server = "api1"

        APP_Defaults.set(server, forKey: "server")
        APP_Defaults.synchronize()
        
        Api.request(endpoint: .registrUser(name: self.regNameTxtFieldOutlet.text!, email: self.regEmailTxtFieldOutlet.text!, country: txtCountry.selectedItem!, phone: Int(self.txtPhoneNo.text!)!, role: role, city: self.txtCity.text!, pincode: Int(self.txtPinCode.text!)!, countryCode: Int(txtPhonExt.text!)!, subbrokerCode: self.txtSubBrokerCode.text!)) { (JSON) in
            
            print("*&$*",JSON)
            
        }
    }
    
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}

extension UIViewController {
    @discardableResult
    func alert(title:String?,message:String?,actionTitle:String?,cancelTitle:String?,success:(((Bool)->Void)?))->UIAlertController {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        if actionTitle != nil {
            let action = UIAlertAction(title: actionTitle, style: .default) { (action) in
                success?(true)
            }
            alertController.addAction(action)
        }
        if cancelTitle != nil {
            let cancel = UIAlertAction(title: cancelTitle, style: .cancel, handler: { (action) in
                success?(false)
            })
            alertController.addAction(cancel)
        }
        DispatchQueue.main.async {
            self.present(alertController,animated: false)
        }
        return alertController
    }
}


