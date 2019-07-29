//
//  PasscodeConfig.swift
//  Passcode
//
//  Created by CHHAGAN SINGH on 16.06.19.
//  Copyright © 2019 Panaesha Capital pvt. ltd.. All rights reserved.
//

import UIKit

public struct PasscodeConfig {    
    var foreground = true
    var biometricsString: String?
    public var biometrics: String? { return biometricsString }
    public var autoBiometrics = true
    
    public var reason: String?
    
    public var colors = PasscodeColors(dark: false, mainTint: UIColor.white, buttonTint: .white, biometrics: (.white, UIColor(red: 0.0, green: 0.48, blue: 1.0, alpha: 1.0)), text: .white)
    
    public var passcodeGetter: (() -> String)
    public var passcodeSetter: ((String) -> Void)
    public var biometricsGetter: (() -> Bool)
    
    public init(passcodeGetter: @escaping (() -> String), passcodeSetter: @escaping ((String) -> Void), biometricsGetter: (() -> Bool)? = nil) {
        self.passcodeGetter = passcodeGetter
        self.passcodeSetter = passcodeSetter
        self.biometricsGetter = biometricsGetter ?? { true }
    }
}

public struct PasscodeColors {
    public var mainTint: UIColor
    public var buttonTint: UIColor
    public var biometrics: (UIColor, UIColor)
    public var text: UIColor
    public var dark: Bool
    
    public init(dark: Bool, mainTint: UIColor, buttonTint: UIColor? = nil, biometrics: (UIColor, UIColor)? = nil, text: UIColor) {
        self.mainTint = mainTint
        self.buttonTint = buttonTint ?? mainTint
        self.biometrics = biometrics ?? (text, mainTint)
        self.text = text
        self.dark = dark
    }
}
