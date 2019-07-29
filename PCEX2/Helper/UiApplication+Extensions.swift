//
//  UiApplication+Extensions.swift
//  PCEX
//
//  Created by CHHAGAN on 12/03/19.
//  Copyright © 2019 Chhagan SIngh. All rights reserved.
//

import Foundation
import UIKit

extension UIApplication {
    var statusBarView: UIView? {
        if responds(to: Selector(("statusBar"))) {
            return value(forKey: "statusBar") as? UIView
        }
        return nil
    }
}

