//
//  Connectivity.swift
//  PCEX
//
//  Created by CHHAGAN on 12/03/19.
//  Copyright © 2019 Chhagan SIngh. All rights reserved.
//

import Foundation
import Alamofire

class Connectivity {
    class var isConnectedToInternet:Bool {
        return NetworkReachabilityManager()!.isReachable
    }
}

