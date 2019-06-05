//
//  KYCVC.swift
//  PCEX2
//
//  Created by RAHUL BANSAL on 5/2/19.
//  Copyright © 2019 Panaesha Capital pvt. ltd. All rights reserved.
//

import UIKit
import Foundation
import SwiftyJSON
import SDWebImage
import IQKeyboardManagerSwift
import NotificationBannerSwift
import Alamofire

class KYCVC: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
    
    @IBOutlet weak var txtAddress: UITextField!
    
    @IBOutlet weak var txtAddressProff: UITextField!
    
    @IBOutlet weak var txtDoucumentName: UITextField!
    
    @IBOutlet weak var txtDoucumentProof: UITextField!
    
    var forAddresOrUid:Bool! = false
    var forAddress:String!
    var forUid:String!
    
    var addressData:Data!
    var uniqIdData:Data!
    
    var postData : [String:Any] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.navigationController?.navigationBar.isHidden = true
    }
    
    
    func createPostDataForUpload()
    {
        
         let userId = APP_Defaults.value(forKey: "userId") as! Int
         let sessionId = APP_Defaults.value(forKey: "sessionId") as! String
         let fastSessionId = APP_Defaults.value(forKey: "fastSessionId") as! Int
        
        postData = ["userId": userId,
                                       "sessionId": sessionId,
                                       "fastSessionId":fastSessionId,
                                       "addressProof": txtAddressProff.text!,
                                       "documentProof": txtDoucumentProof.text!,
                                       "address":txtAddress.text!,
                                       "city":"",
                                       "country":"",
                                       "documentName":txtDoucumentName.text!]
        
       // formData.append("kycData", JSON.stringify(postData));
    }

    @IBAction func btnBackAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    

    
    @IBAction func btnAttachMent(_ sender: UIButton) {
        
        if(sender.tag == 1)
        {
            forAddresOrUid = true
        }
        else
        {
            forAddresOrUid = false
        }
        
        let myPickerController = UIImagePickerController()
        myPickerController.delegate = self;
        myPickerController.sourceType =  UIImagePickerController.SourceType.photoLibrary
        self.present(myPickerController, animated: true, completion: nil)
        
    }
    @IBAction func btnGlobe(_ sender: UIButton) {
        
        if(sender.tag == 2)
        {
            forAddresOrUid = true
        }
        else
        {
            forAddresOrUid = false
        }
        let myPickerController = UIImagePickerController()
        myPickerController.delegate = self;
        myPickerController.sourceType =  UIImagePickerController.SourceType.camera
        self.present(myPickerController, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        let image_data = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        let imageData:Data = image_data!.pngData()!
        if let imageData = image_data!.jpeg(.low)
        {
            print(imageData.count)
        }
        let imageStr = imageData.base64EncodedString()

        if(forAddresOrUid)
        {
            forAddress = imageStr
            addressData = imageData
            if let imageURL = info[UIImagePickerController.InfoKey.imageURL] as? URL {
                let result = (imageURL).lastPathComponent
                txtAddressProff.text = result
            }
        }
        else
        {
            forUid = imageStr
            uniqIdData = imageData
            if let imageURL = info[UIImagePickerController.InfoKey.imageURL] as? URL {
                let result = (imageURL).lastPathComponent
                txtDoucumentProof.text = result
                
            }
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func btnSubmitAction(_ sender: Any) {
        
        let res1 = txtAddress.text!.removeWhitespace()
        let res2 = txtAddressProff.text!.removeWhitespace()
        let res3 = txtDoucumentName.text!.removeWhitespace()
        let res4 = txtDoucumentProof.text!.removeWhitespace()
        
        if(txtAddress.text!.isEmpty || txtAddressProff.text!.isEmpty ||  txtDoucumentName.text!.isEmpty || txtDoucumentProof.text!.isEmpty || res1.isEmpty || res2.isEmpty || res3.isEmpty || res4.isEmpty)
        {
            let banner = StatusBarNotificationBanner(title: "Please fill all fields first.", style: .danger)
            banner.dismiss()
            banner.show()
        }
        else
        {
            self.createPostDataForUpload()
            
            self.requestWith(endUrl: "/kycUpload/upload", imageAddressData: addressData, imageIDProofData: uniqIdData, parameters: postData)
        }
        
    }
    
    
    func requestWith(endUrl: String, imageAddressData: Data?,imageIDProofData: Data?, parameters: [String : Any], onCompletion: ((JSON?) -> Void)? = nil, onError: ((Error?) -> Void)? = nil){
        
        let server = APP_Defaults.object(forKey: "server") as! String
        
        let url = "\(APP_BASE_URL)\(server)\(endUrl)"
        
        let headers: HTTPHeaders = [
            "Content-type": "multipart/form-data"
        ]
        
        Alamofire.upload(multipartFormData: { (multipartFormData) in

            do {
                let jsonData = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
                multipartFormData.append(jsonData, withName: "kycData")

            } catch {
                print(error.localizedDescription)
            }
            
            if let data = imageAddressData{
                multipartFormData.append(data, withName: "pcex_upload_tag", fileName: "image.png", mimeType: "image/png")
            }
            
            if let dataID = imageIDProofData{
                multipartFormData.append(dataID, withName: "pcex_upload_tag", fileName: "image.png", mimeType: "image/png")
            }
            
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
                    onCompletion?(nil)
                }
            case .failure(let error):
                print("Error in upload: \(error.localizedDescription)")
                onError?(error)
            }
        }
    }
    
}


extension UIImage {
    enum JPEGQuality: CGFloat {
        case lowest  = 0
        case low     = 0.25
        case medium  = 0.5
        case high    = 0.75
        case highest = 1
    }
    
    func jpeg(_ jpegQuality: JPEGQuality) -> Data? {
        return jpegData(compressionQuality: jpegQuality.rawValue)
    }
}
