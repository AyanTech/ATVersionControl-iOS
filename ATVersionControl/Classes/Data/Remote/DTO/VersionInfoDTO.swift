//
//  VersionInfoDTO.swift
//  ATVersionControl
//

struct VersionInfoDTO: Decodable, Sendable {
    let acceptButtonText: String
    let body: String
    let changeLogs: [String]
    let link: String
    let linkType: String
    let rejectButtonText: String
    let textToShare: String
    let title: String

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
}
