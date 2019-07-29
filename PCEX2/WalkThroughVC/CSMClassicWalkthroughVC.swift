//
//  CSMClassicWalkthroughVC.swift
//  PCEX2
//
//  Created by CHHAGAN SINGH on 4/3/19.
//  Copyright © 2019 Panaesha Capital pvt. ltd. All rights reserved.
//

import UIKit
import Foundation

class CSMClassicWalkthroughVC: UIViewController {
    @IBOutlet var containerView: UIView!
    @IBOutlet var imageContainerView: UIView!
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var subtitleLabel: UILabel!
    
    @IBOutlet weak var imgView2: UIImageView!
    
    @IBOutlet weak var lbltitle: UILabel!
    
    
    let model: CSMWalkthroughModel
    
    init(model: CSMWalkthroughModel,
         nibName nibNameOrNil: String?,
         bundle nibBundleOrNil: Bundle?) {
        self.model = model
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        imageView.image = UIImage.localImage(model.icon, template: true)
//        imageView.contentMode = .scaleAspectFill
//        imageView.clipsToBounds = true
//        imageView.tintColor = .white
//        imageContainerView.backgroundColor = .clear
//
//        titleLabel.text = model.title
//        titleLabel.font = UIFont.boldSystemFont(ofSize: 20.0)
//        titleLabel.textColor = .white
//
//        subtitleLabel.attributedText = NSAttributedString(string: model.subtitle)
//        subtitleLabel.font = UIFont.systemFont(ofSize: 14.0)
//        subtitleLabel.textColor = .white
        
        
        
        
        imgView2.image = UIImage(named: model.icon) // UIImage.localImage(model.icon, template: true)
        //imgView2.contentMode = .scaleAspectFill
       // imgView2.contentMode = .scaleAspectFit
        imgView2.clipsToBounds = true
        imgView2.tintColor = .white
        imgView2.backgroundColor = .clear
        
        
        lbltitle.text = model.title
        //lbltitle.font = UIFont.boldSystemFont(ofSize: 20.0)
       // lbltitle.textColor = .white
        containerView.backgroundColor = UIColor(hexString: "#3068CC")
        
    }
 
}
