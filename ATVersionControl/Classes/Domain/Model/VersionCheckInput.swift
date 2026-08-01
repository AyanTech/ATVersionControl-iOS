//
//  VersionCheckInput.swift
//  ATVersionControl
//

struct VersionCheckInput: Sendable {
    let applicationName: String
    let version: String
    let categoryName: String
    let extraInfo: [String: String]
}
