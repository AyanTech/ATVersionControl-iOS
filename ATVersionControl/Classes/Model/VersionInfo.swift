//
//  VersionInfo.swift
//  ATVersionControl
//
//  Created by Sepehr Behroozi on 5/6/19.
//  Copyright © 2019 ayantech.ir. All rights reserved.
//

import Foundation

public class VersionInfo {
    public var acceptButtonText = ""
    public var body = ""
    public var changeLogs = [String]()
    public var link = ""
    public var linkType = ""
    public var rejectButtonText = ""
    public var textToShare = ""
    public var title = ""
    
    class func from(json object: [String: Any]?) -> VersionInfo? {
        guard let object = object else {
            return nil
        }
        
        let result = VersionInfo()
        result.acceptButtonText = object["AcceptButtonText"] as? String ?? ""
        result.body = object["Body"] as? String ?? ""
        result.changeLogs = object["ChangeLogs"] as? [String] ?? []
        result.link = object["Link"] as? String ?? ""
        result.linkType = object["LinkType"] as? String ?? ""
        result.rejectButtonText = object["RejectButtonText"] as? String ?? ""
        result.textToShare = object["TextToShare"] as? String ?? ""
        result.title = object["Title"] as? String ?? ""
        return result
    }
}
