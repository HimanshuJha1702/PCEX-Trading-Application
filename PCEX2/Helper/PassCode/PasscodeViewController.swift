//
//  PassviewCodeController.swift
//  Passcode
//
//  Created by CHHAGAN SINGH on 16.06.19.
//  Copyright © 2019 Panaesha Capital pvt. ltd.. All rights reserved.
//

import UIKit
import LocalAuthentication
import Security

public enum PasscodeType {
    case authenticate
    case askCode
    case changeCode
}

class PasscodeViewController: UIViewController {
    
    var config: PasscodeConfig!
    var type = PasscodeType.authenticate
    
    var compareCode: String?
    var code = "" {
        didSet {
            var count = 0
            
            for view in self.viewCode.arrangedSubviews {
                if let view = view as? PasscodeCharacter {
                    view.value = count < code.count
                    count += 1
                }
            }
            
            guard self.code.count == 4 else { return }
            
            switch type {
            case .authenticate, .askCode:
                if code == self.config.passcodeGetter() {
                    self.dismiss(success: true)
                } else {
                    self.displayError()
                }
            case .changeCode:
                if compareCode == nil {
                    compareCode = code
                    self.resetCode()
                    UILabel.animate(withDuration: 0.3, animations: { self.codeReenterLabel.alpha = 1.0 })
                    return
                } else {
                    if compareCode == code {
                        self.config.passcodeSetter(code)
                        self.dismiss(success: true)
                    } else {
                        self.displayError()
                    }
                }
            }
        }
    }
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var lblCode: UILabel!
    @IBOutlet weak var btnCancel: UIButton!
    @IBOutlet weak var viewCode: UIStackView!
    @IBOutlet weak var codeReenterLabel: UILabel!
    
    // MARK: - Callbacks
    
    var authenticatedCompletion: ((Bool) -> Void)?
    var dismissCompletion: (() -> Void)?
    
    // MARK: - View Cycle
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        let strCreatPin = "create pin code"
         let strPinEntr = "enter pin code"
        
        switch type {
        case .changeCode:
            self.lblCode.text = strCreatPin  // create pin code
        case .askCode:
            self.lblCode.text = "enter pin code"  //enter pin code
        default:
            self.lblCode.text = strPinEntr  // enter pin code
            self.btnCancel.isHidden = true
        }
        
        // Config
        self.codeReenterLabel.text = "confirm pin code"  // confirm pin code
        
        // Colors
        self.lblCode.textColor = self.config.colors.text
        self.viewCode.tintColor = self.config.colors.mainTint
        self.codeReenterLabel.textColor = self.config.colors.text

        self.btnCancel.setTitleColor(self.config.colors.mainTint, for: .normal)

        PasscodeCharacter.appearance().tintColor = self.config.colors.mainTint
        NumberButton.appearance().tintColor = self.config.colors.buttonTint

        UIButton.appearance(whenContainedInInstancesOf: [PasscodeViewController.self]).tintColor = self.config.colors.buttonTint
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if self.config.autoBiometrics && self.type == .authenticate {
            let context = LAContext()
            var error: NSError?
            
            guard context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) else {
                return print(error ?? "")
            }
            
            let reason = "for fast enter"  //for fast enter
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { isAuthorized, error in
                guard isAuthorized == true else {
                    return print(error ?? "")
                }
                
                self.dismiss(success: true)
            }
        }
    }
    
    // MARK: - Helpers
    
    func resetCode() {
        self.code = ""
    }
    
    public func dismiss(success: Bool) {
        if let dismissCompletion = dismissCompletion {
            dismissCompletion()
            self.authenticatedCompletion?(success)
        } else {
            self.dismiss(animated: true) {
                self.authenticatedCompletion?(success)
            }
        }
    }
    
    func displayError() {
        self.view.isUserInteractionEnabled = false
        let animation = CABasicAnimation(keyPath: "position")
        animation.autoreverses = true
        animation.duration = 0.1
        animation.isRemovedOnCompletion = true
        animation.repeatCount = 2
        animation.fromValue = NSValue(cgPoint: CGPoint(x: self.viewCode.center.x - 10, y: self.viewCode.center.y))
        animation.toValue = NSValue(cgPoint: CGPoint(x: self.viewCode.center.x + 10, y: self.viewCode.center.y))
        
        self.viewCode.layer.add(animation, forKey: animation.keyPath)
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + animation.duration * Double(animation.repeatCount + 1)) {
            self.code = ""
            self.view.isUserInteractionEnabled = true
        }
    }
    
    // MARK: - IBActions
        @IBAction func didPress(button: UIButton) {
        guard let button = button as? NumberButton else {
            self.code = String(self.code.dropLast(1))
            return
        }

        code.append(button.value)
    }
    
    @IBAction func cancel(_ sender: AnyObject?) {
        self.code = ""
        self.dismiss(success: false)
    }
    
    @IBAction func biometrics(_ sender: AnyObject? = nil) {
    }
    
    static var passcode: Passcode = {
        let config = PasscodeConfig(passcodeGetter: {
            if let passCode = AppDataManager.shared.passCode {
                return passCode
            } else {
                PasscodeViewController.remove()
                return "0000"
            }
        }, passcodeSetter: { code in
            AppDataManager.shared.passCode = code
        }, biometricsGetter: {
            return true
        })
        
        let passcode = Passcode(window: (UIApplication.shared.delegate as! AppDelegate).window, config: config)
        
        return passcode
    }()
    
    static func show() {
        self.passcode.authenticateWindow()
    }
    
    static func remove() {
        self.passcode.dismiss()
    }
    
}
