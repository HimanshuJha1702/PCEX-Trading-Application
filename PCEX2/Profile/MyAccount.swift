//
//  MyAccount.swift
//  PCEX2
//
//  Created by CHHAGAN SINGH on 5/3/19.
//  Copyright © 2019 Panaesha Capital pvt. ltd. All rights reserved.
//

import UIKit

class MyAccount: UIViewController {

    @IBOutlet weak var lblClientId: UILabel!
    @IBOutlet weak var lblUserName: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationController?.navigationBar.isHidden = true
        
        lblUserName.text! = APP_Defaults.value(forKey: "userName") as! String
        lblClientId.text! = APP_Defaults.value(forKey: "userCode") as! String
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
    }
    
    @IBAction func btnKycAction(_ sender: Any) {
        
        let kyc = KYCVC(nibName: "KYCVC", bundle: nil)
        self.navigationController?.pushViewController(kyc, animated: true)
    }
    
    @IBAction func btnBankDetals(_ sender: Any) {
//        let bank = BankDetailsVC(nibName: "BankDetailsVC", bundle: nil)
//        self.navigationController?.pushViewController(bank, animated: true)
        
        self.getBanksOfUser()
        
    }
    
    @IBAction func buttonWhichDoesNothing(_ sender: Any) {
        
        performSegue(withIdentifier: "sub_broker", sender: self)
    }
    
    
    @IBAction func btnSecurityAction(_ sender: Any) {
        
    }
    
    
    @IBAction func btnSupport(_ sender: Any) {
        
    }
    
    @IBAction func btnFeesAction(_ sender: Any) {
        let web : T_C_OthersV = T_C_OthersV(nibName: "T&C_OthersV", bundle: nil)
        web.strTitle = "Fees"
        web.forWhich = 1
        self.navigationController?.pushViewController(web, animated: true)
    }
    
    @IBAction func btnTermsCondition(_ sender: Any) {
        let web : T_C_OthersV = T_C_OthersV(nibName: "T&C_OthersV", bundle: nil)
        web.strTitle = "Terms and Conditions"
        web.forWhich = 2
        self.navigationController?.pushViewController(web, animated: true)
    }
    
    @IBAction func btnAboutAction(_ sender: Any) {
        let web : T_C_OthersV = T_C_OthersV(nibName: "T&C_OthersV", bundle: nil)
        web.strTitle = "About"
        web.forWhich = 3
        self.navigationController?.pushViewController(web, animated: true)
    }
    
    @IBAction func btnLogoutAction(_ sender: Any) {
        
       self.resetDefaults()
        
        UserDefaults.standard.removePersistentDomain(forName: Bundle.main.bundleIdentifier!)
        UserDefaults.standard.synchronize()
        
       // print(Array(UserDefaults.standard.dictionaryRepresentation().keys).count)
        
        let mainStoryBoard = UIStoryboard(name: "Main", bundle: nil)
        let redViewController = mainStoryBoard.instantiateViewController(withIdentifier: "respectiveIdentifier")
        let navigationController = UINavigationController(rootViewController: redViewController)
        let appdelegate = UIApplication.shared.delegate as! AppDelegate
        appdelegate.window!.rootViewController = navigationController
       // appDelegate.window?.rootViewController = redViewController
        
    }
    
    func resetDefaults() {
        let defs = UserDefaults.standard
        let dict = defs.dictionaryRepresentation()
        for key in dict {
            defs.removeObject(forKey: key as? String ?? "")
        }
        defs.synchronize()
    }
    
    
    func getBanksOfUser() {
        
        Api.request(endpoint: .getBanks) { (JSON) in
            if (JSON["status"] == 200)
            {
                let userNetData = JSON["data"].array
                
                if((userNetData) != nil && userNetData!.count>0)
                {
                    let bank = BankDetailsVC(nibName: "BankDetailsVC", bundle: nil)
                    bank.bankArray = JSON["data"].array!
                    self.navigationController?.pushViewController(bank, animated: true)
                    
                }
                else
                {
                    let bank = BankDetailsVC(nibName: "BankDetailsVC", bundle: nil)
                    bank.alreadyAdded = true
                    self.navigationController?.pushViewController(bank, animated: true)
                    
                    let alert = UIAlertController(title: "PCEX", message: "You don't have any bank added yet. Please add a bank for transactions.", preferredStyle: UIAlertController.Style.alert)
                    
                    // add an action (button)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                    
                    // show the alert
                    self.present(alert, animated: true, completion: nil)
                    

                }
                
                
            }
        }
    }
    

}
