//
//  ATURL.swift
//  ATVersionControl
//
//  Created by Sepehr Behroozi on 5/6/19.
//  Copyright © 2019 ayantech.ir. All rights reserved.
//

import Foundation

class ATUrl {
    class var baseUrl: String {
        return "http://versioncontrol.infra.ayantech.ir/WebServices/App.svc"
    }
    
    class var checkVersion: String {
        return "\(baseUrl)/CheckVersion"
    }
    
    class var getLastVersion: String {
        return "\(baseUrl)/GetLastVersion"
    }
}
