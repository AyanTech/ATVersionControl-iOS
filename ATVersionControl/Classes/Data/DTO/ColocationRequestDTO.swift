//
//  ColocationRequestDTO.swift
//  ATVersionControl
//

struct ColocationRequestDTO: Encodable, Sendable {
    private static let applicationTypeValue = "ios"

    let applicationName: String
    let applicationType: String
    let colocationType: String
    let currentApplicationVersion: String

    init(
        applicationName: String,
        version: String,
        lane: ColocationLane
    ) {
        self.applicationName = applicationName
        applicationType = Self.applicationTypeValue
        colocationType = lane.colocationType
        currentApplicationVersion = version
    }

    enum CodingKeys: String, CodingKey {
        case applicationName = "ApplicationName"
        case applicationType = "ApplicationType"
        case colocationType = "ColocationType"
        case currentApplicationVersion = "CurrentApplicationVersion"
    }
}
