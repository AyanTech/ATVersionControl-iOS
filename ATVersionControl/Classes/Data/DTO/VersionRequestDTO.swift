//
//  VersionRequestDTO.swift
//  ATVersionControl
//

struct VersionRequestDTO: Encodable, Sendable {
    private static let applicationTypeValue = "ios"

    let applicationName: String
    let applicationType: String
    let categoryName: String
    let currentApplicationVersion: String
    let extraInfo: [String: String]

    init(input: VersionCheckInput) {
        applicationName = input.applicationName
        applicationType = Self.applicationTypeValue
        categoryName = input.categoryName
        currentApplicationVersion = input.version
        extraInfo = input.extraInfo
    }

    enum CodingKeys: String, CodingKey {
        case applicationName = "ApplicationName"
        case applicationType = "ApplicationType"
        case categoryName = "CategoryName"
        case currentApplicationVersion = "CurrentApplicationVersion"
        case extraInfo = "ExtraInfo"
    }
}
