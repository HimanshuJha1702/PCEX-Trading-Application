//
//  Passcode.swift
//  AuthenticatonView
//
//  Created by CHHAGAN SINGH on 14.06.19.
//  Copyright © 2019 Panaesha Capital pvt. ltd.. All rights reserved.
//

import UIKit
import LocalAuthentication

public class Passcode {
    
    public var config: PasscodeConfig!
    public var isPresented = false
    private var appDelegateWindow: UIWindow?
    
    private var authenticationViewController: PasscodeViewController?
    private lazy var passcodeWindow: UIWindow = {
        let window = UIWindow(frame: UIScreen.main.bounds)
        
        window.windowLevel = UIWindow.Level(rawValue: 0)
        window.makeKeyAndVisible()
        
        return window
    }()
    
    public init(window: UIWindow?, config: PasscodeConfig) {
        self.appDelegateWindow = window
        self.config = config
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.willEnterForeground), name: UIApplication.willEnterForegroundNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.didEnterBackground), name: UIApplication.didEnterBackgroundNotification, object: nil)
        
        let context = LAContext()
        var error: NSError?
        
        if context.canEvaluatePolicy(.deviceOwnerAuthentication, error: &error) {
            if #available(iOS 11.0, *) {
                switch context.biometryType {
                case .faceID:
                    self.config.biometricsString = "Face ID"
                    self.config.reason = "biometricsReasonFaceID"
                case .touchID:
                    self.config.biometricsString = "Touch ID"
                    self.config.reason = "biometricsReasonTouchID"
                default:
                    break
                }
            } else {
                // Fallback on earlier versions
            }
        } else {
            self.config.biometricsString = nil
        }
    }
    
    @objc func willEnterForeground() {
        self.config.foreground = true
        self.authenticationViewController?.biometrics()
    }
    
    @objc func didEnterBackground() {
        self.config.foreground = false
    }
    
    // MARK: - Public
    
    public func authenticateWindow(completion: ((Bool) -> Void)? = nil) {
        guard !isPresented, let viewController = self.load(type: .authenticate, completion: completion) else { return }
        
        viewController.dismissCompletion = { [weak self] in self?.dismiss() }
        
        passcodeWindow.windowLevel = UIWindow.Level(rawValue: 2)
        passcodeWindow.rootViewController = viewController
        
        self.isPresented = true
    }
    
    public func authenticate(completion: ((Bool) -> Void)? = nil) -> UIViewController? {
        return self.load(type: .authenticate, completion: completion)
    }
    
    public func authenticate(on viewController: UIViewController, animated: Bool, completion: ((Bool) -> Void)? = nil) {
        guard let vc = self.authenticate(completion: completion) else { return }
        viewController.present(vc, animated: animated)
    }
    
    public func askCode(completion: ((Bool) -> Void)? = nil) -> UIViewController? {
        return self.load(type: .askCode, completion: completion)
    }
    
    public func askCode(on viewController: UIViewController, animated: Bool, completion: ((Bool) -> Void)? = nil) {
        guard let vc = self.askCode(completion: completion) else { return }
        viewController.present(vc, animated: animated)
    }
    
    public func changeCode(completion: ((Bool) -> Void)? = nil) -> UIViewController? {
        return self.load(type: .changeCode, completion: completion)
    }
    
    public func changeCode(on viewController: UIViewController, animated: Bool, completion: ((Bool) -> Void)? = nil) {
        guard let vc = self.changeCode(completion: completion) else { return }
        viewController.present(vc, animated: animated)
    }
    
    // MARK: - Private
    
    private func load(type: PasscodeType, completion: ((Bool) -> Void)?) -> PasscodeViewController? {
        let bundle = Bundle(for: PasscodeViewController.self)
        let storyboard = UIStoryboard(name: "First", bundle: bundle)
        guard let viewController = storyboard.instantiateInitialViewController() as? PasscodeViewController else {
            return nil
        }
        
        viewController.authenticatedCompletion = completion
        viewController.type = type
        viewController.config = config
        
        self.authenticationViewController = viewController
        
        return viewController
    }
    
    public func dismiss(animated: Bool = true) {
        DispatchQueue.main.async {
            self.isPresented = false
            self.appDelegateWindow?.windowLevel = UIWindow.Level(rawValue: 1)
            self.appDelegateWindow?.makeKeyAndVisible()
            
            UIView.animate(
                withDuration: 0.5,
                delay: 0,
                usingSpringWithDamping: 1,
                initialSpringVelocity: 0,
                options: [.curveEaseInOut],
                animations: { [weak self] in
                    self?.passcodeWindow.alpha = 0
                },
                completion: { [weak self] _ in
                    self?.passcodeWindow.windowLevel = UIWindow.Level(rawValue: 0)
                    self?.passcodeWindow.rootViewController = nil
                    self?.passcodeWindow.alpha = 1
                }
            )
        }
    }
}
