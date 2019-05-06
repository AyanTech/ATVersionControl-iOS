//
//  VersionInfo.swift
//  ATVersionControl
//
//  Created by Sepehr Behroozi on 5/6/19.
//  Copyright © 2019 ayantech.ir. All rights reserved.
//

import Foundation
import SwiftBooster

public class VersionInfo {
    var acceptButtonText = ""
    var body = ""
    var changeLogs = [String]()
    var link = ""
    var linkType = ""
    var rejectButtonText = ""
    var textToShare = ""
    var title = ""
    
    class func from(json object: JSONObject?) -> VersionInfo? {
        guard let object = object else {
            return nil
        }
        
        let result = VersionInfo()
        result.acceptButtonText = getValue(input: object, subscripts: "AcceptButtonText") ?? ""
        result.body = getValue(input: object, subscripts: "Body") ?? ""
        result.changeLogs = getValue(input: object, subscripts: "ChangeLogs") ?? []
        result.link = getValue(input: object, subscripts: "Link") ?? ""
        result.linkType = getValue(input: object, subscripts: "LinkType") ?? ""
        result.rejectButtonText = getValue(input: object, subscripts: "RejectButtonText") ?? ""
        result.textToShare = getValue(input: object, subscripts: "TextToShare") ?? ""
        result.title = getValue(input: object, subscripts: "Title") ?? ""
        return result
    }
}
