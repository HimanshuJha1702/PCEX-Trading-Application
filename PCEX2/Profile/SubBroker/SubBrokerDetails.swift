//
//  SubBrokerDetails.swift
//  PCEX2
//
//  Created by Himanshu Jha on 02/08/19.
//  Copyright © 2019 Panaesha Capital pvt. ltd. All rights reserved.
//
import KRProgressHUD
import Foundation
import UIKit

class SubBrokerDetails : UIViewController {
    
   
    
    @IBOutlet weak var nameOfObject: UITextField!
    
    @IBOutlet weak var emailOfObject: UITextField!
    
    @IBOutlet weak var subBrokerCodeTxt: UITextField!
    
    @IBOutlet weak var switchSubBrokerEdit: UIButton!
    
    @IBOutlet weak var subBrokerLabelEdit: UILabel!
    
    @IBAction func switchSubBrokerBtn(_ sender: UIButton) {
        let storyboardID = storyboard!.instantiateViewController(withIdentifier : "SwitchSubBroker" )
        self.navigationController?.pushViewController(storyboardID, animated: true)
    }

    @objc func buttonClicked()  {
        let transition: CATransition = CATransition()
        transition.duration = 0.5
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        transition.type = CATransitionType.reveal
        transition.subtype = CATransitionSubtype.fromRight
        self.view.window!.layer.add(transition, forKey: nil)
        self.dismiss(animated: false, completion: nil)
    }
    
    @objc func cancelBtnClicked() {
        let alert = UIAlertController(title: "Confirmation", message: "Do you really want to cancel the request ?", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: { action in
            Api.request(endpoint: .switchParent2) { (JSON) in
                if(JSON["status"] == 200 ){
                    let alert = UIAlertController(title: "\(JSON["message"])", message: "", preferredStyle: UIAlertController.Style.alert)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
            }
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.default, handler: { action in
        }))
        self.present(alert, animated: true, completion: nil)
    }
   
    private func performFirst(){
        let label:UILabel = UILabel(frame: CGRect(x: 110, y: 55, width: 195, height: 30))
        label.backgroundColor = UIColor.clear
        label.text = "Sub Broker Details"
        label.textColor = #colorLiteral(red: 0.06666666667, green: 0.2274509804, blue: 0.4980392157, alpha: 1)
        label.font = UIFont (name: "HelveticaNeue-Medium", size: 22)
        self.view.addSubview(label)
        
        //Back Button
        let button:UIButton = UIButton(frame: CGRect(x: 18, y: 48, width: 40, height: 30))
        button.backgroundColor = .clear
        let image = UIImage(named: "back button") as UIImage?
        button.setBackgroundImage(image, for: .normal)
        button.setTitle("", for: .normal)
        button.imageEdgeInsets.top = 5
        button.imageEdgeInsets.bottom = 5
        button.imageEdgeInsets.right = 25
        button.addTarget(self, action:#selector(self.buttonClicked), for: .touchUpInside)
        self.view.addSubview(button)
        
        
        
        KRProgressHUD.show(withMessage: "Loading...")
        
        DispatchQueue.main.asyncAfter(deadline: .now()+2) {
            KRProgressHUD.dismiss()
        }
        
        Api.request(endpoint: .switchParent) { (JSON) in
            let resData = JSON["data"].dictionaryObject;
            //let messagePrint = JSON["message"]
            print(resData)
            if (JSON["status"] == 200 && resData != nil)
            {
                
                
                // prevMessage="hffhg"
                if let prevMessage = resData!["prevRequestMessage"] as? NSNull
                {
                    
                }
                else
                {
                    let prevMessage = resData!["prevRequestMessage"]
                    print("Am i being used in the program")
                    guard let window = UIApplication.shared.keyWindow else {
                        return
                    }
                    
                    let toastLbl = UILabel()
                    toastLbl.text = prevMessage as? String
                    print(prevMessage!)
                    toastLbl.font = UIFont.systemFont(ofSize: 15)
                    toastLbl.textColor = #colorLiteral(red: 0.06666666667, green: 0.2274509804, blue: 0.4980392157, alpha: 1)
                    toastLbl.backgroundColor = UIColor(patternImage: UIImage(named: "bg")!)
                    // toastLbl.backgroundColor = UIColor.black.withAlphaComponent(0.6)
                    toastLbl.numberOfLines = 0
                    let textSize = toastLbl.intrinsicContentSize
                    let labelHeight = ( textSize.width / window.frame.width ) * 30
                    let labelWidth = min(textSize.width, window.frame.width - 40)
                    let adjustedHeight = max(labelHeight, textSize.height + 20)
                    
                    toastLbl.frame = CGRect(x: 20, y: (window.frame.height - 90 ) - adjustedHeight-20, width: labelWidth + 20, height: adjustedHeight)
                    toastLbl.center.x = window.center.x
                    toastLbl.layer.cornerRadius = 10
                    toastLbl.layer.masksToBounds = true
                    self.view.addSubview(toastLbl)
                    
                    let cancel:UIButton = UIButton(frame: CGRect(x: 380, y: (window.frame.height - 90 ) - adjustedHeight-27, width: 15, height: 15))
                    cancel.backgroundColor = .clear
                    cancel.setTitle("", for: .normal)
                    let image = UIImage(named: "cancel button") as UIImage?
                    cancel.setBackgroundImage(image, for: .normal)
                    cancel.addTarget(self, action:#selector(self.cancelBtnClicked), for: .touchUpInside)
                    self.view.addSubview(cancel)
                    cancel.showsTouchWhenHighlighted = true
                    
                }
                
                let currentParentDetails = resData!["currentParentDetails"] as? NSDictionary;
                if((currentParentDetails as? NSNull) == nil && currentParentDetails != nil)
                {
                    self.nameOfObject.text = currentParentDetails!["fullName"] as? String
                    self.emailOfObject.text = currentParentDetails!["emailId"] as? String
                    self.subBrokerCodeTxt.text = currentParentDetails!["userCode"] as? String
                }
            }
            else
            {
                //show error in popup
                //JSON["message"]
            }
        }
        
    }
    override func viewDidLoad() {
    
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        performFirst()
        performFirst()
    }
        
}









