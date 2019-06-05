//
//  T&C_OthersV.swift
//  PCEX2
//
//  Created by RAHUL BANSAL on 5/29/19.
//  Copyright © 2019 Panaesha Capital pvt. ltd. All rights reserved.
//

import UIKit
import Foundation
import WebKit

class T_C_OthersV: UIViewController {

    @IBOutlet weak var webView: WKWebView!
    
    @IBOutlet weak var lblTitle: UILabel!
    var strTitle:String!
    var forWhich:Int! = 0
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    var strToLoad = ""
        if(forWhich == 2)
        {
            strToLoad = "https://www.pcex.io/terms"
        }
       else if(forWhich == 1)
        {
            strToLoad = "https://www.pcex.io/fees"
        }
        else if(forWhich == 3)
        {
            strToLoad = "https://www.pcex.io/about-us"
        }
        
        
        lblTitle.text! = strTitle
        
        let url = URL(string: strToLoad)!
        webView.load(URLRequest(url: url))
        
        
    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
    }


    @IBAction func btnBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }

}
