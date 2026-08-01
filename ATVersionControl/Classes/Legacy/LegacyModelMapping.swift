//
//  LegacyModelMapping.swift
//  ATVersionControl
//

extension VersionInfo {
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
