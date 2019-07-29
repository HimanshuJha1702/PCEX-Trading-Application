//
//  BankDetailsVC.swift
//  PCEX2
//
//  Created by CHHAGAN SINGH on 5/3/19.
//  Copyright © 2019 Panaesha Capital pvt. ltd. All rights reserved.
//

import UIKit
import Foundation
import SwiftyJSON
import SDWebImage
import IQKeyboardManagerSwift
import NotificationBannerSwift
import Alamofire

class BankDetailsVC: UIViewController,UITableViewDataSource, UITableViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
    
    @IBOutlet weak var viewAddBank: UIView!
    @IBOutlet weak var txtBankName: UITextField!
    @IBOutlet weak var txtIfscCode: UITextField!
    @IBOutlet weak var txtSwiftCode: UITextField!
    @IBOutlet weak var txtAccountNo: UITextField!
    
    @IBOutlet weak var lblImgPath: UILabel!
    @IBOutlet weak var btnCancelOutlet: UIButton!
    @IBOutlet weak var tblBankDetails: UITableView!
    
    var swiftBlogs = [JSON]()
    
    var bankArray = [JSON]()
    
    var bankData:Data!
    var imgStrData:String!
    var bankId:String!
    
    var alreadyAdded: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tblBankDetails.delegate = self
        tblBankDetails.dataSource = self
        self.navigationController?.navigationBar.isHidden = true
        
        
        tblBankDetails.register(BankCell.self, forCellReuseIdentifier: "bank")
        tblBankDetails.register(UINib(nibName: "BankCell", bundle: nil), forCellReuseIdentifier: "bank")
        
        if(!alreadyAdded)
        {
            viewAddBank.isHidden = true
        }
    }
    
    
    // MARK:  UITextFieldDelegate Methods
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return bankArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "bank", for: indexPath) as! BankCell
        
        let row = indexPath.row
        
        let dict = bankArray[row ]
      //   print("dict*******",dict)
        cell.configureCell(with: dict)
        
        cell.btnEdit.tag = indexPath.row
        cell.btnEdit.addTarget(self, action: #selector(editBank(sender:)), for: .touchUpInside)
        
        cell.btnDelete.tag = indexPath.row
        cell.btnDelete.addTarget(self, action: #selector(deleteBank(sender:)), for: .touchUpInside)
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 190.0;
    }
    
    // MARK:  Custom buttons actions
    
    @objc func editBank(sender: UIButton){
        
        let dict = bankArray[sender.tag]
        
      //  .text =  "N.A."//dict["message"].stringValue
        txtBankName.text! = (dict["bankName"].stringValue)
        txtAccountNo.text! =  dict["accountNumber"].stringValue
        txtIfscCode.text! = dict["ifscCode"].stringValue
        txtSwiftCode.text! = dict["swiftCode"].stringValue
        lblImgPath.text! = dict["bankProof1"].stringValue
        self.bankId = dict["bankId"].stringValue
        viewAddBank.isHidden = false
    }
    
    @objc func deleteBank(sender: UIButton){
        
        let dict = bankArray[sender.tag]
         self.bankId = dict["bankId"].stringValue
        
        Api.request(endpoint: .deleteBank(param: bankId)) { (JSON) in
            if (JSON["status"] == 200)
            {
                self.getBanksOfUser()
            }
        }
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        let image_data = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        let imageData:Data = image_data!.pngData()!
       let imgData = image_data!.jpegData(compressionQuality: 0.02)!
        if let imageData = image_data!.jpeg(.low)
        {
            print(imageData.count)
            
      
        }
        
        print("There were \(imgData.count) bytes")
        let bcf = ByteCountFormatter()
        bcf.allowedUnits = [.useMB] // optional: restricts the units to MB only
        bcf.countStyle = .file
        let string = bcf.string(fromByteCount: Int64(imgData.count))
        print("formatted result: \(string)")
        
        bankData = imgData
        imgStrData = imageData.base64EncodedString()
        
            if let imageURL = info[UIImagePickerController.InfoKey.imageURL] as? URL {
                let result = (imageURL).lastPathComponent
                lblImgPath.text = result
                
            }
        
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func btnBackAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnAddBankAction(_ sender: Any) {
        
        if(viewAddBank.isHidden)
        {
            viewAddBank.isHidden = false
        }
    }
    
    // Mark: buttons actions
    
    @IBAction func btnPicCameraAction(_ sender: Any) {
        let myPickerController = UIImagePickerController()
        myPickerController.delegate = self;
        myPickerController.sourceType =  UIImagePickerController.SourceType.camera
        self.present(myPickerController, animated: true, completion: nil)
    }
    
    @IBAction func btnPickGallery(_ sender: Any) {
        let myPickerController = UIImagePickerController()
        myPickerController.delegate = self;
        myPickerController.sourceType =  UIImagePickerController.SourceType.photoLibrary
        self.present(myPickerController, animated: true, completion: nil)
    }
    
    @IBAction func btnCancel(_ sender: Any) {
        
        viewAddBank.isHidden = true
    }
    
    @IBAction func btnSubmitAction(_ sender: Any) {
        
        let res1 = txtBankName.text!.removeWhitespace()
        let res3 = txtIfscCode.text!.removeWhitespace()
        let res4 = txtAccountNo.text!.removeWhitespace()
        
        if(txtAccountNo.text!.isEmpty || txtIfscCode.text!.isEmpty ||  txtBankName.text!.isEmpty ||  res1.isEmpty || res3.isEmpty || res4.isEmpty)
        {
            let banner = StatusBarNotificationBanner(title: "Please fill all fields first.", style: .danger)
            banner.dismiss()
            banner.show()
        }
        else
        {
            
            let  postData = ["bankName": txtBankName.text!,
                             "accountNumber": txtAccountNo.text!,
                             "swiftCode":txtSwiftCode.text!,
                             "ifscCode": txtIfscCode.text!,
                             "bankProof1Name":lblImgPath.text!,
                             "bankId":self.bankId]
            
            self.requestWith(endUrl: "/banksUpload/upload", imageBankData: bankData, parameters: postData)
        }
        
    }
    
    
    func requestWith(endUrl: String, imageBankData: Data?, parameters: [String : Any], onCompletion: ((JSON?) -> Void)? = nil, onError: ((Error?) -> Void)? = nil){
        
        let server = APP_Defaults.object(forKey: "server") as! String
        
        let url = "\(APP_BASE_URL)\(server)\(endUrl)"
        
        let headers: HTTPHeaders = [
            "Content-type": "multipart/form-data"
        ]
        
        Alamofire.upload(multipartFormData: { (multipartFormData) in
            
            do {
                let jsonData = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
                multipartFormData.append(jsonData, withName: "bankData")
                
            } catch {
                print(error.localizedDescription)
            }

            multipartFormData.append(self.bankData!, withName: "pcex_upload_tag", fileName: "image.jpg", mimeType: "image/jpeg")

            print("file size",self.bankData!.count)
            print("file size",imageBankData!.count)
            //}
            
        }, usingThreshold: UInt64.init(), to: url, method: .post, headers: headers) { (result) in
            switch result{
            case .success(let upload, _, _):
                upload.responseJSON { response in
                    print("Succesfully uploaded")
                    print("response we get",response)
                    if let err = response.error{
                        onError?(err)
                        print("error we get",onError?(err) as Any)
                        return
                    }
                    self.getBanksOfUser()
                    onCompletion?(nil)
                }
            case .failure(let error):
                print("Error in upload: \(error.localizedDescription)")
                onError?(error)
            }
        }
    }
    
    
    func getBanksOfUser() {
        
        Api.request(endpoint: .getBanks) { (JSON) in
            if (JSON["status"] == 200)
            {

                self.bankArray = JSON["data"].array!
                self.tblBankDetails.reloadData()
                    
                }

            }
    }
    
}
