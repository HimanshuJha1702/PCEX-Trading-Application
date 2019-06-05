//
//  UIImage.swift
//  PCEX2
//
//  Created by RAHUL BANSAL on 4/3/19.
//  Copyright © 2019 Panaesha Capital pvt. ltd. All rights reserved.
//

import UIKit

extension UIImage {
    static func localImage(_ name: String, template: Bool = false) -> UIImage {
        var image = UIImage(named: name)!
        if template {
            image = image.withRenderingMode(.alwaysTemplate)
        }
        return image
    }
}
