//
//  TabViewController.swift
//  PCEX2
//
//  Created by CHHAGAN SINGH on 4/24/19.
//  Copyright © 2019 Panaesha Capital pvt. ltd. All rights reserved.
//

import UIKit

class TabViewController: UIViewController {

    @IBOutlet weak var container: UIView!
    var destinationViewController:UIViewController!
    var oldViewController:UIViewController!
    var _viewControllersByIdentifier:NSMutableDictionary!
    var destinationIdentifier:NSString!
    
     @IBOutlet weak var sliderView: UIView!
    
    @IBOutlet var arrButtons: [UIButton]!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        _viewControllersByIdentifier = NSMutableDictionary()
        
        for btn in arrButtons {
           // btn.contentMode = .center
            btn.imageView?.contentMode = .scaleAspectFill
        }
        
        if(self.children.count < 1){
            self.performSegue(withIdentifier: "FirstSegue", sender: nil)
        }
        
        
    }
    

    @IBAction func btnTabChangedClicked(_ button: UIButton) {
        UIView.animate(withDuration: 0.5, animations: {
            self.sliderView.center = button.center
        })
        
        for btn in arrButtons
        {
            if(btn.tag != button.tag)
            {
                btn.isHighlighted = false
                btn.isSelected = false
            }
        }
        
        button.isSelected = true
        
        
        
        switch button.tag {
        case 1:
            self.performSegue(withIdentifier: "FirstSegue", sender: nil)
        case 2:
            self.performSegue(withIdentifier: "SecondSegue", sender: nil)
        case 3:
             self.performSegue(withIdentifier: "FifthSegue", sender: nil)
           // self.performSegue(withIdentifier: "ThirdSegue", sender: nil)
        case 4:
           self.performSegue(withIdentifier: "FourthSegue", sender: nil)
        
        default:
            self.performSegue(withIdentifier: "FirstSegue", sender: nil)
        }
        
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        self.oldViewController = self.destinationViewController;
        
        
        if((_viewControllersByIdentifier.object(forKey: segue.identifier!)) == nil)
        {
            _viewControllersByIdentifier.setObject(segue.destination, forKey: segue.identifier! as NSCopying)
        }
        
        
        
        self.destinationIdentifier = segue.identifier as NSString?;
        self.destinationViewController = (_viewControllersByIdentifier.object(forKey: self.destinationIdentifier) as! UIViewController);
        
    }

}
