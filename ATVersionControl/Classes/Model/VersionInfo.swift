//
//  VersionInfo.swift
//  ATVersionControl
//
//  Created by Sepehr Behroozi on 5/6/19.
//  Copyright © 2019 ayantech.ir. All rights reserved.
//

import Foundation

public struct VersionInfo: Decodable, Sendable {
    public var acceptButtonText = ""
    public var body = ""
    public var changeLogs = [String]()
    public var link = ""
    public var linkType = ""
    public var rejectButtonText = ""
    public var textToShare = ""
    public var title = ""

    enum CodingKeys: String, CodingKey {
        case acceptButtonText = "AcceptButtonText"
        case body = "Body"
        case changeLogs = "ChangeLogs"
        case link = "Link"
        case linkType = "LinkType"
        case rejectButtonText = "RejectButtonText"
        case textToShare = "TextToShare"
        case title = "Title"
    }

    static func from(json object: [String: Any]?) -> VersionInfo? {
        guard let object = object else {
            return nil
        }
        
        var result = VersionInfo()
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
