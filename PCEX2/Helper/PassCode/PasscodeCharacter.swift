//
//  PasscodeCharacter.swift
//  Passcode
//
//  Created by CHHAGAN SINGH on 15.06.19.
//  Copyright © 2019 Panaesha Capital pvt. ltd.. All rights reserved.
//

import UIKit

@IBDesignable
class PasscodeCharacter: UIView {
    
    var view: UIView?
    @IBInspectable
    public var value: Bool = false {
        didSet {
            self.view?.removeFromSuperview()
            
            self.view = UIView(frame: CGRect(x: self.frame.width/2-8, y: self.frame.height/2-8, width: 16, height: 16))
            
            guard let view = self.view else { return }
            
            view.layer.borderWidth = 1
            view.layer.cornerRadius = 8
            view.layer.borderColor = self.tintColor.cgColor
            view.backgroundColor = self.value ? self.tintColor : .clear
            
            self.addSubview(view)
        }
    }
    
    override func tintColorDidChange() {
        super.tintColorDidChange()
        guard let view = self.view else { return }
        view.layer.borderColor = self.tintColor.cgColor
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
}
