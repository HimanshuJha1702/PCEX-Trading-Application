//
//  UIViewController.swift
//  PCEX2
//
//  Created by RAHUL BANSAL on 4/3/19.
//  Copyright © 2019 Panaesha Capital pvt. ltd. All rights reserved.
//

import UIKit

extension UIViewController {
    
    func addChildViewControllerWithView(_ childViewController: UIViewController, toView view: UIView? = nil) {
        let view: UIView = view ?? self.view
        
        childViewController.removeFromParent()
        childViewController.willMove(toParent: self)
        addChild(childViewController)
        childViewController.didMove(toParent: self)
        view.addSubview(childViewController.view)
        view.setNeedsLayout()
        view.layoutIfNeeded()
    }
    
    func removeChildViewController(_ childViewController: UIViewController) {
        childViewController.removeFromParent()
        childViewController.willMove(toParent: nil)
        childViewController.removeFromParent()
        childViewController.didMove(toParent: nil)
        childViewController.view.removeFromSuperview()
        view.setNeedsLayout()
        view.layoutIfNeeded()
    }
    
    func hideKeyboard() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

