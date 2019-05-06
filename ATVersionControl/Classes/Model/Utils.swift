//
//  Utils.swift
//  ATVersionControl
//
//  Created by Sepehr Behroozi on 5/6/19.
//  Copyright © 2019 ayantech.ir. All rights reserved.
//

import Foundation
import UIKit

class Utils {
    class func getTopMostViewController() -> UIViewController? {
        var topController = UIApplication.shared.keyWindow?.rootViewController
        
        while topController?.presentedViewController != nil {
            topController = topController?.presentedViewController
        }
        return topController
    }
}
